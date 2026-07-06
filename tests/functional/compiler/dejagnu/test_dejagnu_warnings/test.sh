#!/bin/bash
# Functional test: compiler - dejagnu - 警告体系
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        dejagnuSetup
        if ! rpm -q clang 2>/dev/null; then echo openruyi | sudo -S dnf install -y clang 2>/dev/null; fi
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        cat > clean.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static int add(int a,int b){return a+b;}
static void pv(const int*v,size_t n){for(size_t i=0;i<n;i++)printf("%d ",v[i]);printf("\n");}
int main(void){int r=add(100,200);if(r!=300)abort();
int a[]={1,2,3,4,5};pv(a,5);size_t n=sizeof(a)/sizeof(a[0]);if(n!=5)abort();
printf("WARN_CLEAN_OK\n");return 0;}
CEOF

        cat > clean.cpp << 'CEOF'
#include <iostream>
#include <vector>
static int add(int a,int b){return a+b;}
int main(){int x=static_cast<int>(3.14);
std::vector<int>v={1,2,3,4,5};
for(std::size_t i=0;i<v.size();++i)if(v[i]!=static_cast<int>(i+1))abort();
int r=add(x,10);std::cout<<"result="<<r<<std::endl;
std::cout<<"WARN_CLEAN_CXX_OK"<<std::endl;return 0;}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC/G++ 零警告"
        rlRun "gcc -Wall -Wextra -o w_gcc clean.c 2>/tmp/gcc_w.txt && [ ! -s /tmp/gcc_w.txt ]" 0 "GCC -Wall -Wextra 零警告"
        rlRun "gcc -Wall -Werror -o w_gcc_we clean.c && ./w_gcc_we | grep WARN_CLEAN_OK" 0 "GCC -Wall -Werror"
        rlRun "g++ -Wall -Wextra -o w_gxx clean.cpp 2>/tmp/gxx_w.txt && ./w_gxx | grep WARN_CLEAN_CXX_OK" 0 "G++ -Wall -Wextra"
        rlRun "g++ -Wall -Werror -o w_gxx_we clean.cpp && ./w_gxx_we | grep WARN_CLEAN_CXX_OK" 0 "G++ -Wall -Werror"
    rlPhaseEnd

    rlPhaseStartTest "Clang/Clang++ 零警告"
        rlRun "clang -Wall -Wextra -o w_clang clean.c && ./w_clang | grep WARN_CLEAN_OK" 0 "Clang -Wall -Wextra"
        rlRun "clang -Wall -Werror -o w_clang_we clean.c && ./w_clang_we | grep WARN_CLEAN_OK" 0 "Clang -Wall -Werror"
        rlRun "clang++ -Wall -Wextra -o w_clangxx clean.cpp && ./w_clangxx | grep WARN_CLEAN_CXX_OK" 0 "Clang++ -Wall -Wextra"
        rlRun "clang++ -Wall -Werror -o w_clangxx_we clean.cpp && ./w_clangxx_we | grep WARN_CLEAN_CXX_OK" 0 "Clang++ -Wall -Werror"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/{gcc,gxx}_w.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
