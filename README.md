# (Re)Sources Relationnelles

> **(Re)Sources Relationnelles** est une application conçue pour téléphone et navigateur, afin de permettre un rapprochement social sous une intiative gouvernementale. Son API est développée en **PHP**, sa base de données en **MySQL** et son front-end en **Flutter**.

---

## Fonctionnalités Principales

- [ ] Authentification (JWT)

  - [ ] Inscription citoyen
  - [ ] Conne ion/déconne ion
  - [ ] Réinitialisation mot de passe

- [ ] Gestion des rôles

  - [ ] Citoyen
  - [ ] Modérateur
  - [ ] Administrateur

- [ ] Catalogue des ressources

  - [ ] Filtres (catégorie, type, mots-clés)
  - [ ] Système de favoris

- [ ] Création de contenu

  - [ ] Articles/fiches pratiques
  - [ ] Vidéos (upload)

- [ ] Workflow de modération

  - [ ] Validation modérateur
  - [ ] Historique des modifications

- [ ] Commentaires

  - [ ] Ajout/réponse
  - [ ] Modération

- [ ] Système de notation (1-5★)

- [ ] Partage externe

- [ ] Backoffice

  - [ ] Gestion utilisateurs
  - [ ] Tableau de bord

- [ ] Export de données (CSV/Excel)

- [ ] Statistiques
  - [ ] Consultations
  - [ ] Partages
- [ ] Chiffrement données
- [ ] Audit sécurité
- [ ] Conformité RGPD
- [ ] Normes RGAA
- [ ] UI Responsive
- [ ] Notifications push
- [ ] Mode hors-ligne
- [ ] Synchronisation background

---

## Installation & Setup

### Prérequis

- PHP 8.3
- MySQL 8+
- Dart & Flutter (latest)
- Android Studio (émulation d'un téléphone Android)

### 1. Cloner le projet

```bash
git clone https://github.com/coline-baudrier/SP-CESIZen.git
cd SP-RessourcesRelationnelles
```

### 2. Backend (PHP + MySQL)

A faire si vous souhaitez démarrer en local, sinon l'API est disponble à l'adresse : **http://51.178.183.31/ressrelationnellescesi/api/**.

```bash
cd backend
composer install
cp .env.e ample .env  # Configurer la BDD et la secret key
php -S localhost:8000 -t api
```

Les scripts SQL sont trouvables dans `backend/sql/Database.sql`.

### 3. Frontend (Flutter)

Pensez à démarrer votre émulateur ou émuler directement sur votre téléphone branché.

```bash
# 1. Se placer dans le dossier frontend
cd frontend

# 2. Récupérer les dépendances Dart/Flutter
flutter pub get

# 3. Générer les fichiers spécifiques à la plateforme
flutter create --empty .  # Re-génère android/, ios/, etc. si besoin

# 4. Lancer l'app (pensez à allumer l'émulateur avant)
flutter run
```

---

## Tests & qualité

```bash
backend/tests/
├── unit/  # Tests unitaires (isolés, avec mocks)
│   ├── UserTest.php
├── functional/  # Tests fonctionnels (simulent des scénarios complets)
│   ├── AuthFunctionalTest.php
├── non_regression/  # Tests de non-régression (vérifient les anciens comportements)
│   ├── UserNonRegressionTest.php
```

#### Backend

Pour lancer les tests à la main :

```bash
cd backend
vendor/bin/phpunit --testdo  --colors=always --configuration phpunit. ml
```

#### Frontend

A mettre en place.

---

## Workflow Git & CI/CD

**Branches principales :**

- `main` → **Production**
- `dev` → **Développement**
- `test` → **Vérification et réalisation de test avant passage en production**

**Convention des branches :**

- `frontend/nom-view` (Ajout dans la partie frontend)
- `backend/nom-feature` (Ajout dans la partie backend)
- `api/nom-feature` (Ajout dans l'API)

---

## Contact & Contributeurs

👩‍💻 **Développé par** : [@coline-baudrier](https://github.com/coline-baudrier) - [@LeRouxTom](https://github.com/LeRouxTom) - [@GBIRRIEN](https://github.com/GBIRRIEN)
