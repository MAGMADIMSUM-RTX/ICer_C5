# 工艺库准备

在本目录准备以下五个 SMIC 130 nm 配套文件。

| 文件 | 用途 |
|---|---|
| `typical_1v2c25.db` | 标准单元综合库 |
| `SP013D3_V1p2_typ.db` | I/O PAD 综合与时序库 |
| `smic13g.sdb` | 原理图符号库 |
| `smic13g.v` | 标准单元仿真模型 |
| `SP013D3_V1p2.v` | I/O PAD 仿真模型 |

原实验主机保存这些文件的目录为 `E:\Documents\ChatGPT\ICer\工艺库\smic_130nm`。前三个文件来自其 `smic_130nm工艺库` 子目录，后两个来自 `syn_综合后仿真阶段` 子目录。

两份 `.db` 的内部库名分别为 `typical_1v2c25` 和 `SP013D3_V1p2_typ`，当前脚本使用这些名称。仿真模型需与综合库配套。

原虚拟机 `/home/ICer/asic53/syn_smic/ref` 已具备这些文件。仓库中的本目录保存文件清单，复现时将已有的配套库放入此处。
