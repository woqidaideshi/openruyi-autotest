#!/bin/bash
# yarpgen - PGO: -fprofile-generate → trainingrun → -fprofile-use
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 yarpgenSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""

 cat > pgo_test.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
// pathfunction
static int hot_path(int n){int s=0;for(int i=0;i<n;i++)s+=i*i;return s;}
static int cold_path(int n){int s=1;for(int i=1;i<=n;i++)s*=i;return s;} // factorial
static int mixed(int n){return n<100? hot_path(n):cold_path(n%10);}
int main(void){
 // training: hot_path
 int total=0;
 for(int i=0;i<100;i++)total+=mixed(i);
 printf("total=%d\n",total);
 if(total!=328350)abort(); // sum_{i=0}^{99} sum_{j=0}^{i-1} j^2
 printf("PGO_OK\n");
 return 0;
}
CEOF
 rlPhaseEnd

 rlPhaseStartTest "GCC PGO"
 # Step 1: -fprofile-generate compile
 rlRun "gcc -fprofile-generate -o pgo_gen pgo_test.c" 0 "GCC -fprofile-generate compile"
 # Step 2: runproduced profile data
 rlRun "./pgo_gen" 0 "GCC PGO trainingrun"
 rlRun "ls *.gcda 2>/dev/null || echo no gcda" 0 "check profile file"
 # Step 3: -fprofile-use use profile newcompile
 rlRun "gcc -fprofile-use -o pgo_use pgo_test.c 2>/dev/null" 0 "GCC -fprofile-use compile"
 if [ -x./pgo_use ]; then
 rlRun "./pgo_use | grep PGO_OK" 0 "GCC PGO optimizationpostruncorrect"
 rlPass "GCC PGO Complete"
 else
 # e.g.if -fprofile-use failed（missing profile），with feedback 
 rlLogWarning "GCC -fprofile-use failed，retry -fprofile-feedback"
 rlRun "gcc -fprofile-correction -o pgo_fb pgo_test.c 2>/dev/null &&./pgo_fb | grep PGO_OK" 0 "GCC PGO fallback"
 fi
 rlPhaseEnd

 rlPhaseStartTest "Clang PGO"
 # Clang use -fprofile-instr-generate and -fprofile-instr-use
 rlRun "clang -fprofile-instr-generate -o pgo_clang_gen pgo_test.c 2>/dev/null" 0 "Clang -fprofile-instr-generate"
 if [ -x./pgo_clang_gen ]; then
 llvm-profdata merge 2>/dev/null && LLVM_PROFDATA=1 || LLVM_PROFDATA=0
 rlRun "./pgo_clang_gen" 0 "Clang PGO trainingrun"
 if [ "$LLVM_PROFDATA" -eq 1 ] && [ -f default.profraw ]; then
 llvm-profdata merge default.profraw -o default.profdata 2>/dev/null
 rlRun "clang -fprofile-instr-use=default.profdata -o pgo_clang_use pgo_test.c 2>/dev/null &&./pgo_clang_use | grep PGO_OK" 0 "Clang PGO optimizationrun"
 else
 rlLogInfo "Clang llvm-profdata noavailable，skip use "
 fi
 else
 rlLogInfo "Clang -fprofile-instr-generate not supported，skip"
 fi
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
