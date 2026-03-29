const db = require('../db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: "Veuillez fournir un email et un mot de passe." });
        }

        // Search for user by email
        const [users] = await db.query('SELECT * FROM Utilisateur WHERE email = ?', [email]);
        
        if (users.length === 0) {
            return res.status(401).json({ message: "Email ou mot de passe incorrect." });
        }

        const user = users[0];

        // Compare password
        const isMatch = await bcrypt.compare(password, user.mot_de_passe);
        if (!isMatch) {
            return res.status(401).json({ message: "Email ou mot de passe incorrect." });
        }

        // Generate JWT Token
        const payload = {
            userId: user.id_utilisateur,
            role: user.role
        };

        const token = jwt.sign(payload, process.env.JWT_SECRET, {
            expiresIn: process.env.JWT_EXPIRES_IN || '24h'
        });

        // Send response without password
        delete user.mot_de_passe;

        res.json({
            message: "Connexion réussie",
            token,
            user
        });
    } catch (error) {
        console.error("Erreur lors de la connexion:", error);
        res.status(500).json({ message: "Erreur serveur" });
    }
};
