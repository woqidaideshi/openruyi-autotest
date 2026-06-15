#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
X=hello; test "$X" = "hello"
rlRun 'export Y=world' 0 "export 变量"
rlRun 'echo $HOME | grep /' 0 "\$HOME 环境变量"
rlRun 'echo ${#HOME}' 0 "\${#VAR} 字符串长度"
echo "smoke test passed!"
