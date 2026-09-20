# Node networking as Talos 1.13+ typed network documents. The MAC-matched
#  link is enslaved to a single-link active-backup bond so every consumer
#  (Cilium devices, VLANs, the VIP, metrics) sees a stable interface name,
#  bond0, regardless of kernel NIC naming; a second NIC can join the bond
#  later without renaming anything. The bond name is also referenced by
#  `devices` in the cilium HelmRelease.
---
apiVersion: v1alpha1
kind: LinkAliasConfig
name: ethSel0
selector:
  match: glob("{{ .Node.Data.macAddr }}", mac(link.hardware_addr))
---
apiVersion: v1alpha1
kind: BondConfig
name: bond0
links:
  - ethSel0
bondMode: active-backup
mtu: {{ .Node.Data.mtu }}
addresses:
  - address: "{{ .Node.IP }}/23"
routes:
  - gateway: "10.0.2.1"
{{ if eq .Node.Role "control-plane" }}
---
apiVersion: v1alpha1
kind: Layer2VIPConfig
link: bond0
name: "10.0.2.100"
{{ end }}
