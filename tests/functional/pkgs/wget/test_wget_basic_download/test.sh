#!/bin/bash
# Functional test: wget - Basic-download
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        wgetSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Basic-download"
        rlRun "wget --version" 0 "检查 wget 版本信息"
        rlRun "echo '<html><body>Hello</body></html>' > $TmpDir/index.html" 0 "创建测试页面"
        rlRun "python3 -m http.server --bind 127.0.0.1 0 &> /dev/null &" 0 "启动本地 HTTP 服务器"
        HTTP_PID=$!
        sleep 2
        PORT=$(ss -tlpn 2>/dev/null | grep $HTTP_PID | grep -oP '127\.0\.0\.1:\K\d+' | head -1)
        if [ -n "$PORT" ]; then
            rlRun "wget -q http://127.0.0.1:$PORT/index.html" 0 "下载 index.html"
            rlRun "test -f $TmpDir/index.html" 0 "验证文件已下载"
        fi
        kill $HTTP_PID 2>/dev/null || true
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # wget 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
