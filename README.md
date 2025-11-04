# 🎓 Gestion de Notes - Application Web

Application complète de gestion de notes universitaires avec Vue.js, Laravel et MySQL.

## 🚀 Installation Rapide

### Prérequis
- PHP 8.1+
- Composer
- Node.js 18+
- MySQL
- XAMPP (recommandé)

### Installation Automatique
```bash
# 1. Cloner le projet
git clone <votre-repo>
cd gestionNote

# 2. Exécuter l'installation (Windows)
install.bat

# 3. Démarrer l'application
start.bat
```

### Installation Manuelle

#### Backend (Laravel)
```bash
cd appNotes
composer install
php artisan key:generate
php artisan migrate:fresh --seed
php artisan serve
```

#### Frontend (Vue.js)
```bash
cd frontend
npm install
npm run dev
```

## 🔐 Comptes de Test

- **Admin**: `admin@gestion-notes.com` / `password`
- **Professeur**: `prof@test.com` / `password`
- **Étudiant**: `etudiant@test.com` / `password`

## 🌐 URLs d'Accès

- **Application**: http://localhost:5173
- **API Backend**: http://localhost:8000
- **Base de données**: http://localhost/phpmyadmin

## 📋 Fonctionnalités

### 👨‍🎓 Étudiant
- Consulter ses notes
- Faire des réclamations
- Télécharger son bulletin
- Voir son profil

### 👨‍🏫 Professeur
- Ajouter/modifier des notes
- Faire des réclamations
- Traiter les réclamations
- Gérer ses cours

### 👨‍💼 Administration
- Ajouter des étudiants
- Gérer les cours
- Traiter toutes les réclamations
- Délibérations finales
- Statistiques complètes

## 🛠️ Technologies

- **Frontend**: Vue.js 3, Pinia, Vue Router, Tailwind CSS
- **Backend**: Laravel 11, Sanctum, Eloquent ORM
- **Base de données**: MySQL 8.0

## 📁 Structure du Projet

```
gestionNote/
├── appNotes/          # Backend Laravel
├── frontend/          # Frontend Vue.js
├── install.bat        # Script d'installation
├── start.bat          # Script de démarrage
└── README.md          # Documentation
```

## 🔧 Configuration

### Variables d'environnement

#### Backend (.env)
```env
DB_DATABASE=gestion_notes
DB_USERNAME=root
DB_PASSWORD=
```

#### Frontend (.env)
```env
VITE_API_URL=http://localhost:8000/api
```

## 🐛 Résolution de Problèmes

### Erreur PowerShell
```cmd
# Utiliser CMD au lieu de PowerShell
cd /d C:\xampp\htdocs\gestionNote
start.bat
```

### Erreur CORS
- Vérifier que les deux serveurs sont démarrés
- Backend: http://localhost:8000
- Frontend: http://localhost:5173

### Base de données
```bash
# Recréer la base
php artisan migrate:fresh --seed
```

## 📞 Support

Pour toute question ou problème, créer une issue sur GitHub.

## 📄 Licence

MIT License

---

# 🛠️ Guide DevOps (Docker, Kubernetes, CI/CD, Monitoring)

## 🚢 Docker Compose (développement local)

```
docker compose up -d --build
```

- Frontend: http://localhost:8080
- Backend API: http://localhost:8000
- MySQL: 3306 (volume: `db_data`)

Arrêt et nettoyage:

```
docker compose down -v
```

## ☸️ Kubernetes (namespace `gestion-notes`)

Prérequis: Ingress NGINX installé, `kubectl` configuré.

```
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/ -n gestion-notes
```

Ingress par défaut: `gestion-notes.local`
Ajoutez dans `/etc/hosts` (en local):

```
127.0.0.1 gestion-notes.local
```

Vérification:

```
kubectl get pods,svc,ingress -n gestion-notes
```

## 📦 Images & Registre

Les manifests référencent GHCR: `ghcr.io/OWNER/appnotes-frontend` et `ghcr.io/OWNER/appnotes-backend`.
Remplacez `OWNER` par votre compte/organisation GitHub, ou ajustez les manifests/workflows si vous utilisez un autre registre.

## 🔄 CI/CD (GitHub Actions)

- CI: `.github/workflows/ci.yml` build et push des images vers GHCR.
- CD: `.github/workflows/cd.yml` applique `k8s/` et `monitoring/` sur le cluster.

Secrets requis dans le repo GitHub:

- `KUBE_CONFIG`: kubeconfig du cluster encodé en base64.
- `GITHUB_TOKEN`: fourni par GitHub, permet le push vers GHCR (packages: write).

Déclenchement:

- CI: push PR/main.
- CD: push sur `main` modifiant `k8s/**` ou `monitoring/**` (ou `workflow_dispatch`).

## 📊 Monitoring (Prometheus + Grafana)

Installer kube-prometheus-stack (namespace `monitoring`):

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace
```

Déployer blackbox-exporter et la Probe HTTP:

```
kubectl apply -f monitoring/blackbox-exporter.yaml -n gestion-notes
kubectl apply -f monitoring/backend-probe.yaml -n gestion-notes
```

Grafana:

```
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
```

Accéder à http://localhost:3000 (admin/prom-operator par défaut), ajouter un panel sur `probe_success{probe="backend-http-probe"}`.

## 🧪 Santé & Probes

- Backend: `/healthz` renvoie `{ "status": "ok" }` → utiliser pour readiness/liveness (port 8000).
- Frontend: probes HTTP `/` (port 80).
- MySQL: probes TCP 3306.

## 🧰 Dépannage rapide

- Pods en CrashLoop:
  - `kubectl logs <pod> -n gestion-notes`
  - `kubectl describe pod <pod> -n gestion-notes` (probes/resources)
- Ingress non joignable:
  - Vérifier l’ingress controller, DNS/hosts, règles Ingress
- CI push GHCR échoue:
  - Vérifier permissions `packages: write` sur `GITHUB_TOKEN` et OWNER correct
- DB non persistante:
  - Remplacer `emptyDir: {}` par PVC (StatefulSet + PersistentVolumeClaim)