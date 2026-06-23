#!/bin/bash
# Functional test: podman - Help-commands
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        podmanSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Help-commands"
        rlRun "podman manifest --help 2>&1 | head -5" 0 "podman manifest help"
        rlRun "podman healthcheck --help 2>&1 | head -5" 0 "podman healthcheck help"
        rlRun "podman events --help 2>&1 | head -5" 0 "podman events help"
        rlRun "podman pod list 2>&1 | head -5" 0 "podman pod list"
        rlRun "podman-remote --help 2>&1 | head -5" 0 "podman-remote help"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # podman 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
