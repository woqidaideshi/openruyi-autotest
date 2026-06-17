#!/bin/sh -eux
# LTP POSIX 兼容性测试: aio 异步 I/O 接口一致性

. "$(dirname "$0")/../setup.sh"
. "$(dirname "$0")/../helper.sh"

echo "=== LTP POSIX 兼容性测试: aio 异步 I/O 接口 ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

INTERFACES="aio_cancel aio_error aio_fsync aio_read aio_return aio_suspend aio_write lio_listio"

for iface in $INTERFACES; do
    run_posix_iface_test "$iface" || true
done

echo ""
echo "=== aio 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
