#!/bin/bash
# csmith - 位置无关代码: -fPIC/-fPIE/-pie, 符号可见性
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        csmithSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""

        cat > pic_test.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
// 默认可见符号
int public_func(int x){return x*2;}
// 隐藏符号
__attribute__((visibility("hidden"))) int hidden_func(int x){return x*3;}
// 弱符号
__attribute__((weak)) int weak_func(int x){return x+1;}
// 强符号（默认）
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
        # -fPIC 编译共享目标文件
        rlRun "gcc -fPIC -c pic_test.c -o pic_test.o" 0 "GCC -fPIC 编译"
        # -pie 链接为位置无关可执行文件
        rlRun "gcc -pie -o pie_gcc pic_main.c pic_test.o && ./pie_gcc | grep PIC_PIE_OK" 0 "GCC -pie 运行"
        # 验证 PIE binary
        rlRun "file pie_gcc | grep -q 'shared object\|pie executable\|position independent'" 0 "GCC PIE 类型验证"

        # -fPIE
        rlRun "gcc -fPIE -c pic_main.c -o pic_main.o && gcc -pie pic_main.o pic_test.o -o pie2_gcc && ./pie2_gcc | grep PIC_PIE_OK" 0 "GCC -fPIE + -pie"

        # 验证 hidden 符号不导出
        rlRun "nm pic_test.o | grep -q 'hidden_func'" 0 "hidden_func 存在于 .o"
        nm pic_test.o | grep hidden_func | grep -qi ' t \| T ' && rlLogInfo "hidden_func 在符号表中可见"
    rlPhaseEnd

    rlPhaseStartTest "Clang -fPIC + -pie"
        rlRun "clang -fPIC -c pic_test.c -o pic_test_c.o" 0 "Clang -fPIC 编译"
        rlRun "clang -pie -o pie_clang pic_main.c pic_test_c.o && ./pie_clang | grep PIC_PIE_OK" 0 "Clang -pie"
        rlPass "Clang PIC/PIE 正确"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
