#!/bin/bash
# Smoke test: shell_basics - \$() 命令替换
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeShellBasicsSetup
        rlRun "X=$(date +%Y); test -n "$X"" 0 "准备环境"

    rlPhaseEnd

    rlPhaseStartTest "\$() 命令替换"
        rlRun 'echo $(uname)' 0 "\$() 命令替换"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd