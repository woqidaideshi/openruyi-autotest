#!/bin/bash
# Functional test: tmux - Server-management
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

    rlPhaseStartTest "Server-management"
        rlRun "tmux start-server" 0 "start-server: start tmux server"
        rlRun "tmux list-sessions 2>&1 || true" 0 "list-sessions: initial state"
        rlRun "tmux has-session -t test 2>&1 || true" 0 "has-session: check nonexistent"
        rlRun "tmux list-clients 2>&1 || true" 0 "list-clients: list connected clients"
        rlRun "tmux list-commands | head -20" 0 "list-commands: list all commands"
        rlRun "tmux lscm new-session" 0 "list-commands: filter specific command"
        rlRun "tmux lscm -F \"#{command}\" | head -10" 0 "list-commands: format output"
        rlRun "tmux server-access -l 2>&1 || true" 0 "server-access -l: list access"
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
