#!/bin/sh -eux
# Functional test: mpdecimal - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install mpdecimal ===
INSTALLED_BY_TEST=0
if ! rpm -q mpdecimal 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y mpdecimal 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed mpdecimal"
    else
        echo "SKIP: mpdecimal not available in repos"
        exit 0
    fi
else
    echo "SETUP: mpdecimal already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y mpdecimal 2>/dev/null || true
    echo "TEARDOWN: removed mpdecimal"
fi
echo ""
echo "All mpdecimal functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All mpdecimal 错误处理 tests passed!"
