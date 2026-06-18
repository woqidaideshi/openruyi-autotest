#!/bin/sh -eux
# LTP POSIX 兼容性测试: 文件系统 - ctime 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: filesystem / ctime ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "ctime" || true

echo ""
echo "=== ctime 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
