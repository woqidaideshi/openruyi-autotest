#!/bin/bash
# Smoke test: shell_basics - export 变量
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeShellBasicsSetup
        rlRun "X=hello; test "$X" = "hello"" 0 "准备环境"

    rlPhaseEnd

    rlPhaseStartTest "export 变量"
        rlRun 'export Y=world' 0 "export 变量"
        rlRun 'echo $HOME | grep /' 0 "\$HOME 环境变量"
        rlRun 'echo ${#HOME}' 0 "\${#VAR} 字符串长度"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd