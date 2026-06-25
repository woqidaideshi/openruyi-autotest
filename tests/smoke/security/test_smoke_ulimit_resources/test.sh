#!/bin/bash
# Smoke test: security - ulimit -n 文件描述符上限
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSecuritySetup

    rlPhaseEnd

    rlPhaseStartTest "ulimit -n 文件描述符上限"
        rlRun 'ulimit -n' 0 "ulimit -n 文件描述符上限"
        rlRun 'ulimit -u' 0 "ulimit -u 用户进程数上限"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd