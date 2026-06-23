#!/bin/bash
# Smoke test: network - ssh 版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "ssh 版本"
        rlRun 'ssh -V 2>&1' 0 "ssh 版本"
        rlRun 'which scp' 0 "scp 存在"
        rlRun 'which sftp' 0 "sftp 存在"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd