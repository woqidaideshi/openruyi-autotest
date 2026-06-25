#!/bin/bash
# Smoke test: shell_basics - *.txt 通配符
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeShellBasicsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "touch a.txt b.txt c.jpg" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "*.txt 通配符"
        rlRun 'ls *.txt | wc -l' 0 "*.txt 通配符"
        rlRun 'ls ?.jpg' 0 "?.jpg 单字通配符"
        rlRun 'echo ~ | grep /' 0 "~ 家目录展开"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd