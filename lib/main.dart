
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan_dart/adhan_dart.dart';

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
  String? _lastSurahName;
  int? _lastSurahNumber;

  @override
  void initState() {
    super.initState();
    _surahsFuture = _loadSurahs();
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _lastSurahName = prefs.getString('last_surah_name');
      _lastSurahNumber = prefs.getInt('last_surah_number');
    });
  }

  Future<void> _saveLastRead(String name, int number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_surah_name', name);
    await prefs.setInt('last_surah_number', number);
    if (!mounted) return;
    setState(() {
      _lastSurahName = name;
      _lastSurahNumber = number;
    });
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
            padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Text(
              'اختر السورة لقراءة آياتها بالترتيب',
              style: TextStyle(color: green, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          if (_lastSurahName != null && _lastSurahNumber != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Card(
                color: const Color(0xFFEDE2CE),
                child: ListTile(
                  leading: const Icon(Icons.history, color: green),
                  title: const Text('متابعة آخر قراءة', style: TextStyle(color: green, fontWeight: FontWeight.bold)),
                  subtitle: Text('سورة $_lastSurahName'),
                  trailing: const Icon(Icons.arrow_forward_ios, color: green, size: 16),
                  onTap: () async {
                    final data = await _surahsFuture;
                    final index = _lastSurahNumber! - 1;
                    if (index < 0 || index >= data.length || !context.mounted) return;
                    final saved = Map<String, dynamic>.from(data[index] as Map);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => QuranReaderPage(surah: saved, surahNumber: _lastSurahNumber!, startPage: 1)),
                    );
                  },
                ),
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
                          _saveLastRead(name, index + 1);
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => QuranReaderPage(surah: surah, surahNumber: index + 1, startPage: 1)),
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
  final int surahNumber;
  final int startPage;

  const QuranReaderPage({
    super.key,
    required this.surah,
    required this.surahNumber,
    required this.startPage,
  });

  String _arabicNumber(int value) {
    const digits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    return value.toString().split('').map((d) => digits[int.parse(d)]).join();
  }

  @override
  Widget build(BuildContext context) {
    final name = surah['name'] as String? ?? '';
    final ayahs = (surah['ayahs'] as List?) ?? const [];

    final spans = <InlineSpan>[];
    for (final item in ayahs) {
      final ayah = Map<String, dynamic>.from(item as Map);
      final text = (ayah['text'] ?? ayah['text_uthmani'] ?? ayah['content'] ?? '').toString();
      final number = (ayah['number'] as num?)?.toInt() ?? 0;
      if (text.isEmpty) continue;
      spans.add(TextSpan(text: '$text '));
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF1E5CE),
              border: Border.all(color: gold, width: 1.2),
            ),
            child: Text(
              _arabicNumber(number),
              style: const TextStyle(
                color: green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
      spans.add(const TextSpan(text: '  '));
    }

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: gold,
        title: Text('سورة $name'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0E5),
              border: Border.all(color: green, width: 5),
              boxShadow: [
                BoxShadow(
                  color: green.withOpacity(0.12),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 18, 15, 24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFCF4),
                border: Border.all(color: gold, width: 1.3),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE2CE),
                      border: Border.all(color: gold, width: 2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.local_florist, color: Color(0xFF9A7440), size: 27),
                        Expanded(
                          child: Text(
                            'سُورَةُ $name',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF352719),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.local_florist, color: Color(0xFF9A7440), size: 27),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (surahNumber != 1 && surahNumber != 9)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 18),
                      child: Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF211B15),
                          fontSize: 22,
                          height: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SelectableText.rich(
                    TextSpan(
                      style: const TextStyle(
                        color: Color(0xFF211B15),
                        fontSize: 23,
                        height: 2.15,
                        fontWeight: FontWeight.w500,
                      ),
                      children: spans,
                    ),
                    textAlign: TextAlign.justify,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 22),
                  const Icon(Icons.auto_awesome, color: Color(0xFF9A7440), size: 20),
                ],
              ),
            ),
          ),
        ),
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
  bool ready = false;
  final List<String> choices = const ['سبحان الله','الحمد لله','الله أكبر','لا إله إلا الله','سبحان الله وبحمده','أستغفر الله','لا حول ولا قوة إلا بالله','اللهم صل وسلم على نبينا محمد'];
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() { count = prefs.getInt('tasbeeh_count') ?? 0; zekr = prefs.getString('tasbeeh_zekr') ?? zekr; if (!choices.contains(zekr)) zekr = choices.first; ready = true; });
  }
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbeeh_count', count);
    await prefs.setString('tasbeeh_zekr', zekr);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [
      const PageHeader(title: 'المسبحة الإلكترونية', icon: Icons.radio_button_checked),
      const Spacer(),
      const Text('الذكر الحالي', style: TextStyle(color: Colors.black54, fontSize: 16)),
      const SizedBox(height: 8),
      DropdownButton<String>(value: zekr, items: choices.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
        onChanged: (v) { if (v == null) return; setState(() { zekr = v; count = 0; }); _save(); }),
      const SizedBox(height: 22),
      Container(width: 205, height: 205, decoration: BoxDecoration(shape: BoxShape.circle, color: green, border: Border.all(color: gold, width: 6),
        boxShadow: [BoxShadow(color: green.withOpacity(0.16), blurRadius: 20, spreadRadius: 4)]),
        child: Center(child: ready ? Text('$count', style: const TextStyle(color: gold, fontSize: 65, fontWeight: FontWeight.bold)) : const CircularProgressIndicator(color: gold))),
      const SizedBox(height: 18),
      Text(zekr, textAlign: TextAlign.center, style: const TextStyle(color: green, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 17)),
        onPressed: ready ? () { setState(() => count++); _save(); } : null, child: const Text('تسبيح')),
      TextButton(onPressed: ready ? () { setState(() => count = 0); _save(); } : null, child: const Text('إعادة العداد', style: TextStyle(color: green))),
      const Spacer(),
    ]));
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
  @override
  void initState() { super.initState(); _loadCounters(); }

  Future<void> _loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('azkar_counters');
    if (raw == null || !mounted) return;
    try {
      final saved = jsonDecode(raw) as Map<String, dynamic>;
      setState(() { for (final entry in saved.entries) { counters[entry.key] = (entry.value as num).toInt(); } });
    } catch (_) {}
  }

  Future<void> _saveCounters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('azkar_counters', jsonEncode(counters));
  }


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
    'أذكار عامة': [
      {'text': 'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.', 'times': 10},
      {'text': 'سبحان الله وبحمده، سبحان الله العظيم.', 'times': 100},
      {'text': 'أستغفر الله وأتوب إليه.', 'times': 100},
      {'text': 'اللهم صل وسلم على نبينا محمد.', 'times': 10},
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
                                    _saveCounters();
                                  });
                                },
                          child: const Text('اضغط للتسبيح'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => counters[key] = 0);
                            _saveCounters();
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
  static const List<Map<String, String>> stories = [
    {'name':'آدم عليه السلام','text':'خلق الله آدم من تراب ثم سوّاه ونفخ فيه من روحه، وعلّمه الأسماء كلها، وأمر الملائكة بالسجود له سجود تكريم، فسجدوا إلا إبليس أبى واستكبر وكان من الكافرين. وأسكن الله آدم وزوجه الجنة، وأباح لهما نعيمها ونهاهما عن شجرة معينة، وحذّرهما من الشيطان. فوسوس لهما الشيطان حتى أكلا منها، فبدت لهما سوآتهما، وأخذا يخصفان عليهما من ورق الجنة. ثم تلقّى آدم من ربه كلمات فتاب عليه؛ فالله تواب رحيم. وأُهبط آدم وزوجه إلى الأرض، وأخبرهما الله أن من اتبع هداه فلا خوف عليه ولا يحزن، ومن أعرض عن ذكره فله معيشة ضنكًا. وتعلّم البشر من قصة أبيهم أن عداوة الشيطان قديمة، وأن باب التوبة مفتوح لمن رجع إلى الله. والقرآن لا يذكر تفاصيل زمن آدم وأعمار ذريته أو موضع نزوله، فلا نجزم بما لم يرد به دليل صحيح.','ref':'البقرة: 30–39، طه: 115–123'},
    {'name':'إدريس عليه السلام','text':'أثنى الله على إدريس عليه السلام في كتابه، فقال إنه كان صديقًا نبيًا، وذكر أنه رفعه مكانًا عليًا. وجاء ذكره مع إسماعيل وذي الكفل في سياق الثناء على الصبر والصلاح، كما ورد ذكره ضمن الأنبياء الذين أنعم الله عليهم وهداهم إلى صراط مستقيم. وهذه هي المعلومات الثابتة الصريحة في القرآن عن قصته؛ فلم يسرد القرآن قومه أو تفاصيل دعوته أو أحداث حياته، ولذلك لا يصح أن نملأ الفراغ بحكايات لا تثبت. نتعلم من ذكره صدق النبوة وعلو المنزلة عند الله، وأن العبرة ليست بكثرة الأخبار عن الإنسان، بل بإيمانه وصدقه وصلاحه.','ref':'مريم: 56–57، الأنبياء: 85'},
    {'name':'نوح عليه السلام','text':'أرسل الله نوحًا إلى قومه حين عبدوا غير الله، فدعاهم إلى عبادة الله وحده، وأنذرهم عذاب يوم عظيم. دعاهم ليلًا ونهارًا، وأعلن دعوته وجهر بها وأسرّ بها، وذكّرهم بأن الاستغفار سبب للمغفرة ونزول البركات والأموال والبنين. لكن الملأ استكبروا، وسدّوا آذانهم، وأصروا على عبادة أصنامهم، ولم يؤمن معه إلا قليل. وأوحى الله إليه أنه لن يؤمن من قومه إلا من قد آمن، وأمره بصنع الفلك بأعين الله ووحيه. وكان قومه يسخرون منه كلما مروا به، فكان يجيبهم أن السخرية ستظهر عاقبتها. حتى جاء أمر الله وفار التنور، فحمل في السفينة من كل زوجين اثنين وأهله ومن آمن، إلا من سبق عليه القول. ونادى نوح ابنه ليركب معهم، فرفض واعتصم بجبل، فأخبره أبوه أن لا عاصم اليوم من أمر الله، فحال الموج بينهما. ونجّى الله نوحًا ومن معه، وأغرق المكذبين، ثم استوت السفينة على الجودي. ودعا نوح ربه بشأن ابنه، فعلّمه الله أن رابطة الإيمان هي الميزان، فاستغفر وأناب. وكانت دعوته ألف سنة إلا خمسين عامًا، ثم جعل الله ذريته هم الباقين وترك عليه ثناءً في العالمين.','ref':'هود: 25–49، نوح: 1–28'},
    {'name':'هود عليه السلام','text':'أرسل الله هودًا إلى عاد، وكانوا قومًا ذوي قوة وبطش وعمران، لكنهم اغتروا بقوتهم وقالوا من أشد منا قوة، وعبدوا الأصنام. دعاهم هود إلى عبادة الله وحده، وذكّرهم أن الله هو الذي خلقهم وزادهم في الخلق بسطة، ونهاهم عن الطغيان والفساد. وقال لهم إنه لا يسألهم أجرًا، وإن أجره على الذي فطره. قابلوا دعوته بالتكذيب والسخرية وطلبوا منه أن يأتيهم بالعذاب، فذكّرهم أن العلم بوقت العذاب عند الله. واستمروا على عنادهم، فأرسل الله عليهم ريحًا صرصرًا عاتية في أيام نحسات، تدمر كل شيء بأمر ربها، حتى صاروا كأعجاز نخل خاوية. ونجّى الله هودًا والذين آمنوا معه برحمة منه، وأصبح مصير عاد عبرة لمن يغتر بالقوة ويعرض عن الحق. ولا يحدد القرآن موقع مساكنهم تحديدًا جازمًا، وإنما يذكر عادًا والأحقاف.','ref':'الأعراف: 65–72، الحاقة: 6–8'},
    {'name':'صالح عليه السلام','text':'أرسل الله صالحًا إلى ثمود، وكانوا يسكنون الحجر وينحتون من الجبال بيوتًا آمنين، لكنهم عبدوا غير الله. دعاهم صالح إلى التوحيد، وذكّرهم بنعم الله عليهم، وأنشأهم من الأرض واستعمرهم فيها، ونهاهم عن الإفساد. طلبوا آية، فجعل الله لهم الناقة آية مبصرة، وأمرهم أن يتركوها تأكل في أرض الله وألا يمسوها بسوء. وجعل للماء قسمة معلومة بينهم وبين الناقة. لكن جماعة من أشقيائهم تآمروا على قتلها فعقروها، وتحدوا صالحًا أن يأتيهم بما يعدهم إن كان من المرسلين. فأخبرهم أن يتمتعوا في دارهم ثلاثة أيام، وكان ذلك وعدًا غير مكذوب. ثم أخذتهم الرجفة والصيحة فأصبحوا في ديارهم جاثمين، ونجّى الله صالحًا والذين آمنوا معه. ومرّ النبي ﷺ بالحجر فنهى عن دخول ديار المعذبين إلا مع الاعتبار والخشوع. وفي القصة تحذير من جحود النعم، ومن الاعتداء على آيات الله بعد وضوحها.','ref':'الأعراف: 73–79، الشمس: 11–15'},
    {'name':'إبراهيم عليه السلام','text':'نشأ إبراهيم بين قوم يعبدون الأصنام، فأنكر عليهم عبادتها وسألهم عن سمعها وبصرها ونفعها، وبيّن لأبيه وقومه أن العبادة لا تكون إلا للخالق. ونظر في ملكوت السماوات والأرض فازداد يقينًا، وأعلن براءته من الشرك. ولما خرج قومه إلى عيدهم، حطّم أصنامهم وترك كبيرها ليقيم عليهم الحجة، فلما رجعوا سألوه، فألزمهم أن يسألوا أصنامهم إن كانت تنطق. فعرفوا عجزها، لكنهم بدل أن يؤمنوا قرروا إحراقه، فجعل الله النار بردًا وسلامًا عليه. وهاجر إبراهيم في سبيل الله، ورزقه الله إسماعيل وإسحاق على الكبر، وبشّره بالذرية الصالحة. وابتلاه الله بأوامر عظيمة فوفّى، ومنها الرؤيا التي رأى فيها أنه يذبح ابنه، فلما أسلما وتله للجبين فداه الله بذبح عظيم. ورفع إبراهيم مع إسماعيل قواعد البيت، ودعوا الله أن يتقبل منهما، وأن يبعث في ذريتهما رسولًا يعلمهم الكتاب والحكمة. وجعل الله إبراهيم إمامًا للناس، واتخذه خليلًا، وأمر النبي محمدًا ﷺ باتباع ملته الحنيفية.','ref':'الأنبياء: 51–70، البقرة: 124–129'},
    {'name':'لوط عليه السلام','text':'أرسل الله لوطًا إلى قوم اشتهروا بإتيان الفاحشة وقطع السبيل وإتيان المنكر في مجالسهم. دعاهم لوط إلى تقوى الله وترك الفاحشة، وبيّن لهم أن ما يفعلونه تجاوز لحدود الله. لكنهم استهزؤوا به وهددوه بالإخراج من قريتهم، وأصروا على المنكر. وجاءت الملائكة إلى إبراهيم مبشرين ومخبرين بشأن قوم لوط، ثم وصلوا إلى لوط في صورة ضيوف، فساءه أمرهم وضاق بهم ذرعًا لما خاف من اعتداء قومه عليهم. وأسرع قومه إليه يريدون ضيوفه، فنصحهم لوط وذكّرهم بالحلال، لكنهم لم يستجيبوا. عرّفته الملائكة أنهم رسل ربه، وأمروه أن يسري بأهله بقطع من الليل وألا يلتفت أحد، إلا امرأته فقد كان مصيرها مع القوم. فلما جاء أمر الله جعل عالي القرية سافلها وأمطر عليها حجارة من سجيل، فكان في ذلك آية للمعتبرين. ويؤكد القرآن أن النجاة كانت للوّط وأهله المؤمنين، وأن القرابة لا تنفع مع الكفر.','ref':'الأعراف: 80–84، هود: 77–83'},
    {'name':'إسماعيل عليه السلام','text':'إسماعيل ابن إبراهيم عليهما السلام، وقد ذكر القرآن صبره وصدقه ووفاءه بوعده، وأنه كان رسولًا نبيًا يأمر أهله بالصلاة والزكاة وكان عند ربه مرضيًا. وتظهر طاعته في قصة الابتلاء حين أخبره أبوه إبراهيم أنه يرى في المنام أنه يذبحه، فقال: يا أبت افعل ما تؤمر، ستجدني إن شاء الله من الصابرين. فلما أسلما وتله للجبين ناداه الله أن قد صدقت الرؤيا، وفداه بذبح عظيم، وأثنى عليهما بالإحسان. وشارك إسماعيل أباه في رفع قواعد الكعبة، وكانا يدعوان الله أن يتقبل منهما وأن يجعلهما مسلمين له ومن ذريتهما أمة مسلمة. ودعا إبراهيم أن يبعث في أهل مكة رسولًا منهم، فكانت بعثة محمد ﷺ من ذرية إسماعيل. ولا يذكر القرآن تفاصيل كل مراحل حياة إسماعيل، لكنه يبرز توحيده وصبره ووفاءه ومشاركته في بناء البيت الحرام.','ref':'مريم: 54–55، البقرة: 125–129، الصافات: 102–107'},
    {'name':'إسحاق عليه السلام','text':'بشّرت الملائكة إبراهيم وزوجه بإسحاق، وكانت امرأته عجوزًا عاقرًا فتعجبت من البشارة، فأخبرتها الملائكة أن ذلك أمر الله ورحمته وبركاته. وجعل الله إسحاق نبيًا من الصالحين، وبارك عليه وعلى يعقوب، وجعل في ذريتهما النبوة والكتاب. وذكره القرآن مع أنبياء الله الذين هداهم واجتباهم، وأمر نبيه محمدًا ﷺ أن يتذكر عباده إبراهيم وإسحاق ويعقوب أولي الأيدي والأبصار. ولم يفصل القرآن دعوة إسحاق أو أحداث حياته كما فصل قصة يوسف أو موسى، لذلك نقتصر على الثابت: أنه ابن إبراهيم، وأبو يعقوب، ونبي مبارك من عباد الله الصالحين.','ref':'هود: 71–73، الصافات: 112–113، الأنعام: 84'},
    {'name':'يعقوب عليه السلام','text':'يعقوب هو إسرائيل، ابن إسحاق وحفيد إبراهيم عليهم السلام، وقد كان نبيًا موحدًا يوصي أبناءه بعبادة الله وحده. وتظهر وصيته عند حضور الموت حين سأل أبناءه: ما تعبدون من بعدي؟ فأعلنوا أنهم يعبدون إلهه وإله آبائه إبراهيم وإسماعيل وإسحاق إلهًا واحدًا. وابتلي يعقوب بفقد ابنه يوسف بعد أن جاءه أبناؤه بقميصه وعليه دم كذب، فعلم أن الأمر مكيدة، وقال فصبر جميل. ثم اشتد حزنه حتى ابيضت عيناه من الحزن وهو كظيم، لكنه لم ييأس من رحمة الله، وأمر أبناءه أن يتحسسوا من يوسف وأخيه وألا ييأسوا من روح الله. ولما جاءه البشير بقميص يوسف ألقاه على وجهه فارتد بصيرًا، ثم اجتمع بيوسف وأهله في مصر، ورفع أبويه على العرش وخروا له سجدًا سجود تحية في شريعتهم، وتحققت رؤيا يوسف. فكان يعقوب مثالًا للصبر الجميل وحسن الظن بالله.','ref':'يوسف: 83–101'},
    {'name':'يوسف عليه السلام','text':'رأى يوسف وهو صغير أحد عشر كوكبًا والشمس والقمر له ساجدين، فطلب منه أبوه يعقوب ألا يقص رؤياه على إخوته خشية حسدهم. فحسده إخوته وألقوه في غيابة الجب، ثم جاءوا أباهم بقميص عليه دم كذب. مرّت سيارة فأرسلوا واردهم فأدلى دلوه، فوجد يوسف وباعوه بثمن بخس في مصر. اشتراه عزيز مصر وأوصى بإكرام مثواه، ونشأ يوسف في بيت العزيز. راودته امرأة العزيز عن نفسه فاستعصم بالله، وشهد شاهد من أهلها بقرينة القميص، ثم شاع الخبر وقطّعت النسوة أيديهن حين رأينه، فاختار يوسف السجن على المعصية. دخل السجن ودعا صاحبيه إلى توحيد الله، وفسّر رؤياهما. ثم رأى الملك رؤيا البقرات والسنبلات، فعجز الملأ عن تفسيرها، ففسرها يوسف وبيّن خطة تدبير سنوات الخصب والجدب. طلب التحقيق في أمر النسوة قبل خروجه، فظهرت براءته، وجعله الملك على خزائن الأرض. وجاء إخوته يطلبون الميرة، فعرفهم ولم يعرفوه، ودبّر أن يبقي أخاه عنده بحكمة، ثم كشف لهم عن نفسه وعفا عنهم. أرسل قميصه إلى أبيه فعاد إليه بصره، وجاءت الأسرة إلى مصر، ورفع أبويه على العرش، وتحققت رؤياه. وختم يوسف قصته بحمد الله وسؤاله أن يتوفاه مسلمًا ويلحقه بالصالحين.','ref':'سورة يوسف كاملة'},
    {'name':'أيوب عليه السلام','text':'أثنى الله على أيوب بأنه وجده صابرًا، نعم العبد إنه أواب. مسّه الضر فنادى ربه بأدب وتضرع: أني مسني الضر وأنت أرحم الراحمين. لم يكن دعاؤه اعتراضًا على قضاء الله، بل افتقارًا إلى رحمته. فاستجاب الله له، وأمره أن يركض برجله، فكان له ماء يغتسل به ويشرب، فكشف الله ما به من ضر. ورد عليه أهله ومثلهم معهم رحمة من عنده وذكرى للعابدين. وذكر القرآن أيضًا أن أيوب حلف في أمر يخص أهله، فأرشده الله إلى حل يبر بقسمه دون ظلم أو حنث، وأمره أن يأخذ ضغثًا فيضرب به ولا يحنث. ولا يحدد القرآن نوع المرض أو مدته أو تفاصيل ما فقده أيوب، فلا يصح الجزم بالروايات الشائعة التي لا تثبت. وعبرة قصته الصبر والرجوع إلى الله في الشدة والرخاء.','ref':'الأنبياء: 83–84، ص: 41–44'},
    {'name':'شعيب عليه السلام','text':'أرسل الله شعيبًا إلى مدين، فدعاهم إلى عبادة الله وحده، وإيفاء الكيل والميزان، وعدم بخس الناس أشياءهم، وعدم الإفساد في الأرض. وذكّرهم أن ما يبقى لهم من الحلال خير من المكاسب المحرمة، وأنه لا يريد مخالفتهم إلى ما ينهاهم عنه، بل يريد الإصلاح ما استطاع. لكن الملأ استكبروا وهددوا شعيبًا والذين آمنوا معه بالإخراج من القرية أو العودة إلى ملتهم، فرفض الرجوع إلى الشرك بعد إذ أنقذه الله منه. وحذّرهم من مصير قوم نوح وهود وصالح ولوط، وذكّرهم بقرب قوم لوط منهم. استمروا في التكذيب والاستهزاء، فأخذتهم الرجفة، وفي موضع آخر وصف القرآن عذابهم بالصيحة، فأصبحوا في ديارهم جاثمين. ونجّى الله شعيبًا والذين آمنوا معه برحمة منه. وتبين القصة أن فساد المعاملات والغش والظلم من أسباب الهلاك، وأن الدعوة إلى التوحيد تشمل إصلاح السلوك والحقوق.','ref':'الأعراف: 85–93، هود: 84–95'},
    {'name':'موسى عليه السلام','text':'ولد موسى في زمن فرعون الذي كان يقتل أبناء بني إسرائيل ويستحيي نساءهم. فأوحى الله إلى أمه أن ترضعه، فإذا خافت عليه ألقت تابوته في اليم ولا تخاف ولا تحزن، ووعدها أن يرده إليها ويجعله من المرسلين. التقطه آل فرعون، وحرّم الله عليه المراضع حتى دُلّت أخته على أمه، فردّه الله إليها كي تقر عينها. ولما بلغ أشده آتاه الله حكمًا وعلمًا. وخرج من المدينة خائفًا يترقب بعد أن قتل رجلًا خطأً حين استغاثه أحد الإسرائيليين، فاستغفر ربه وغفر له. وصل إلى مدين، فسقى للمرأتين، ثم تزوج إحداهما وعمل عند أبيهما سنين. وفي طريق عودته آنس نارًا عند الطور، فناداه الله وكلمه، وأراه آيتي العصا واليد، وأرسله إلى فرعون، وطلب موسى أن يشد الله أزره بأخيه هارون. واجه فرعون بالحجة والآيات، وأظهر الله الحق على يد موسى أمام السحرة فآمنوا. ثم خرج موسى ببني إسرائيل ليلًا، فلحقهم فرعون وجنوده، فضرب موسى البحر بعصاه فانفلق، ونجا المؤمنون وغرق فرعون. واعد الله موسى أربعين ليلة، فعبد بعض بني إسرائيل العجل في غيابه، فأنكر عليهم هارون، وعاد موسى غضبان أسفًا. وواصل موسى قيادة قومه ودعوتهم، وابتلوا بأوامر كثيرة، منها دخول الأرض المقدسة، لكنهم جبنوا وقالوا إن فيها قومًا جبارين، فحُرّمت عليهم أربعين سنة يتيهون في الأرض. وفي قصته مع العبد الصالح تعلّم أن علم الله أوسع من علم البشر. وتكرر ذكر موسى في القرآن لما في سيرته من آيات الصبر والقيادة ومواجهة الطغيان.','ref':'طه: 9–79، القصص: 3–46، الشعراء: 52–68'},
    {'name':'هارون عليه السلام','text':'كان هارون أخا موسى عليهما السلام ونبيًا أرسله الله معه إلى فرعون، بعدما دعا موسى ربه أن يشرح صدره وييسر أمره ويجعل هارون وزيرًا له من أهله يشد أزره ويشاركه في الأمر. واستجاب الله له، وأمرهما أن يذهبا إلى فرعون ويقولا له قولًا لينًا لعله يتذكر أو يخشى. وساند هارون موسى في تبليغ الرسالة ومواجهة فرعون، وكان فصيح اللسان. وعندما ذهب موسى لميقات ربه واستخلف هارون على قومه، صنع السامري لهم عجلًا جسدًا له خوار، فحذّرهم هارون وقال إنما فتنتم به وإن ربكم الرحمن فاتبعوني وأطيعوا أمري. لكنهم كادوا يقتلونه، فصبر حتى رجع موسى. ولما عاد موسى غضبان أخذ برأس أخيه يجره إليه، فشرح هارون أنه خشي أن يقول له فرّقت بين بني إسرائيل ولم ترقب قولي. ففهم موسى عذره ودعا لنفسه ولأخيه بالمغفرة والرحمة. وتظهر قصته الوفاء في نصرة الحق والصبر على قومه.','ref':'طه: 29–36، طه: 90–94'},
    {'name':'ذو الكفل عليه السلام','text':'ذكر الله ذا الكفل مع إسماعيل وإدريس في سياق الصبر، فقال إنهم من الصابرين، وأدخلهم في رحمته، وذكره كذلك ضمن الأخيار. ولم يسرد القرآن قصة مفصلة له، ولا يبين قومه أو زمنه أو أحداث دعوته. لذلك لا ننسب إليه حكايات منتشرة عن عدد معين من الصلوات أو العهود أو الابتلاءات إلا بدليل ثابت. الثابت أنه عبد صالح أثنى الله عليه وألحقه بالصابرين والأخيار. والعبرة من ذكره أن الصبر والوفاء والاستقامة من صفات عباد الله الذين تشملهم رحمته، وأن المسلم يقف عند النص الصحيح ولا يتوسع في أخبار لا تثبت.','ref':'الأنبياء: 85–86، ص: 48'},
    {'name':'داود عليه السلام','text':'آتَى الله داود الملك والحكمة، وجعله نبيًا، وقتل جالوت بإذن الله بعد أن برز له طالوت وجنده. وآتاه الله الزبور، وألان له الحديد، وعلّمه صنعة الدروع، وسخّر معه الجبال والطير يسبحن بالعشي والإشراق. وكان ذا أيد، أي قوة في العبادة والعمل الصالح، وأوابًا كثير الرجوع إلى الله. وابتلاه الله بقضية الخصمين اللذين تسورا المحراب، فاستمع إلى أحدهما ثم تنبه إلى أن عليه أن يسمع من الآخر، فاستغفر ربه وخر راكعًا وأناب. وأرشده الله إلى الحكم بالحق وألا يتبع الهوى، وبيّن له أن الظلم يضل عن سبيل الله. وسخّر الله له الريح والجبال، وجعل في ذريته النبوة والكتاب، فكان سليمان وارثًا له في العلم والنبوة والملك. وتعلمنا قصته أن القوة والملك نعمة ومسؤولية، وأن العدل والإنابة أساس الحكم.','ref':'ص: 17–26، سبأ: 10–11'},
    {'name':'سليمان عليه السلام','text':'ورث سليمان داود في النبوة والعلم والملك، وقال إن الله علّمه منطق الطير وأوتي من كل شيء. وسخّر الله له الريح والجن يعملون بأمره، وكان جيشه من الجن والإنس والطير. وفي مسيره سمع نملة تحذر قومها من أن يحطمهم الجيش وهم لا يشعرون، فتبسم ضاحكًا من قولها ودعا ربه أن يوزعه شكر نعمته. وتفقد الطير فلم يجد الهدهد، فلما جاءه الهدهد بخبر ملكة سبأ وقومها الذين يسجدون للشمس، أرسل إليها كتابًا يدعوها فيه إلى الإسلام وألا تعلو عليه. تشاورت الملكة مع قومها وأرسلت هدية، فردها سليمان وطلب إحضار عرشها. أتى به عفريت من الجن وآخر عنده علم من الكتاب قبل ارتداد طرفه، فحمد سليمان ربه. ولما جاءت الملكة عرفت عرشها، ودخلت الصرح الممرد من قوارير فحسبته لجة، ثم أعلنت إسلامها لله رب العالمين. ومات سليمان متكئًا على عصاه، ولم يعلم الجن بموته إلا حين أكلت دابة الأرض منسأته فخر، فعرفوا أنهم لا يعلمون الغيب. وتبرز قصته شكر النعمة وتسخير القوة في الدعوة إلى الله.','ref':'النمل: 15–44، سبأ: 12–14'},
    {'name':'إلياس عليه السلام','text':'أرسل الله إلياس إلى قومه، فأنكر عليهم عبادتهم بعلًا وتركهم عبادة الله أحسن الخالقين، وسألهم ألا يتقوا الله. دعاهم إلى التوحيد وبيّن لهم أن الله ربهم ورب آبائهم الأولين، لكن أكثرهم كذبوه. واستثنى الله عباده المخلصين، وأبقى لإلياس ثناءً حسنًا في الآخرين، وجعل عليه سلامًا، وأثنى عليه بأنه من عباده المؤمنين. ولم يفصل القرآن بقية أحداث حياته أو أسماء قومه وأماكنهم، لذلك لا نجزم بتفاصيل لم يذكرها الوحي. وعبرة قصته الثبات في الدعوة إلى التوحيد، وأن قلة المستجيبين لا تنقص من قدر الداعي الصادق عند الله.','ref':'الصافات: 123–132'},
    {'name':'اليسع عليه السلام','text':'ذكر الله اليسع عليه السلام في جملة من الأنبياء الذين أنعم عليهم وفضلهم على العالمين، وذكره مع إسماعيل ويونس ولوط، وكلًا فضل على العالمين. كما وصفه في موضع آخر بأنه من الأخيار. ولم يورد القرآن تفاصيل دعوته أو قومه أو المعجزات التي أيده الله بها، فلا يصح أن ننسب إليه أحداثًا لا تثبت. وما نعلمه يقينًا أنه نبي كريم من عباد الله المصطفين، أثنى الله عليه وأدخله في زمرة الأخيار. وتذكرنا قصته بأن الإيمان بالغيب يقتضي تصديق ما أخبر الله به، والتوقف عما لم يرد فيه علم.','ref':'الأنعام: 86، ص: 48'},
    {'name':'يونس عليه السلام','text':'أرسل الله يونس إلى قومه، فدعاهم إلى الإيمان، ثم خرج مغاضبًا قبل أن يأذن الله له، فركب سفينة فساهم أهلها فكان من المدحضين، فألقوه في البحر فالتقمه الحوت وهو مليم. فنادى في الظلمات: لا إله إلا أنت سبحانك إني كنت من الظالمين. فاستجاب الله له ونجّاه من الغم، وأمر الحوت أن يلقيه بالعراء وهو سقيم، وأنبت عليه شجرة من يقطين. ثم أرسله الله إلى مئة ألف أو يزيدون، فآمنوا فمتعهم إلى حين. وذكر القرآن أن قوم يونس نفعهم إيمانهم لما آمنوا فكشف عنهم عذاب الخزي في الحياة الدنيا ومتعهم إلى أجل. وتعلمنا قصته أن التسبيح والتوحيد والاعتراف بالتقصير من أعظم أسباب تفريج الكرب، وأن رحمة الله واسعة، وأن على الداعية الصبر حتى يأذن الله.','ref':'الأنبياء: 87–88، الصافات: 139–148'},
    {'name':'زكريا عليه السلام','text':'كان زكريا نبيًا صالحًا، وكفل مريم، فكان يجد عندها رزقًا كلما دخل عليها المحراب، فيسألها أنى لك هذا فتقول هو من عند الله. عند ذلك دعا ربه أن يهب له من لدنه ذرية طيبة، مع كبر سنه وكون امرأته عاقرًا. فبشرته الملائكة بيحيى مصدقًا بكلمة من الله وسيدًا وحصورًا ونبيًا من الصالحين. تعجب زكريا من حصول الولد وقد بلغه الكبر، فأخبره الله أن ذلك عليه هين. وسأل ربه آية، فجعل آيته ألا يكلم الناس ثلاثة أيام إلا رمزًا، وأمره أن يكثر من ذكر الله ويسبح بالعشي والإبكار. وكان زكريا يسارع في الخيرات ويدعو ربه رغبًا ورهبًا، وكان خاشعًا. وتظهر قصته حسن الظن بالله، وأن الدعاء لا ينقطع بسبب ضعف الأسباب، وأن الله يهب من يشاء بقدرته.','ref':'آل عمران: 37–41، مريم: 2–11'},
    {'name':'يحيى عليه السلام','text':'بشّر الله زكريا بيحيى، وجعل اسمه مميزًا لم يجعل له من قبل سميًا. وأُتي يحيى الحكم صبيًا، وآتاه الله حنانًا من لدنه وزكاة، وكان تقيًا. وأمره الله أن يأخذ الكتاب بقوة، وجعله بارًا بوالديه، ولم يكن جبارًا عصيًا. وسلّم الله عليه يوم ولد ويوم يموت ويوم يبعث حيًا. ووصفه القرآن بأنه مصدق بكلمة من الله وسيدًا وحصورًا ونبيًا من الصالحين. ولم يذكر القرآن تفاصيل دعوته أو كيفية وفاته، فلا نضيف إليها روايات غير ثابتة. وتعلمنا سيرته أن التقوى والطهارة والبر بالوالدين ليست مرتبطة بعمر الإنسان، فقد آتاه الله الحكم وهو صبي.','ref':'مريم: 7–15، آل عمران: 39'},
    {'name':'عيسى عليه السلام','text':'اصطفى الله مريم وطهرها، وبشرها بالولد عيسى من غير أب، بكلمة من الله، فتعجبت كيف يكون لها ولد ولم يمسسها بشر، فأخبرها الملك أن الله يخلق ما يشاء. حملت به واعتزلت قومها، ثم جاءها المخاض إلى جذع النخلة، فأمرها الله أن تهز الجذع وتأكل وتشرب وتقر عينًا. ولما أتت قومها به أشارت إليه، فأنطقه الله في المهد فقال إنه عبد الله آتاه الكتاب وجعله نبيًا، وأوصاه بالصلاة والزكاة والبر بوالدته. أرسله الله إلى بني إسرائيل، وأيده بالبينات: يخلق من الطين كهيئة الطير فينفخ فيه فيكون طيرًا بإذن الله، ويبرئ الأكمه والأبرص ويحيي الموتى بإذن الله، وينبئهم بما يأكلون وما يدخرون. ودعا إلى عبادة الله ربه وربهم، وآمن به الحواريون ونصروه. ولما مكر أعداؤه، بيّن القرآن أنهم ما قتلوه وما صلبوه ولكن شبه لهم، بل رفعه الله إليه. ويؤكد القرآن أن عيسى عبد الله ورسوله، وأنه كلمة ألقاها إلى مريم وروح منه، وليس إلهًا ولا ابنًا لله. ويوم القيامة يتبرأ ممن اتخذه وأمه إلهين من دون الله.','ref':'آل عمران: 45–55، مريم: 16–36، المائدة: 110–120'},
    {'name':'محمد ﷺ','text':'ولد محمد ﷺ في مكة، ونشأ يتيم الأب ثم فقد أمه، فكفله جده ثم عمه. وعُرف بين قومه بالصدق والأمانة. ولما بلغ أربعين سنة أكرمه الله بالنبوة، ونزل عليه الوحي في غار حراء، فدعا إلى عبادة الله وحده وترك الأصنام والظلم. بدأ الدعوة سرًا ثم جهر بها، فآذاه قومه وآذوا أصحابه، وثبت هو والمؤمنون على الدين. واشتد الأذى والحصار، ثم أذن الله له بالهجرة إلى المدينة، فهاجر وأقام مجتمعًا يقوم على الإيمان والأخوة والعدل. وشرع الله له الجهاد دفاعًا عن المؤمنين، ووقعت أحداث بدر وأحد والخندق وصلح الحديبية، ثم فتح الله مكة فدخلها النبي ﷺ متواضعًا وعفا عن كثير ممن آذوه. واستمرت الوفود تدخل في الإسلام، وأدى حجة الوداع وبيّن للناس حرمة الدماء والأموال وحقوقهم، ونزل قول الله: اليوم أكملت لكم دينكم. ثم توفي ﷺ بعد أن بلغ الرسالة وأدى الأمانة ونصح الأمة، وترك فيهم كتاب الله وسنته. وهو خاتم النبيين، أرسله الله رحمة للعالمين، وجعل شريعته عامة للناس إلى يوم القيامة.','ref':'الأنبياء: 107، الأحزاب: 40، الفتح: 29'},
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [
      const PageHeader(title: 'قصص الأنبياء', icon: Icons.auto_stories),
      const Padding(padding: EdgeInsets.all(12), child: Text('اقرأ أحداث كل قصة بتسلسلها، مع التنبيه إلى ما لم يرد فيه نص ثابت', textAlign: TextAlign.center, style: TextStyle(color: green))),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.all(15), itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Card(color: Colors.white, child: ListTile(
            leading: CircleAvatar(backgroundColor: green, child: Text('${index + 1}', style: const TextStyle(color: gold))),
            title: Text(story['name']!, style: const TextStyle(color: green, fontWeight: FontWeight.bold)),
            subtitle: Text(story['ref']!, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.arrow_forward_ios, color: gold, size: 16),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryDetailPage(story: story))),
          ));
        },
      )),
    ]));
  }
}
class StoryDetailPage extends StatelessWidget {
  final Map<String, String> story;
  const StoryDetailPage({super.key, required this.story});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(backgroundColor: green, foregroundColor: gold, title: Text(story['name']!)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: gold)),
          child: Text(story['text']!, textAlign: TextAlign.justify, style: const TextStyle(color: green, fontSize: 19, height: 2)),
        ),
        const SizedBox(height: 18),
        const Text('مواضع القصة في القرآن الكريم', style: TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 17)),
        const SizedBox(height: 8),
        Text(story['ref']!, style: const TextStyle(color: Colors.black87, height: 1.8)),
        const SizedBox(height: 20),
        const Text('تنبيه: عُرضت القصة بحسب ما ثبت في القرآن الكريم، وما لم يفصّله الوحي لم نضف إليه حكايات غير ثابتة.', style: TextStyle(color: Colors.black54, fontSize: 12)),
      ]),
    );
  }
}

