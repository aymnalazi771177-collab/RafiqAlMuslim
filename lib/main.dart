import 'package:flutter/material.dart';

void main() {
  runApp(const RafiqAlMuslim());
}

const Color green = Color(0xFF073F35);
const Color darkGreen = Color(0xFF052F28);
const Color gold = Color(0xFFD5B16A);
const Color cream = Color(0xFFF8F4E9);

class RafiqAlMuslim extends StatelessWidget {
  const RafiqAlMuslim({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رفيق المسلم',
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> items = const [
    {'title': 'القرآن الكريم', 'icon': Icons.menu_book},
    {'title': 'الأذكار', 'icon': Icons.volunteer_activism},
    {'title': 'السبحة الإلكترونية', 'icon': Icons.radio_button_checked},
    {'title': 'قصص الأنبياء', 'icon': Icons.auto_stories},
    {'title': 'مواقيت الصلاة', 'icon': Icons.mosque},
    {'title': 'أسماء الله الحسنى', 'icon': Icons.star},
    {'title': 'الأحاديث النبوية', 'icon': Icons.book},
    {'title': 'الإعدادات', 'icon': Icons.settings},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 35, 20, 30),
                decoration: const BoxDecoration(
                  color: darkGreen,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(35),
                  ),
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
                    const SizedBox(height: 8),
                    const Text(
                      'رفيقك إلى الطمأنينة',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: gold.withOpacity(.5)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        '﴿ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 22, 20, 12),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'أقسام التطبيق',
                    style: TextStyle(
                      color: green,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.25,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SectionPage(
                              title: item['title'],
                              icon: item['icon'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: gold.withOpacity(.65)),
                          boxShadow: [
                            BoxShadow(
                              color: green.withOpacity(.06),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item['icon'], color: green, size: 34),
                            const SizedBox(height: 12),
                            Text(
                              item['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'رفيقك إلى الطمأنينة',
                  style: TextStyle(color: green, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: darkGreen,
          foregroundColor: gold,
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: green, size: 75),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: green,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'سيتم تجهيز هذا القسم بمحتواه الكامل',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
