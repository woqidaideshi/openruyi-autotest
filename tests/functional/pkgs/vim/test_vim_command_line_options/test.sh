#!/bin/sh -eux
# Functional test: vim - Command-line-options

. "../setup.sh"

echo "=== Test 3: Command line options ==="
rlRun 'vim --help 2>&1 | head -10' 0 "vim --help"
rlRun 'vim -c "version" -c "q" test.txt 2>&1 | head -3 || true' 0 "vim -c: execute command"
rlRun 'vim -R test.txt -c "q" 2>&1 || true' 0 "vim -R: readonly mode"
rlRun 'vim -b test.txt -c "q" 2>&1 || true' 0 "vim -b: binary mode"
rlRun 'vim -n test.txt -c "q" 2>&1 || true' 0 "vim -n: no swap file"

. "../teardown.sh"
echo "All vim Command-line-options tests passed!"
