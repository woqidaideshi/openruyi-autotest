#!/bin/bash
# jotai - 浮点精度: -ffast-math, -fno-fast-math, NaN/Inf 处理
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        jotaiSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""

        cat > fp.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>
#include <fenv.h>
int main(void){
  double a=0.1,b=0.2,c=0.3;
  double sum=a+b;
  printf("0.1+0.2=%.20f\n",sum);
  int ok=(fabs(sum-0.3)<1e-15);
  printf("sum_close_to_0.3=%d\n",ok);
  // 除零 → Inf
  double inf=1.0/0.0;
  printf("1.0/0.0=%.1f isinf=%d\n",inf,isinf(inf));
  // 0/0 → NaN
  double nan=0.0/0.0;
  int isnan_v=isnan(nan);
  printf("0.0/0.0 isnan=%d\n",isnan_v);
  // sqrt 负数
  double neg_sqrt=sqrt(-1.0);
  printf("sqrt(-1) isnan=%d\n",isnan(neg_sqrt));
  // 三角
  double s=sin(3.1415926535);
  printf("sin(pi)=%.15f\n",s);
  if(fabs(s)<1e-10)printf("sin_pi_ok\n");
  // 正常运算
  double mul=1.5*2.0; if(fabs(mul-3.0)>1e-15)abort();
  double d=10.0/3.0; if(fabs(d-3.333333333)<0.01)printf("div_ok\n");
  if(ok)printf("FP_OK\n");
  return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 浮点"
        for mode in "no-fast-math" "ffast-math"; do
            local flag=""; [ "$mode" == "ffast-math" ] && flag="-ffast-math"
            rlRun "gcc $flag -o fp_gcc_${mode} fp.c -lm && ./fp_gcc_${mode} >/tmp/fp_gcc_${mode}.txt 2>&1" 0 "GCC $mode"
            grep -q "FP_OK" /tmp/fp_gcc_${mode}.txt && rlPass "GCC $mode OK"
            grep -q "sin_pi_ok" /tmp/fp_gcc_${mode}.txt && rlPass "GCC $mode: sin(pi)≈0"
            grep -q "sum_close_to_0.3=1" /tmp/fp_gcc_${mode}.txt && rlPass "GCC $mode: 0.1+0.2≈0.3"
        done
        # 对比两个模式输出差异
        diff /tmp/fp_gcc_no-fast-math.txt /tmp/fp_gcc_ffast-math.txt >/tmp/fp_diff.txt 2>&1
        if [ -s /tmp/fp_diff.txt ]; then
            rlLogInfo "GCC -ffast-math vs no-fast-math 输出有差异（预期行为）"
            rlRun "cat /tmp/fp_diff.txt | head -10" 0 "浮点差异"
        else
            rlPass "GCC 浮点模式输出完全一致"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Clang 浮点"
        rlRun "clang -o fp_clang fp.c -lm && ./fp_clang | grep FP_OK" 0 "Clang 浮点 OK"
        rlRun "clang -ffast-math -o fp_clang_fast fp.c -lm && ./fp_clang_fast | grep FP_OK" 0 "Clang -ffast-math OK"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/fp_{gcc,clang}_*.txt /tmp/fp_diff.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
