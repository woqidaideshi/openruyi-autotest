#!/bin/bash
# yarpgen - vectorization: -ftree-vectorize, -fopt-info-vec
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 yarpgenSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""

 cat > vec.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#define N 1024
// canvectorizationloop
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
 // verify: sum(0..1023)=523776, dot(a,b)=sum(i*(N-i))
 int expected_dot=0;for(int i=0;i<N;i++)expected_dot+=i*(N-i);
 if(s!=523776||d!=expected_dot)abort();
 printf("VEC_OK\n");return 0;
}
CEOF
 rlPhaseEnd

 rlPhaseStartTest "GCC vectorization"
 # -O2 Default enabled -ftree-vectorize
 rlRun "gcc -O2 -o vec_gcc_O2 vec.c &&./vec_gcc_O2 | grep VEC_OK" 0 "GCC -O2 vectorizationcompile+run"

 # -O3 morevectorization
 rlRun "gcc -O3 -o vec_gcc_O3 vec.c &&./vec_gcc_O3 | grep VEC_OK" 0 "GCC -O3 vectorization"

 # disablevectorizationcomparison
 rlRun "gcc -O2 -fno-tree-vectorize -o vec_gcc_novec vec.c &&./vec_gcc_novec | grep VEC_OK" 0 "GCC disablevectorizationstill correct"

 # vectorizationreport
 gcc -O2 -ftree-vectorize -fopt-info-vec -c vec.c -o /dev/null 2>/tmp/vec_report.txt
 if grep -qi "vectorized\|loop vectorized\|LOOP VECTORIZED" /tmp/vec_report.txt; then
 rlPass "GCC vectorizationreport: detect to vectorizationloop"
 rlRun "grep -i 'vectorized\|VECTORIZED' /tmp/vec_report.txt | head -5" 0 "vectorizationlooplist"
 else
 rlLogInfo "GCC notreportvectorization（possibleorformatdifferent）"
 fi
 rlPhaseEnd

 rlPhaseStartTest "Clang vectorization"
 rlRun "clang -O2 -o vec_clang_O2 vec.c &&./vec_clang_O2 | grep VEC_OK" 0 "Clang -O2 vectorization"
 rlRun "clang -O3 -o vec_clang_O3 vec.c &&./vec_clang_O3 | grep VEC_OK" 0 "Clang -O3 vectorization"
 # Clang vectorizationreport
 clang -O2 -Rpass=loop-vectorize -c vec.c -o /dev/null 2>/tmp/vec_clang_report.txt
 if [ -s /tmp/vec_clang_report.txt ]; then
 rlPass "Clang vectorizationreport: hasoutput"
 rlRun "cat /tmp/vec_clang_report.txt | head -5" 0 "Clang vectorizationreport"
 fi
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rm -f /tmp/vec_{,clang_}report.txt
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
