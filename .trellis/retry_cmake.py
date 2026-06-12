import paramiko, time
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('10.20.237.192', port=12055, username='openruyi', password='openruyi', timeout=15)

with open('tests/functional/cmake/test.sh', 'r', encoding='utf-8') as f:
    content = f.read().replace('\r\n', '\n')
sftp = ssh.open_sftp()
with sftp.open('/home/openruyi/cmake_test.sh', 'w') as rf:
    rf.write(content)
sftp.chmod('/home/openruyi/cmake_test.sh', 0o755)
sftp.close()

ssh.exec_command('chmod +x /home/openruyi/cmake_test.sh; nohup timeout 120 bash /home/openruyi/cmake_test.sh > /home/openruyi/cmake_result.log 2>&1 &')
print('Running...')
time.sleep(90)

i,o,e = ssh.exec_command('grep -c "tests passed" /home/openruyi/cmake_result.log; echo ===; tail -5 /home/openruyi/cmake_result.log')
print(o.read().decode())
ssh.close()