// مواقيت الصلاة

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});
  @override
  State<PrayerPage> createState() => _PrayerPageState();
}
class _PrayerPageState extends State<PrayerPage> {
  static const Map<String, Coordinates> cities = {
    'عدن': Coordinates(12.7855, 45.0187),
    'صنعاء': Coordinates(15.3694, 44.1910),
    'تعز': Coordinates(13.5789, 44.0219),
    'الحديدة': Coordinates(14.7978, 42.9545),
    'إب': Coordinates(13.9667, 44.1833),
    'المكلا': Coordinates(14.5425, 49.1242),
  };
  String city = 'عدن';
  String method = 'أم القرى';
  CalculationParameters _parameters() {
    switch (method) {
      case 'رابطة العالم الإسلامي': return CalculationMethodParameters.muslimWorldLeague();
      case 'المصري': return CalculationMethodParameters.egyptian();
      case 'كراتشي': return CalculationMethodParameters.karachi();
      case 'الخليج': return CalculationMethodParameters.gulfRegion();
      default: return CalculationMethodParameters.ummAlQura();
    }
  }
  String _time(DateTime value) {
    final local = value.toLocal();
    final h = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '$h:$minute ${local.hour >= 12 ? 'م' : 'ص'}';
  }
  @override
  Widget build(BuildContext context) {
    final times = PrayerTimes(coordinates: cities[city]!, date: DateTime.now(), calculationParameters: _parameters());
    final entries = <MapEntry<String, DateTime>>[
      MapEntry('الفجر', times.fajr), MapEntry('الشروق', times.sunrise),
      MapEntry('الظهر', times.dhuhr), MapEntry('العصر', times.asr),
      MapEntry('المغرب', times.maghrib), MapEntry('العشاء', times.isha),
    ];
    return SafeArea(child: Column(children: [
      const PageHeader(title: 'مواقيت الصلاة', icon: Icons.access_time),
      Padding(padding: const EdgeInsets.fromLTRB(16, 15, 16, 5), child: Row(children: [
        const Icon(Icons.location_on, color: gold), const SizedBox(width: 8),
        const Text('المدينة:', style: TextStyle(color: green, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Expanded(child: DropdownButton<String>(isExpanded: true, value: city,
          items: cities.keys.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
          onChanged: (v) { if (v != null) setState(() => city = v); })),
      ])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
        const Text('طريقة الحساب:', style: TextStyle(color: green, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Expanded(child: DropdownButton<String>(isExpanded: true, value: method,
          items: const ['أم القرى','رابطة العالم الإسلامي','المصري','كراتشي','الخليج'].map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
          onChanged: (v) { if (v != null) setState(() => method = v); })),
      ])),
      Padding(padding: const EdgeInsets.all(12), child: Text('مواقيت اليوم في $city • ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: const TextStyle(color: green, fontWeight: FontWeight.bold))),
      Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(15, 0, 15, 15), children: entries.map((e) => Card(
        color: Colors.white, child: ListTile(
          leading: const Icon(Icons.mosque, color: gold),
          title: Text(e.key, style: const TextStyle(color: green, fontWeight: FontWeight.bold)),
          trailing: Text(_time(e.value), style: const TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 17)),
        ),
      )).toList())),
      const Padding(padding: EdgeInsets.only(bottom: 8, left: 12, right: 12),
        child: Text('الأوقات محسوبة محليًا دون إنترنت. قد تختلف دقائق يسيرة حسب التقويم الرسمي في منطقتك.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 11))),
    ]));
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
  bool ready = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      notifications = prefs.getBool('setting_notifications') ?? true;
      vibration = prefs.getBool('setting_vibration') ?? true;
      ready = true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [
      const PageHeader(title: 'الإعدادات', icon: Icons.settings),
      Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
        Card(color: Colors.white, child: SwitchListTile(
          secondary: const Icon(Icons.notifications_outlined, color: gold),
          title: const Text('التنبيهات'),
          subtitle: const Text('تفضيل المستخدم فقط؛ لا ترسل تنبيهات في هذه النسخة'),
          value: notifications, activeColor: green,
          onChanged: ready ? (value) {
            setState(() => notifications = value);
            _saveSetting('setting_notifications', value);
          } : null,
        )),
        Card(color: Colors.white, child: SwitchListTile(
          secondary: const Icon(Icons.vibration, color: gold),
          title: const Text('الاهتزاز'),
          subtitle: const Text('تفضيل محفوظ؛ لا يتم تشغيل الاهتزاز في هذه النسخة'),
          value: vibration, activeColor: green,
          onChanged: ready ? (value) {
            setState(() => vibration = value);
            _saveSetting('setting_vibration', value);
          } : null,
        )),
        const Card(color: Colors.white, child: ListTile(
          leading: Icon(Icons.info_outline, color: gold),
          title: Text('عن التطبيق'),
          subtitle: Text('رفيق المسلم - رفيقك إلى الطمأنينة'),
        )),
        const Card(color: Colors.white, child: ListTile(
          leading: Icon(Icons.favorite, color: gold),
          title: Text('نسأل الله أن ينفع بهذا العمل'),
        )),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text('التطبيق يضم القرآن الكريم والأذكار والمسبحة وقصص الأنبياء ومواقيت الصلاة المحسوبة دون إنترنت.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, height: 1.7)),
        ),
      ])),
    ]));
  }
}
