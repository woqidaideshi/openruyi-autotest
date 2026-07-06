#!/bin/bash
# Functional test: kernel - mmtests - memdb_redis_benchmark_small
# MMTests: run-mmtests.sh --config configs/config-memdb-redis-benchmark-small
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        mmtestsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "MMTests - memdb_redis_benchmark_small"
        rlRun "_mmtestsRunCase config-memdb-redis-benchmark-small" 0 "执行 MMTests config-memdb-redis-benchmark-small"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd