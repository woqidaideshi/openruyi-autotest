#!/bin/bash
# Smoke test: shell_basics - && 逻辑与
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeShellBasicsSetup
        rlRun "true; test $? -eq 0" 0 "准备环境"
        rlRun "false; test $? -ne 0" 0 "准备环境"

    rlPhaseEnd

    rlPhaseStartTest "&& 逻辑与"
        rlRun 'true && echo yes' 0 "&& 逻辑与"
        rlRun 'false || echo no' 0 "|| 逻辑或"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd