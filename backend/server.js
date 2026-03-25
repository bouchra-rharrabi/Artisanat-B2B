// App init
const express = require('express');
const app = express();

// port 5000
const PORT = process.env.PORT || 5000;

// Home route
app.get('/', (req, res) => {
    res.send('Hello World! Le serveur de la plateforme B2B est en ligne.');
});

// Start server
app.listen(PORT, () => {
    console.log(`Serveur démarré avec succès sur http://localhost:${PORT}`);
});
