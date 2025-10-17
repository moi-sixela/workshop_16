import 'package:flutter/material.dart';

void main() {
  runApp(const WizardQuizApp());
}

/// Simple, self-contained Flutter app for a 20-question QCM that classifies the user
/// into 1 of 4 wizard archetypes. No external dependencies.
///
/// Notes:
/// - All UI strings are in French.
/// - Code comments are in English (user preference).
/// - Scoring is additive: A→Erudit, B→Elementaliste, C→Illusionniste, D→Guerrier.
/// - Includes basic tie handling and a restart flow.
class WizardQuizApp extends StatelessWidget {
  const WizardQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QCM – Quel sorcier es-tu ?',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const QuizScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Domain types
enum WizardType { erudit, elementaliste, illusionniste, guerrier }

class AnswerOption {
  final String label; // e.g. "A. ..."
  final WizardType type;
  const AnswerOption({required this.label, required this.type});
}

class Question {
  final String text;
  final List<AnswerOption> options; // must be length 4 (A,B,C,D)
  const Question({required this.text, required this.options});
}

/// Data source — 20 questions mapping A,B,C,D → (Erudit, Élémentaliste, Illusionniste, Guerrier)
/// Keep the exact wording from the earlier specification.
final List<Question> kQuestions = [
  Question(
    text: '1. Lors d\'un conflit magique, vous…',
    options: [
      AnswerOption(
        label: 'A. Cherchez à comprendre les causes et à les résoudre',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Canalisez la puissance des éléments pour riposter',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Trouvez un moyen de détourner le conflit',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Chargez en première ligne',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '2. Une porte ancienne et scellée bloque votre passage. Vous…',
    options: [
      AnswerOption(
        label: 'A. Analysez les runes pour briser le sceau',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Faites fondre la pierre avec un sort de feu',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Trouvez une faille dans l\'illusion du mur',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Dégondez la porte de force',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '3. Votre grimoire idéal est…',
    options: [
      AnswerOption(
        label: 'A. Rempli de symboles anciens et de diagrammes',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Un recueil de chants et de rites naturels',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Une suite de récits énigmatiques et codés',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Un manuel de combat magique',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '4. Votre lieu préféré pour étudier la magie…',
    options: [
      AnswerOption(
        label: 'A. Une bibliothèque poussiéreuse',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Une clairière au lever du soleil',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Un théâtre aux lumières tamisées',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Une forteresse d\'entraînement',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '5. Face à une énigme complexe, vous…',
    options: [
      AnswerOption(
        label: 'A. Décomposez méthodiquement le problème',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Laissez votre intuition vous guider',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Imaginez une solution créative',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Foncez et essayez toutes les options',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '6. Quel élément vous attire le plus ?',
    options: [
      AnswerOption(label: 'A. L’air et ses secrets', type: WizardType.erudit),
      AnswerOption(
        label: 'B. L’eau, la terre, le feu, le vent',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. La brume et l’ombre',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Le métal et la foudre',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '7. Si vous pouviez apprendre un sort, ce serait…',
    options: [
      AnswerOption(
        label: 'A. Lire dans les esprits anciens',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Parler aux animaux et contrôler la nature',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Créer des illusions réalistes',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Déchaîner une tempête d’énergie brute',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '8. Dans une équipe de sorciers, vous seriez…',
    options: [
      AnswerOption(label: 'A. Le stratège', type: WizardType.erudit),
      AnswerOption(
        label: 'B. Le guide spirituel',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Le trompeur qui déstabilise l’ennemi',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Le protecteur et combattant',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '9. Votre plus grand atout magique est…',
    options: [
      AnswerOption(label: 'A. Votre savoir', type: WizardType.erudit),
      AnswerOption(
        label: 'B. Votre connexion à la nature',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Votre imagination',
        type: WizardType.illusionniste,
      ),
      AnswerOption(label: 'D. Votre puissance', type: WizardType.guerrier),
    ],
  ),
  Question(
    text: '10. Quel artefact choisiriez-vous ?',
    options: [
      AnswerOption(
        label: 'A. Une plume d’écriture ancienne',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Un cristal vibrant',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Un masque mystique',
        type: WizardType.illusionniste,
      ),
      AnswerOption(label: 'D. Une épée runique', type: WizardType.guerrier),
    ],
  ),
  Question(
    text: '11. Comment préférez-vous lancer vos sorts ?',
    options: [
      AnswerOption(
        label: 'A. En récitant des incantations longues',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Par un chant ou un geste fluide',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Par un murmure ou un signe caché',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Par un cri et un impact physique',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '12. Votre relation avec les créatures magiques est…',
    options: [
      AnswerOption(
        label: 'A. Étudier leurs comportements',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Communier avec elles',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Les manipuler pour surprendre',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Les dresser pour le combat',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '13. Dans un duel, votre premier réflexe est…',
    options: [
      AnswerOption(
        label: 'A. Analyser votre adversaire',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Créer une barrière élémentaire',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Le tromper par une illusion',
        type: WizardType.illusionniste,
      ),
      AnswerOption(label: 'D. L’attaquer de front', type: WizardType.guerrier),
    ],
  ),
  Question(
    text: '14. Si vous deviez enseigner la magie…',
    options: [
      AnswerOption(
        label: 'A. Cours théoriques et précis',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Sorties dans la nature',
        type: WizardType.elementaliste,
      ),
      AnswerOption(label: 'C. Énigmes et jeux', type: WizardType.illusionniste),
      AnswerOption(label: 'D. Tournois magiques', type: WizardType.guerrier),
    ],
  ),
  Question(
    text: '15. Votre rapport au pouvoir magique est…',
    options: [
      AnswerOption(label: 'A. Une responsabilité', type: WizardType.erudit),
      AnswerOption(
        label: 'B. Une harmonie à respecter',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Un art à exprimer',
        type: WizardType.illusionniste,
      ),
      AnswerOption(label: 'D. Une arme à maîtriser', type: WizardType.guerrier),
    ],
  ),
  Question(
    text: '16. Quel est votre plus grand défaut magique ?',
    options: [
      AnswerOption(label: 'A. Trop analytique', type: WizardType.erudit),
      AnswerOption(label: 'B. Trop émotif', type: WizardType.elementaliste),
      AnswerOption(
        label: 'C. Trop imprévisible',
        type: WizardType.illusionniste,
      ),
      AnswerOption(label: 'D. Trop impulsif', type: WizardType.guerrier),
    ],
  ),
  Question(
    text: '17. Face à une prophétie obscure…',
    options: [
      AnswerOption(
        label: 'A. Traduisez symboles et textes anciens',
        type: WizardType.erudit,
      ),
      AnswerOption(
        label: 'B. Écoutez la voix de la nature',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. Doutez de sa réalité',
        type: WizardType.illusionniste,
      ),
      AnswerOption(
        label: 'D. Agissez immédiatement',
        type: WizardType.guerrier,
      ),
    ],
  ),
  Question(
    text: '18. Quel familier choisiriez-vous ?',
    options: [
      AnswerOption(label: 'A. Un hibou', type: WizardType.erudit),
      AnswerOption(label: 'B. Un loup', type: WizardType.elementaliste),
      AnswerOption(label: 'C. Un renard', type: WizardType.illusionniste),
      AnswerOption(label: 'D. Un dragonnet', type: WizardType.guerrier),
    ],
  ),
  Question(
    text: '19. Quelle saison vous inspire le plus ?',
    options: [
      AnswerOption(label: 'A. L’automne (réflexion)', type: WizardType.erudit),
      AnswerOption(
        label: 'B. Le printemps (renouveau)',
        type: WizardType.elementaliste,
      ),
      AnswerOption(
        label: 'C. L’hiver (mystère)',
        type: WizardType.illusionniste,
      ),
      AnswerOption(label: 'D. L’été (énergie)', type: WizardType.guerrier),
    ],
  ),
  Question(
    text: '20. Décrivez votre magie en un mot…',
    options: [
      AnswerOption(label: 'A. « Savoir »', type: WizardType.erudit),
      AnswerOption(label: 'B. « Harmonie »', type: WizardType.elementaliste),
      AnswerOption(label: 'C. « Mystère »', type: WizardType.illusionniste),
      AnswerOption(label: 'D. « Puissance »', type: WizardType.guerrier),
    ],
  ),
];

/// Human-readable labels & descriptions per wizard type.
String wizardLabel(WizardType t) {
  switch (t) {
    case WizardType.erudit:
      return 'Érudit mystique';
    case WizardType.elementaliste:
      return 'Élémentaliste';
    case WizardType.illusionniste:
      return 'Tisseur d’illusions';
    case WizardType.guerrier:
      return 'Guerrier arcanique';
  }
}

String wizardEmoji(WizardType t) {
  switch (t) {
    case WizardType.erudit:
      return '📚✨';
    case WizardType.elementaliste:
      return '🌊🔥🌪️🌱';
    case WizardType.illusionniste:
      return '🎭🌫️';
    case WizardType.guerrier:
      return '⚔️⚡';
  }
}

String wizardDescription(WizardType t) {
  switch (t) {
    case WizardType.erudit:
      return 'Maîtrise des rituels, précision et savoir ancestral. Vous résolvez les mystères par la logique.';
    case WizardType.elementaliste:
      return 'Connexion profonde à la nature et aux éléments. Vous recherchez l’harmonie et la puissance brute.';
    case WizardType.illusionniste:
      return 'Créativité et ruse. Vous trompez les sens et façonnez la perception.';
    case WizardType.guerrier:
      return 'Courage et stratégie. Vous affrontez les dangers avec force et détermination.';
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Index of the current question [0..19]
  int _index = 0;

  // Selected option index per question (null if none)
  final List<int?> _selected = List<int?>.filled(kQuestions.length, null);

  // Score accumulator per wizard type
  final Map<WizardType, int> _scores = {for (var t in WizardType.values) t: 0};

  void _selectOption(int optionIdx) {
    setState(() {
      final q = kQuestions[_index];
      final prev = _selected[_index];

      // If previously answered, subtract previous contribution
      if (prev != null) {
        final prevType = q.options[prev].type;
        _scores[prevType] = (_scores[prevType] ?? 0) - 1;
      }

      // Add new contribution
      _selected[_index] = optionIdx;
      final t = q.options[optionIdx].type;
      _scores[t] = (_scores[t] ?? 0) + 1;
    });
  }

  void _next() {
    if (_index < kQuestions.length - 1) {
      setState(() => _index++);
    } else {
      // Finished: compute result
      final result = _computeResult();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (_) => ResultScreen(
                scores: Map.unmodifiable(_scores),
                primary: result.$1,
                secondary: result.$2,
                onRestart: _restart,
              ),
        ),
      );
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() => _index--);
    }
  }

  (WizardType, WizardType?) _computeResult() {
    // Sort types by score desc; on tie, preserve enum order deterministically
    final entries =
        _scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final primary = entries.first.key;

    // Determine secondary if close or tie
    WizardType? secondary;
    if (entries.length >= 2 && entries[1].value == entries.first.value) {
      secondary = entries[1].key;
    } else if (entries.length >= 2 &&
        (entries[0].value - entries[1].value) <= 2) {
      // Optional: show a "sub-dominant" style if within 2 points
      secondary = entries[1].key;
    }
    return (primary, secondary);
  }

  void _restart() {
    setState(() {
      _index = 0;
      for (var t in WizardType.values) {
        _scores[t] = 0;
      }
      for (var i = 0; i < _selected.length; i++) {
        _selected[i] = null;
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = kQuestions[_index];
    final selectedIdx = _selected[_index];
    final total = kQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quel sorcier es-tu ?'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Progress header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${_index + 1} / $total',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: (_index + 1) / total),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(q.text, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                for (int i = 0; i < q.options.length; i++)
                  _AnswerTile(
                    isSelected: selectedIdx == i,
                    label: q.options[i].label,
                    onTap: () => _selectOption(i),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _index > 0 ? _prev : null,
                  label: const Text('Précédent'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  icon: Icon(
                    _index == total - 1 ? Icons.check : Icons.chevron_right,
                  ),
                  onPressed: selectedIdx != null ? _next : null,
                  label: Text(
                    _index == total - 1 ? 'Voir le résultat' : 'Suivant',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onTap;
  const _AnswerTile({
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: isSelected ? 1.5 : 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                // Default color palette
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final Map<WizardType, int> scores;
  final WizardType primary;
  final WizardType? secondary;
  final VoidCallback onRestart;

  const ResultScreen({
    super.key,
    required this.scores,
    required this.primary,
    required this.secondary,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final sorted =
        scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(title: const Text('Résultat')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Tu es : ${wizardLabel(primary)} ${wizardEmoji(primary)}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(wizardDescription(primary)),
          if (secondary != null) ...[
            const SizedBox(height: 16),
            Text(
              'Style secondaire : ${wizardLabel(secondary!)} ${wizardEmoji(secondary!)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(wizardDescription(secondary!)),
          ],
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Scores détaillés',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final e in sorted)
            ListTile(
              title: Text(wizardLabel(e.key)),
              trailing: Text(e.value.toString()),
              leading: Text(wizardEmoji(e.key)),
            ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.restart_alt),
            onPressed: onRestart,
            label: const Text('Recommencer'),
          ),
        ],
      ),
    );
  }
}
