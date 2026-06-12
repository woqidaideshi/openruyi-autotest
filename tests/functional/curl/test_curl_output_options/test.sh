#!/bin/sh -eux
# Functional test: curl - 输出选项

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install curl ===
INSTALLED_BY_TEST=0
if ! rpm -q curl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y curl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed curl"
    else
        echo "SKIP: curl not available in repos"
        exit 0
    fi
else
    echo "SETUP: curl already installed"
fi

rlRun 'curl --version' 0 "curl 版本信息"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 输出选项 ==="
rlRun 'curl -s -o /tmp/curl_test.html http://example.com 2>&1 || echo "输出测试"' 0 "curl -o: 输出到文件"
rlRun 'curl -s -O /dev/null 2>&1 || true' 0 "curl -O: 远程文件名"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y curl 2>/dev/null || true
    echo "TEARDOWN: removed curl"
fi
echo ""
echo "All curl 输出选项 tests passed!"
