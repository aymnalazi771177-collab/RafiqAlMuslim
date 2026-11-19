
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
  static const List<Map<String, String>> stories = [
    {'name':'آدم عليه السلام','text':'خلق الله آدم من طين، وعلّمه الأسماء، وأسكنه وزوجه الجنة. ثم وقعت الزلة، فتاب آدم إلى ربه فتاب عليه وهداه.','ref':'البقرة: 30–39، طه: 115–123'},
    {'name':'إدريس عليه السلام','text':'ذكر الله إدريس بالصدق والنبوة ورفعة المكانة، وأثنى عليه بأنه كان صديقًا نبيًا. ولم يفصل القرآن أحداثًا كثيرة من حياته.','ref':'مريم: 56–57، الأنبياء: 85'},
    {'name':'نوح عليه السلام','text':'دعا نوح قومه إلى عبادة الله ليلًا ونهارًا، وصبر على تكذيبهم زمنًا طويلًا. فأمره الله بصنع السفينة، ونجّاه ومن آمن معه، وأغرق المكذبين بالطوفان.','ref':'هود: 25–49، نوح: 1–28'},
    {'name':'هود عليه السلام','text':'أرسل الله هودًا إلى عاد، فدعاهم إلى التوحيد وترك الاستكبار. كذبوه فأهلكهم الله بريح صرصر عاتية، ونجّى هودًا والذين آمنوا معه.','ref':'الأعراف: 65–72، الحاقة: 6–8'},
    {'name':'صالح عليه السلام','text':'أرسل صالح إلى ثمود، وأيّده الله بالناقة آية لهم، وأمرهم ألا يمسوها بسوء. فعقروها واستكبروا، فأخذتهم الرجفة ونجّى الله صالحًا والمؤمنين.','ref':'الأعراف: 73–79، الشمس: 11–15'},
    {'name':'إبراهيم عليه السلام','text':'حاجّ إبراهيم قومه في عبادة الأصنام، وكسر أصنامهم ليبيّن عجزها، فألقوه في النار فجعلها الله بردًا وسلامًا. وابتلاه الله فوفّى، ورفع قواعد البيت مع إسماعيل.','ref':'الأنبياء: 51–70، البقرة: 124–129'},
    {'name':'لوط عليه السلام','text':'أرسل الله لوطًا إلى قوم ارتكبوا الفاحشة، فنهاهم عنها ودعاهم إلى التقوى. أصروا على المنكر، فنجّى الله لوطًا وأهله إلا امرأته، وأهلك القوم.','ref':'الأعراف: 80–84، هود: 77–83'},
    {'name':'إسماعيل عليه السلام','text':'كان إسماعيل صادق الوعد، وكان يأمر أهله بالصلاة والزكاة. وشارك أباه إبراهيم في رفع قواعد الكعبة، وظهر في قصته التسليم لأمر الله عند الابتلاء.','ref':'مريم: 54–55، البقرة: 125–129، الصافات: 102–107'},
    {'name':'إسحاق عليه السلام','text':'بشّر الله إبراهيم وزوجه بإسحاق، وجعله نبيًا من الصالحين، وبارك عليه وعلى يعقوب. وذكره القرآن ضمن أنبياء الله الذين هداهم واجتباهم.','ref':'هود: 71–73، الصافات: 112–113، الأنعام: 84'},
    {'name':'يعقوب عليه السلام','text':'يعقوب هو إسرائيل، وكان نبيًا صابرًا. ابتُلي بفقد يوسف، لكنه لم ييأس من روح الله، وردّ الله إليه بصره واجتمع بأهله.','ref':'يوسف: 83–101'},
    {'name':'يوسف عليه السلام','text':'رأى يوسف رؤيا فحسده إخوته وألقوه في الجب. بيع في مصر، وابتلي بالسجن فصبر، ثم أظهر الله براءته ومكّنه في الأرض، واجتمع بأهله وتحققت رؤياه.','ref':'سورة يوسف كاملة'},
    {'name':'أيوب عليه السلام','text':'ابتلى الله أيوب بالضر، فصبر ولم يقطع رجاءه من ربه، ودعا: أني مسني الضر وأنت أرحم الراحمين. فاستجاب الله له وكشف ما به ورد عليه أهله ومثلهم معهم.','ref':'الأنبياء: 83–84، ص: 41–44'},
    {'name':'شعيب عليه السلام','text':'دعا شعيب أهل مدين إلى عبادة الله وإيفاء الكيل والميزان وعدم بخس الناس أشياءهم. كذبوه وهددوه، فنجّى الله شعيبًا والذين آمنوا وأخذ الظالمين.','ref':'الأعراف: 85–93، هود: 84–95'},
    {'name':'موسى عليه السلام','text':'ولد موسى في زمن فرعون، فأوحى الله إلى أمه أن تلقيه في اليم، فالتقطه آل فرعون. أرسله الله إلى فرعون ومعه هارون، وأيّده بالآيات، ونجّى بني إسرائيل وشق لهم البحر.','ref':'طه: 9–79، القصص: 3–46، الشعراء: 52–68'},
    {'name':'هارون عليه السلام','text':'كان هارون نبيًا وأخًا لموسى ووزيره، طلب موسى من ربه أن يشد أزره به. دعا هارون بني إسرائيل إلى الحق، وصبر حين فُتنوا بالعجل أثناء غياب موسى.','ref':'طه: 29–36، طه: 90–94'},
    {'name':'ذو الكفل عليه السلام','text':'ذكره الله في جملة الصابرين والأخيار، وأثنى عليه مع إسماعيل وإدريس. ولم يذكر القرآن تفاصيل قصته، فنثبت ما ورد دون الجزم بتفاصيل لم يذكرها الوحي.','ref':'الأنبياء: 85–86، ص: 48'},
    {'name':'داود عليه السلام','text':'آتاه الله الملك والحكمة، وأنزل عليه الزبور، وسخّر معه الجبال والطير يسبحن. وكان ذا قوة في العبادة، وفصل الله بين الخصوم وأرشده إلى العدل.','ref':'ص: 17–26، سبأ: 10–11'},
    {'name':'سليمان عليه السلام','text':'ورث سليمان داود في النبوة والملك، وعلّمه الله منطق الطير وسخّر له الجن والريح. تفقد الهدهد، ودعا ملكة سبأ إلى الإسلام، وشكر الله على نعمه.','ref':'النمل: 15–44، سبأ: 12–14'},
    {'name':'إلياس عليه السلام','text':'أرسل الله إلياس إلى قومه فأنكر عليهم عبادتهم بعلًا، ودعاهم إلى عبادة الله وحده. وذكره الله في عباده المؤمنين وترك عليه ثناءً حسنًا.','ref':'الصافات: 123–132'},
    {'name':'اليسع عليه السلام','text':'ذكر الله اليسع في جملة الأخيار والأنبياء الذين فضلهم وهدى آباءهم وذرياتهم. ولم يفصل القرآن أحداث دعوته، فنقف عند الثناء القرآني عليه.','ref':'الأنعام: 86، ص: 48'},
    {'name':'يونس عليه السلام','text':'خرج يونس مغاضبًا، فابتلعه الحوت، فنادى في الظلمات أن لا إله إلا أنت سبحانك إني كنت من الظالمين. فاستجاب الله له ونجّاه، وأرسله إلى قوم آمنوا فمتعهم إلى حين.','ref':'الأنبياء: 87–88، الصافات: 139–148'},
    {'name':'زكريا عليه السلام','text':'دعا زكريا ربه أن يرزقه ذرية طيبة على كبر سنه، فبشره الله بيحيى. وكان قائمًا بالدعاء والمسارعة في الخيرات والخشوع لله.','ref':'آل عمران: 37–41، مريم: 2–11'},
    {'name':'يحيى عليه السلام','text':'آتاه الله الحكم صبيًا، وجعله حنانًا وزكاة وكان تقيًا بارًا بوالديه، ولم يكن جبارًا عصيًا. وبشّر الله به زكريا استجابة لدعائه.','ref':'مريم: 7–15، آل عمران: 39'},
    {'name':'عيسى عليه السلام','text':'خلق الله عيسى بكلمته من أم بلا أب، وأيّده بالبينات وروح القدس. تكلم في المهد، ودعا بني إسرائيل إلى عبادة الله، وأجرى الله على يديه معجزات بإذنه، ورفعه إليه.','ref':'آل عمران: 45–55، مريم: 16–36، المائدة: 110–120'},
    {'name':'محمد ﷺ','text':'خاتم الأنبياء، أرسله الله رحمة للعالمين بشيرًا ونذيرًا. نزل عليه القرآن، ودعا إلى التوحيد، وصبر على الأذى، وهاجر، وأقام مجتمع الإيمان، وأتم الله به الدين.','ref':'الأنبياء: 107، الأحزاب: 40، الفتح: 29'},
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [
      const PageHeader(title: 'قصص الأنبياء', icon: Icons.auto_stories),
      const Padding(padding: EdgeInsets.all(12), child: Text('قصص موجزة مستندة إلى الآيات القرآنية، مع مواضع الرجوع إلى السور', textAlign: TextAlign.center, style: TextStyle(color: green))),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.all(15), itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Card(color: Colors.white, child: ListTile(
            leading: CircleAvatar(backgroundColor: green, child: Text('\${index + 1}', style: const TextStyle(color: gold))),
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
        const Text('هذا ملخص للتذكير، والمرجع هو الآيات المذكورة.', style: TextStyle(color: Colors.black54, fontSize: 12)),
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
    return '$h:$minute \${local.hour >= 12 ? 'م' : 'ص'}';
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
      Padding(padding: const EdgeInsets.all(12), child: Text('مواقيت اليوم في $city • \${DateTime.now().day}/\${DateTime.now().month}/\${DateTime.now().year}', style: const TextStyle(color: green, fontWeight: FontWeight.bold))),
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
