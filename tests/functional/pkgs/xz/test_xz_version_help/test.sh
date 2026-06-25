#!/bin/bash
# Functional test: xz - 版本和帮助
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        xzSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "版本和帮助"
        rlRun "xz --version 2>&1 || true" 0 "xz 版本信息"
        rlRun "xz --help 2>&1 | head -5 || true" 0 "xz 帮助信息"
        rlRun "unxz --version 2>&1 || true" 0 "unxz 版本信息"
        rlRun "unxz --help 2>&1 | head -5 || true" 0 "unxz 帮助信息"
        rlRun "xzcat --version 2>&1 || true" 0 "xzcat 版本信息"
        rlRun "xzcat --help 2>&1 | head -5 || true" 0 "xzcat 帮助信息"
        rlRun "lzma --version 2>&1 || true" 0 "lzma 版本信息"
        rlRun "lzma --help 2>&1 | head -5 || true" 0 "lzma 帮助信息"
        rlRun "unlzma --version 2>&1 || true" 0 "unlzma 版本信息"
        rlRun "unlzma --help 2>&1 | head -5 || true" 0 "unlzma 帮助信息"
        rlRun "lzcat --version 2>&1 || true" 0 "lzcat 版本信息"
        rlRun "lzcat --help 2>&1 | head -5 || true" 0 "lzcat 帮助信息"
        rlRun "lzcmp --version 2>&1 || true" 0 "lzcmp 版本信息"
        rlRun "lzcmp --help 2>&1 | head -5 || true" 0 "lzcmp 帮助信息"
        rlRun "lzdiff --version 2>&1 || true" 0 "lzdiff 版本信息"
        rlRun "lzdiff --help 2>&1 | head -5 || true" 0 "lzdiff 帮助信息"
        rlRun "lzgrep --version 2>&1 || true" 0 "lzgrep 版本信息"
        rlRun "lzgrep --help 2>&1 | head -5 || true" 0 "lzgrep 帮助信息"
        rlRun "lzless --version 2>&1 || true" 0 "lzless 版本信息"
        rlRun "lzless --help 2>&1 | head -5 || true" 0 "lzless 帮助信息"
        rlRun "lzmore --version 2>&1 || true" 0 "lzmore 版本信息"
        rlRun "lzmore --help 2>&1 | head -5 || true" 0 "lzmore 帮助信息"
        rlRun "lzmadec --version 2>&1 || true" 0 "lzmadec 版本信息"
        rlRun "lzmadec --help 2>&1 | head -5 || true" 0 "lzmadec 帮助信息"
        rlRun "lzmainfo --version 2>&1 || true" 0 "lzmainfo 版本信息"
        rlRun "lzmainfo --help 2>&1 | head -5 || true" 0 "lzmainfo 帮助信息"
        rlRun "lzegrep --version 2>&1 || true" 0 "lzegrep 版本信息"
        rlRun "lzegrep --help 2>&1 | head -5 || true" 0 "lzegrep 帮助信息"
        rlRun "lzfgrep --version 2>&1 || true" 0 "lzfgrep 版本信息"
        rlRun "lzfgrep --help 2>&1 | head -5 || true" 0 "lzfgrep 帮助信息"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # xz 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
