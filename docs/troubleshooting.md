# Troubleshooting Runbook

## Scenario 1: SSH says "Connection refused"

Meaning:

The client reached the VM, but port 22 was closed or SSH was not listening.

Check on the VM:

```bash
sudo systemctl status ssh --no-pager
sudo ss -tlnp | grep :22
```

Fix:

```bash
sudo systemctl enable --now ssh
sudo systemctl restart ssh
```

## Scenario 2: SSH says "Connection timed out"

Meaning:

The traffic did not successfully reach the service.

Likely causes:

- Twingate client disconnected
- Twingate resource not assigned to the user/group
- Connector offline
- Wrong resource IP/CIDR
- VM IP changed
- Firewall blocking traffic
- Port restriction does not include the needed port

Check from Windows:

```powershell
Test-NetConnection 192.168.1.168 -Port 22
Test-NetConnection 192.168.1.168 -Port 30080
```

Check on the VM:

```bash
ip -br a
sudo ufw status
```

## Scenario 3: SSH says "Permission denied"

Meaning:

The network path works, but SSH authentication failed.

Check:

```bash
whoami
ls -la ~/.ssh
cat ~/.ssh/authorized_keys
```

## Scenario 4: Kubernetes service does not respond

Check pods:

```bash
kubectl get pods -n demo -o wide
```

Check service:

```bash
kubectl get svc -n demo
```

Check logs:

```bash
kubectl logs -n demo deploy/whoami
```

Check local NodePort:

```bash
curl http://192.168.1.168:30080
```

## Packet Path

External client traffic follows this path:

```text
Windows PC
  -> Twingate Client
  -> Twingate Network
  -> Twingate Connector inside LAN
  -> Ubuntu VM 192.168.1.168
  -> K3s NodePort service on TCP 30080
  -> Pod running whoami container
```
