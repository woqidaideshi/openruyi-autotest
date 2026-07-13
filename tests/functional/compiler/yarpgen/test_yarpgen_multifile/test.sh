#!/bin/bash
# Functional test: compiler - yarpgen - multifileseparate compilation + C/C++ 
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 yarpgenSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"

 cat > str.c << 'CEOF'
#include <string.h>
#include <ctype.h>
int cv(const char*s){int c=0;for(;*s;s++){char ch=tolower((unsigned char)*s);
if(ch=='a'||ch=='e'||ch=='i'||ch=='o'||ch=='u')c++;}return c;}
int cd(const char*s){int c=0;for(;*s;s++)if(*s>='0'&&*s<='9')c++;return c;}
CEOF
 cat > str.h << 'CEOF'
#ifndef S_H
#define S_H
#ifdef __cplusplus
extern "C" {
#endif
int cv(const char*s);int cd(const char*s);
#ifdef __cplusplus
}
#endif
#endif
CEOF
 cat > mat.c << 'CEOF'
int fact(int n){int r=1;for(int i=2;i<=n;i++)r*=i;return r;}
int gcd(int a,int b){while(b){int t=b;b=a%b;a=t;}return a;}
CEOF
 cat > mat.h << 'CEOF'
#ifndef M_H
#define M_H
#ifdef __cplusplus
extern "C" {
#endif
int fact(int n);int gcd(int a,int b);
#ifdef __cplusplus
}
#endif
#endif
CEOF
 cat > main.cpp << 'CEOF'
#include <iostream>
#include "str.h"
#include "mat.h"
using namespace std;
int main(){int v=cv("Hello 2024");int d=cd("Hello 2024");
int f=fact(5);int g=gcd(48,18);
cout<<"v="<<v<<" d="<<d<<" f5="<<f<<" g(48,18)="<<g<<endl;
bool ok=(v==3&&d==4&&f==120&&g==6);
if(ok)cout<<"MULTI_OK"<<endl;return ok?0:1;}
CEOF
 rlPhaseEnd

 rlPhaseStartTest "GCC/G++ separate compilation"
 rlRun "gcc -c str.c -o str.o && gcc -c mat.c -o mat.o" 0 "GCC compile.o"
 rlRun "g++ -o multi_gxx main.cpp str.o mat.o &&./multi_gxx | grep MULTI_OK" 0 "G++ link C+C++"
 rlPhaseEnd

 rlPhaseStartTest "Clang/Clang++ separate compilation"
 rlRun "clang -c str.c -o str_c.o && clang -c mat.c -o mat_c.o" 0 "Clang compile.o"
 rlRun "clang++ -o multi_clang main.cpp str_c.o mat_c.o &&./multi_clang | grep MULTI_OK" 0 "Clang++ link"
 rlPhaseEnd

 rlPhaseStartTest "cross-compiler linking"
 rlRun "clang++ -o cross1 main.cpp str.o mat.o 2>&1 &&./cross1 | grep MULTI_OK" 0 "Clang++ + GCC.o"
 rlRun "g++ -o cross2 main.cpp str_c.o mat_c.o 2>&1 &&./cross2 | grep MULTI_OK" 0 "G++ + Clang.o"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
