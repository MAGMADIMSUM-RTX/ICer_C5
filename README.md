# 第五章实验：SMIC 130 nm 控制器综合与门级仿真

本仓库整理远程 Linux 主机 `/home/ICer/asic53/syn_smic` 中与第五章 `control_pad` 控制器实验相关的源码、综合脚本、网表、时序约束、延迟文件和验证日志，对应实验指导书 5.3.1～5.3.7 的控制器部分。

实验结果来自 2026 年 11 月 19 日，整理日期为 2026 年 11 月 25 日。远程发布副本位于 `/home/ICer/asic53/ICer_C5`。

## 目录与主要文件

```text
.
├── README.md
├── .synopsys_dc.setup       DC 启动配置
├── common_setup.tcl         工艺库和搜索目录
├── dc_setup.tcl             目标库、链接库、符号库设置
├── ref/README.md            配套工艺库准备说明
├── rtl/
│   ├── control.v           控制器功能 RTL
│   └── control_pad.v       包含 PI、PO8 的顶层
├── scripts/
│   ├── dc_scripts.tcl      综合、约束、报告与结果导出
│   └── run_sweep.sh        六组约束对照实验
├── unmapped/               控制器映射前 DDC
├── mapped/                 基准网表、DDC、SDC、SDF
│   ├── clock_8ns/
│   ├── clock_5ns/
│   ├── area_relaxed/
│   ├── area_tight/
│   └── input_slew_0p5ns/
├── rpt/                    综合报告与日志，各组结构对应 mapped
└── verify/section537/
    ├── control_test.v      自检查测试台
    ├── run_control.sh      RTL 与门级测试入口
    ├── control_rtl/        RTL 编译、运行日志
    ├── control_gate/       基准门级编译、运行日志
    └── control_gate_slew/  输入转换时间组的门级日志
```

`rtl/control_pad.v` 是综合输入，`mapped/control_pad.v` 是生成的门级网表。`mapped` 根目录保存 20 ns 基准，其余实验组分别保存在同名子目录。

## 环境与工艺库

- Design Compiler O-2018.06-SP1。
- VCS O-2018.09-1。
- SMIC 130 nm 标准单元和配套 I/O 库。
- Linux shell，工具环境和许可证服务可用。

在 `ref` 中放入以下配套文件，详细用途见 [ref/README.md](ref/README.md)。

```text
typical_1v2c25.db
SP013D3_V1p2_typ.db
smic13g.sdb
smic13g.v
SP013D3_V1p2.v
```

库文件由实验环境提供。原主机 `/home/ICer/asic53/syn_smic/ref` 已有这些文件。当前仓库的 `ref` 保存准备说明，克隆到其他目录后需要补齐上述五个文件。

## 复现步骤

克隆仓库并进入目录。

```bash
git clone git@github.com:MAGMADIMSUM-RTX/ICer_C5.git
cd ICer_C5
command -v dc_shell
command -v vcs
ls -lh ref
```

### 1. 执行基准综合

```bash
dc_shell -64 -f scripts/dc_scripts.tcl </dev/null > rpt/dc.log 2>&1
```

完成后日志包含 `Synthesis complete: baseline`。综合输出包括网表、DDC 设计数据库、SDC 约束和 SDF 延迟数据。

### 2. 执行六组综合对照

```bash
bash scripts/run_sweep.sh
```

脚本依次运行基准、8 ns、5 ns、两组面积目标和 0.5 ns 输入转换时间组。

### 3. 执行 RTL 与门级仿真

```bash
bash verify/section537/run_control.sh
```

该脚本需要前面的基准和 `input_slew_0p5ns` 综合结果。三组测试应依次输出：

```text
PASS: control_test, 144 checks
PASS: control_test, 144 checks
PASS: control_test, 144 checks
```

144 项检查来自 8 个操作码、2 种 `zero` 和 9 个状态检查点。测试台通过复位和实际时钟推进状态，对比九个控制输出。门级实例名为 `c1`，SDF 反标到该实例。脚本使用 `-v ./ref/smic13g.v` 和 `-v ./ref/SP013D3_V1p2.v` 载入两份仿真模型。

