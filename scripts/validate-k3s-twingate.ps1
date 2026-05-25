$ErrorActionPreference = "Continue"

$OutputFolder = "$env:USERPROFILE\Desktop\k3s-lab-evidence"
New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null

$OutFile = "$OutputFolder\remote-validation.txt"

"Captured at: $(Get-Date)" | Out-File $OutFile -Encoding utf8

"`n## TCP 22 - SSH" | Out-File $OutFile -Append -Encoding utf8
Test-NetConnection 192.168.1.168 -Port 22 | Out-File $OutFile -Append -Encoding utf8

"`n## TCP 6443 - Kubernetes API" | Out-File $OutFile -Append -Encoding utf8
Test-NetConnection 192.168.1.168 -Port 6443 | Out-File $OutFile -Append -Encoding utf8

"`n## TCP 30080 - Demo App" | Out-File $OutFile -Append -Encoding utf8
Test-NetConnection 192.168.1.168 -Port 30080 | Out-File $OutFile -Append -Encoding utf8

"`n## SSH Remote Command Test" | Out-File $OutFile -Append -Encoding utf8
ssh k3-demo@192.168.1.168 "hostname && whoami" | Out-File $OutFile -Append -Encoding utf8

"`n## kubectl nodes" | Out-File $OutFile -Append -Encoding utf8
kubectl get nodes -o wide | Out-File $OutFile -Append -Encoding utf8

"`n## kubectl demo pods" | Out-File $OutFile -Append -Encoding utf8
kubectl get pods -n demo -o wide | Out-File $OutFile -Append -Encoding utf8

"`n## kubectl demo service" | Out-File $OutFile -Append -Encoding utf8
kubectl get svc -n demo -o wide | Out-File $OutFile -Append -Encoding utf8

"`n## HTTP app test" | Out-File $OutFile -Append -Encoding utf8
curl.exe http://192.168.1.168:30080 | Out-File $OutFile -Append -Encoding utf8

notepad $OutFile
