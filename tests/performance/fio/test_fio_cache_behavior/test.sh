#!/bin/bash

# Performance: fio - linesis: Direct I/O vs Buffered I/O, Measure Page Cache if

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 fioSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 ""

 rlPhaseEnd



 rlPhaseStartTest "Direct I/O vs Buffered read"

 local testfile="$TmpDir/cache_read.dat"

 dd if=/dev/zero of="$testfile" bs=1M count=512 2>/dev/null



 echo ""

 echo "=== Direct I/O vs Buffered sequential read ==="

 printf "%-15s %-15s %-15s\n" "Mode" "BW" "CPU(sys%)"



 # Buffered (first read, cold cache)

 _fioDropCaches

 local log="$TmpDir/buf_cold.log"

 fio --name=buf_cold --filename="$testfile" --direct=0 \

 --rw=read --bs=64k --size=256M --numjobs=1 --iodepth=8 \

 --ioengine=sync --runtime=15 2>&1 | tee "$log"

 local bw1 cpu1

 bw1=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

 cpu1=$(grep "cpu " "$log" | grep -oP'sys=\K[\d.]+%' | head -1)

 printf "%-15s %-15s %-15s\n" "Buffered(cold)" "${bw1:-N/A}" "${cpu1:-N/A}"



 # Buffered (second read, warm cache)

 local log="$TmpDir/buf_warm.log"

 fio --name=buf_warm --filename="$testfile" --direct=0 \

 --rw=read --bs=64k --size=256M --numjobs=1 --iodepth=8 \

 --ioengine=sync --runtime=15 2>&1 | tee "$log"

 local bw2 cpu2

 bw2=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

 cpu2=$(grep "cpu " "$log" | grep -oP'sys=\K[\d.]+%' | head -1)

 printf "%-15s %-15s %-15s\n" "Buffered(warm)" "${bw2:-N/A}" "${cpu2:-N/A}"



 # Direct I/O

 _fioDropCaches

 local log="$TmpDir/direct.log"

 fio --name=direct --filename="$testfile" --direct=1 \

 --rw=read --bs=64k --size=256M --numjobs=1 --iodepth=8 \

 --ioengine=libaio --runtime=15 2>&1 | tee "$log"

 local bw3 cpu3

 bw3=$(grep "READ:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

 cpu3=$(grep "cpu " "$log" | grep -oP'sys=\K[\d.]+%' | head -1)

 printf "%-15s %-15s %-15s\n" "Direct" "${bw3:-N/A}" "${cpu3:-N/A}"



 # analysis: warm cache shouldin cold/direct

 if [ -n "$bw2" ] && [ -n "$bw3" ]; then

 rlLogInfo "Page Cache: warm=$bw2 vs direct=$bw3"

 fi

 rlPass "linesiscomparisonComplete"

 rm -f "$testfile"

 rlPhaseEnd



 rlPhaseStartTest "Direct I/O vs Buffered write"

 _fioDropCaches

 echo ""

 echo "=== Direct I/O vs Buffered sequential write ==="

 printf "%-15s %-15s %-15s\n" "Mode" "BW" "CPU(sys%)"



 # Buffered write

 local testfile="$TmpDir/buf_write.dat"

 local log="$TmpDir/buf_write.log"

 fio --name=buf_write --filename="$testfile" --direct=0 \

 --rw=write --bs=64k --size=128M --numjobs=1 --iodepth=8 \

 --ioengine=sync --runtime=15 2>&1 | tee "$log"

 local bw1 cpu1

 bw1=$(grep "WRITE:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

 cpu1=$(grep "cpu " "$log" | grep -oP'sys=\K[\d.]+%' | head -1)

 printf "%-15s %-15s %-15s\n" "Buffered" "${bw1:-N/A}" "${cpu1:-N/A}"

 rm -f "$testfile"



 # Direct write

 _fioDropCaches

 local testfile="$TmpDir/dir_write.dat"

 local log="$TmpDir/dir_write.log"

 fio --name=dir_write --filename="$testfile" --direct=1 \

 --rw=write --bs=64k --size=128M --numjobs=1 --iodepth=8 \

 --ioengine=libaio --runtime=15 2>&1 | tee "$log"

 local bw2 cpu2

 bw2=$(grep "WRITE:" "$log" | grep -oP 'bw=\K[\d.]+[KMG]iB/s' | head -1)

 cpu2=$(grep "cpu " "$log" | grep -oP'sys=\K[\d.]+%' | head -1)

 printf "%-15s %-15s %-15s\n" "Direct" "${bw2:-N/A}" "${cpu2:-N/A}"



 rlPass "writelinesiscomparisonComplete"

 rm -f "$testfile"

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

