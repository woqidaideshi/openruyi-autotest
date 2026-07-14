#!/bin/bash

# Performance: stream - multi-core: Measurememorybandwidthcorecount

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    streamSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 ""

    local max_cores=$(nproc)

    rlLogInfo "CPU corecount: $max_cores"

    rlPhaseEnd



    rlPhaseStartTest "multi-core TRIAD bandwidth"

    echo ""

    echo "=== multi-corememorybandwidth (TRIAD) ==="

    printf "%-8s %-15s %-15s %-15s\n" "Cores" "Triad(MB/s)" "Copy(MB/s)" ""

    local single_bw=""



    for t in 1 2 4 $(nproc); do

    # skipcorecounttest

    [ "$t" -gt "$max_cores" ] && continue



    local log="/tmp/stream_${t}core.log"

    rlLogInfo "=== ${t} core TRIAD ==="

    export OMP_NUM_THREADS=$t

    _streamRun $t > "$log" 2>&1 2>/dev/null



    local triad copy

    triad=$(grep "^Triad:" "$log" | awk '{print $2}' | head -1)

    copy=$(grep "^Copy:" "$log" | awk '{print $2}' | head -1)



    if [ -n "$triad" ]; then

    if [ "$t" -eq 1 ]; then

    single_bw="$triad"

    fi

    local eff="N/A"

    if [ -n "$single_bw" ] && [ "$single_bw" != "0" ]; then

    eff=$(awk "BEGIN {printf \"%.1f%%\", ${triad}/${single_bw}/${t}*100}" 2>/dev/null || echo "N/A")

    fi

    printf "%-8s %-15s %-15s %-15s\n" "$t" "$triad" "${copy:-N/A}" "$eff"

    rlPass "${t}core TRIAD: ${triad} MB/s"

    else

    rlFail "${t}core: nodata"

    fi

    done



    if [ -n "$single_bw" ] && [ "$single_bw" != "0" ]; then

    rlLogInfo " (single-core TRIAD): ${single_bw} MB/s"

    fi

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

    rm -f /tmp/stream_*core.log

    rlPhaseEnd

    rlJournalPrintText

rlJournalEnd

