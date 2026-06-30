#!/bin/bash
# Functional test: gnutls - certtool
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        gnutlsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "certtool"
        rlRun "TmpDir=$(mktemp -d)" 0 "错误处理ʱĿ¼"
        rlRun "cd $TmpDir" 0 "错误处理�Ŀ¼"
        rlRun "certtool --generate-privkey --outfile key.pem 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "����˽Կ"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # gnutls 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
