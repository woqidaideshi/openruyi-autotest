#!/bin/sh -eux
# LTP POSIX 兼容性测试: filesystem 文件系统及基础接口一致性

. "$(dirname "$0")/../setup.sh"
. "$(dirname "$0")/../helper.sh"

echo "=== LTP POSIX 兼容性测试: filesystem 文件系统接口 ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

INTERFACES="access fork fsync getpid strchr strcpy strlen strncpy strftime time asctime ctime difftime gmtime localtime mktime"

for iface in $INTERFACES; do
    run_posix_iface_test "$iface" || true
done

echo ""
echo "=== filesystem 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
