#!/bin/bash

# Performance: lmbench - filesystem: filecreate/delete, mmap, page faultlatency

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 lmbenchSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 ""

 rlPhaseEnd



 rlPhaseStartTest "filecreate/deletelatency"

 cd "$LMBENCH_DIR"

 echo "=== fileoperationlatency (microsecond) ==="



 # 0K file

 echo "0file:"

 echo -n " create: ";./bin/lat_fs /tmp 2>&1 | grep -oP '[\d.]+' | head -1 || echo "N/A"

 echo -n " delete: ";./bin/lat_unlink /tmp 2>&1 | grep -oP '[\d.]+' | head -1 || echo "N/A"



 # 10K file 

 echo "10Kfile:"

./bin/lat_fs 10k /tmp 2>&1 || true

 echo ""



 rlPass "fileoperationlatencytestComplete"

 rlPhaseEnd



 rlPhaseStartTest "mmap mappinglatency"

 cd "$LMBENCH_DIR"

 echo ""

 echo "=== mmap latency (microsecond) ==="

 for size in 1m 4m 16m; do

 echo -n " mmap ${size}: "

./bin/lat_mmap ${size} /tmp 2>&1 | grep -oP '[\d.]+' | head -1 || echo "N/A"

 done

 rlPass "mmap latencyanalysisComplete"

 rlPhaseEnd



 rlPhaseStartTest "page faultlatency"

 cd "$LMBENCH_DIR"

 echo ""

 echo "=== pageerror handlinglatency ==="

 # Page fault (major/minor)

 echo -n " minor page fault: "

./bin/lat_pagefault /tmp 2>&1 | grep -oP '[\d.]+' | head -1 || echo "N/A"



 # filesystembandwidth

 echo ""

 echo "=== filesystemsequential readwritebandwidth ==="

 for size in 1m 4m; do

 echo -n " read ${size}: "

./bin/bw_file_rd ${size} io_only /tmp 2>&1 | grep -oP '[\d.]+' | tail -1 || echo "N/A"

 done

 rlPass "page faultanalysisComplete"

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

