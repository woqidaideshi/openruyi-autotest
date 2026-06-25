#!/bin/bash
# Smoke test: scripting - printf 基本输出
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeScriptingSetup

    rlPhaseEnd

    rlPhaseStartTest "printf 基本输出"
        rlRun 'printf "hello"' 0 "printf 基本输出"
        rlRun 'printf "%d\n" 42' 0 "printf 格式化数字"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd