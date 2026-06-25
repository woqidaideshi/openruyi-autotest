#!/bin/bash
# Smoke test: shell_basics - bash 版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeShellBasicsSetup

    rlPhaseEnd

    rlPhaseStartTest "bash 版本"
        rlRun 'bash --version' 0 "bash 版本"
        rlRun 'bash -c "echo shell works"' 0 "bash -c 执行命令"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd