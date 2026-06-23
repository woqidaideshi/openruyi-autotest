#!/bin/bash
# Smoke test: process - nproc CPU 核心数
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeProcessSetup

    rlPhaseEnd

    rlPhaseStartTest "nproc CPU 核心数"
        rlRun 'nproc' 0 "nproc CPU 核心数"
        rlRun 'nproc --all' 0 "nproc --all 所有处理器"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd