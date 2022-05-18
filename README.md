# WebSockets Test

This is a simple application to test websockets.

This is mostly from: <https://websockets.readthedocs.io/en/stable/howto/kubernetes.html>.

## Setup

* Prerequisites - Python!

* Setup VirtualEnv

```bash
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Local Testing

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

## Docker Image / Testing

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

## Kubernetes Deployment

NOTE: This depends on the docker image above being deployed to GHCR (GitHub Container Registry).

* Create a MyValues.yaml to define ingress parameters (citrix example)

```yaml
ingress:
  enabled: true
  annotations:
    ingress.citrix.com/frontend-ip: 10.201.14.227
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

* Deploy helm chart

```bash
helm upgrade --install websockets-test ./chart/websockets-test -f MyValues.yaml
```

* Test

NOTE: It takes time for the DNS to propagate.

```bash
source .venv/bin/activate
python -m websockets wss://cluster-name-ws-test.example.com
```

NOTE: Anything typed should be echoed back after a short delay.

## TODO

* Find a way to automate testing
