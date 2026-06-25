#!/bin/bash
# Functional test: tmux - Hooks
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        tmuxSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Hooks"
        rlRun "tmux set-hook -g session-created \"display-message created\"" 0 "set-hook: session-created"
        rlRun "tmux set-hook -g client-attached \"display-message attached\"" 0 "set-hook: client-attached"
        rlRun "tmux show-hooks -g" 0 "show-hooks -g: global hooks"
        rlRun "tmux set-hook -gu session-created" 0 "set-hook -gu: remove global hook"
        rlRun "tmux set-hook -gu client-attached" 0 "set-hook -gu: remove hook"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # tmux 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
