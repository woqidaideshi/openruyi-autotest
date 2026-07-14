#!/bin/bash
# Functional test: compiler - dejagnu - C++ Standard (C++11/14/17)
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    dejagnuSetup
    if ! rpm -q clang 2>/dev/null; then echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y clang 2>/dev/null; fi
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary directory"

    cat > cxx11.cpp << 'CEOF'
#include <iostream>
#include <memory>
using namespace std;
constexpr int sq(int x){return x*x;}
static_assert(sq(5)==25,"");
int main(){auto v={1,2,3,4,5};int s=0;for(auto x:v)s+=x;if(s!=15)abort();
auto lambda=[](int a,int b){return a+b;};if(lambda(10,20)!=30)abort();
auto up=make_unique<int>(42);if(*up!=42)abort();
int x=10;decltype(x)y=20;if(x+y!=30)abort();
cout<<"CXX11_OK"<<endl;return 0;}
CEOF

    cat > cxx14.cpp << 'CEOF'
#include <iostream>
using namespace std;
int main(){auto gen=[](auto a,auto b){return a+b;};if(gen(10,20)!=30)abort();
if(gen(1.5,2.5)!=4.0)abort();
int bin=0b101010;if(bin!=42)abort();
int big=1'000'000;if(big!=1000000)abort();
auto inc=[val=41](){return val+1;};if(inc()!=42)abort();
cout<<"CXX14_OK"<<endl;return 0;}
CEOF

    cat > cxx17.cpp << 'CEOF'
#include <iostream>
#include <string_view>
#include <tuple>
#include <optional>
using namespace std;
inline constexpr int ANS=42;
template<typename T> auto gv(T t){if constexpr(is_pointer_v<T>)return *t;else return t;}
int main(){auto[a,b,c]=tuple{1,2.0,"three"};if(a!=1)abort();
int x=42;if(gv(&x)!=42||gv(x)!=42)abort();
string_view sv="hello world";if(sv.substr(0,5)!="hello")abort();
optional<int>o=100;if(o.value()!=100)abort();
if(ANS!=42)abort();
cout<<"CXX17_OK"<<endl;return 0;}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "G++"
    rlRun "g++ -std=c++11 -Wall -o cxx11_gxx cxx11.cpp && ./cxx11_gxx | grep CXX11_OK" 0 "G++ C++11"
    rlRun "g++ -std=c++14 -Wall -o cxx14_gxx cxx14.cpp && ./cxx14_gxx | grep CXX14_OK" 0 "G++ C++14"
    rlRun "g++ -std=c++17 -Wall -o cxx17_gxx cxx17.cpp && ./cxx17_gxx | grep CXX17_OK" 0 "G++ C++17"
    rlPhaseEnd

    rlPhaseStartTest "Clang++"
    rlRun "clang++ -std=c++11 -Wall -o cxx11_clang cxx11.cpp && ./cxx11_clang | grep CXX11_OK" 0 "Clang C++11"
    rlRun "clang++ -std=c++14 -Wall -o cxx14_clang cxx14.cpp && ./cxx14_clang | grep CXX14_OK" 0 "Clang C++14"
    rlRun "clang++ -std=c++17 -Wall -o cxx17_clang cxx17.cpp && ./cxx17_clang | grep CXX17_OK" 0 "Clang C++17"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
