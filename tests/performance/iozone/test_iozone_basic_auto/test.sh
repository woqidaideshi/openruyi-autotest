#!/bin/bash

# Performance: iozone - mode (-a): testmultiblock sizeandfilesize

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    iozoneSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary directory"

    sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true

    rlLogInfo "alreadyCleanup"

    rlPhaseEnd



    rlPhaseStartTest "Auto Mode (-a) file"

    local log="$TmpDir/iozone_auto_small.log"

    # -a: auto mode, -c: include close, 64m file

    rlRun "iozone -a -c -s 64m -r 4k -f $TmpDir/iozone_test.dat 2>&1 | tee $log" 0 "iozone -a -s 64m -r 4k"



    echo ""

    echo "=== IOzone Auto Mode result (64M, 4K) ==="

    cat "$log"

    echo "=== output end ==="



    # verifydatafull

    grep -q "Auto Mode" "$log" && rlPass "Auto Mode outputconfirm"

    grep -qE '^\s+[0-9]+\s+[0-9]+' "$log" && rlPass "datalinesexists"

    _iozoneParseOutput "$log"

    rlPhaseEnd



    rlPhaseStartTest "Auto Mode (-a) infile"

    sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true

    local log="$TmpDir/iozone_auto_medium.log"

    rlRun "iozone -a -c -s 256m -r 16k -f $TmpDir/iozone_test2.dat 2>&1 | tee $log" 0 "iozone -a -s 256m -r 16k"



    echo ""

    echo "=== IOzone Auto Mode result (256M, 16K) ==="

    cat "$log"

    echo "=== output end ==="



    grep -qE '^\s+[0-9]+\s+[0-9]+' "$log" && rlPass "datalinesexists"

    _iozoneParseOutput "$log"

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

    rlPhaseEnd

    rlJournalPrintText

rlJournalEnd

