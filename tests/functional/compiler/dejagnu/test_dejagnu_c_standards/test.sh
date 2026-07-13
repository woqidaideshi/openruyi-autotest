#!/bin/bash
# Functional test: compiler - dejagnu - C language standard (C99/C11/C17)
# verify GCC and Clang vsdifferent C Standardsupports
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 dejagnuSetup
 if ! rpm -q clang 2>/dev/null; then echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y clang 2>/dev/null; fi
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"

 cat > c99_test.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
int main(void) {
 int x = 10, y = x * 2;
 int n = 5, vla[n];
 for (int i = 0; i < n; i++) vla[i] = i * i;
 for (int i = 0; i < n; i++) if (vla[i] != i * i) abort();
 int64_t val = 12345678901234LL;
 if (sizeof(int64_t) != 8) abort();
 inline int sq(int a) { return a * a; }
 if (sq(7) != 49) abort();
 printf("C99_OK\n"); return 0;
}
CEOF

 cat > c11_test.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <stdalign.h>
_Static_assert(sizeof(int) >= 4, "int too small");
#define type_name(x) _Generic((x), int:"int", long:"long", float:"float", double:"double", default:"other")
int main(void) {
 printf("int->%s double->%s\n", type_name(42), type_name(3.14));
 alignas(64) int av = 100;
 if (av != 100) abort();
 printf("C11_OK\n"); return 0;
}
CEOF

 cat > c17_test.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define cmp(a,b) _Generic((a), int:(a)==(b), double:(a)==(b), default:0)
int main(void) {
 if (!cmp(42,42)) abort();
 int *p = (int[]){1,2,3,4,5}; int s=0;
 for (int i=0;i<5;i++) s+=p[i];
 if (s!=15) abort();
 struct {int a;int b;int c;} st={.a=1,.c=3};
 if (st.a!=1||st.c!=3) abort();
 printf("C17_OK\n"); return 0;
}
CEOF
 rlPhaseEnd

 rlPhaseStartTest "GCC C Standard"
 rlRun "gcc -std=c99 -Wall -o c99_gcc c99_test.c && ./c99_gcc | grep C99_OK" 0 "GCC -std=c99"
 rlRun "gcc -std=c11 -Wall -o c11_gcc c11_test.c && ./c11_gcc | grep C11_OK" 0 "GCC -std=c11"
 rlRun "gcc -std=c17 -Wall -o c17_gcc c17_test.c && ./c17_gcc | grep C17_OK" 0 "GCC -std=c17"
 rlPhaseEnd

 rlPhaseStartTest "Clang C Standard"
 rlRun "clang -std=c99 -Wall -o c99_clang c99_test.c && ./c99_clang | grep C99_OK" 0 "Clang -std=c99"
 rlRun "clang -std=c11 -Wall -o c11_clang c11_test.c && ./c11_clang | grep C11_OK" 0 "Clang -std=c11"
 rlRun "clang -std=c17 -Wall -o c17_clang c17_test.c && ./c17_clang | grep C17_OK" 0 "Clang -std=c17"
 ./c99_gcc >/tmp/c99_gcc.txt 2>&1; ./c99_clang >/tmp/c99_clang.txt 2>&1
 diff -q /tmp/c99_gcc.txt /tmp/c99_clang.txt >/dev/null 2>&1 && rlPass "C99 GCC/Clang output consistent" || rlLogInfo "C99 output differs"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rm -f /tmp/c99_{gcc,clang}.txt
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
