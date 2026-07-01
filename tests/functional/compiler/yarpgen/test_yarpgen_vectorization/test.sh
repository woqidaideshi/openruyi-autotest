#!/bin/bash
# yarpgen - 自动向量化: -ftree-vectorize, -fopt-info-vec
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        yarpgenSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""

        cat > vec.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#define N 1024
// 典型可向量化循环
static void vec_add(int*a,int*b,int*c,int n){for(int i=0;i<n;i++)c[i]=a[i]+b[i];}
static void vec_mul(float*a,float*b,float*c,int n){for(int i=0;i<n;i++)c[i]=a[i]*b[i];}
static int sum(int*a,int n){int s=0;for(int i=0;i<n;i++)s+=a[i];return s;}
static int dot(int*a,int*b,int n){int s=0;for(int i=0;i<n;i++)s+=a[i]*b[i];return s;}
int main(void){
  static int a[N],b[N],c[N];
  for(int i=0;i<N;i++){a[i]=i;b[i]=N-i;}
  vec_add(a,b,c,N);
  for(int i=0;i<N;i++)if(c[i]!=N)abort(); // a[i]+b[i]=i+N-i=N
  int s=sum(a,N);
  int d=dot(a,b,N);
  printf("sum=%d dot=%d\n",s,d);
  // 验证: sum(0..1023)=523776, dot(a,b)=sum(i*(N-i))
  int expected_dot=0;for(int i=0;i<N;i++)expected_dot+=i*(N-i);
  if(s!=523776||d!=expected_dot)abort();
  printf("VEC_OK\n");return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 向量化"
        # -O2 默认启用 -ftree-vectorize
        rlRun "gcc -O2 -o vec_gcc_O2 vec.c && ./vec_gcc_O2 | grep VEC_OK" 0 "GCC -O2 向量化编译+运行"

        # -O3 更激进向量化
        rlRun "gcc -O3 -o vec_gcc_O3 vec.c && ./vec_gcc_O3 | grep VEC_OK" 0 "GCC -O3 向量化"

        # 禁止向量化对比
        rlRun "gcc -O2 -fno-tree-vectorize -o vec_gcc_novec vec.c && ./vec_gcc_novec | grep VEC_OK" 0 "GCC 禁止向量化仍正确"

        # 向量化报告
        gcc -O2 -ftree-vectorize -fopt-info-vec -c vec.c -o /dev/null 2>/tmp/vec_report.txt
        if grep -qi "vectorized\|loop vectorized\|LOOP VECTORIZED" /tmp/vec_report.txt; then
            rlPass "GCC 向量化报告: 检测到向量化循环"
            rlRun "grep -i 'vectorized\|VECTORIZED' /tmp/vec_report.txt | head -5" 0 "向量化循环列表"
        else
            rlLogInfo "GCC 未报告向量化（可能被忽略或格式不同）"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Clang 向量化"
        rlRun "clang -O2 -o vec_clang_O2 vec.c && ./vec_clang_O2 | grep VEC_OK" 0 "Clang -O2 向量化"
        rlRun "clang -O3 -o vec_clang_O3 vec.c && ./vec_clang_O3 | grep VEC_OK" 0 "Clang -O3 向量化"
        # Clang 向量化报告
        clang -O2 -Rpass=loop-vectorize -c vec.c -o /dev/null 2>/tmp/vec_clang_report.txt
        if [ -s /tmp/vec_clang_report.txt ]; then
            rlPass "Clang 向量化报告: 有输出"
            rlRun "cat /tmp/vec_clang_report.txt | head -5" 0 "Clang 向量化报告"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/vec_{,clang_}report.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
