#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
cat > myscript.sh << 'EOF'
#!/bin/sh
echo "script ran successfully"
EOF
chmod +x myscript.sh
rlRun './myscript.sh' 0 "shebang 脚本执行"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
