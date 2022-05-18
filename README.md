# WebSockets Test (helm chart)

This is a simple application to test websockets. (echo test)

This is mostly from [the python websockets tutorial docs](https://websockets.readthedocs.io/en/stable/howto/kubernetes.html).

## Installation

```bash
helm repo add tjm-websockets https://tjm.github.io/websockets-test/
helm repo update
helm install websockets-test tjm-websockets/websockets-test
```

You may also want to provide a `-f myValues.yaml` option.

Example `myValues.yaml` annotations for Citrix Ingress:

```yaml
ingress:
  enabled: true
  annotations:
    ingress.citrix.com/frontend-ip: 10.1.2.3
    ingress.citrix.com/frontend-httpprofile: '{"webSocket" : "enabled"}'
    ingress.citrix.com/frontend-tcpprofile: '{"ws":"enabled"}'
    ingress.citrix.com/insecure-termination: redirect
    ingress.citrix.com/preconfigured-certkey: '{"certs": [ {"name": "wc.example.com", "type":"default"} ] }'
    kubernetes.io/ingress.class: citrix
  hosts:
    - host: cluster-name-ws-test.example.com
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - hosts:
        - cluster-name-ws-test.example.com
```

## Development

* Prerequisites - Python!

* Setup VirtualEnv

```bash
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Local Testing

* Activate VirtualEnv

```bash
source .venv/bin/activate
```

* Run Server (this will attempt to run a webserver on port 80)

```bash
python app.py
```

* Test Connectivity (from another terminal)

```bash
source .venv/bin/activate
python -m websockets ws://localhost
```

NOTE: Anything typed should be echoed back after a short delay.

### Docker Image / Testing

* Create docker image

```bash
docker build -t websockets-test:1.0.0 .
```

* Docker test

```bash
docker run --name run-websockets-test --publish 32080:80 --rm websockets-test:1.0.0
```

* Test Connectivity (from another terminal)

```bash
source .venv/bin/activate
python -m websockets ws://localhost:32080
```

NOTE: Anything typed should be echoed back after a short delay.

### Kubernetes Helm Deployment Testing

NOTE: This depends on the docker image above being deployed to GHCR (GitHub Container Registry).

* Render Templates without installing

```bash
helm template websockets-test ./chart/websockets-test -f myValues.yaml
```

* Deploy local helm chart (during chart testing/development)

```bash
helm upgrade --install websockets-test ./chart/websockets-test -f myValues.yaml
```

* Test

NOTE: It takes time for the DNS to propagate.

```bash
source .venv/bin/activate
python -m websockets wss://cluster-name-ws-test.example.com
```

NOTE: Anything typed should be echoed back after a short delay.

## TODO

* Use the code from the benchmark.py (from the websockets docs) for automated testing
