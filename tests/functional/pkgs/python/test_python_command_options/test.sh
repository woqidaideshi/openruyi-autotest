#!/bin/sh -eux
# Functional test: python - 命令行选项

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

echo "=== 测试 2: 命令行选项 ==="
rlRun 'python3 -h 2>&1 | head -5' 0 "python3 -h: 帮助"
rlRun 'python3 -V' 0 "python3 -V: 版本"
rlRun 'python3 -c "import os; print(os.name)"' 0 "python3: os模块"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python 2>/dev/null || true
    echo "TEARDOWN: removed python"
fi
echo ""
echo "All python 命令行选项 tests passed!"
