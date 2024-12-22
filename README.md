# explo-kubernetes

An exploration of some kubernetes tools and features

## Important information

- All secrets and certificates in this repository are public. Do not use them in another situation. They are here for testing purposes ONLY.

## Usage

### TLS

The TLS is set up to use a custom CA certificate that is not secured in any kind of way. Do not use if not for tests.

To enable HTTPS on your communication, you need two things :

- Add the ./assets/certificates/ca.crt to your browser (for browser based communication)
- Add the ./assets/certificates/ca.crt to your system (for curl and other CLI communications)

```shell
sudo cp ./assets/certificates/ca.crt /usr/local/share/ca-certificates/sandbox.local.crt
sudo update-ca-certificates
```

## Cleaning up

Once you finished your tests.

### Delete the CA certificate

- From your browser
- From your system

```shell
sudo rm /usr/local/share/ca-certificates/sandbox.local.crt
sudo update-ca-certificates --fresh
```

## Issues

- Pod failing because of Too Many Opened files: https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files

## Backlog

- [ ] Cilium
- [ ] Tetragon
- [ ] Istio
- [ ] Grafana
- [ ] Terraform Cloud
- [ ] ArgoCD
- [ ] Crossplane
- [ ] Kyverno
- [ ] NginxController
- [ ] CertManager
