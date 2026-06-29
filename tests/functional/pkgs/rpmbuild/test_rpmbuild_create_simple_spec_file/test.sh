#!/bin/bash
# Functional test: rpmbuild - Create-simple-spec-file
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        rpmbuildSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Create-simple-spec-file"
        rlRun "echo 'Name: testpkg' > $TmpDir/test.spec" 0 "创建 spec 文件头"
        rlRun "echo 'Version: 1.0' >> $TmpDir/test.spec" 0 "添加版本"
        rlRun "echo 'Release: 1' >> $TmpDir/test.spec" 0 "添加 Release"
        rlRun "echo 'Summary: Test package' >> $TmpDir/test.spec" 0 "添加 Summary"
        rlRun "echo 'License: MIT' >> $TmpDir/test.spec" 0 "添加 License"
        rlRun "echo '%description' >> $TmpDir/test.spec" 0 "添加 %description"
        rlRun "echo 'Test package for rpmbuild' >> $TmpDir/test.spec" 0 "描述内容"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # rpmbuild 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
