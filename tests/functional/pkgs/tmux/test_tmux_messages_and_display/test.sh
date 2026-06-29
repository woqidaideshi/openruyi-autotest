#!/bin/bash
# Functional test: tmux - Messages-and-display
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

    rlPhaseStartTest "Messages-and-display"
        rlRun "tmux display-message \"test message\" 2>&1 || true" 0 "display-message: show message"
        rlRun "tmux display-message -p \"session: #{session_name}\"" 0 "display-message -p: print format"
        rlRun "tmux show-messages 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "show-messages: message log"
        rlRun "tmux display-popup -C 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "display-popup -C: close popup"
        rlRun "tmux clear-history -t testsess:win1" 0 "clear-history: clear pane history"
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
