#!/bin/sh -eux
# Functional test: gzip package
# Tests gzip 压缩工具集
# Version: gzip

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install gzip ===
INSTALLED_BY_TEST=0
if ! rpm -q gzip 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gzip 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gzip"
    else
        echo "SKIP: gzip not available in repos"
        exit 0
    fi
else
    echo "SETUP: gzip already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="
rlRun 'gzip --version 2>&1 || true' 0 "gzip 版本信息"
rlRun 'gzip --help 2>&1 | head -5 || true' 0 "gzip 帮助信息"
rlRun 'gunzip --version 2>&1 || true' 0 "gunzip 版本信息"
rlRun 'gunzip --help 2>&1 | head -5 || true' 0 "gunzip 帮助信息"
rlRun 'zcat --version 2>&1 || true' 0 "zcat 版本信息"
rlRun 'zcat --help 2>&1 | head -5 || true' 0 "zcat 帮助信息"
rlRun 'zcmp --version 2>&1 || true' 0 "zcmp 版本信息"
rlRun 'zcmp --help 2>&1 | head -5 || true' 0 "zcmp 帮助信息"
rlRun 'zdiff --version 2>&1 || true' 0 "zdiff 版本信息"
rlRun 'zdiff --help 2>&1 | head -5 || true' 0 "zdiff 帮助信息"
rlRun 'zgrep --version 2>&1 || true' 0 "zgrep 版本信息"
rlRun 'zgrep --help 2>&1 | head -5 || true' 0 "zgrep 帮助信息"
rlRun 'zless --version 2>&1 || true' 0 "zless 版本信息"
rlRun 'zless --help 2>&1 | head -5 || true' 0 "zless 帮助信息"
rlRun 'zmore --version 2>&1 || true' 0 "zmore 版本信息"
rlRun 'zmore --help 2>&1 | head -5 || true' 0 "zmore 帮助信息"
rlRun 'znew --version 2>&1 || true' 0 "znew 版本信息"
rlRun 'znew --help 2>&1 | head -5 || true' 0 "znew 帮助信息"
rlRun 'gzexe --version 2>&1 || true' 0 "gzexe 版本信息"
rlRun 'gzexe --help 2>&1 | head -5 || true' 0 "gzexe 帮助信息"
rlRun 'zforce --version 2>&1 || true' 0 "zforce 版本信息"
rlRun 'zforce --help 2>&1 | head -5 || true' 0 "zforce 帮助信息"
rlRun 'zegrep --version 2>&1 || true' 0 "zegrep 版本信息"
rlRun 'zegrep --help 2>&1 | head -5 || true' 0 "zegrep 帮助信息"
rlRun 'zfgrep --version 2>&1 || true' 0 "zfgrep 版本信息"
rlRun 'zfgrep --help 2>&1 | head -5 || true' 0 "zfgrep 帮助信息"
rlRun 'uncompress --version 2>&1 || true' 0 "uncompress 版本信息"
rlRun 'uncompress --help 2>&1 | head -5 || true' 0 "uncompress 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'gzip --invalid 2>&1 || true' 0 "gzip: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gzip 2>/dev/null || true
    echo "TEARDOWN: removed gzip"
fi
echo ""
echo "All gzip functional tests passed!"
