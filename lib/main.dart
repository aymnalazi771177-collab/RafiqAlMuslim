
import 'package:flutter/material.dart';

void main() {
  runApp(const RafiqApp());
}

const Color green = Color(0xFF073D32);
const Color darkGreen = Color(0xFF052C25);
const Color gold = Color(0xFFD5B16A);
const Color cream = Color(0xFFF8F5EC);

class RafiqApp extends StatelessWidget {
  const RafiqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رفيق المسلم',
      theme: ThemeData(
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
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
  int selectedIndex = 0;

  final pages = const [
    HomePage(),
    TasbeehPage(),
    AzkarPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: gold.withOpacity(0.2),
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() => selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: green),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.radio_button_unchecked),
              label: 'السبحة',
            ),
            NavigationDestination(
              icon: Icon(Icons.volunteer_activism_outlined),
              label: 'الأذكار',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const sections = [
    ['القرآن الكريم', Icons.menu_book],
    ['الأذكار', Icons.volunteer_activism],
    ['السبحة الإلكترونية', Icons.fingerprint],
    ['قصص الأنبياء', Icons.auto_stories],
    ['مواقيت الصلاة', Icons.mosque],
    ['أسماء الله الحسنى', Icons.star_outline],
    ['الأحاديث النبوية', Icons.book_outlined],
    ['القبلة', Icons.explore_outlined],
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [green, darkGreen],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.mosque, color: gold, size: 32),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'رفيق المسلم',
                          style: TextStyle(
                            color: gold,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'السلام عليكم ورحمة الله وبركاته',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'رفيقك إلى الطمأنينة',
                    style: TextStyle(color: gold, fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(19),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      border: Border.all(color: gold.withOpacity(0.55)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '﴿ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1.8,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'سورة الرعد - الآية 28',
                          style: TextStyle(color: gold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 12),
              child: Row(
                children: [
                  const Text(
                    'أقسام التطبيق',
                    style: TextStyle(
                      color: green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.auto_awesome, color: gold, size: 22),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final section = sections[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SectionPage(
                            title: section[0] as String,
                            icon: section[1] as IconData,
                          ),
                        ),
                      );
                    },
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
                            blurRadius: 9,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: green.withOpacity(0.07),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              section[1] as IconData,
                              color: green,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            section[0] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: sections.length,
              ),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 13,
                crossAxisSpacing: 13,
                childAspectRatio: 1.18,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(22),
              child: Center(
                child: Text(
                  'رفيقك إلى الطمأنينة',
                  style: TextStyle(color: green, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionPage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: gold,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 75, color: green),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'سيتم تجهيز محتوى هذا القسم في المراحل القادمة',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
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
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'السبحة الإلكترونية',
              style: TextStyle(
                color: green,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 35),
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: green,
                border: Border.all(color: gold, width: 5),
                boxShadow: [
                  BoxShadow(
                    color: green.withOpacity(0.2),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'عدد التسبيحات',
                    style: TextStyle(color: gold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 55,
                  vertical: 18,
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
          ],
        ),
      ),
    );
  }
}

class AzkarPage extends StatelessWidget {
  const AzkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'الأذكار',
        style: TextStyle(
          color: green,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'إعدادات رفيق المسلم',
        style: TextStyle(
          color: green,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
