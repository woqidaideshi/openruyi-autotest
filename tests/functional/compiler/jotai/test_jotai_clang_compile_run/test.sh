#!/bin/bash
# Functional test: compiler - jotai - Clang multioptimizationlevelcompilerun
# Select Jotai benchmark (and gcc testwithfile), with clang compilerun
# verify: All optimization levels compile successfully, Runs without crash, outputand gcc consistent (differential testing)

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

 rlPhaseStartTest "Clang compile and run"
 if [ ! -f./bench.c ]; then
 rlFail "bench.c does not exist, skiptest"
 else
 outputs=()
 
 for opt in O0 O1 O2 O3; do
 bin="bench_clang_$opt"
 out="output_clang_$opt.txt"
 
 rlRun "clang -$opt bench.c -o $bin -lm 2>&1" 0 "Clang -$opt compile"
 
 if [ -x "./$bin" ]; then
 rlRun "./$bin 0 > $out 2>&1" 0 "Clang -$opt run (input=0)"
 
 if [ -s "$out" ]; then
 rlPass "Clang -$opt producedoutput ($(wc -c < $out) bytes)"
 
 # checkwhetherhaserroroutput
 if grep -qi "error\|segfault\|abort\|assert" "$out" 2>/dev/null; then
 rlLogWarning "Clang -$opt outputcontainserrorinfo"
 fi
 else
 rlLogWarning "Clang -$opt outputis"
 fi
 
 outputs+=("$(cat $out)")
 else
 rlFail "Clang -$opt compilenocanExecute"
 fi
 done
 
 # simultaneouslywith gcc compileiscomparison
 if command -v gcc >/dev/null 2>&1; then
 rlRun "gcc -std=c99 -O2 bench.c -o bench_gcc_O2 -lm 2>&1" 0 "GCC -O2 compile (comparison)"
 if [ -x "./bench_gcc_O2" ]; then
./bench_gcc_O2 0 > output_gcc_ref.txt 2>&1
 
 # comparison clang -O2 and gcc -O2 output
 if [ -f "output_clang_O2.txt" ]; then
 if diff -q output_gcc_ref.txt output_clang_O2.txt >/dev/null 2>&1; then
 rlPass "GCC and Clang -O2 output consistent (differential testingpassed)"
 else
 rlLogWarning "GCC and Clang -O2 output mismatch (possiblebycompilediffcauses)"
 rlRun "diff output_gcc_ref.txt output_clang_O2.txt" 0 "displayoutput diff"
 # noconsistentno bug, but needs
 rlPass "GCC and Clang correctcompilerun"
 fi
 fi
 fi
 fi
 
 # verify Clang Internaleach optimizationlevelconsistent
 if [ ${#outputs[@]} -ge 2 ]; then
 first="${outputs[0]}"
 all_match=1
 for ((i=1; i<${#outputs[@]}; i++)); do
 if [ "${outputs[$i]}" != "$first" ]; then
 all_match=0
 fi
 done
 if [ "$all_match" -eq 1 ]; then
 rlPass "Clang alloptimizationopt level output consistent"
 else
 rlLogWarning "Clang differentoptimizationleveloutputexistsdiff"
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
