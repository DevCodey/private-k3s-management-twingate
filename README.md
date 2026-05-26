# Private Kubernetes Management Plane with Twingate and K3s

A hands-on lab for securely administering private infrastructure with Twingate, Ubuntu, and K3s.

This project demonstrates how an authorized Windows client can remotely access private services without exposing inbound ports to the public internet.

## What This Lab Demonstrates

The lab allows an authorized remote client to:

- SSH into a private Ubuntu VM over TCP 22
- Manage a private K3s API over TCP 6443 using `kubectl`
- Access an internal Kubernetes demo app over TCP 30080
- Validate access from an external network using a phone hotspot

No public inbound port forwarding is used for SSH, the Kubernetes API, or the demo application.

## Why I Built This

I built this lab to practice practical infrastructure support and troubleshooting across:

- TCP/IP networking
- Private IP routing
- NAT and firewall concepts
- ZTNA-style private access
- Windows and Linux CLI troubleshooting
- Kubernetes administration
- Bash and PowerShell scripting
- Support-quality documentation

## Practical Scenario

A remote engineer needs to administer a private Kubernetes environment without exposing management ports to the public internet.

Instead of publishing SSH or the Kubernetes API publicly, access is granted through Twingate-protected Resources and validated from a separate network.

In this lab, the private K3s API endpoint remains on the private LAN at:

```text
192.168.1.168:6443

