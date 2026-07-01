#!/bin/bash
# Functional test: compiler scenarios - C++ 语言标准 (C++11/14/17)
# 验证 GCC/Clang 对各种 C++ 标准的支持

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        scenariosSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        # C++11: auto, lambda, range-for, nullptr, constexpr, move semantics
        cat > cxx11_test.cpp << 'CEOF'
#include <iostream>
#include <vector>
#include <memory>
#include <initializer_list>
using namespace std;
// C++11: constexpr
constexpr int square(int x) { return x * x; }
static_assert(square(5) == 25, "constexpr fail");
// C++11: auto + range-for + initializer_list
int main() {
    auto vec = {1, 2, 3, 4, 5};
    int sum = 0;
    for (auto v : vec) sum += v;
    if (sum != 15) abort();
    // C++11: lambda
    auto lambda = [](int a, int b) { return a + b; };
    if (lambda(10, 20) != 30) abort();
    // C++11: nullptr
    int *p = nullptr;
    if (p != nullptr) abort();
    // C++11: unique_ptr
    auto up = make_unique<int>(42);
    if (*up != 42) abort();
    // C++11: decltype
    int x = 10;
    decltype(x) y = 20;
    if (x + y != 30) abort();
    cout << "CXX11_OK" << endl;
    return 0;
}
CEOF

        # C++14: generic lambdas, return type deduction, binary literals, digit separators
        cat > cxx14_test.cpp << 'CEOF'
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
int main() {
    // C++14: generic lambda
    auto gen = [](auto a, auto b) { return a + b; };
    if (gen(10, 20) != 30) abort();
    if (gen(1.5, 2.5) != 4.0) abort();
    // C++14: binary literal
    int bin = 0b101010;  // 42
    if (bin != 42) abort();
    // C++14: digit separator
    int big = 1'000'000;
    if (big != 1000000) abort();
    // C++14: decltype(auto)
    int x = 5;
    decltype(auto) y = x;
    y = 10;
    if (x != 5) abort();  // y is int, not int& (x unchanged)
    // C++14: lambda init capture
    auto inc = [val = 41]() { return val + 1; };
    if (inc() != 42) abort();
    cout << "CXX14_OK" << endl;
    return 0;
}
CEOF

        # C++17: structured bindings, if constexpr, string_view, fold expressions, inline vars
        cat > cxx17_test.cpp << 'CEOF'
#include <iostream>
#include <string_view>
#include <tuple>
#include <optional>
using namespace std;
// C++17: inline variable
inline constexpr int ANSWER = 42;
// C++17: if constexpr
template<typename T>
auto get_value(T t) {
    if constexpr (is_pointer_v<T>)
        return *t;
    else
        return t;
}
int main() {
    // C++17: structured binding
    auto [a, b, c] = tuple{1, 2.0, "three"};
    if (a != 1) abort();
    // C++17: if constexpr
    int x = 42;
    if (get_value(&x) != 42) abort();
    if (get_value(x) != 42) abort();
    // C++17: string_view
    string_view sv = "hello world";
    if (sv.substr(0, 5) != "hello") abort();
    // C++17: optional
    optional<int> opt = 100;
    if (opt.value() != 100) abort();
    // C++17: fold expression (C++17)
    auto sum_all = [](auto... args) { return (args + ...); };
    if (sum_all(1, 2, 3, 4) != 10) abort();
    // C++17: inline constexpr
    if (ANSWER != 42) abort();
    cout << "CXX17_OK" << endl;
    return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "G++ C++ 标准编译"
        rlRun "g++ -std=c++11 -Wall -o cxx11_gxx cxx11_test.cpp" 0 "G++ -std=c++11 编译"
        rlRun "./cxx11_gxx | grep 'CXX11_OK'" 0 "G++ C++11 验证"

        rlRun "g++ -std=c++14 -Wall -o cxx14_gxx cxx14_test.cpp" 0 "G++ -std=c++14 编译"
        rlRun "./cxx14_gxx | grep 'CXX14_OK'" 0 "G++ C++14 验证"

        rlRun "g++ -std=c++17 -Wall -o cxx17_gxx cxx17_test.cpp" 0 "G++ -std=c++17 编译"
        rlRun "./cxx17_gxx | grep 'CXX17_OK'" 0 "G++ C++17 验证"
    rlPhaseEnd

    rlPhaseStartTest "Clang++ C++ 标准编译"
        rlRun "clang++ -std=c++11 -Wall -o cxx11_clang cxx11_test.cpp" 0 "Clang -std=c++11 编译"
        rlRun "./cxx11_clang | grep 'CXX11_OK'" 0 "Clang C++11 验证"

        rlRun "clang++ -std=c++14 -Wall -o cxx14_clang cxx14_test.cpp" 0 "Clang -std=c++14 编译"
        rlRun "./cxx14_clang | grep 'CXX14_OK'" 0 "Clang C++14 验证"

        rlRun "clang++ -std=c++17 -Wall -o cxx17_clang cxx17_test.cpp" 0 "Clang -std=c++17 编译"
        rlRun "./cxx17_clang | grep 'CXX17_OK'" 0 "Clang C++17 验证"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
