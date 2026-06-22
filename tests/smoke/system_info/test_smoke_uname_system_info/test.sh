#!/bin/bash
# Smoke test: system_info - uname 内核名称
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSystemInfoSetup

    rlPhaseEnd

    rlPhaseStartTest "uname 内核名称"
        rlRun 'uname' 0 "uname 内核名称"
        rlRun 'uname -a' 0 "uname -a 全部信息"
        rlRun 'uname -r' 0 "uname -r 内核版本"
        rlRun 'uname -m' 0 "uname -m 机器架构"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd