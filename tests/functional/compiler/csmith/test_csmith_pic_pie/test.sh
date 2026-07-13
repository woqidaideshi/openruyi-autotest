#!/bin/bash
# csmith - no: -fPIC/-fPIE/-pie, symbolcan
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 csmithSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""

 cat > pic_test.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
// defaultcansymbol
int public_func(int x){return x*2;}
// symbol
__attribute__((visibility("hidden"))) int hidden_func(int x){return x*3;}
// symbol
__attribute__((weak)) int weak_func(int x){return x+1;}
// symbol（default）
int strong_func(int x){return x+2;}
const char* get_info(void){return "PIC_PIE_OK";}
CEOF

 cat > pic_main.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
extern int public_func(int);
extern int strong_func(int);
extern const char* get_info(void);
int main(void){int a=public_func(21);int b=strong_func(40);
printf("public=%d strong=%d info=%s\n",a,b,get_info());
if(a!=42||b!=42)abort();printf("PIC_PIE_OK\n");return 0;}
CEOF
 rlPhaseEnd

 rlPhaseStartTest "GCC -fPIC + -pie"
 # -fPIC compilesharedtargetfile
 rlRun "gcc -fPIC -c pic_test.c -o pic_test.o" 0 "GCC -fPIC compile"
 # -pie linkisnoexecutable
 rlRun "gcc -pie -o pie_gcc pic_main.c pic_test.o &&./pie_gcc | grep PIC_PIE_OK" 0 "GCC -pie run"
 # verify PIE binary
 rlRun "file pie_gcc | grep -q'shared object\|pie executable\|position independent'" 0 "GCC PIE typeverify"

 # -fPIE
 rlRun "gcc -fPIE -c pic_main.c -o pic_main.o && gcc -pie pic_main.o pic_test.o -o pie2_gcc &&./pie2_gcc | grep PIC_PIE_OK" 0 "GCC -fPIE + -pie"

 # verify hidden symbolnoexport
 rlRun "nm pic_test.o | grep -q 'hidden_func'" 0 "hidden_func existsin.o"
 nm pic_test.o | grep hidden_func | grep -qi ' t \| T ' && rlLogInfo "hidden_func insymboltableincan"
 rlPhaseEnd

 rlPhaseStartTest "Clang -fPIC + -pie"
 rlRun "clang -fPIC -c pic_test.c -o pic_test_c.o" 0 "Clang -fPIC compile"
 rlRun "clang -pie -o pie_clang pic_main.c pic_test_c.o &&./pie_clang | grep PIC_PIE_OK" 0 "Clang -pie"
 rlPass "Clang PIC/PIE correct"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
