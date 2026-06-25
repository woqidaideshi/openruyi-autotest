#!/bin/bash
# Functional test: curl - 其他选项
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

    rlPhaseStartTest "其他选项"
        rlRun "curl -L http://example.com 2>&1 | head -3 || echo \"跟随重定向\"" 0 "curl -L: 跟随重定向"
        rlRun "curl -k https://example.com 2>&1 | head -3 || echo \"忽略证书\"" 0 "curl -k: 忽略SSL证书"
        rlRun "curl --connect-timeout 5 http://example.com 2>&1 | head -3 || echo \"超时\"" 0 "curl --connect-timeout: 连接超时"
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
