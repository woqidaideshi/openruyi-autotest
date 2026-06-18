#!/bin/sh
# LTP POSIX 测试公共辅助函数
# 被所有子测试脚本 source 使用

# rlRun 包装器
rlRun() { eval "$1" 2>&1; return $?; }

# 在指定接口目录中编译并运行所有测试
# 用法: run_posix_iface_test <接口名>
run_posix_iface_test() {
    local iface="$1"
    local dir="$IFACE_DIR/$iface"
    local inc_dir="$LTP_BUILD_DIR/include"
    local lib_common="$LTP_BUILD_DIR/lib/common.c"
    
    if [ ! -d "$dir" ]; then
        echo "SKIP: 接口目录不存在 $iface"
        return 1
    fi
    
    echo ""
    echo "--- 测试接口: $iface ---"
    cd "$dir"
    
    local found=0
    
    # 1. 运行 .sh 脚本测试（使用 sudo 确保权限）
    for test_sh in $(find . -maxdepth 1 -type f -name "*.sh" ! -name "Makefile" 2>/dev/null | sort); do
        test_name="${iface}/$(basename "$test_sh")"
        found=1
        if rlRun "echo ${SUDO_PASSWORD:-openruyi} | sudo -S sh $test_sh" 0 "POSIX $test_name"; then
            PASS=$((PASS + 1))
        else
            FAIL=$((FAIL + 1))
        fi
    done
    
    # 2. 编译 .c 文件（与 lib/common.c 链接）并运行（每接口最多 3 个样本，使用 sudo）
    local c_count=0
    for src in $(find . -maxdepth 1 -type f -name "*.c" 2>/dev/null | sort); do
        local test_name="${iface}/$(basename "$src" .c)"
        local bin="/tmp/posix_test_$$_${c_count}"
        found=1
        c_count=$((c_count + 1))
        if gcc -std=gnu11 -I"$inc_dir" -Wno-error=incompatible-pointer-types -o "$bin" "$lib_common" "$src" -lpthread -lrt -lm 2>/dev/null; then
            if rlRun "echo ${SUDO_PASSWORD:-openruyi} | sudo -S $bin" 0 "POSIX $test_name"; then
                PASS=$((PASS + 1))
            else
                FAIL=$((FAIL + 1))
            fi
            rm -f "$bin"
        else
            echo "SKIP: 编译失败 $test_name"
            SKIP=$((SKIP + 1))
        fi
        [ "$c_count" -ge 3 ] && break
    done
    
    [ "$found" -eq 0 ] && echo "SKIP: $iface 无测试文件" && return 1
    return 0
}
