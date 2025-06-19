<?php

class User
{
    private $pdo;
    private $table = 'Utilisateur';

    public function __construct($db)
    {
        $this->pdo = $db;
    }

    public function authenticate($email, $password)
{
    try {
        $user = $this->getUserByEmail($email);
        
        if (!$user) {
            error_log("Utilisateur non trouvé: " . $email);
            return ["error" => "Email ou mot de passe incorrect"];
        }

        // Comparaison directe du mot de passe sans hachage
        error_log("Comparaison pour: " . $email);
        error_log("Mot de passe fourni: " . $password);
        error_log("Mot de passe stocké: " . $user['mot_de_passe']);
        error_log("Résultat verification: " . ($password === $user['mot_de_passe'] ? 'true' : 'false'));

        if ($password !== $user['mot_de_passe']) {
            return ["error" => "Email ou mot de passe incorrect"];
        }

        if (!$user['compte_actif']) {
            return ["error" => "Compte désactivé"];
        }

        $this->updateLastLogin($user['id_utilisateur']);
        unset($user['mot_de_passe']);
        
        return $user;

    } catch (PDOException $e) {
        error_log("Erreur d'authentification: " . $e->getMessage());
        return ["error" => "Erreur lors de l'authentification"];
    }
}


    public function createUser($email, $password, $nom, $prenom, $role = 'citoyen')
    {
        try {
            if ($this->getUserByEmail($email)) {
                return ["error" => "Email déjà utilisé"];
            }

            $hashedPassword = password_hash($password, PASSWORD_BCRYPT);
            $sql = "INSERT INTO $this->table 
                    (email, mot_de_passe, nom, prenom, date_inscription, compte_actif, role) 
                    VALUES (:email, :password, :nom, :prenom, NOW(), 1, :role)";
            
            $query = $this->pdo->prepare($sql);
            $query->execute([
                ':email' => $email,
                ':password' => $hashedPassword,
                ':nom' => $nom,
                ':prenom' => $prenom,
                ':role' => $role
            ]);

            return [
                "message" => "Utilisateur créé avec succès",
                "id" => $this->pdo->lastInsertId()
            ];

        } catch (PDOException $e) {
            error_log("Erreur SQL: " . $e->getMessage());
            return ["error" => "Erreur lors de la création du compte"];
        }
    }

    public function createCitizenAccount($email, $password, $nom, $prenom)
    {
        return $this->createUser($email, $password, $nom, $prenom, 'citoyen');
    }

    public function updateUser($id, $data)
    {
        try {
            $allowedFields = ['email', 'nom', 'prenom', 'mot_de_passe'];
            $updates = [];
            $params = [':id' => $id];

            foreach ($data as $field => $value) {
                if (!in_array($field, $allowedFields)) {
                    return ["error" => "Champ non autorisé : $field"];
                }

                if ($field === 'email' && $this->getUserByEmail($value)) {
                    return ["error" => "Email déjà utilisé"];
                }

                if ($field === 'mot_de_passe') {
                    $value = password_hash($value, PASSWORD_BCRYPT);
                }

                $updates[] = "$field = :$field";
                $params[":$field"] = $value;
            }

            if (empty($updates)) {
                return ["error" => "Aucun champ valide à mettre à jour"];
            }

            $sql = "UPDATE $this->table SET " . implode(", ", $updates) . " WHERE id_utilisateur = :id";
            $query = $this->pdo->prepare($sql);
            $query->execute($params);

            return ["message" => "Profil mis à jour"];

        } catch (PDOException $e) {
            error_log("Erreur SQL: " . $e->getMessage());
            return ["error" => "Erreur lors de la mise à jour"];
        }
    }

    public function deleteUser($id) 
    {
        try {
            $sql = "DELETE FROM $this->table WHERE id_utilisateur = :id";
            $query = $this->pdo->prepare($sql);
            $query->execute([':id' => $id]);
            return ["message" => "Utilisateur supprimé"];
        } catch (PDOException $e) {
            error_log("Erreur SQL: " . $e->getMessage());
            return ["error" => "Erreur lors de la suppression"];
        }
    }

