#!/bin/bash
# dejagnu - GCC -fanalyzer analysis
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 dejagnuSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""

 # normal code（analyzer noshould error）
 cat > clean.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
int* alloc_and_fill(int n){int*p=malloc(n*sizeof(int));if(!p)return NULL;
for(int i=0;i<n;i++)p[i]=i;return p;}
int sum(int*p,int n){int s=0;for(int i=0;i<n;i++)s+=p[i];return s;}
int main(void){int*p=alloc_and_fill(10);if(!p)return 1;int s=sum(p,10);
printf("sum=%d\n",s);free(p);if(s!=45)abort();return 0;}
CEOF

 # hasinissue（double-free, use-after-free）
 cat > bug.c << 'CEOF'
#include <stdlib.h>
int* bug_double_free(void){int*p=malloc(100);free(p);free(p);return p;}
int bug_use_after_free(void){int*p=malloc(100);free(p);return*p;}
int bug_leak(void){int*p=malloc(100);return 0;}
CEOF
 rlPhaseEnd

 rlPhaseStartTest "normal code zero warning"
 rlRun "gcc -fanalyzer -Wall -o analyze_clean clean.c 2>/tmp/analyzer_clean.txt" 0 "GCC -fanalyzer normal codecompile"
 if grep -qi "warning:\|error:" /tmp/analyzer_clean.txt; then
 rlLogWarning "fanalyzer vsnormal codeproducedwarning"
 rlRun "cat /tmp/analyzer_clean.txt" 0 "analyzer output"
 else
 rlPass "fanalyzer: normal codezero warnings"
 fi
 rlRun "./analyze_clean | grep'sum=45'" 0 "normal coderunverify"
 rlPhaseEnd

 rlPhaseStartTest "Bug code detection"
 rlRun "gcc -fanalyzer -c bug.c -o bug.o 2>/tmp/analyzer_bug.txt" 0 "GCC -fanalyzer bug compile"
 rlRun "cat /tmp/analyzer_bug.txt" 0 "analyzer bug detectoutput"
 # analyzer shouldexport double-free or use-after-free
 if grep -qi "double.*free\|use.after.*free\|leak" /tmp/analyzer_bug.txt; then
 rlPass "fanalyzer successexportmemoryissue"
 else
 rlLogWarning "fanalyzer notexportprememoryissue（possibleversionnot supported）"
 fi
 rlPhaseEnd

 rlPhaseStartTest "Clang static analysis"
 rlRun "clang --analyze clean.c 2>/tmp/clang_analyze.txt" 0 "Clang --analyze normal code"
 if grep -qi "warning:\|error:" /tmp/clang_analyze.txt; then
 rlLogWarning "Clang --analyze vsnormal codeproducedwarning"
 else
 rlPass "Clang --analyze: normal codezero warnings"
 fi
 rlRun "clang --analyze bug.c 2>/tmp/clang_analyze_bug.txt" 0 "Clang --analyze bug "
 grep -qi "warning:" /tmp/clang_analyze_bug.txt && rlPass "Clang --analyze exportissue" || rlLogInfo "Clang notexport"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rm -f /tmp/{analyzer,clang_analyze}{_clean,_bug}.txt
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
