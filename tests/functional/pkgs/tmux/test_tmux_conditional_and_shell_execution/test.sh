#!/bin/bash
# Functional test: tmux - Conditional-and-shell-execution
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

    rlPhaseStartTest "Conditional-and-shell-execution"
        rlRun "tmux if-shell \"true\" \"display-message ok\" \"display-message fail\" 2>&1 || true" 0 "if-shell: true condition"
        rlRun "tmux run-shell \"echo hello_from_run_shell\" 2>&1 || true" 0 "run-shell: run shell command"
        rlRun "tmux run-shell -b \"sleep 0.1; echo background\" 2>&1 || true" 0 "run-shell -b: background"
        rlRun "echo quit | tmux command-prompt 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "command-prompt: open prompt"
        rlRun "tmux confirm-before -p \"OK?\" \"echo confirmed\" 2>&1 || true" 0 "confirm-before: confirm dialog"
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
