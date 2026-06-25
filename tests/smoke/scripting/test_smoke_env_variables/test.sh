#!/bin/bash
# Smoke test: scripting - env 列出环境变量
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeScriptingSetup

    rlPhaseEnd

    rlPhaseStartTest "env 列出环境变量"
        rlRun 'env | head -5' 0 "env 列出环境变量"
        rlRun 'echo $PATH | grep /bin' 0 "\$PATH 含/bin"
        rlRun 'echo $SHELL' 0 "\$SHELL 默认shell"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd