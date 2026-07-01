#!/bin/bash
# Functional test: compiler scenarios - 警告体系
# 编写零警告合规代码，验证 -Wall -Wextra -Werror -pedantic 下零警告编译

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        scenariosSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        # 创建零警告的 C 代码
        cat > clean_c.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
// 所有函数都有返回类型
static int add(int a, int b) { return a + b; }
static void print_vec(const int *vec, size_t len) {
    for (size_t i = 0; i < len; i++) printf("%d ", vec[i]);
    printf("\n");
}
int main(void) {
    int result = add(100, 200);
    if (result != 300) abort();
    int arr[] = {1, 2, 3, 4, 5};
    print_vec(arr, 5);
    // 无未使用变量
    size_t n = sizeof(arr) / sizeof(arr[0]);
    if (n != 5) abort();
    // 指针检查
    const char *msg = "warnings clean";
    if (strlen(msg) < 5) abort();
    printf("WARN_CLEAN_C_OK\n");
    return 0;
}
CEOF

        # 创建零警告的 C++ 代码
        cat > clean_cpp.cpp << 'CEOF'
#include <iostream>
#include <string>
#include <vector>
#include <memory>
static int add(int a, int b) { return a + b; }
int main() {
    // 正确的类型转换
    int x = static_cast<int>(3.14);
    // 无符号比较警告防护
    std::vector<int> vec = {1, 2, 3, 4, 5};
    for (std::size_t i = 0; i < vec.size(); ++i) {
        if (vec[i] != static_cast<int>(i + 1)) abort();
    }
    // 避免未使用变量
    int result = add(x, 10);
    std::cout << "result=" << result << std::endl;
    std::cout << "WARN_CLEAN_CXX_OK" << std::endl;
    return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 零警告编译"
        # -Wall
        rlRun "gcc -Wall -o warn_gcc_wall clean_c.c 2>/tmp/gcc_wall_err.txt" 0 "GCC -Wall 编译"
        if [ ! -s /tmp/gcc_wall_err.txt ]; then
            rlPass "GCC -Wall: 零警告"
        else
            rlLogWarning "GCC -Wall: 存在输出 $(cat /tmp/gcc_wall_err.txt)"
        fi

        # -Wall -Wextra
        rlRun "gcc -Wall -Wextra -o warn_gcc_wextra clean_c.c 2>/tmp/gcc_wextra_err.txt" 0 "GCC -Wall -Wextra 编译"
        if [ ! -s /tmp/gcc_wextra_err.txt ]; then
            rlPass "GCC -Wall -Wextra: 零警告"
        fi

        # -Wall -Werror（关键：警告即错误）
        rlRun "gcc -Wall -Werror -o warn_gcc_werror clean_c.c" 0 "GCC -Wall -Werror 编译（警告即错误）"

        # -Wall -pedantic
        rlRun "gcc -Wall -pedantic -o warn_gcc_pedantic clean_c.c 2>/tmp/gcc_pedantic_err.txt" 0 "GCC -Wall -pedantic 编译"
        rlRun "./warn_gcc_pedantic | grep 'WARN_CLEAN_C_OK'" 0 "GCC pedantic 运行验证"
    rlPhaseEnd

    rlPhaseStartTest "G++ 零警告编译"
        rlRun "g++ -Wall -Wextra -o warn_gxx_wextra clean_cpp.cpp 2>/tmp/gxx_wextra_err.txt" 0 "G++ -Wall -Wextra 编译"
        if [ ! -s /tmp/gxx_wextra_err.txt ]; then
            rlPass "G++ -Wall -Wextra: 零警告"
        else
            rlLogWarning "G++ 存在警告"
        fi
        rlRun "g++ -Wall -Werror -o warn_gxx_werror clean_cpp.cpp" 0 "G++ -Wall -Werror 编译"
        rlRun "./warn_gxx_werror | grep 'WARN_CLEAN_CXX_OK'" 0 "G++ Werror 运行验证"
    rlPhaseEnd

    rlPhaseStartTest "Clang 零警告编译"
        rlRun "clang -Wall -Wextra -o warn_clang_wextra clean_c.c" 0 "Clang -Wall -Wextra 编译"
        rlRun "clang -Wall -Werror -o warn_clang_werror clean_c.c" 0 "Clang -Wall -Werror 编译"
        rlRun "./warn_clang_werror | grep 'WARN_CLEAN_C_OK'" 0 "Clang Werror 运行验证"

        rlRun "clang++ -Wall -Wextra -o warn_clangxx_wextra clean_cpp.cpp" 0 "Clang++ -Wall -Wextra 编译"
        rlRun "clang++ -Wall -Werror -o warn_clangxx_werror clean_cpp.cpp" 0 "Clang++ -Wall -Werror 编译"
        rlRun "./warn_clangxx_werror | grep 'WARN_CLEAN_CXX_OK'" 0 "Clang++ Werror 运行验证"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/{gcc,gxx}_wall_err.txt /tmp/{gcc,gxx}_wextra_err.txt /tmp/gcc_pedantic_err.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
