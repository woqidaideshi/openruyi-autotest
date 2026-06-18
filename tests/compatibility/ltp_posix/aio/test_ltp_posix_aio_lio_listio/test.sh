#!/bin/sh -eux
# LTP POSIX 兼容性测试: 异步 I/O - lio_listio 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: aio / lio_listio ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "lio_listio" || true

echo ""
echo "=== lio_listio 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
