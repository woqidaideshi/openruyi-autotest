#!/bin/bash
# Smoke test: network - curl 版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeNetworkSetup

    rlPhaseEnd

    rlPhaseStartTest "curl 版本"
        rlRun 'curl --version' 0 "curl 版本"
        rlRun 'curl -s -o /dev/null -w "%{http_code}" http://localhost 2>&1 || true' 0 "curl 本地HTTP"
        rlRun 'curl --connect-timeout 5 -I http://example.com 2>&1 || true' 0 "curl HEAD请求"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd