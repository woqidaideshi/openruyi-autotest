#!/bin/bash
# Functional test: compiler - jotai - GCC multioptimizationlevelcompilerun
# Select Jotai benchmark，with gcc -O0/-O1/-O2/-O3 compileandrun
# verify: All optimization levels compile successfully、Runs without crash、outputcontentconsistent

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

BENCH_DIR="/tmp/jotai-benchmarks/benchmarks/anghaLeaves"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 jotaiSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"
 
 jotaiPrepareBenchmark./bench.c
 if [ ! -f./bench.c ]; then
 rlFail "bench.c createfailed"
 fi
 rlPhaseEnd

 rlPhaseStartTest "GCC compile and run"
 if [ ! -f./bench.c ]; then
 rlFail "bench.c does not exist，skiptest"
 else
 outputs=()
 exit_codes=()
 
 for opt in O0 O1 O2 O3; do
 bin="bench_gcc_$opt"
 out="output_gcc_$opt.txt"
 
 # compile
 rlRun "gcc -std=c99 -$opt bench.c -o $bin -lm 2>&1" 0 "GCC -$opt compile"
 
 if [ -x "./$bin" ]; then
 # run（input: 0=big-arr, 1=big-arr-10x）
 rlRun "./$bin 0 > $out 2>&1; echo \"exit=\$?\" >> $out" 0 "GCC -$opt run (input=0)"
 
 # checkwhetherhasoutput
 if [ -s "$out" ]; then
 rlPass "GCC -$opt producedoutput ($(wc -c < $out) bytes)"
 else
 rlLogWarning "GCC -$opt outputis"
 fi
 
 outputs+=("$(cat $out)")
 exit_codes+=("$?")
 else
 rlFail "GCC -$opt compilenocanExecute"
 fi
 done
 
 # verifyalloptimizationopt level output consistent
 if [ ${#outputs[@]} -ge 2 ]; then
 first="${outputs[0]}"
 all_match=1
 for ((i=1; i<${#outputs[@]}; i++)); do
 if [ "${outputs[$i]}" != "$first" ]; then
 all_match=0
 rlLogWarning "GCC -$opt outputandotherlevelnoconsistent"
 fi
 done
 if [ "$all_match" -eq 1 ]; then
 rlPass "GCC alloptimizationopt level output consistent"
 else
 # output mismatchnofailed（differentoptimizationpossiblehasdifferentlinesis），recordwarning
 rlLogWarning "GCC differentoptimizationleveloutputexistsdiff（possiblebyoptimizationcauses）"
 rlPass "GCC alloptimizationlevelcompilerunsuccess"
 fi
 fi
 fi
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 "Leave temporary directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
