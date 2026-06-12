"""Upload all functional tests as tarball and run them."""
import paramiko, os, time, csv, tarfile, io

SERVER='10.20.237.192';PORT=12055;USER='openruyi';PASS='openruyi'
BASE='e:/code/openruyi-autotest/tests/functional'

# Discover all test dirs (new flat structure for 143 pkgs)
cases=[]
for pkg in sorted(os.listdir(BASE)):
    pp=os.path.join(BASE,pkg)
    if not os.path.isdir(pp): continue
    subdirs=[d for d in os.listdir(pp) if d.startswith('test_')]
    if subdirs:
        # Split structure
        for case in sorted(subdirs):
            tf=os.path.join(pp,case,'test.sh')
            if os.path.isfile(tf): cases.append((pkg,case,tf))
    else:
        # Flat structure (new packages)
        tf=os.path.join(pp,'test.sh')
        if os.path.isfile(tf): cases.append((pkg,pkg,tf))

print(f'Found {len(cases)} cases')

# Create tarball
buf=io.BytesIO()
with tarfile.open(fileobj=buf,mode='w:gz') as tar:
    for pkg,case,local in cases:
        filename=f'{pkg}__{case}.sh'  # unique name
        with open(local,'r',encoding='utf-8') as f:
            data=f.read().replace('\r\n','\n').encode('utf-8')
        info=tarfile.TarInfo(name=filename)
        info.size=len(data);info.mode=0o755
        tar.addfile(info,io.BytesIO(data))

# Upload
print('Uploading...')
ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER,port=PORT,username=USER,password=PASS,timeout=180)
sftp=ssh.open_sftp()
sftp.putfo(io.BytesIO(buf.getvalue()),'/home/openruyi/alltests.tar.gz')
sftp.close()
ssh.exec_command('rm -rf /home/openruyi/tc;mkdir -p /home/openruyi/tc;cd /home/openruyi/tc&&tar xzf /home/openruyi/alltests.tar.gz')

# Verify
stdin,stdout,sterr=ssh.exec_command('ls /home/openruyi/tc/*.sh|wc -l')
print(f'Server files: {stdout.read().decode().strip()}')

# Run all
print('Running...')
results={}
batch_size=25
all_files=sorted([(pkg,case) for pkg,case,_ in cases])
for i in range(0,len(all_files),batch_size):
    batch=all_files[i:i+batch_size]
    n=i//batch_size+1
    for pkg,case in batch:
        fn=f'{pkg}__{case}.sh'
        ssh.exec_command(f'nohup timeout 60 bash /home/openruyi/tc/{fn} > /home/openruyi/tc/{fn}.log 2>&1 &')
    time.sleep(50)
    for pkg,case in batch:
        fn=f'{pkg}__{case}.sh'
        stdin,stdout,sterr=ssh.exec_command(f'tail -1 /home/openruyi/tc/{fn}.log 2>/dev/null')
        passed='tests passed' in stdout.read().decode().lower()
        key=(pkg,case if case!=pkg else pkg)
        results[key]=('PASS' if passed else 'FAIL')
    pcount=sum(1 for r in list(results.values())[-len(batch):] if r=='PASS')
    print(f'  Batch {n}/{(len(all_files)+batch_size-1)//batch_size}: {pcount}/{len(batch)}')

# CSV
with open('docs/test_report.csv','w',newline='',encoding='utf-8-sig') as f:
    w=csv.writer(f)
    w.writerow(['测试套','测试用例','测试结果'])
    for (pkg,case),result in sorted(results.items()):
        w.writerow([pkg,case,result])

tp=sum(1 for v in results.values() if v=='PASS')
print(f'\nTotal: {tp}/{len(results)} passed')
ssh.close()
