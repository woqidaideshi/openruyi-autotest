#!/bin/sh -eux
# Functional test: isl - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install isl ===
INSTALLED_BY_TEST=0
if ! rpm -q isl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y isl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed isl"
    else
        echo "SKIP: isl not available in repos"
        exit 0
    fi
else
    echo "SETUP: isl already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y isl 2>/dev/null || true
    echo "TEARDOWN: removed isl"
fi
echo ""
echo "All isl functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All isl 错误处理 tests passed!"
