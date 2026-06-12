#!/bin/sh -eux
# Functional test: findutils - xargs

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install findutils ===
INSTALLED_BY_TEST=0
if ! rpm -q findutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y findutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed findutils"
    else
        echo "SKIP: findutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: findutils already installed"
fi

rlRun 'find --version' 0 "find 版本"
rlRun 'xargs --version' 0 "xargs 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 4: xargs ==="
echo -e "1\n2\n3" > nums.txt
rlRun 'cat nums.txt | xargs echo' 0 "xargs: 基本用法"
rlRun 'echo "test1 test2" | xargs -n1 echo' 0 "xargs -n1: 每次一个参数"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y findutils 2>/dev/null || true
    echo "TEARDOWN: removed findutils"
fi
echo ""
echo "All findutils xargs tests passed!"
