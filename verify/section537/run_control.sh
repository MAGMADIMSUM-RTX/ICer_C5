#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
base=verify/section537
models=./ref

run() {
    local name=$1
    shift
    local dest="$base/$name"
    mkdir -p "$dest"
    vcs -full64 -sverilog -timescale=1ns/1ps -top control_test -Mdir="$dest/csrc" \
        -o "$dest/simv" "$base/control_test.v" "$@" </dev/null > "$dest/vcs.log" 2>&1
    "$dest/simv" </dev/null > "$dest/sim.log" 2>&1
    grep -Fx 'PASS: control_test, 144 checks' "$dest/sim.log"
}

run control_rtl rtl/control.v
for netlist_dir in mapped mapped/input_slew_0p5ns; do
    name=control_gate
    if [[ $netlist_dir != mapped ]]; then name=control_gate_slew; fi
    run "$name" +neg_tchk -negdelay +sdfverbose +define+GATE \
        "+define+SDF_FILE=\"$netlist_dir/control_pad.sdf\"" \
        -v "$models/smic13g.v" -v "$models/SP013D3_V1p2.v" "$netlist_dir/control_pad.v"
done
