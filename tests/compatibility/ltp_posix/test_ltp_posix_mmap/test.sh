#!/bin/sh -eux
# LTP POSIX 兼容性测试: mmap 内存映射接口一致性

. "$(dirname "$0")/../setup.sh"
. "$(dirname "$0")/../helper.sh"

echo "=== LTP POSIX 兼容性测试: mmap 内存映射接口 ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

INTERFACES="mmap munmap mlock mlockall munlock munlockall shm_open shm_unlink"

for iface in $INTERFACES; do
    run_posix_iface_test "$iface" || true
done

echo ""
echo "=== mmap 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
