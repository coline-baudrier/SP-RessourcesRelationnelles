# 📘 API Ressources Relationnelles

## 🌐 Base URL

```
http://localhost:8000
```

---

## 🧾 Authentication Flow

### ▶️ Register New Citizen

**POST** `/auth/register.php`

#### Body (JSON)

```json
{
  "email": "new_user@mail.com",
  "password": "pass123!",
  "nom": "Test",
  "prenom": "User"
}
```

---

### ▶️ Login (Admin / Modérateur / Citoyen)

**POST** `/auth/login.php`

#### Body (JSON)

```json
{
  "email": "admin@relation.fr",
  "password": "pass123"
}
```

---

### 📄 Get My Profile

**GET** `/auth/getProfile.php`

#### Headers

```
Authorization: Bearer <token>
```

---

### 🔑 Reset Password

**POST** `/auth/resetPassword.php`

#### Body (JSON)

```json
{
  "email": "nouveau@citoyen.fr",
  "new_password": "Test123!"
}
```

---

## 👥 User Management (Admin)

### 👀 Get All Users

**GET** `/admin/getAllUsers.php`

#### Headers

```
Authorization: Bearer <admin_token>
```

---

### 🔄 Toggle User Status

**PUT** `/admin/toggleStatus.php`

#### Headers

```
Authorization: Bearer <admin_token>
```

#### Body (JSON)

```json
{
  "userId": 6
}
```

---

### 🔧 Update User Role

**PUT** `/admin/updateRole.php`

#### Headers

```
Authorization: Bearer <admin_token>
```

#### Body (JSON)

```json
{
  "user_id": "6",
  "new_role": "moderateur"
}
```

---

## 📚 Resource Management

### ➕ Create Resource

**POST** `/resources/create.php`

#### Headers

```
Authorization: Bearer <citizen_token>
```

#### Body (JSON)

```json
{
  "titre": "Nouvelle ressource",
  "description": "Description de test",
  "contenu": "Contenu détaillé...",
  "id_type_ressource": 1,
  "id_categorie": 1,
  "relations": [1, 3],
  "visibilite": "public"
}
```

---

### 📄 Get All Resources

**GET** `/resources/getAll.php`

---

### 📘 Get Resource Details

**GET** `/resources/getOne.php`

#### Body (JSON)

```json
{
  "id": 1
}
```

---

### ✏️ Update Resource

**PUT** `/resources/update.php`

#### Headers

```
Authorization: Bearer <citizen_token>
```

#### Body (JSON)

```json
{
  "id_ressource": 7,
  "titre": "Nouveau titre",
  "description": "Nouvelle description",
  "relations": [1, 2, 3]
}
```

---

### ⏳ Get Pending Resources

**GET** `/resources/admin/pending.php`

#### Headers

```
Authorization: Bearer <modo_token>
```

---

### ✅ Approve Resource

**PUT** `/resources/admin/update_status.php`

#### Headers

```
Authorization: Bearer <modo_token>
```

#### Body (JSON)

```json
{
  "id": 7,
  "status": "publie"
}
```

---

### ❌ Delete Resource

**DELETE** `/resources/delete.php`

#### Headers

```
Authorization: Bearer <modo_token>
```

#### Body (JSON)

```json
{
  "id": 7
}
```

---

## 🏷️ Categories

### ➕ Create Category

**POST** `/categories/create.php`

#### Headers

```
Authorization: Bearer <modo_token>
```

#### Body (JSON)

```json
{
  "nom": "Santé mentale",
  "description": "Ressources pour le bien-être psychologique",
  "actif": true
}
```

---

### 📋 Get All Categories

**GET** `/categories/read.php`

---

### ❌ Delete Category

**DELETE** `/categories/delete.php`

#### Headers

```
Authorization: Bearer <admin_token>
```

#### Body (JSON)

```json
{
  "id": 5,
  "nom_categorie": "Santé psychologique",
  "actif": false
}
```

---

## 💬 Gestion des commentaires

### 🗨️ Get Comments

**POST** `/comments/read.php`

#### Body (JSON)

```json
{
  "id_ressource": 1
}
```

---

### ➕ Add Comment

**POST** `/comments/create.php`

#### Body (JSON)

```json
{
  "contenu": "Ce contenu est très utile!",
  "id_ressource": 1
}
```

---

### ✅ Moderate Comment

**POST** `/comments/moderate.php`

#### Body (JSON)

```json
{
  "id": 5,
  "statut_moderation": "approuve"
}
```

---

### ❌ Delete Comment

**DELETE** `/comments/delete.php`

#### Body (JSON)

```json
{
  "id": 4
}
```
