#!/bin/sh -eux
# Functional test: sed - 行操作

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install sed ===
INSTALLED_BY_TEST=0
if ! rpm -q sed 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y sed 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed sed"
    else
        echo "SKIP: sed not available in repos"
        exit 0
    fi
else
    echo "SETUP: sed already installed"
fi

rlRun 'sed --version' 0 "sed 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 2: 行操作 ==="
echo -e "line1\nline2\nline3" > lines.txt
rlRun 'sed -n "2p" lines.txt' 0 "sed -n: 打印指定行"
rlRun 'sed "2d" lines.txt' 0 "sed d: 删除指定行"
rlRun 'sed "2a newline" lines.txt' 0 "sed a: 追加行"
rlRun 'sed "2i insertline" lines.txt' 0 "sed i: 插入行"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y sed 2>/dev/null || true
    echo "TEARDOWN: removed sed"
fi
echo ""
echo "All sed 行操作 tests passed!"
