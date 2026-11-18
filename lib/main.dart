
class AzkarPage extends StatefulWidget {
  const AzkarPage({super.key});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  String selected = 'أذكار الصباح';
  int count = 0;

  final Map<String, List<Map<String, dynamic>>> azkar = {
    'أذكار الصباح': [
      {
        'text': 'أصبحنا وأصبح الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له.',
        'times': 1,
      },
      {
        'text': 'رضيت بالله رباً، وبالإسلام ديناً، وبمحمد ﷺ نبياً.',
        'times': 3,
      },
      {
        'text': 'سبحان الله وبحمده.',
        'times': 100,
      },
      {
        'text': 'اللهم إني أسألك العفو والعافية في الدنيا والآخرة.',
        'times': 1,
      },
    ],
    'أذكار المساء': [
      {
        'text': 'أمسينا وأمسى الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له.',
        'times': 1,
      },
      {
        'text': 'رضيت بالله رباً، وبالإسلام ديناً، وبمحمد ﷺ نبياً.',
        'times': 3,
      },
      {
        'text': 'سبحان الله وبحمده.',
        'times': 100,
      },
      {
        'text': 'اللهم إني أسألك العفو والعافية في الدنيا والآخرة.',
        'times': 1,
      },
    ],
    'بعد الصلاة': [
      {
        'text': 'أستغفر الله.',
        'times': 3,
      },
      {
        'text': 'اللهم أنت السلام ومنك السلام، تباركت يا ذا الجلال والإكرام.',
        'times': 1,
      },
      {
        'text': 'سبحان الله.',
        'times': 33,
      },
      {
        'text': 'الحمد لله.',
        'times': 33,
      },
      {
        'text': 'الله أكبر.',
        'times': 33,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final items = azkar[selected]!;

    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: green,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.volunteer_activism,
                    color: gold, size: 42),
                SizedBox(height: 12),
                Text(
                  'الأذكار اليومية',
                  style: TextStyle(
                    color: gold,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'اجعل لسانك رطباً بذكر الله',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: azkar.keys.map((name) {
                return ChoiceChip(
                  label: Text(name),
                  selected: selected == name,
                  selectedColor: gold.withOpacity(0.35),
                  onSelected: (_) {
                    setState(() {
                      selected = name;
                      count = 0;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final target = item['times'] as int;

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: gold.withOpacity(0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Text(
                          item['text'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: green,
                            fontSize: 18,
                            height: 2,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'عدد التكرار المطلوب: $target',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 13,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              count++;
                              if (count >= target) count = 0;
                            });
                          },
                          child: Text(
                            'اضغط للتسبيح  ($count / $target)',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
