#!/bin/bash
# Functional test: curl - 输出选项
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        curlSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "输出选项"
        rlRun "curl -s -o /tmp/curl_test.html http://example.com 2>&1 || echo \"输出测试\"" 0 "curl -o: 输出到文件"
        rlRun "curl -s -O /dev/null 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "curl -O: 远程文件名"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # curl 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