    public function getAllUsers() 
    {
        try {
            $sql = "SELECT id_utilisateur, email, nom, prenom, date_inscription, compte_actif, role 
                    FROM $this->table 
                    ORDER BY id_utilisateur DESC";
            $query = $this->pdo->prepare($sql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Erreur SQL: " . $e->getMessage());
            return ["error" => "Erreur lors de la récupération des utilisateurs"];
        }
    }

    public function getUserByEmail($email)
    {
        try {
            $sql = "SELECT * FROM $this->table WHERE email = :email LIMIT 1";
            $query = $this->pdo->prepare($sql);
            $query->execute([':email' => $email]);
            return $query->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Erreur SQL: " . $e->getMessage());
            return null;
        }
    }

    public function getUserById($id) 
    {
        try {
            $sql = "SELECT id_utilisateur, email, nom, prenom, date_inscription, role 
                    FROM $this->table 
                    WHERE id_utilisateur = :id LIMIT 1";
            $query = $this->pdo->prepare($sql);
            $query->execute([':id' => $id]);
            return $query->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Erreur SQL: " . $e->getMessage());
            return null;
        }
    }

    public function toggleUserStatus($id)
    {
        try {
            // Basculer le statut actif/inactif
            $sql = "UPDATE $this->table 
                    SET compte_actif = NOT compte_actif, 
                        date_derniere_connexion = NOW() 
                    WHERE id_utilisateur = :id";
            
            $query = $this->pdo->prepare($sql);
            $query->execute([':id' => $id]);

            // Récupérer le nouveau statut
            $sql = "SELECT compte_actif FROM $this->table WHERE id_utilisateur = :id";
            $query = $this->pdo->prepare($sql);
            $query->execute([':id' => $id]);
            $result = $query->fetch(PDO::FETCH_ASSOC);

            return [
                "message" => "Statut mis à jour",
                "compte_actif" => $result['compte_actif']
            ];

        } catch (PDOException $e) {
            error_log("Erreur SQL: " . $e->getMessage());
            return ["error" => "Erreur lors de la modification du statut"];
        }
    }

    public function updateLastLogin($id)
    {
        try {
            $sql = "UPDATE $this->table 
                    SET date_derniere_connexion = NOW() 
                    WHERE id_utilisateur = :id";
            
            $query = $this->pdo->prepare($sql);
            $query->execute([':id' => $id]);
            return true;

        } catch (PDOException $e) {
            error_log("Erreur SQL: " . $e->getMessage());
            return false;
        }
    }

    public function resetPassword($email, $newPassword)
    {
        try {
            $hashedPassword = password_hash($newPassword, PASSWORD_BCRYPT);
            
            $sql = "UPDATE $this->table 
                    SET mot_de_passe = :password 
                    WHERE email = :email";
            
            $query = $this->pdo->prepare($sql);
            $query->execute([
                ':password' => $hashedPassword,
                ':email' => $email
            ]);

            return ["message" => "Mot de passe réinitialisé"];

        } catch (PDOException $e) {
            error_log("Erreur SQL: " . $e->getMessage());
            return ["error" => "Erreur lors de la réinitialisation"];
        }
    }

    public function updateRole($id, $newRole)
{
    try {
        // Liste des rôles valides (à adapter selon votre application)
        $validRoles = ['citoyen', 'moderateur', 'super_admin'];
        
        if (!in_array($newRole, $validRoles)) {
            return ["error" => "Rôle invalide. Les rôles valides sont : " . implode(', ', $validRoles)];
        }

        // Vérifier que l'utilisateur existe
        $user = $this->getUserById($id);
        if (!$user) {
            return ["error" => "Utilisateur non trouvé"];
        }

        // Mise à jour du rôle
        $sql = "UPDATE $this->table SET role = :role WHERE id_utilisateur = :id";
        $query = $this->pdo->prepare($sql);
        $query->execute([
            ':role' => $newRole,
            ':id' => $id
        ]);

        return [
            "message" => "Rôle mis à jour avec succès",
            "new_role" => $newRole,
            "user_id" => $id
        ];

    } catch (PDOException $e) {
        error_log("Erreur SQL dans updateRole: " . $e->getMessage());
        return ["error" => "Erreur lors de la mise à jour du rôle"];
    }
}
}