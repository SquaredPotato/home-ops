---
apiVersion: v1alpha1
kind: RawVolumeConfig
name: longhorn-data
provisioning:
  diskSelector:
    match: {{ .Node.Data.longhornDiskSelector }}
  minSize: 300GiB
  maxSize: 600GiB
