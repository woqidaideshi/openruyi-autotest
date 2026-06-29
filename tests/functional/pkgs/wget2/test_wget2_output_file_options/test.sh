#!/bin/bash
# Functional test: wget2 - Output-file-options
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        wget2Setup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Output-file-options"
        rlRun "wget2 -O /dev/null --version 2>&1 >/dev/null" 1 "wget2 -O 选项"
        rlRun "echo '<html><body>test</body></html>' > $TmpDir/index.html" 0 "创建测试页面"
        rlRun "python3 -m http.server --bind 127.0.0.1 0 &> /dev/null &" 0 "启动本地 HTTP 服务器"
        HTTP_PID=$!
        sleep 2
        PORT=$(ss -tlpn 2>/dev/null | grep $HTTP_PID | grep -oP '127\.0\.0\.1:\K\d+' | head -1)
        if [ -n "$PORT" ]; then
            rlRun "wget2 -q -O $TmpDir/wget2out.html http://127.0.0.1:$PORT/index.html" 0 "wget2 下载到指定文件"
            rlRun "test -f $TmpDir/wget2out.html" 0 "验证输出文件已保存"
        fi
        kill $HTTP_PID 2>/dev/null || true
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # wget2 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
