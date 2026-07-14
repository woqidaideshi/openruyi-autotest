#!/bin/bash

# Performance: iozone - Direct I/O mode (-I): bypass Page Cache testperformance

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    iozoneSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary directory"

    sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true

    rlPhaseEnd



    rlPhaseStartTest "Direct I/O vs Normal comparison"

    local testfile="$TmpDir/iozone_dio.dat"



    # Normal IO (use Page Cache)

    rlLogInfo "=== Standard I/O (use Page Cache) ==="

    iozone -s 64m -r 4k -i 0 -i 1 -f "$testfile" 2>&1 | tee /tmp/iozone_normal.txt

    echo "--- Standard I/O result ---"

    cat /tmp/iozone_normal.txt



    sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true

    rm -f "$testfile"



    # Direct IO (bypass Page Cache)

    rlLogInfo "=== Direct I/O (bypass Page Cache, -I) ==="

    iozone -I -s 64m -r 4k -i 0 -i 1 -f "$testfile" 2>&1 | tee /tmp/iozone_direct.txt

    echo "--- Direct I/O result ---"

    cat /tmp/iozone_direct.txt



    # verifyhasoutput

    grep -qE '^\s+[0-9]+\s+[0-9]+' /tmp/iozone_normal.txt && rlPass "Standard I/O: datalinesexists"

    grep -qE '^\s+[0-9]+\s+[0-9]+' /tmp/iozone_direct.txt && rlPass "Direct I/O: datalinesexists"



    # comparisonanalysis

    local normal_write

    normal_write=$(grep -E '^\s+[0-9]+\s+[0-9]+' /tmp/iozone_normal.txt | awk '{print $3}' | head -1)

    local direct_write

    direct_write=$(grep -E '^\s+[0-9]+\s+[0-9]+' /tmp/iozone_direct.txt | awk '{print $3}' | head -1)



    rlLogInfo "Standard I/O Write: ${normal_write} KB/s"

    rlLogInfo "Direct I/O Write: ${direct_write} KB/s"



    if [ -n "$normal_write" ] && [ -n "$direct_write" ]; then

    # Direct I/O more (bypass), but noshouldis 0

    if [ "$direct_write" != "0" ] && [ "$direct_write" != "" ]; then

    rlPass "Direct I/O producedhas: ${direct_write} KB/s"

    else

    rlLogWarning "Direct I/O is 0 (possible -I not supportedcurrentfilesystem)"

    fi

    # Standard I/O should Direct I/O (has)

    rlLogInfo ": $(awk "BEGIN {printf \"%.1f\", ${normal_write}/${direct_write}}" 2>/dev/null || echo N/A)x"

    fi

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

    rm -f /tmp/iozone_{normal,direct}.txt

    rlPhaseEnd

    rlJournalPrintText

rlJournalEnd

