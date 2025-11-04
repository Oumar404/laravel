# Monitoring (Prometheus + Grafana)

This repo assumes you install kube-prometheus-stack (Prometheus Operator) via Helm in the cluster. Example:

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace
```

Then apply the blackbox exporter and probe in the app namespace:

```
kubectl apply -f monitoring/blackbox-exporter.yaml -n gestion-notes
kubectl apply -f monitoring/backend-probe.yaml -n gestion-notes
```

Open Grafana:
- `kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80`
- Login admin/prom-operator (default), change password.

Dashboards: use built-in K8s/Pods dashboards; add panels for `probe_success{probe="backend-http-probe"}` and `probe_http_status_code`.
