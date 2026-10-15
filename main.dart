
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MonFormulairePage(),
  ));
}

class MonFormulairePage extends StatefulWidget {
  const MonFormulairePage({super.key});

  @override
  State<MonFormulairePage> createState() =>
      _MonFormulairePageState();
}

class _MonFormulairePageState extends State<MonFormulairePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomController =
      TextEditingController();
  final TextEditingController emailController =
      TextEditingController();

  String genre = 'Non précisé';
  bool notifications = false;
  bool sport = false;
  bool musique = false;
  bool informatique = false;

  List<String> get centresInteret => [
        if (sport) 'Sport',
        if (musique) 'Musique',
        if (informatique) 'Informatique',
      ];

  void reinitialiser() {
    _formKey.currentState?.reset();
    nomController.clear();
    emailController.clear();

    setState(() {
      genre = 'Non précisé';
      notifications = false;
      sport = false;
      musique = false;
      informatique = false;
    });
  }

  void afficherResume() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumePage(
          nom: nomController.text.trim(),
          email: emailController.text.trim(),
          genre: genre,
          notifications: notifications,
          centresInteret: centresInteret,
        ),
      ),
    );
  }

  @override
  void dispose() {
    nomController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon formulaire'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Informations personnelles',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Champ Nom : méthode avec controller
              TextFormField(
                controller: nomController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nom complet',
                  hintText: 'Entrez votre nom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez saisir votre nom.';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 14),

              // Champ E-mail
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Adresse e-mail',
                  hintText: 'exemple@email.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(value.trim())) {
                    return 'Veuillez saisir un e-mail valide.';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 20),

              const Text(
                'Genre',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              RadioGroup<String>(
                groupValue: genre,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => genre = value);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Femme'),
                      value: 'Femme',
                    ),
                    RadioListTile<String>(
                      title: Text('Homme'),
                      value: 'Homme',
                    ),
                    RadioListTile<String>(
                      title: Text('Non précisé'),
                      value: 'Non précisé',
                    ),
                  ],
                ),
              ),

              const Divider(height: 24),

              SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text(
                  'Recevoir des notifications',
                ),
                secondary: const Icon(Icons.notifications),
                value: notifications,
                onChanged: (value) {
                  setState(() => notifications = value);
                },
              ),

              const SizedBox(height: 12),

              const Text(
                'Centres d’intérêt',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              CheckboxListTile(
                title: const Text('Sport'),
                value: sport,
                onChanged: (value) {
                  setState(() => sport = value ?? false);
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              CheckboxListTile(
                title: const Text('Musique'),
                value: musique,
                onChanged: (value) {
                  setState(() => musique = value ?? false);
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              CheckboxListTile(
                title: const Text('Informatique'),
                value: informatique,
                onChanged: (value) {
                  setState(() => informatique = value ?? false);
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 16),

              // Zone de synthèse de la première page
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aperçu de vos informations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nom : ${nomController.text.isEmpty ? "Non renseigné" : nomController.text}',
                      ),
                      Text(
                        'E-mail : ${emailController.text.isEmpty ? "Non renseigné" : emailController.text}',
                      ),
                      Text('Genre : $genre'),
                      Text(
                        'Notifications : ${notifications ? "Activées" : "Désactivées"}',
                      ),
                      Text(
                        'Centres d’intérêt : ${centresInteret.isEmpty ? "Aucun" : centresInteret.join(", ")}',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: reinitialiser,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Effacer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: afficherResume,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Résumé'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// DEUXIÈME PAGE : affichage du résumé

class ResumePage extends StatelessWidget {
  final String nom;
  final String email;
  final String genre;
  final bool notifications;
  final List<String> centresInteret;

  const ResumePage({
    super.key,
    required this.nom,
    required this.email,
    required this.genre,
    required this.notifications,
    required this.centresInteret,
  });

  Widget ligneInfo(IconData icone, String titre, String valeur) {
    return ListTile(
      leading: Icon(icone, color: Colors.blue),
      title: Text(titre),
      subtitle: Text(valeur),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résumé des informations'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour au formulaire',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(
            Icons.account_circle,
            size: 90,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          const Text(
            'Récapitulatif',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          Card(
            child: Column(
              children: [
                ligneInfo(Icons.person, 'Nom complet', nom),
                const Divider(height: 1),
                ligneInfo(Icons.email, 'Adresse e-mail', email),
                const Divider(height: 1),
                ligneInfo(Icons.people, 'Genre', genre),
                const Divider(height: 1),
                ligneInfo(
                  Icons.notifications,
                  'Notifications',
                  notifications ? 'Activées' : 'Désactivées',
                ),
                const Divider(height: 1),
                ligneInfo(
                  Icons.favorite,
                  'Centres d’intérêt',
                  centresInteret.isEmpty
                      ? 'Aucun'
                      : centresInteret.join(', '),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour au formulaire'),
          ),
        ],
      ),
    );
  }
}
