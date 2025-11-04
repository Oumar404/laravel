# 🏗️ Architecture Gestion de Notes

## Structure du projet
```
gestionNote/
├── appNotes/          # Backend Laravel (API)
├── frontend/          # Frontend Vue.js
├── database_schema.sql # Base de données MySQL
└── ARCHITECTURE.md    # Ce fichier
```

## 🔄 Flux de données
Frontend (Vue.js) ↔ API REST (Laravel) ↔ Base de données (MySQL)

## 🔐 Rôles et permissions
- **Étudiant**: Consulter ses notes, voir délibérations
- **Professeur**: Gérer notes de ses cours, réclamations
- **Administration**: Gestion complète, délibérations finales

## 🚀 Technologies
- **Frontend**: Vue.js 3, Pinia, Vue Router, Axios, Tailwind CSS
- **Backend**: Laravel 11, Sanctum, Eloquent ORM
- **Database**: MySQL 8.0

---

## 🧩 Architecture DevOps

- **Conteneurs Docker**
  - Frontend: build Vite → servi par NGINX (port 80)
  - Backend: Laravel via `php artisan serve` (port 8000)
  - MySQL: image officielle `mysql:8.0`

- **Kubernetes (namespace `gestion-notes`)**
  - Deployments: `frontend`, `backend`, `mysql`
  - Services: `frontend-service` (80), `backend-service` (8000), `mysql-service` (3306)
  - Ingress: `gestion-notes.local` → `/` vers frontend, `/api` vers backend
  - ConfigMap: NGINX frontend (`frontend-nginx-conf`)
  - Secrets: `mysql-secret` (root pwd, db)
  - Fiabilité: Probes (readiness/liveness), `backend-hpa`, PDB (frontend/backend/mysql)

- **CI/CD (GitHub Actions)**
  - CI: build frontend/backend, images Docker, push GHCR `ghcr.io/OWNER/*`
  - CD: `kubectl apply` des dossiers `k8s/` et `monitoring/` via kubeconfig secret

- **Supervision (Prometheus + Grafana)**
  - Installation via Helm: kube-prometheus-stack (namespace `monitoring`)
  - `prom/blackbox-exporter` + CRD `Probe` pour surveiller l’HTTP du backend
  - Dashboards Grafana: K8s par défaut + panels basés sur `probe_success`

## 📈 SLO/Alerting (suggestion)
- Dispo API: 99.9%/30j → alerte si `probe_success == 0` > 5m
- Perf API: p95 < 500ms (ajouter métriques applicatives ultérieurement)
- Capacité: CPU > 80% 10m (HPA réagit), alerte si persistant