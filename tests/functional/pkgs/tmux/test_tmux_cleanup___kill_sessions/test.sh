#!/bin/bash
# Functional test: tmux - Cleanup---kill-sessions
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

    rlPhaseStartTest "Cleanup---kill-sessions"
        rlRun "tmux kill-session -t renamed_sess 2>&1 || true" 0 "kill-session: kill renamed_sess"
        rlRun "tmux kill-session -t sess_fmt 2>&1 || true" 0 "kill-session: kill sess_fmt"
        rlRun "tmux kill-session -t sess_sz 2>&1 || true" 0 "kill-session: kill sess_sz"
        rlRun "tmux kill-session -t sess_flags 2>&1 || true" 0 "kill-session: kill sess_flags"
        rlRun "tmux kill-session -t sess_env 2>&1 || true" 0 "kill-session: kill sess_env"
        rlRun "tmux kill-session -t testsess 2>&1 || true" 0 "kill-session: kill main test session"
        rlRun "tmux kill-server 2>&1 || true" 0 "kill-server: terminate server"
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
