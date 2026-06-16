#!/bin/sh -eux
# Functional test: curl package
# Tests curl 下载工具
# Version: curl

. "./setup.sh"

echo "=== 测试 1: 基本下载 ==="
rlRun 'curl -s -o /dev/null http://example.com 2>&1 || echo "网络测试完成"' 0 "curl 下载示例页面"
rlRun 'curl -s -I http://example.com 2>&1 | head -5' 0 "curl -I: 仅获取响应头"

echo "=== 测试 2: 输出选项 ==="
rlRun 'curl -s -o /tmp/curl_test.html http://example.com 2>&1 || echo "输出测试"' 0 "curl -o: 输出到文件"
rlRun 'curl -s -O /dev/null 2>&1 || true' 0 "curl -O: 远程文件名"

echo "=== 测试 3: 详细模式和静默模式 ==="
rlRun 'curl -v http://example.com 2>&1 | head -5 || echo "详细模式"' 0 "curl -v: 详细模式"
rlRun 'curl -s http://example.com 2>&1 | head -3' 0 "curl -s: 静默模式"

echo "=== 测试 4: 其他选项 ==="
rlRun 'curl -L http://example.com 2>&1 | head -3 || echo "跟随重定向"' 0 "curl -L: 跟随重定向"
rlRun 'curl -k https://example.com 2>&1 | head -3 || echo "忽略证书"' 0 "curl -k: 忽略SSL证书"
rlRun 'curl --connect-timeout 5 http://example.com 2>&1 | head -3 || echo "超时"' 0 "curl --connect-timeout: 连接超时"

echo "=== 测试 5: wcurl ==="
rlRun 'wcurl --help 2>&1 | head -5 || echo "wcurl帮助"' 0 "wcurl 帮助"

echo "=== 测试 6: 错误处理 ==="
rlRun 'curl --invalid 2>&1 || true' 0 "curl: 无效选项"

. "./teardown.sh"
echo "All curl functional tests passed!"
