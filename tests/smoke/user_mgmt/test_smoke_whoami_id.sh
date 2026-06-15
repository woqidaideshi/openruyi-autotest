#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'whoami' 0 "whoami 当前用户"
rlRun 'id' 0 "id 用户和组信息"
rlRun 'id -u' 0 "id -u UID"
rlRun 'id -g' 0 "id -g GID"
echo "smoke test passed!"
