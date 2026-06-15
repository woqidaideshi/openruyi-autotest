#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'du -sh /etc' 0 "du -sh 目录大小"
rlRun 'du -h /bin | head -5' 0 "du 列出文件大小"
echo "smoke test passed!"
