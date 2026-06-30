#!/bin/bash
# Functional test: tmux - Layout-management
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

    rlPhaseStartTest "Layout-management"
        rlRun "tmux select-layout -t testsess:win1 even-horizontal 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "select-layout: even-horizontal"
        rlRun "tmux select-layout -t testsess:win1 even-vertical 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "select-layout: even-vertical"
        rlRun "tmux select-layout -t testsess:win1 main-horizontal 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "select-layout: main-horizontal"
        rlRun "tmux select-layout -t testsess:win1 main-vertical 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "select-layout: main-vertical"
        rlRun "tmux select-layout -t testsess:win1 tiled 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "select-layout: tiled"
        rlRun "tmux next-layout -t testsess:win1 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "next-layout: cycle layouts"
        rlRun "tmux previous-layout -t testsess:win1 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "previous-layout: prev layout"
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
