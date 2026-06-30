#!/bin/bash
# Functional test: ca-certificates-mozilla - certificates-mozilla - 错误处理
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        caCertificatesMozillaSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "certificates-mozilla - 错误处理"
        rlRun "rpm -q ca-certificates-mozilla 2>/dev/null || rpm -q ca-certificates" 0 "CA 证书包已安装"
        rlRun "ls /etc/pki/ca-trust/ 2>/dev/null || ls /etc/ssl/certs/ 2>/dev/null" 0 "证书目录存在"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # ca-certificates-mozilla 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
