#!/bin/bash
# yarpgen - TLS: __thread (C), thread_local (C++)
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        yarpgenSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""

        cat > tls_c.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
__thread int tls_var = 0;
__thread char tls_buf[64];
static void test_tls_init(void){
  tls_var++;
  snprintf(tls_buf,sizeof(tls_buf),"tls_%d",tls_var);
}
int main(void){
  test_tls_init();
  printf("tls_var=%d buf=%s\n",tls_var,tls_buf);
  if(tls_var!=1)abort();
  test_tls_init();
  printf("tls_var=%d buf=%s\n",tls_var,tls_buf);
  if(tls_var!=2)abort();
  printf("TLS_C_OK\n");return 0;
}
CEOF

        cat > tls_cpp.cpp << 'CEOF'
#include <iostream>
#include <string>
using namespace std;
thread_local int tl_int = 100;
thread_local string tl_str = "init";
int main(){
  tl_int += 42;
  tl_str += "_modified";
  cout<<"tl_int="<<tl_int<<" tl_str="<<tl_str<<endl;
  if(tl_int!=142)abort();
  if(tl_str!="init_modified")abort();
  cout<<"TLS_CPP_OK"<<endl;return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC __thread"
        rlRun "gcc -std=c11 -o tls_c_gcc tls_c.c && ./tls_c_gcc | grep TLS_C_OK" 0 "GCC __thread 运行正确"
        rlRun "gcc -std=c11 -o tls_c_gcc tls_c.c -lpthread" 0 "GCC __thread -lpthread 编译"
    rlPhaseEnd

    rlPhaseStartTest "G++ thread_local"
        rlRun "g++ -std=c++17 -o tls_cpp_gxx tls_cpp.cpp && ./tls_cpp_gxx | grep TLS_CPP_OK" 0 "G++ thread_local 运行正确"
    rlPhaseEnd

    rlPhaseStartTest "Clang __thread"
        rlRun "clang -std=c11 -o tls_c_clang tls_c.c && ./tls_c_clang | grep TLS_C_OK" 0 "Clang __thread 运行正确"
    rlPhaseEnd

    rlPhaseStartTest "Clang++ thread_local"
        rlRun "clang++ -std=c++17 -o tls_cpp_clang tls_cpp.cpp && ./tls_cpp_clang | grep TLS_CPP_OK" 0 "Clang++ thread_local 运行正确"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
