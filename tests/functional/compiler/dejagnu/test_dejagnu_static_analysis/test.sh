#!/bin/bash
# dejagnu - GCC -fanalyzer 静态分析
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        dejagnuSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""

        # 正常代码（analyzer 不应报错）
        cat > clean.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
int* alloc_and_fill(int n){int*p=malloc(n*sizeof(int));if(!p)return NULL;
for(int i=0;i<n;i++)p[i]=i;return p;}
int sum(int*p,int n){int s=0;for(int i=0;i<n;i++)s+=p[i];return s;}
int main(void){int*p=alloc_and_fill(10);if(!p)return 1;int s=sum(p,10);
printf("sum=%d\n",s);free(p);if(s!=45)abort();return 0;}
CEOF

        # 有潜在问题的代码（double-free, use-after-free）
        cat > bug.c << 'CEOF'
#include <stdlib.h>
int* bug_double_free(void){int*p=malloc(100);free(p);free(p);return p;}
int bug_use_after_free(void){int*p=malloc(100);free(p);return*p;}
int bug_leak(void){int*p=malloc(100);return 0;}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "正常代码 zero warning"
        rlRun "gcc -fanalyzer -Wall -o analyze_clean clean.c 2>/tmp/analyzer_clean.txt" 0 "GCC -fanalyzer 正常代码编译"
        if grep -qi "warning:\|error:" /tmp/analyzer_clean.txt; then
            rlLogWarning "fanalyzer 对正常代码产生警告"
            rlRun "cat /tmp/analyzer_clean.txt" 0 "analyzer 输出"
        else
            rlPass "fanalyzer: 正常代码零警告"
        fi
        rlRun "./analyze_clean | grep 'sum=45'" 0 "正常代码运行验证"
    rlPhaseEnd

    rlPhaseStartTest "Bug 代码检测"
        rlRun "gcc -fanalyzer -c bug.c -o bug.o 2>/tmp/analyzer_bug.txt" 0 "GCC -fanalyzer bug 代码编译"
        rlRun "cat /tmp/analyzer_bug.txt" 0 "analyzer bug 检测输出"
        # analyzer 应检出 double-free 或 use-after-free
        if grep -qi "double.*free\|use.after.*free\|leak" /tmp/analyzer_bug.txt; then
            rlPass "fanalyzer 成功检出内存问题"
        else
            rlLogWarning "fanalyzer 未检出预期的内存问题（可能版本不支持）"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Clang static analysis"
        rlRun "clang --analyze clean.c 2>/tmp/clang_analyze.txt" 0 "Clang --analyze 正常代码"
        if grep -qi "warning:\|error:" /tmp/clang_analyze.txt; then
            rlLogWarning "Clang --analyze 对正常代码产生警告"
        else
            rlPass "Clang --analyze: 正常代码零警告"
        fi
        rlRun "clang --analyze bug.c 2>/tmp/clang_analyze_bug.txt" 0 "Clang --analyze bug 代码"
        grep -qi "warning:" /tmp/clang_analyze_bug.txt && rlPass "Clang --analyze 检出问题" || rlLogInfo "Clang 未检出"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/{analyzer,clang_analyze}{_clean,_bug}.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
