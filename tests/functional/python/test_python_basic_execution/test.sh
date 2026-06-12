#!/bin/sh -eux
# Functional test: python - 基本执行

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python ===
INSTALLED_BY_TEST=0
if ! rpm -q python 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python"
    else
        echo "SKIP: python not available in repos"
        exit 0
    fi
else
    echo "SETUP: python already installed"
fi

rlRun 'python3 --version' 0 "Python 版本"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 基本执行 ==="
rlRun 'python3 -c "print(1+2)"' 0 "Python 基本运算"
rlRun 'python3 -c "import sys; print(sys.version)"' 0 "Python sys模块"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python 2>/dev/null || true
    echo "TEARDOWN: removed python"
fi
echo ""
echo "All python 基本执行 tests passed!"
