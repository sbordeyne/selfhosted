# Self hosting with kubernetes

This is the logbook of my journey into self hosting apps using kubernetes as a framework.
I used that as a way to get better and understand more about kubernetes, DevOps and GitOps

## Step 1 : Choosing an Operating System

The platform of choice of course was a Unix like OS, given that is what I'm most confortable with.
I gave FreeBSD a thought before dismissing it since I lack the know how, and it doesn't seem well supported enough.

That being said, my first choice was TrueNAS Scale. It's a great system, but for a tinkerer like I am, it felt clunky to actually use. I found myself growing increasingly frustrated with the OS as a whole, and would do all of my maintenance
in a terminal anyways. I eventually opened up port 22 to log in with SSH.

While tinkering though, I ended up borking the system. TrueNAS Scale comes with k3s, a lightweight, single node kubernetes
distribution, but that also brings pain points :

- k3s includes tooling, but you need to prefix with `k3s` (i.e. `k3s kubectl`) to use it, it's annoying
- k3s only works with a single node, you can't actually make a cluster of servers with it
- `helm` was locked on the machine by default and required a script to actually "unlock" it.

Given that TrueNAS Scale did not fit my needs anymore, I decided to find a new linux flavour to replace it with, and I
chose the recently released, trusty `Debian 12` for that.

## Step 2 : Setting up the kubernetes cluster

To install kubernetes, you have to go through `kubeadm` (or the kubernetes administration tool).
Installing it was fairly straightforward, add the APT repository, and `apt install --no-install-recommends -y kubeadm kubelet kubectl` did the trick.

I followed this guide https://www.linuxtechi.com/install-kubernetes-cluster-on-debian/ which was a godsent.

## Step 3 : Deploying the first manifests

I knew I wanted to do as much as possible with kubernetes.
I chose to use CNPG for the databases, MinIO for object storage,
external-dns for DNS entries management, cert-manager for SSL certificate generation,
traefik for the reverse proxy and metallb for load balancing.

I also wanted a single sign on experience accross all my services,
hence why I went with keycloak and lldap for user management.

Everything is logged in this repository