## 怎样观察结果

```bash
cat verify/section537/control_gate/sim.log
grep -nE 'Parsing library|SDF file|Total errors|Total warnings' \
    verify/section537/control_gate/vcs.log
```

保存的基准门级日志记录了 SDF 反标 0 错误、0 警告，以及 `PASS: control_test, 144 checks`。测试不匹配时会打印状态、操作码、实际输出 `got` 和预期输出 `exp`。

## 综合结果

| 实验组 | 周期/ns | 最差建立裕量/ns | 单元数 | 单元面积 | 动态功耗/mW |
|---|---:|---:|---:|---:|---:|
| baseline | 20 | +7.9047 | 39 | 103660.938597 | 0.6286244 |
| clock_8ns | 8 | −2.2390 | 47 | 104041.156203 | 2.3782 |
| clock_5ns | 5 | −5.2206 | 49 | 104073.406806 | 3.8164 |
| area_relaxed，上限 104000 | 20 | +9.1622 | 46 | 103730.531995 | 0.8423549 |
| area_tight，上限 103600 | 20 | +9.1622 | 47 | 103728.834596 | 0.8398054 |
| input_slew_0p5ns | 20 | +15.5040 | 39 | 103660.938597 | 0.6988782 |

面积采用库报告口径，功耗来自默认活动传播估计。两组面积实验统一使用 `compile -map_effort high`，其余采用 `compile_ultra`。本机 DC 版本的 `compile_ultra` 会忽略指定的 `set_max_area` 值。

## SDC、SDF 和报告怎么看

| 文件 | 主要用途 |
|---|---|
| [mapped/control_pad.v](mapped/control_pad.v) | 查看映射后的具体单元与连接 |
| [mapped/control_pad.sdc](mapped/control_pad.sdc) | 查看时钟、I/O 延迟、输入驱动和输出负载约束 |
| [mapped/control_pad.sdf](mapped/control_pad.sdf) | 查看门级仿真使用的延迟和时序检查信息 |
| [rpt/rpt_timing](rpt/rpt_timing) | 查看路径增量延迟、到达时间和建立裕量 |
| [rpt/rpt_area](rpt/rpt_area) | 查看单元数量与面积 |
| [rpt/rpt_power](rpt/rpt_power) | 查看内部、切换和泄漏功耗估计 |
| [rpt/rpt_constraints](rpt/rpt_constraints) | 查看约束违规 |
| [rpt/rpt_qor](rpt/rpt_qor) | 查看综合质量摘要 |
| [rpt/rpt_check_timing](rpt/rpt_check_timing) | 检查约束完整性 |

20 ns 基准 SDC 定义了 0.2 ns 时钟不确定度、0.1 ns 输入最大延迟、1 ns 输出最大延迟和每个输出 0.06366 pF 负载。最差路径从 `opcode[1]` 到 `inc_pc`，要求时间 18.8000 ns，到达时间 10.8953 ns，建立裕量为 +7.9047 ns。

SDF 由综合脚本中的 `write_sdf` 导出，时间单位为 ns，可用以下命令阅读。

```bash
less mapped/control_pad.sdc
less mapped/control_pad.sdf
```

在 `less` 中输入 `/IOPATH` 搜索单元路径延迟，按 `n` 查找下一项，按 `q` 退出。

## 当前结果与源文件说明

控制器有 6 个输入 PAD `PI`、9 个输出 PAD `PO8` 和 3 个状态触发器。PAD 面积合计为 103425，约占基准单元面积的 99.77%。

20 ns 基准仍有 11 个最大转换时间和 11 个最大电容违规网络，最小 I/O 延迟条件也需要完善。0.5 ns 输入转换时间组消除了五个外部输入的相关电气违规，内部到 PAD 的六个网络仍有违规。功能检查通过表示当前测试激励下输出符合预期，电气约束和约束完整性仍需继续处理。

`rtl/control.v` 沿用已验证的 Lab 7 版本。`rtl/control_pad.v` 为本次建立并配置 SMIC PAD 的顶层，测试台加入了 SDF 反标和独立状态表检查。
