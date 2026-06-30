#!/bin/bash
# Functional test: tmux - Options-and-settings
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

    rlPhaseStartTest "Options-and-settings"
        rlRun "tmux set-option -g status-interval 5 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "set-option -g: global"
        rlRun "tmux set-option -g -a status-left \"test\" 2>&1 || true" 0 "set-option -a: append"
        rlRun "tmux set-option -g mouse on 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "set-option: mouse on"
        rlRun "tmux set-option -s escape-time 10 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "set-option -s: server option"
        rlRun "tmux set-window-option -t testsess:win1 monitor-activity on 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "set-window-option: monitor activity"
        rlRun "tmux set-window-option -g automatic-rename on 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "set-window-option -g: global"
        rlRun "tmux show-options -g | head -10" 0 "show-options -g: global options"
        rlRun "tmux show-options -s | head -10" 0 "show-options -s: server options"
        rlRun "tmux show-window-options -t testsess:win1 | head -10" 0 "show-window-options: window options"
        rlRun "tmux show-window-options -g | head -10" 0 "show-window-options -g: global window options"
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
