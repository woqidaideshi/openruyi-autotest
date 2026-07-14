#!/bin/bash

# dejagnu - C++ Exceptionhandle try/catch/throw/noexcept

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    dejagnuSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 ""



    cat > exc.cpp << 'CEOF'

#include <iostream>

#include <stdexcept>

#include <string>

using namespace std;

// noexcept function

int safe_add(int a,int b)noexcept{return a+b;}

// possibleExceptionfunction

int checked_div(int a,int b){if(b==0)throw runtime_error("div by zero");return a/b;}

// Cleanup RAII

struct Guard{int id;Guard(int i):id(i){cout<<"ctor "<<id<<endl;}

~Guard(){cout<<"dtor "<<id<<endl;}};

int test_nested(){Guard g(1);try{Guard g2(2);throw runtime_error("inner");}

catch(const runtime_error&e){cout<<"caught: "<<e.what()<<endl;}

return 0;}

int main(void){

 int a=safe_add(10,20);if(a!=30)abort();

 cout<<"safe_add="<<a<<endl;

 int d=checked_div(100,4);if(d!=25)abort();

 cout<<"div="<<d<<endl;

 try{checked_div(1,0);abort();}catch(const runtime_error&e){cout<<"div0 caught"<<endl;}

 test_nested();

 cout<<"CXX_EXC_OK"<<endl;return 0;}

CEOF

    rlPhaseEnd



    rlPhaseStartTest "G++ Exception"

    rlRun "g++ -std=c++17 -o exc_gxx exc.cpp &&./exc_gxx" 0 "G++ Exceptionprogramrun"

./exc_gxx | tee /tmp/exc_gxx.txt

    grep -q "safe_add=30" /tmp/exc_gxx.txt && rlPass "noexcept functionnormal"

    grep -q "div=25" /tmp/exc_gxx.txt && rlPass "normal"

    grep -q "div0 caught" /tmp/exc_gxx.txt && rlPass "Exception (throw→catch)"

    grep -q "ctor 1" /tmp/exc_gxx.txt && grep -q "dtor 1" /tmp/exc_gxx.txt && rlPass "RAII /"

    grep -q "caught: inner" /tmp/exc_gxx.txt && rlPass "nestedException"

    grep -q "CXX_EXC_OK" /tmp/exc_gxx.txt && rlPass "Exceptionhandleallpassed"

    rlPhaseEnd



    rlPhaseStartTest "Clang++ Exception"

    rlRun "clang++ -std=c++17 -o exc_clang exc.cpp &&./exc_clang | grep CXX_EXC_OK" 0 "Clang++ Exceptionhandle"

    rlPhaseEnd



    rlPhaseStartTest "G++ vs Clang++ exception consistency"

./exc_gxx >/tmp/exc_gxx2.txt 2>&1;./exc_clang >/tmp/exc_clang2.txt 2>&1

    diff /tmp/exc_gxx2.txt /tmp/exc_clang2.txt >/dev/null 2>&1 && rlPass "G++/Clang++ Exceptionlinesisconsistent" || rlLogInfo "output differs"

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

    rm -f /tmp/exc_{gxx,gxx2,clang2}.txt

    rlPhaseEnd

    rlJournalPrintText

rlJournalEnd

