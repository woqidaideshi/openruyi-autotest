#!/bin/sh -eux
# LTP POSIX 兼容性测试: mqueue 消息队列接口一致性

. "$(dirname "$0")/../setup.sh"
. "$(dirname "$0")/../helper.sh"

echo "=== LTP POSIX 兼容性测试: mqueue 消息队列接口 ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

INTERFACES="mq_close mq_getattr mq_notify mq_open mq_receive mq_send mq_setattr mq_timedreceive mq_timedsend mq_unlink"

for iface in $INTERFACES; do
    run_posix_iface_test "$iface" || true
done

echo ""
echo "=== mqueue 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
