# Twingate Architecture Notes

## Project Framing

This lab demonstrates private Kubernetes administration and internal service access without exposing inbound ports to the public internet.

The practical goal is to allow an authorized remote administrator to use SSH, kubectl, and internal application access through Twingate while keeping the private VM and K3s API endpoint off the public internet.

## Twingate Components

### Controller

The Controller is the control-plane component.

Responsibilities:

- Stores configuration from the Admin Console
- Handles configuration and policy
- Delegates user authentication to an identity provider
- Registers Connectors
- Generates signed ACLs for Clients
- Generates ACLs for Connectors

The Controller is not the application data path.

### Client

The Client runs on the user's device.

Responsibilities:

- Authenticates the user
- Receives authorization/policy information
- Detects traffic to protected Resources
- Proxies DNS, TCP, and UDP traffic for protected Resources
- Establishes an encrypted tunnel to the appropriate Connector

In this lab, the Windows Twingate Client detects traffic to:

```text
192.168.1.168:22
192.168.1.168:6443
192.168.1.168:30080
```

### Connector

The Connector runs inside the private network.

Responsibilities:

- Maintains outbound connectivity to Twingate infrastructure
- Receives a Connector ACL
- Verifies Client connection requests
- Performs local DNS resolution when needed
- Forwards authorized traffic to internal Resources

In this lab, the Connector can reach the private Ubuntu/K3s VM at:

```text
192.168.1.168
```

### Relay

The Relay helps Clients and Connectors communicate when direct peer-to-peer connectivity is not available.

Twingate attempts peer-to-peer communication first. If that is not possible, relayed connectivity is used as a fallback.

## NAT Traversal

The private network blocks unsolicited inbound traffic from the internet.

Twingate avoids inbound firewall exposure by having both the Client and Connector initiate outbound communication. This allows access to private Resources without opening inbound ports on the router or firewall.

## Lab Resources

| Resource | Address | Port | Purpose |
|---|---:|---:|---|
| k3s-ssh | 192.168.1.168 | TCP 22 | Linux administration |
| k3s-api | 192.168.1.168 | TCP 6443 | Kubernetes administration with kubectl |
| whoami-demo | 192.168.1.168 | TCP 30080 | Private demo application |

## Packet Path: kubectl

```text
Windows kubectl
  -> Twingate Client
  -> Twingate authorization/policy
  -> Twingate Connector inside private LAN
  -> K3s API at 192.168.1.168:6443
  -> Kubernetes control plane
```

## Practical Meaning

This is not just remote SSH.

This is a private management plane for a Kubernetes environment:

- SSH for host administration
- kubectl for Kubernetes control-plane administration
- HTTP access for internal application validation
- Twingate policy and port restrictions for least-privilege access
