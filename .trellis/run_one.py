"""Run a test script on the server and stream output."""
import paramiko, sys, time

PKG = sys.argv[1] if len(sys.argv) > 1 else 'acl'

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('10.20.237.192', port=12055, username='openruyi', password='openruyi', timeout=15)

# Upload with LF conversion
with open(f'e:/code/openruyi-autotest/tests/functional/{PKG}/test.sh', 'r', encoding='utf-8') as f:
    content = f.read().replace('\r\n', '\n')
sftp = ssh.open_sftp()
with sftp.open(f'/home/openruyi/{PKG}_test.sh', 'w') as remote_file:
    remote_file.write(content)
sftp.chmod(f'/home/openruyi/{PKG}_test.sh', 0o755)
sftp.close()

# Run without PTY to avoid password prompts
stdin, stdout, stderr = ssh.exec_command(f'bash /home/openruyi/{PKG}_test.sh 2>&1')

print(f'=== Running {PKG} test on server ===\n')
while not stdout.channel.exit_status_ready():
    if stdout.channel.recv_ready():
        data = stdout.channel.recv(4096).decode('utf-8', errors='replace')
        print(data, end='', flush=True)
    time.sleep(0.1)

data = stdout.read().decode('utf-8', errors='replace')
print(data, end='', flush=True)

print(f'\n=== Exit: {stdout.channel.recv_exit_status()} ===')
ssh.close()
