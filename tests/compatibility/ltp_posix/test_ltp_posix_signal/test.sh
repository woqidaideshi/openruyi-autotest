#!/bin/sh -eux
# LTP POSIX 兼容性测试: signal 信号接口一致性

. "$(dirname "$0")/../setup.sh"
. "$(dirname "$0")/../helper.sh"

echo "=== LTP POSIX 兼容性测试: signal 信号接口 ==="

IFACE_DIR="$LTP_BUILD_DIR/conformance/interfaces"
PASS=0; FAIL=0; SKIP=0

INTERFACES="sigaction sigaddset sigaltstack sigdelset sigemptyset sigfillset sighold sigignore sigismember signal sigpause sigpending sigprocmask sigqueue sigrelse sigset sigsuspend sigtimedwait sigwait sigwaitinfo kill raise"

for iface in $INTERFACES; do
    run_posix_iface_test "$iface" || true
done

echo ""
echo "=== signal 结果: PASS=$PASS FAIL=$FAIL SKIP=$SKIP ==="
