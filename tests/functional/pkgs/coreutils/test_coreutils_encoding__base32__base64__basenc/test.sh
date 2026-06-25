#!/bin/bash
# Functional test: coreutils - Encoding--base32--base64--basenc
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        coreutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Encoding--base32--base64--basenc"
        rlRun "echo \"hello\" | base32" 0 "base32 encode"
        rlRun "echo \"hello\" | base32 | base32 -d" 0 "base32 -d decode"
        rlRun "echo \"hello\" | base64" 0 "base64 encode"
        rlRun "echo \"hello\" | base64 | base64 -d" 0 "base64 -d decode"
        rlRun "echo \"hello\" | basenc --base64" 0 "basenc --base64 encode"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # coreutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
