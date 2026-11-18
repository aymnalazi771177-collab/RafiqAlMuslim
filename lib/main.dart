
import 'package:flutter/material.dart';

const Color green = Color(0xFF073F35);
const Color darkGreen = Color(0xFF052F28);
const Color gold = Color(0xFFD5B16A);
const Color cream = Color(0xFFF8F4E9);

void main() {
  runApp(const RafiqApp());
}

class RafiqApp extends StatelessWidget {
  const RafiqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رفيق المسلم',
      theme: ThemeData(
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          primary: green,
          secondary: gold,
        ),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int page = 0;

  final List<Widget> pages = const [
    HomePage(),
    QuranPage(),
    TasbeehPage(),
    AzkarPage(),
    StoriesPage(),
    PrayerPage(),
    SettingsPage(),
  ];

  void openPage(int index) {
    setState(() => page = index);
  }

  int get navigationIndex {
    if (page == 1) return 1;
    if (page == 2 || page == 3) return 2;
    if (page == 6) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: page,
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: gold.withOpacity(0.25),
          selectedIndex: navigationIndex,
          onDestinationSelected: (index) {
            if (index == 0) openPage(0);
            if (index == 1) openPage(1);
            if (index == 2) openPage(3);
            if (index == 3) openPage(6);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'القرآن',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'الأذكار',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(int) onOpen;

  const HomePage({super.key, this.onOpen = _empty});

  static void _empty(int index) {}

  @override
  Widget build(BuildContext context) {
    final items = [
      ['القرآن الكريم', Icons.menu_book, 1],
      ['الأذكار اليومية', Icons.volunteer_activism, 3],
      ['المسبحة الإلكترونية', Icons.radio_button_checked, 2],
      ['قصص الأنبياء', Icons.auto_stories, 4],
      ['مواقيت الصلاة', Icons.access_time, 5],
      ['الإعدادات', Icons.settings, 6],
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [green, darkGreen],
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.mosque,
                  color: gold,
                  size: 55,
                ),
                const SizedBox(height: 12),
                const Text(
                  'رفيق المسلم',
                  style: TextStyle(
                    color: gold,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'رفيقك إلى الطمأنينة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'ألا بذكر الله تطمئن القلوب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'أقسام التطبيق',
            style: TextStyle(
              color: green,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onOpen(item[2] as int),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: gold.withOpacity(0.45),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item[1] as IconData,
                        color: green,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item[0] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'القرآن الكريم',
      icon: Icons.menu_book,
      child: Column(
        children: [
          const Text(
            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: green,
              fontSize: 23,
              height: 2,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ۝ '
            'الرَّحْمَٰنِ الرَّحِيمِ ۝ '
            'مَالِكِ يَوْمِ الدِّينِ ۝ '
            'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: green,
              fontSize: 21,
              height: 2.1,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'سورة الفاتحة',
            style: TextStyle(
              color: gold,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'هذه صفحة أولية للقرآن الكريم. '
            'سيتم استكمال المصحف كاملاً في مرحلة لاحقة.',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.8),
          ),
        ],
      ),
    );
  }
}

class TasbeehPage extends StatefulWidget {
  const TasbeehPage({super.key});

  @override
  State<TasbeehPage> createState() => _TasbeehPageState();
}

class _TasbeehPageState extends State<TasbeehPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'المسبحة الإلكترونية',
      icon: Icons.radio_button_checked,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'سبحان الله وبحمده',
            style: TextStyle(
              color: green,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: green,
              border: Border.all(color: gold, width: 5),
              boxShadow: [
                BoxShadow(
                  color: green.withOpacity(0.2),
                  blurRadius: 18,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$count',
                style: const TextStyle(
                  color: gold,
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
                vertical: 17,
              ),
            ),
            onPressed: () {
              setState(() => count++);
            },
            child: const Text('تسبيح'),
          ),
          TextButton(
            onPressed: () => setState(() => count = 0),
            child: const Text(
              'تصفير العداد',
              style: TextStyle(color: green),
            ),
          ),
        ],
      ),
    );
  }
}

class AzkarPage extends StatefulWidget {
  const AzkarPage({super.key});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  String selected = 'أذكار الصباح';

  final Map<String, List<Map<String, dynamic>>> azkar = {
    'أذكار الصباح': [
      {
        'text': 'أصبحنا وأصبح الملك لله، والحمد لله.',
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
        'text': 'أمسينا وأمسى الملك لله، والحمد لله.',
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

  final Map<String, int> counters = {};

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
                Icon(
                  Icons.volunteer_activism,
                  color: gold,
                  size: 42,
                ),
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
          const SizedBox(height: 15),
          Wrap(
            spacing: 7,
            children: azkar.keys.map((name) {
              return ChoiceChip(
                label: Text(name),
                selected: selected == name,
                selectedColor: gold.withOpacity(0.35),
                onSelected: (_) {
                  setState(() => selected = name);
                },
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final target = item['times'] as int;
                final key = '$selected-$index';
                final count = counters[key] ?? 0;

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
                          item['text'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: green,
                            fontSize: 18,
                            height: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          count >= target
                              ? 'اكتمل الذكر'
                              : 'التكرار: $count من $target',
                          style: const TextStyle(
                            color: Colors.black54,
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
                          onPressed: count >= target
                              ? null
                              : () {
                                  setState(() {
                                    counters[key] = count + 1;
                                  });
                                },
                          child: const Text('اضغط للتسبيح'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => counters[key] = 0);
                          },
                          child: const Text(
                            'إعادة العداد',
                            style: TextStyle(color: green),
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

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = [
      'قصة آدم عليه السلام',
      'قصة نوح عليه السلام',
      'قصة إبراهيم عليه السلام',
      'قصة يوسف عليه السلام',
      'قصة موسى عليه السلام',
      'قصة عيسى عليه السلام',
      'سيرة النبي محمد ﷺ',
    ];

    return SimplePage(
      title: 'قصص الأنبياء',
      icon: Icons.auto_stories,
      child: Column(
        children: stories.map((story) {
          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.menu_book,
                color: gold,
              ),
              title: Text(
                story,
                style: const TextStyle(
                  color: green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: green,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('سيتم إضافة القصة في تحديث قادم'),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prayers = [
      ['الفجر', '--:--'],
      ['الشروق', '--:--'],
      ['الظهر', '--:--'],
      ['العصر', '--:--'],
      ['المغرب', '--:--'],
      ['العشاء', '--:--'],
    ];

    return SimplePage(
      title: 'مواقيت الصلاة',
      icon: Icons.access_time,
      child: Column(
        children: [
          const Text(
            'مواقيت الصلاة',
            style: TextStyle(
              color: green,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'سيتم ربط المواقيت بموقعك وطريقة الحساب لاحقاً',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...prayers.map((prayer) {
            return Card(
              child: ListTile(
                leading: const Icon(
                  Icons.mosque,
                  color: gold,
                ),
                title: Text(
                  prayer[0],
                  style: const TextStyle(
                    color: green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  prayer[1],
                  style: const TextStyle(
                    color: green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'الإعدادات',
      icon: Icons.settings,
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.info_outline, color: gold),
            title: Text('عن تطبيق رفيق المسلم'),
            subtitle: Text('رفيقك إلى الطمأنينة'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.palette_outlined, color: gold),
            title: Text('المظهر'),
            subtitle: Text('الأخضر والذهبي'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.favorite_outline, color: gold),
            title: Text('نسأل الله أن ينفع بهذا التطبيق'),
          ),
        ],
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SimplePage({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: green,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Icon(icon, color: gold, size: 38),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: gold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [child],
            ),
          ),
        ],
      ),
    );
  }
}
