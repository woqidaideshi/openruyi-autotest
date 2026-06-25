#!/bin/bash
# Smoke test: shell_basics - test -f 文件存在
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeShellBasicsSetup

    rlPhaseEnd

    rlPhaseStartTest "test -f 文件存在"
        rlRun 'test -f /etc/os-release' 0 "test -f 文件存在"
        rlRun '[ -d /tmp ]' 0 "[ -d ] 目录存在"
        rlRun 'test "a" = "a"' 0 "test 字符串相等"
        rlRun 'test 1 -lt 2' 0 "test 数值比较"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd