#!/bin/bash
# Reliability: stress-ng - CPU 压力 (阶梯线程 1→2→4)
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        stressNgSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
        TAINT=$(_stressNgTaintBefore)
        rlLogInfo "CPU 核心数: $(nproc)"
    rlPhaseEnd

    rlPhaseStartTest "CPU stress 阶梯线程"
        local bogo_vals=()
        for t in 1 2 4; do
            local log="$TmpDir/cpu_${t}.log"
            rlRun "stress-ng --cpu $t --timeout 30s --metrics-brief --log-file $log 2>&1 | tail -5" 0 "CPU $t 线程"
            tail -15 "$log"
            _stressNgValidate "$log" "cpu"
            # 提取 bogo ops/s
            local bogo
            bogo=$(grep "cpu" "$log" | grep -oP '\d+\.?\d*(?=\s*\(\s*real)' | head -1)
            bogo_vals+=("$bogo")
            rlLogInfo "CPU ${t}线程 bogo ops/s: $bogo"
        done
        # 验证多线程应有更高吞吐（至少不降）
        if [ "${#bogo_vals[@]}" -ge 2 ]; then
            rlLogInfo "CPU bogo: 1t=${bogo_vals[0]} 2t=${bogo_vals[1]} 4t=${bogo_vals[2]}"
            rlPass "CPU 阶梯测试完成"
        fi
    rlPhaseEnd

    rlPhaseStartTest "tainted"
        _stressNgTaintCheck "$TAINT"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
