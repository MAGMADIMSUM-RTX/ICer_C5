#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

run_case() {
    local name=$1 period=$2 compiler=$3 area=$4 slew=$5 log_dir=rpt
    if [[ $name != baseline ]]; then
        log_dir="rpt/$name"
    fi
    mkdir -p "$log_dir"
    DC_CASE="$name" DC_PERIOD="$period" DC_COMPILER="$compiler" DC_MAX_AREA="$area" \
        DC_INPUT_SLEW="$slew" dc_shell -64 -f scripts/dc_scripts.tcl \
        </dev/null > "$log_dir/dc.log" 2>&1
    grep -Fx "Synthesis complete: $name" "$log_dir/dc.log"
}

run_case baseline 20 ultra "" ""
run_case clock_8ns 8 ultra "" ""
run_case clock_5ns 5 ultra "" ""
run_case area_relaxed 20 expert 104000 ""
run_case area_tight 20 expert 103600 ""
run_case input_slew_0p5ns 20 ultra "" 0.5
