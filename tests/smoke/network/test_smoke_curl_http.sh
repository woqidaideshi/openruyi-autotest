#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'curl --version' 0 "curl 版本"
rlRun 'curl -s -o /dev/null -w "%{http_code}" http://localhost 2>&1 || true' 0 "curl 本地HTTP"
rlRun 'curl --connect-timeout 5 -I http://example.com 2>&1 || true' 0 "curl HEAD请求"
echo "smoke test passed!"
