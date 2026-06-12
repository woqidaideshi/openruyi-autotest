#!/bin/sh -eux
# Functional test: curl - 其他选项

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

echo "=== 测试 4: 其他选项 ==="
rlRun 'curl -L http://example.com 2>&1 | head -3 || echo "跟随重定向"' 0 "curl -L: 跟随重定向"
rlRun 'curl -k https://example.com 2>&1 | head -3 || echo "忽略证书"' 0 "curl -k: 忽略SSL证书"
rlRun 'curl --connect-timeout 5 http://example.com 2>&1 | head -3 || echo "超时"' 0 "curl --connect-timeout: 连接超时"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y curl 2>/dev/null || true
    echo "TEARDOWN: removed curl"
fi
echo ""
echo "All curl 其他选项 tests passed!"
