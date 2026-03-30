const bcrypt = require('bcryptjs');
const db = require('../db');

exports.register = async (req, res) => {
    try {
        const { 
            nom_complet, 
            email, 
            mot_de_passe, 
            role, 
            telephone, 
            nom_boutique, 
            raison_sociale, 
            adresse_unique 
        } = req.body;

        // Validation basique
        if (!nom_complet || !email || !mot_de_passe || !role) {
            return res.status(400).json({ message: 'Veuillez remplir tous les champs obligatoires (nom_complet, email, mot_de_passe, role).' });
        }

        if (role !== 'ARTISAN' && role !== 'ENTREPRISE') {
            return res.status(400).json({ message: 'Le rôle doit être ARTISAN ou ENTREPRISE.' });
        }

        // Vérifier si l'utilisateur existe déjà
        const [existingUser] = await db.query('SELECT id_utilisateur FROM Utilisateur WHERE email = ?', [email]);
        if (existingUser.length > 0) {
            return res.status(400).json({ message: 'Cet email est déjà utilisé.' });
        }

        // Hasher le mot de passe
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(mot_de_passe, salt);

        // Préparer la requête d'insertion
        const query = `
            INSERT INTO Utilisateur 
            (nom_complet, email, mot_de_passe, role, telephone, nom_boutique, raison_sociale, adresse_unique) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `;
        
        // Assigner les valeurs selon le rôle
        const values = [
            nom_complet,
            email,
            hashedPassword,
            role,
            telephone || null,
            role === 'ARTISAN' ? nom_boutique : null,
            role === 'ENTREPRISE' ? raison_sociale : null,
            role === 'ENTREPRISE' ? adresse_unique : null
        ];

        // Exécuter la requête
        const [result] = await db.query(query, values);

        res.status(201).json({
            message: 'Utilisateur créé avec succès',
            userId: result.insertId,
            role: role
        });

    } catch (error) {
        console.error('Erreur SQL lors de l\'inscription:', error);
        res.status(500).json({ message: 'Erreur interne du serveur lors de la création du compte.' });
    }
};
