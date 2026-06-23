#!/bin/bash
# Functional test: tmux - Environment-variables
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

    rlPhaseStartTest "Environment-variables"
        rlRun "tmux set-environment -g MY_VAR test_value" 0 "set-environment -g: global env"
        rlRun "tmux set-environment -t testsess SESSION_VAR session_val" 0 "set-environment: session env"
        rlRun "tmux set-environment -gru MY_VAR" 0 "set-environment -gur: update then remove"
        rlRun "tmux show-environment -g | head -10" 0 "show-environment -g: global env"
        rlRun "tmux show-environment -t testsess | head -10" 0 "show-environment: session env"
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
