#!/bin/sh -eux
# Functional test: bash - 条件判断

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bash ===
INSTALLED_BY_TEST=0
if ! rpm -q bash 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bash 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bash"
    else
        echo "SKIP: bash not available in repos"
        exit 0
    fi
else
    echo "SETUP: bash already installed"
fi

rlRun 'bash --version' 0 "bash 版本"
rlRun 'sh --version 2>&1 || true' 0 "sh 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 3: 条件判断 ==="
rlRun 'bash -c "if [ 1 -eq 1 ]; then echo ok; fi"' 0 "bash: if条件"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y bash 2>/dev/null || true
    echo "TEARDOWN: removed bash"
fi
echo ""
echo "All bash 条件判断 tests passed!"
