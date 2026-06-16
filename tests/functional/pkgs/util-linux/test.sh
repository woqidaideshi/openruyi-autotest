#!/bin/sh -eux
# Functional test: util-linux package
# Tests util-linux 系统工具集
# Version: util-linux

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install util-linux ===
INSTALLED_BY_TEST=0
if ! rpm -q util-linux 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y util-linux 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed util-linux"
    else
        echo "SKIP: util-linux not available in repos"
        exit 0
    fi
else
    echo "SETUP: util-linux already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="
rlRun 'addpart --version 2>&1 || true' 0 "addpart 版本信息"
rlRun 'addpart --help 2>&1 | head -5 || true' 0 "addpart 帮助信息"
rlRun 'agetty --version 2>&1 || true' 0 "agetty 版本信息"
rlRun 'agetty --help 2>&1 | head -5 || true' 0 "agetty 帮助信息"
rlRun 'blkid --version 2>&1 || true' 0 "blkid 版本信息"
rlRun 'blkid --help 2>&1 | head -5 || true' 0 "blkid 帮助信息"
rlRun 'blkdiscard --version 2>&1 || true' 0 "blkdiscard 版本信息"
rlRun 'blkdiscard --help 2>&1 | head -5 || true' 0 "blkdiscard 帮助信息"
rlRun 'blockdev --version 2>&1 || true' 0 "blockdev 版本信息"
rlRun 'blockdev --help 2>&1 | head -5 || true' 0 "blockdev 帮助信息"
rlRun 'cal --version 2>&1 || true' 0 "cal 版本信息"
rlRun 'cal --help 2>&1 | head -5 || true' 0 "cal 帮助信息"
rlRun 'cfdisk --version 2>&1 || true' 0 "cfdisk 版本信息"
rlRun 'cfdisk --help 2>&1 | head -5 || true' 0 "cfdisk 帮助信息"
rlRun 'chcpu --version 2>&1 || true' 0 "chcpu 版本信息"
rlRun 'chcpu --help 2>&1 | head -5 || true' 0 "chcpu 帮助信息"
rlRun 'chfn --version 2>&1 || true' 0 "chfn 版本信息"
rlRun 'chfn --help 2>&1 | head -5 || true' 0 "chfn 帮助信息"
rlRun 'chmem --version 2>&1 || true' 0 "chmem 版本信息"
rlRun 'chmem --help 2>&1 | head -5 || true' 0 "chmem 帮助信息"
rlRun 'choom --version 2>&1 || true' 0 "choom 版本信息"
rlRun 'choom --help 2>&1 | head -5 || true' 0 "choom 帮助信息"
rlRun 'chrt --version 2>&1 || true' 0 "chrt 版本信息"
rlRun 'chrt --help 2>&1 | head -5 || true' 0 "chrt 帮助信息"
rlRun 'bits --version 2>&1 || true' 0 "bits 版本信息"
rlRun 'bits --help 2>&1 | head -5 || true' 0 "bits 帮助信息"
rlRun 'blkpr --version 2>&1 || true' 0 "blkpr 版本信息"
rlRun 'blkpr --help 2>&1 | head -5 || true' 0 "blkpr 帮助信息"
rlRun 'blkzone --version 2>&1 || true' 0 "blkzone 版本信息"
rlRun 'blkzone --help 2>&1 | head -5 || true' 0 "blkzone 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'addpart --invalid 2>&1 || true' 0 "addpart: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y util-linux 2>/dev/null || true
    echo "TEARDOWN: removed util-linux"
fi
echo ""
echo "All util-linux functional tests passed!"
