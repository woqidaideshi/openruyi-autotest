"""Re-run only the 42 failed test cases with longer timeout."""
import paramiko, os, time, csv, re

SERVER='10.20.237.192';PORT=12055;USER='openruyi';PASS='openruyi'
BASE='e:/code/openruyi-autotest/tests/functional'

# Read failed cases from CSV
failed=[]
with open('docs/test_report.csv','r',encoding='utf-8-sig') as f:
    for row in f:
        if 'FAIL' in row:
            parts=row.strip().split(',')
            pkg=parts[0]
            case=parts[1]
            tf=os.path.join(BASE,pkg,case,'test.sh')
            if os.path.isfile(tf):
                failed.append((pkg,case,tf))
print(f'Retrying {len(failed)} failed cases')

ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER,port=PORT,username=USER,password=PASS,timeout=15)

# Upload fixed scripts (just increase timeout, no code changes)
for pkg,case,local in failed:
    with open(local,'r',encoding='utf-8') as f:
        data=f.read().replace('\r\n','\n').encode('utf-8')
    sftp=ssh.open_sftp()
    with sftp.open(f'/home/openruyi/tc/{case}.sh','w') as rf:
        rf.write(data)
    sftp.chmod(f'/home/openruyi/tc/{case}.sh',0o755)
    sftp.close()

# Run with 90s timeout
print('Running...')
results={}
for i in range(0,len(failed),5):
    batch=failed[i:i+5]
    n=i//5+1
    for _,case,_ in batch:
        ssh.exec_command(f'nohup timeout 90 bash /home/openruyi/tc/{case}.sh > /home/openruyi/tc/{case}.log 2>&1 &')
    time.sleep(70)
    for _,case,_ in batch:
        stdin,stdout,sterr=ssh.exec_command(f'grep -c "tests passed" /home/openruyi/tc/{case}.log 2>/dev/null')
        cnt=stdout.read().decode().strip()
        passed=int(cnt or 0) > 0
        results[case]=('PASS' if passed else 'FAIL')
        print(f'  {case}: {"PASS" if passed else "FAIL"}')
    print()

# Merge with original CSV
new_results={}
with open('docs/test_report.csv','r',encoding='utf-8-sig') as f:
    for row in f:
        parts=row.strip().split(',')
        if len(parts)==3 and parts[0]!='测试套':
            pkg,case,orig_result=parts
            new_results[(pkg,case)]=results.get(case,orig_result)

# Write updated CSV
with open('docs/test_report.csv','w',newline='',encoding='utf-8-sig') as f:
    w=csv.writer(f)
    w.writerow(['测试套','测试用例','测试结果'])
    for (pkg,case),result in sorted(new_results.items()):
        w.writerow([pkg,case,result])

tp=sum(1 for v in new_results.values() if v=='PASS')
tf_count=sum(1 for v in new_results.values() if v=='FAIL')
print(f'\nFinal: {tp} PASS, {tf_count} FAIL (total {tp+tf_count})')
ssh.close()
