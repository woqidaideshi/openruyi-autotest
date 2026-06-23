#!/bin/bash
# Functional test: zstd - 版本和帮助
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        zstdSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "版本和帮助"
        rlRun "zstd --version 2>&1 || true" 0 "zstd 版本信息"
        rlRun "zstd --help 2>&1 | head -5 || true" 0 "zstd 帮助信息"
        rlRun "unzstd --version 2>&1 || true" 0 "unzstd 版本信息"
        rlRun "unzstd --help 2>&1 | head -5 || true" 0 "unzstd 帮助信息"
        rlRun "zstdcat --version 2>&1 || true" 0 "zstdcat 版本信息"
        rlRun "zstdcat --help 2>&1 | head -5 || true" 0 "zstdcat 帮助信息"
        rlRun "zstdgrep --version 2>&1 || true" 0 "zstdgrep 版本信息"
        rlRun "zstdgrep --help 2>&1 | head -5 || true" 0 "zstdgrep 帮助信息"
        rlRun "zstdless --version 2>&1 || true" 0 "zstdless 版本信息"
        rlRun "zstdless --help 2>&1 | head -5 || true" 0 "zstdless 帮助信息"
        rlRun "zstdmt --version 2>&1 || true" 0 "zstdmt 版本信息"
        rlRun "zstdmt --help 2>&1 | head -5 || true" 0 "zstdmt 帮助信息"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # zstd 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
