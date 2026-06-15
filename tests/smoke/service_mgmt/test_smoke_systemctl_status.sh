#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'systemctl --version' 0 "systemctl 版本"
rlRun 'systemctl list-units --type=service | head -5' 0 "systemctl 服务列表"
rlRun 'systemctl is-system-running 2>&1 || true' 0 "systemctl 系统运行状态"
echo "smoke test passed!"
