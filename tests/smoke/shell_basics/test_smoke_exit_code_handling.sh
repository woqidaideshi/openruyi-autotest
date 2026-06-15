#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
true; test $? -eq 0
false; test $? -ne 0
rlRun 'true && echo yes' 0 "&& 逻辑与"
rlRun 'false || echo no' 0 "|| 逻辑或"
echo "smoke test passed!"
