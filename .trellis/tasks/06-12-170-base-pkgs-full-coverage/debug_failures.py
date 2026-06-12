"""Quick fix: Check one test log on server to understand failures."""
import paramiko

SERVER='10.20.237.192'; PORT=12055; USER='openruyi'; PASS='openruyi'

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=30)

# Check a few test logs
for test_name in ['attr', 'bc', 'sqlite', 'which', 'openssl']:
    stdin, stdout, stderr = ssh.exec_command(f'cat /home/openruyi/functional-tests/{test_name}.log 2>/dev/null | tail -20', timeout=10)
    log = stdout.read().decode(errors='replace')
    print(f'=== {test_name}.log (last 20 lines) ===')
    print(log[:500])
    print()

ssh.close()
