#!/bin/bash
# Functional test: coreutils - Environment-and-time--env--printenv--date--printf
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        coreutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Environment-and-time--env--printenv--date--printf"
        rlRun "env" 0 "env show environment"
        rlRun "env PATH=/usr/bin echo test" 0 "env set variable for command"
        rlRun "printenv PATH" 0 "printenv show PATH"
        rlRun "date" 0 "date current date/time"
        rlRun "date +%Y-%m-%d" 0 "date custom format"
        rlRun "date -u" 0 "date -u UTC time"
        rlRun "printf \"%s %d\n\" hello 42" 0 "printf formatted output"
        rlRun "test \"$(printf \"%s\" one two)\" = \"onetwo\"" 0 "printf string output"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # coreutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
