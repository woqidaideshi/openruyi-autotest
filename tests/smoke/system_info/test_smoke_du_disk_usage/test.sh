#!/bin/bash
# Smoke test: system_info - du -sh 目录大小
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSystemInfoSetup

    rlPhaseEnd

    rlPhaseStartTest "du -sh 目录大小"
        rlRun 'du -sh /etc' 0 "du -sh 目录大小"
        rlRun 'du -h /bin | head -5' 0 "du 列出文件大小"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd