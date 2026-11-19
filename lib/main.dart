
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: MainScreen(),
      ),
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

  void openPage(int index) {
    setState(() => page = index);
  }

  int get navIndex {
    if (page == 1) return 1;
    if (page == 2 || page == 3 || page == 4 || page == 5) {
      return 2;
    }
    if (page == 6) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onOpen: openPage),
      const QuranPage(),
      const TasbeehPage(),
      const AzkarPage(),
      const StoriesPage(),
      const PrayerPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: page,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navIndex,
        backgroundColor: Colors.white,
        indicatorColor: gold.withOpacity(0.22),
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
    );
  }
}

// الصفحة الرئيسية

class HomeItem {
  final String title;
  final IconData icon;
  final int page;

  const HomeItem(this.title, this.icon, this.page);
}

class HomePage extends StatelessWidget {
  final Function(int) onOpen;

  const HomePage({super.key, required this.onOpen});

  static const items = [
    HomeItem('القرآن الكريم', Icons.menu_book, 1),
    HomeItem('الأذكار اليومية', Icons.volunteer_activism, 3),
    HomeItem('المسبحة الإلكترونية', Icons.radio_button_checked, 2),
    HomeItem('قصص الأنبياء', Icons.auto_stories, 4),
    HomeItem('مواقيت الصلاة', Icons.access_time, 5),
    HomeItem('الإعدادات', Icons.settings, 6),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [green, darkGreen],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(27),
              border: Border.all(color: gold, width: 1.2),
            ),
            child: Column(
              children: [
                const Icon(Icons.mosque, color: gold, size: 55),
                const SizedBox(height: 12),
                const Text(
                  'رفيق المسلم',
                  style: TextStyle(
                    color: gold,
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'رفيقك إلى الطمأنينة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: const Text(
                    'ألا بذكر الله تطمئن القلوب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      height: 1.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'أقسام التطبيق',
            style: TextStyle(
              color: green,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
              childAspectRatio: 1.12,
            ),
            itemBuilder: (context, index) {
              final item = items[index];

              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onOpen(item.page),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: gold.withOpacity(0.65),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: green.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: green, size: 39),
                      const SizedBox(height: 13),
                      Text(
                        item.title,
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

// رأس موحد للصفحات

class PageHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const PageHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 23),
      decoration: const BoxDecoration(
        color: green,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(27),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: gold, size: 39),
          const SizedBox(height: 9),
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
    );
  }
}

// القرآن الكريم

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  late final Future<List<dynamic>> _surahsFuture;

  @override
  void initState() {
    super.initState();
    _surahsFuture = _loadSurahs();
  }

  Future<List<dynamic>> _loadSurahs() async {
    final raw = await rootBundle.loadString('assets/quran-uthmani.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return data['surahs'] as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const PageHeader(title: 'القرآن الكريم', icon: Icons.menu_book),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Text(
              'اختر السورة لقراءة آياتها بالترتيب',
              style: TextStyle(color: green, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _surahsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator(color: green));
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('تعذر تحميل المصحف. يرجى إعادة تشغيل التطبيق.'));
                }
                final surahs = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: surahs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == surahs.length) {
                      return const Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          'النص القرآني: مشروع تنزيل – الرسم العثماني، الإصدار 1.1\nTanzil.net • CC BY 3.0',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54, fontSize: 11),
                        ),
                      );
                    }
                    final surah = Map<String, dynamic>.from(surahs[index] as Map);
                    final name = surah['name'] as String;
                    final count = (surah['ayahs'] as List).where((a) => (a['number'] as int) > 0).length;
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: green,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: gold, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          'سورة $name',
                          style: const TextStyle(color: green, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('$count آية  •  ${surah['loc'] ?? ''}'),
                        trailing: const Icon(Icons.menu_book, color: gold),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => QuranReaderPage(surah: surah)),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QuranReaderPage extends StatelessWidget {
  final Map<String, dynamic> surah;

  const QuranReaderPage({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final name = surah['name'] as String;
    final ayahs = surah['ayahs'] as List<dynamic>;

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: Text('سورة $name'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 30),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Text(name, style: const TextStyle(color: gold, fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 7),
                Text(
                  '${surah['loc'] ?? ''}  •  ${ayahs.where((a) => (a['number'] as int) > 0).length} آية',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...ayahs.map((item) {
            final ayah = Map<String, dynamic>.from(item as Map);
            final number = ayah['number'] as int;
            final text = ayah['text'] as String;

            if (number == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: green, fontSize: 25, height: 2, fontWeight: FontWeight.w600),
                ),
              );
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: gold.withOpacity(0.35)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    margin: const EdgeInsetsDirectional.only(start: 10, top: 4),
                    decoration: const BoxDecoration(color: green, shape: BoxShape.circle),
                    child: Text(
                      '$number',
                      style: const TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.justify,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(color: Color(0xFF18251F), fontSize: 24, height: 2.05),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// المسبحة الإلكترونية=page);
        },
      ),
    );
  }
}

// المسبحة الإلكترونية

class TasbeehPage extends StatefulWidget {
  const TasbeehPage({super.key});

  @override
  State<TasbeehPage> createState() => _TasbeehPageState();
}

class _TasbeehPageState extends State<TasbeehPage> {
  int count = 0;
  String zekr = 'سبحان الله وبحمده';

  final List<String> choices = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا إله إلا الله',
    'سبحان الله وبحمده',
    'أستغفر الله',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const PageHeader(
            title: 'المسبحة الإلكترونية',
            icon: Icons.radio_button_checked,
          ),
          const Spacer(),
          const Text(
            'الذكر الحالي',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: zekr,
            items: choices.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  zekr = value;
                  count = 0;
                });
              }
            },
          ),
          const SizedBox(height: 25),
          Container(
            width: 205,
            height: 205,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: green,
              border: Border.all(color: gold, width: 6),
              boxShadow: [
                BoxShadow(
                  color: green.withOpacity(0.16),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$count',
                style: const TextStyle(
                  color: gold,
                  fontSize: 65,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 55,
                vertical: 17,
              ),
            ),
            onPressed: () => setState(() => count++),
            child: const Text('تسبيح'),
          ),
          TextButton(
            onPressed: () => setState(() => count = 0),
            child: const Text(
              'إعادة العداد',
              style: TextStyle(color: green),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// الأذكار اليومية

class AzkarPage extends StatefulWidget {
  const AzkarPage({super.key});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  String selected = 'أذكار الصباح';
  final Map<String, int> counters = {};

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
      {'text': 'أستغفر الله.', 'times': 3},
      {
        'text': 'اللهم أنت السلام ومنك السلام، تباركت يا ذا الجلال والإكرام.',
        'times': 1,
      },
      {'text': 'سبحان الله.', 'times': 33},
      {'text': 'الحمد لله.', 'times': 33},
      {'text': 'الله أكبر.', 'times': 33},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final items = azkar[selected]!;

    return SafeArea(
      child: Column(
        children: [
          const PageHeader(
            title: 'الأذكار اليومية',
            icon: Icons.volunteer_activism,
          ),
          const SizedBox(height: 14),
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
              padding: const EdgeInsets.all(15),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final target = item['times'] as int;
                final key = '$selected-$index';
                final count = counters[key] ?? 0;

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 13),
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
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
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

// قصص الأنبياء

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  static const stories = [
    'آدم عليه السلام',
    'نوح عليه السلام',
    'إبراهيم عليه السلام',
    'يوسف عليه السلام',
    'موسى عليه السلام',
    'عيسى عليه السلام',
    'محمد ﷺ',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const PageHeader(
            title: 'قصص الأنبياء',
            icon: Icons.auto_stories,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(
                      Icons.menu_book,
                      color: gold,
                    ),
                    title: Text(
                      'قصة ${stories[index]}',
                      style: const TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: green,
                      size: 16,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('قصة ${stories[index]}'),
                          content: const Text(
                            'سيتم إضافة القصة كاملة '
                            'مع مراجعة محتواها في تحديث المحتوى.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('إغلاق'),
                            ),
                          ],
                        ),
                      );
                    },
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

// مواقيت الصلاة

class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});

  static const prayers = [
    'الفجر',
    'الشروق',
    'الظهر',
    'العصر',
    'المغرب',
    'العشاء',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const PageHeader(
            title: 'مواقيت الصلاة',
            icon: Icons.access_time,
          ),
          const SizedBox(height: 20),
          const Icon(Icons.location_on, color: gold, size: 35),
          const Text(
            'مواقيت الصلاة حسب موقعك',
            style: TextStyle(
              color: green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'سيتم تفعيل تحديد الموقع وحساب المواقيت '
              'في مرحلة ربط خدمة الصلاة.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.8),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: prayers.map((name) {
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.mosque, color: gold),
                    title: Text(
                      name,
                      style: const TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Text(
                      '--:--',
                      style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// الإعدادات

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool vibration = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const PageHeader(
            title: 'الإعدادات',
            icon: Icons.settings,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: Colors.white,
                  child: SwitchListTile(
                    secondary: const Icon(
                      Icons.notifications_outlined,
                      color: gold,
                    ),
                    title: const Text('التنبيهات'),
                    value: notifications,
                    activeColor: green,
                    onChanged: (value) {
                      setState(() => notifications = value);
                    },
                  ),
                ),
                Card(
                  color: Colors.white,
                  child: SwitchListTile(
                    secondary: const Icon(
                      Icons.vibration,
                      color: gold,
                    ),
                    title: const Text('الاهتزاز'),
                    value: vibration,
                    activeColor: green,
                    onChanged: (value) {
                      setState(() => vibration = value);
                    },
                  ),
                ),
                const Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.info_outline, color: gold),
                    title: Text('عن التطبيق'),
                    subtitle: Text('رفيق المسلم - رفيقك إلى الطمأنينة'),
                  ),
                ),
                const Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.favorite, color: gold),
                    title: Text('نسأل الله أن ينفع بهذا العمل'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
