#!/bin/sh -eux
# LTP POSIX 兼容性测试: 消息队列 - mq_notify 接口一致性

. "$(dirname "$0")/../../setup.sh"
. "$(dirname "$0")/../../helper.sh"

echo "=== LTP POSIX 兼容性测试: mqueue / mq_notify ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

run_posix_iface_test "mq_notify" || true

echo ""
echo "=== mq_notify 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
