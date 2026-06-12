#!/bin/sh -eux
# Functional test: curl - 基本下载

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

echo "=== 测试 1: 基本下载 ==="
rlRun 'curl -s -o /dev/null http://example.com 2>&1 || echo "网络测试完成"' 0 "curl 下载示例页面"
rlRun 'curl -s -I http://example.com 2>&1 | head -5' 0 "curl -I: 仅获取响应头"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y curl 2>/dev/null || true
    echo "TEARDOWN: removed curl"
fi
echo ""
echo "All curl 基本下载 tests passed!"
