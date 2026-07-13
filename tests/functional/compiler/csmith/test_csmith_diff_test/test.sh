#!/bin/bash


# Functional test: compiler - csmith - differential testing (GCC vs Clang output comparison)


# core test: Csmith random program compiled with gcc and clang, then run to compare output


# compare output -- e.g. if output mismatch, compiler has bug





. /usr/share/beakerlib/beakerlib.sh || exit 1


. "$(dirname "$0")/../lib.sh"





rlJournalStart


 rlPhaseStartSetup "Environment setup"


 csmithSetup


 TmpDir=$(mktemp -d)


 rlRun "cd $TmpDir" 0 "Enter temporary directory"


 


 # Generate 3 different random programs, check for bugs 


 for i in 1 2 3; do


 rlRun "csmith > csmith_diff_${i}.c 2>/dev/null" 0 "Generate random program #${i}"


 done


 rlPhaseEnd





 rlPhaseStartTest "differential testing"


 local diff_failures=0


 local total_tests=0


 


 for i in 1 2 3; do


 local src="csmith_diff_${i}.c"


 local gcc_bin="csmith_diff_${i}_gcc"


 local clang_bin="csmith_diff_${i}_clang"


 local gcc_out="csmith_diff_${i}_gcc_out.txt"


 local clang_out="csmith_diff_${i}_clang_out.txt"


 


 rlLogInfo "=== differential testing #${i} ==="


 total_tests=$((total_tests + 1))


 


 # GCC compile


 if gcc -O2 "$src" -o "$gcc_bin" -w 2>/dev/null; then


 rlPass "test #${i}: GCC Compile succeeded"


 else


 rlFail "test #${i}: GCC Compile failed"


 continue


 fi


 


 # Clang compile


 if clang -O2 "$src" -o "$clang_bin" -w 2>/dev/null; then


 rlPass "test #${i}: Clang Compile succeeded"


 else


 rlFail "test #${i}: Clang Compile failed"


 continue


 fi


 


 # GCC run


 timeout 10./"$gcc_bin" > "$gcc_out" 2>/tmp/csmith_gcc_runerr_${i}.txt


 local gcc_run_rc=$?


 


 # Clang run


 timeout 10./"$clang_bin" > "$clang_out" 2>/tmp/csmith_clang_runerr_${i}.txt


 local clang_run_rc=$?


 


 # checkrunexit code


 if [ "$gcc_run_rc" -ne 0 ]; then


 rlLogWarning "test #${i}: GCC runtime exit codenon- 0: $gcc_run_rc"


 fi


 if [ "$clang_run_rc" -ne 0 ]; then


 rlLogWarning "test #${i}: Clang runtime exit codenon- 0: $clang_run_rc"


 fi


 


 # Check for runtime errors


 local has_error=0


 if grep -qi "segmentation fault\|core dumped\|stack smash\|buffer overflow" /tmp/csmith_gcc_runerr_${i}.txt 2>/dev/null; then


 rlLogWarning "test #${i}: GCC runtime detect/error"


 has_error=1


 fi


 if grep -qi "segmentation fault\|core dumped\|stack smash\|buffer overflow" /tmp/csmith_clang_runerr_${i}.txt 2>/dev/null; then


 rlLogWarning "test #${i}: Clang runtime detect/error"


 has_error=1


 fi


 


 # core: output comparison


 if [ -f "$gcc_out" ] && [ -f "$clang_out" ]; then


 if diff -q "$gcc_out" "$clang_out" >/dev/null 2>&1; then


 rlPass "test #${i}: GCC and Clang output consistent ✓"


 else


 diff_failures=$((diff_failures + 1))


 rlLogWarning "test #${i}: GCC and Clang output mismatch!"


 


 # Show diff (display first 20 lines)


 rlRun "diff $gcc_out $clang_out | head -20" 0 "output diff (before 20 lines)"


 


 # Check for undefined behavior (UB) causing diff -- Csmith generates standard C, should be consistent


 rlFail "test #${i}: differential testing failed -- GCC/Clang output mismatch (possible compiler bug)"


 fi


 else


 rlFail "test #${i}: notcan Generateoutputfile"


 fi


 


 # checkoutputall non-


 if [ -s "$gcc_out" ] && [ -s "$clang_out" ]; then


 rlPass "test #${i}: compileproducedhasoutput"


 else


 rlLogWarning "test #${i}: outputfileis"


 fi


 done


 


 # Summary


 rlLogInfo "differential testingComplete: $total_tests program, $diff_failures noconsistent"


 if [ "$diff_failures" -eq 0 ]; then


 rlPass "alldifferential testingpassed: nocompileoutput mismatch"


 fi


 rlPhaseEnd





 rlPhaseStartCleanup "Cleanup"


 rlRun "cd /" 0 "Leave temporary directory"


 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"


 rm -f /tmp/csmith_{gcc,clang}_runerr_*.txt


 rlPhaseEnd





 rlJournalPrintText


rlJournalEnd


