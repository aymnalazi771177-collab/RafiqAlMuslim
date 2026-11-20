import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quran/quran.dart' as quran;
import 'package:adhan_dart/adhan_dart.dart';
import 'package:geolocator/geolocator.dart';
import 'data/prophet_stories.dart';

// Page numbers taken from the embedded 569-page PDF's own bookmarks.
const List<int> quranPdfSurahStartPages = [1,2,45,69,95,115,136,160,169,187,199,212,225,231,237,242,255,266,277,284,294,302,311,319,329,335,345,354,364,371,377,381,383,393,399,404,410,417,422,431,439,445,451,457,460,464,468,472,477,479,482,485,487,490,493,496,499,504,507,510,513,515,516,518,520,522,524,526,529,531,533,534,537,538,540,542,544,545,547,548,550,551,552,553,554,555,556,556,557,559,559,560,561,561,562,562,563,563,564,564,565,565,566,566,566,567,567,567,568,568,568,569,569,569];

const green=Color(0xFF073F35), darkGreen=Color(0xFF052F28), gold=Color(0xFFD5B16A), cream=Color(0xFFF8F4E9);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await pdfrxFlutterInitialize();
  try {
    await AppPrefs.instance.load();
  } catch (_) {
    // Keep the app usable even if local preferences cannot be read.
  }
  runApp(const RafiqApp());
}

class AppPrefs extends ChangeNotifier {
  AppPrefs._();
  static final instance=AppPrefs._();
  bool dark=false, vibration=true;
  Future<void> load() async {
    final p=await SharedPreferences.getInstance();
    dark=p.getBool('dark_mode')??false;
    vibration=p.getBool('vibration')??true;
  }
  Future<void> setDark(bool v) async { if(dark==v)return; dark=v; notifyListeners(); try { final p=await SharedPreferences.getInstance(); await p.setBool('dark_mode',v); } catch (_) {} }
  Future<void> setVibration(bool v) async { vibration=v; notifyListeners(); try { final p=await SharedPreferences.getInstance(); await p.setBool('vibration',v); } catch (_) {} }
}
Future<void> feedback() async { if(AppPrefs.instance.vibration) await HapticFeedback.selectionClick(); }

class RafiqApp extends StatefulWidget { const RafiqApp({super.key}); @override State<RafiqApp> createState()=>_RafiqAppState(); }
class _RafiqAppState extends State<RafiqApp> {
  @override void initState(){super.initState();AppPrefs.instance.addListener(refresh);}
  @override void dispose(){AppPrefs.instance.removeListener(refresh);super.dispose();}
  void refresh()=>setState((){});
  @override Widget build(BuildContext context){
    final dark=AppPrefs.instance.dark;
    return MaterialApp(
      debugShowCheckedModeBanner:false,title:'رفيق المسلم',themeMode:dark?ThemeMode.dark:ThemeMode.light,
      theme:ThemeData(useMaterial3:true,scaffoldBackgroundColor:cream,colorScheme:ColorScheme.fromSeed(seedColor:green,primary:green,secondary:gold),appBarTheme:const AppBarTheme(backgroundColor:green,foregroundColor:gold,centerTitle:true,elevation:0),cardTheme:CardThemeData(color:const Color(0xFFFFFCF4),elevation:2,margin:const EdgeInsets.symmetric(vertical:6,horizontal:2),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20),side:BorderSide(color:gold.withOpacity(.38)))),inputDecorationTheme:InputDecorationTheme(filled:true,fillColor:const Color(0xFFFFFCF4),contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:14),border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none),enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide(color:gold.withOpacity(.35)))),navigationBarTheme:NavigationBarThemeData(height:68,backgroundColor:const Color(0xFFFFFCF4),indicatorColor:gold.withOpacity(.24),labelTextStyle:WidgetStateProperty.all(const TextStyle(fontWeight:FontWeight.w700)))),
      darkTheme:ThemeData(useMaterial3:true,brightness:Brightness.dark,colorScheme:ColorScheme.fromSeed(seedColor:green,secondary:gold,brightness:Brightness.dark),scaffoldBackgroundColor:const Color(0xFF101B18),appBarTheme:const AppBarTheme(backgroundColor:darkGreen,foregroundColor:gold,centerTitle:true)),
      home:const Directionality(textDirection:TextDirection.rtl,child:MainScreen()));
  }
}

class MainScreen extends StatefulWidget { const MainScreen({super.key}); @override State<MainScreen> createState()=>_MainScreenState(); }
class _MainScreenState extends State<MainScreen>{
  int page=0; void go(int n)=>setState(()=>page=n);
  int get nav=>page==1?1:page==3?2:page==6?3:0;
  @override Widget build(BuildContext context){
    final pages=<Widget>[HomePage(open:go),const QuranPage(),const TasbeehPage(),const AzkarPage(),const StoriesPage(),const PrayerPage(),const SettingsPage()];
    return Scaffold(body:IndexedStack(index:page,children:pages),bottomNavigationBar:NavigationBar(selectedIndex:nav,backgroundColor:Theme.of(context).cardColor,indicatorColor:gold.withOpacity(.2),onDestinationSelected:(i)=>go([0,1,3,6][i]),destinations:const[
      NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'الرئيسية'),
      NavigationDestination(icon:Icon(Icons.menu_book_outlined),selectedIcon:Icon(Icons.menu_book),label:'القرآن'),
      NavigationDestination(icon:Icon(Icons.favorite_outline),selectedIcon:Icon(Icons.favorite),label:'الأذكار'),
      NavigationDestination(icon:Icon(Icons.settings_outlined),selectedIcon:Icon(Icons.settings),label:'الإعدادات'),
    ]));
  }
}

class HomePage extends StatelessWidget{
  final ValueChanged<int> open; const HomePage({super.key,required this.open});
  static const items=[('القرآن الكريم',Icons.menu_book_rounded,1),('الأذكار اليومية',Icons.volunteer_activism_rounded,3),('المسبحة الإلكترونية',Icons.radio_button_checked_rounded,2),('قصص الأنبياء',Icons.auto_stories_rounded,4),('مواقيت الصلاة',Icons.access_time_rounded,5),('الإعدادات',Icons.settings_rounded,6)];
  @override Widget build(BuildContext context)=>SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(15,12,15,22),children:[
    Container(
      padding:const EdgeInsets.fromLTRB(20,22,20,20),
      decoration:BoxDecoration(
        gradient:const LinearGradient(begin:Alignment.topRight,end:Alignment.bottomLeft,colors:[Color(0xFF075344),Color(0xFF032D26)]),
        borderRadius:BorderRadius.circular(28),
        border:Border.all(color:gold,width:1.5),
        boxShadow:[BoxShadow(color:green.withOpacity(.18),blurRadius:16,offset:const Offset(0,7))],
      ),
      child:Stack(children:[
        Positioned(left:0,top:0,child:Icon(Icons.nightlight_round,color:gold.withOpacity(.18),size:45)),
        Column(children:[
          Container(width:66,height:66,decoration:BoxDecoration(shape:BoxShape.circle,color:gold.withOpacity(.12),border:Border.all(color:gold.withOpacity(.7))),child:const Icon(Icons.menu_book_rounded,color:gold,size:38)),
          const SizedBox(height:10),
          const Text('رفيق المسلم',style:TextStyle(color:Color(0xFFF5D58D),fontSize:29,fontWeight:FontWeight.bold,letterSpacing:.2)),
          const SizedBox(height:3),
          const Text('رفيقك إلى الطمأنينة',style:TextStyle(color:Colors.white,fontSize:14)),
          const SizedBox(height:17),
          Container(height:1,color:gold.withOpacity(.55)),
          const SizedBox(height:14),
          const Text('السلام عليكم ورحمة الله',style:TextStyle(color:Colors.white,fontSize:19,fontWeight:FontWeight.bold)),
          const SizedBox(height:7),
          const Text('اجعل يومك عامرًا بذكر الله',style:TextStyle(color:Color(0xFFF2D99E),fontSize:14)),
          const SizedBox(height:15),
          Container(width:double.infinity,padding:const EdgeInsets.symmetric(vertical:13,horizontal:10),decoration:BoxDecoration(color:Colors.white.withOpacity(.08),borderRadius:BorderRadius.circular(16),border:Border.all(color:gold.withOpacity(.45))),child:const Column(children:[
            Text('آية اليوم',style:TextStyle(color:Color(0xFFF2D99E),fontWeight:FontWeight.bold)),
            SizedBox(height:5),
            Text('أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontSize:18,height:1.7)),
            Text('سورة الرعد • 28',style:TextStyle(color:Color(0xFFE7D4A8),fontSize:11)),
          ])),
        ]),
      ]),
    ),
    const SizedBox(height:21),
    Row(children:[
      const Expanded(child:Text('أقسام التطبيق',style:TextStyle(color:green,fontSize:20,fontWeight:FontWeight.bold))),
      Container(padding:const EdgeInsets.symmetric(horizontal:11,vertical:5),decoration:BoxDecoration(color:gold.withOpacity(.18),borderRadius:BorderRadius.circular(20)),child:const Text('رفيقك اليومي',style:TextStyle(color:green,fontSize:11,fontWeight:FontWeight.bold))),
    ]),
    const SizedBox(height:12),
    GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:items.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:11,mainAxisSpacing:11,childAspectRatio:1.16),itemBuilder:(c,i){
      final x=items[i];
      return Material(color:Colors.transparent,child:InkWell(borderRadius:BorderRadius.circular(20),onTap:(){feedback();open(x.$3);},child:Container(
        decoration:BoxDecoration(color:const Color(0xFFFFFCF4),borderRadius:BorderRadius.circular(20),border:Border.all(color:gold.withOpacity(.55)),boxShadow:[BoxShadow(color:green.withOpacity(.05),blurRadius:8,offset:const Offset(0,3))]),
        child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
          Container(width:54,height:54,decoration:BoxDecoration(color:green.withOpacity(.09),shape:BoxShape.circle,border:Border.all(color:gold.withOpacity(.65))),child:Icon(x.$2,color:green,size:29)),
          const SizedBox(height:9),
          Text(x.$1,textAlign:TextAlign.center,style:const TextStyle(color:green,fontWeight:FontWeight.bold,fontSize:13)),
        ]),
      )));
    }),
    const SizedBox(height:8),
    Container(decoration:BoxDecoration(color:const Color(0xFFFFFCF4),borderRadius:BorderRadius.circular(18),border:Border.all(color:gold.withOpacity(.55))),child:ListTile(
      contentPadding:const EdgeInsets.symmetric(horizontal:15,vertical:5),
      leading:Container(width:43,height:43,decoration:BoxDecoration(color:green.withOpacity(.1),shape:BoxShape.circle),child:const Icon(Icons.bookmark_added_rounded,color:green)),
      title:const Text('متابعة آخر قراءة',style:TextStyle(color:green,fontWeight:FontWeight.bold)),
      subtitle:const Text('العودة إلى موضعك المحفوظ في المصحف'),
      trailing:const Icon(Icons.chevron_left,color:gold),
      onTap:()async{final p=await SharedPreferences.getInstance();final page=p.getInt('last_page')??1;if(!context.mounted)return;Navigator.push(context,MaterialPageRoute(builder:(_)=>Directionality(textDirection:TextDirection.rtl,child:QuranReader(initialPage:page))));},
    )),
  ]));
}

class Header extends StatelessWidget{final String title;final IconData icon;const Header(this.title,this.icon,{super.key});@override Widget build(BuildContext c)=>Container(width:double.infinity,padding:const EdgeInsets.fromLTRB(18,18,18,20),decoration:BoxDecoration(gradient:const LinearGradient(begin:Alignment.topRight,end:Alignment.bottomLeft,colors:[green,darkGreen]),borderRadius:const BorderRadius.vertical(bottom:Radius.circular(26)),border:Border(bottom:BorderSide(color:gold.withOpacity(.8),width:1.2)),boxShadow:[BoxShadow(color:green.withOpacity(.12),blurRadius:10,offset:const Offset(0,4))]),child:Column(children:[Container(width:48,height:48,decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:gold.withOpacity(.65)),color:Colors.white.withOpacity(.06)),child:Icon(icon,color:gold,size:27)),const SizedBox(height:8),Text(title,style:const TextStyle(color:Color(0xFFF3D28D),fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:3),Container(width:52,height:2,decoration:BoxDecoration(color:gold,borderRadius:BorderRadius.circular(3))) ]));}

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});
  @override State<QuranPage> createState() => _QuranPageState();
}
class _QuranPageState extends State<QuranPage> {
  final search = TextEditingController();
  @override void dispose() { search.dispose(); super.dispose(); }
  @override Widget build(BuildContext c) {
    final nums = List<int>.generate(114, (i) => i + 1).where((n) =>
      search.text.isEmpty || quran.getSurahNameArabic(n).contains(search.text) || n.toString() == search.text).toList();
    return SafeArea(child: Column(children: [
      const Header('المصحف الشريف', Icons.menu_book),
      Padding(padding: const EdgeInsets.all(13), child: TextField(
        controller: search, onChanged: (_) => setState(() {}),
        decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'ابحث عن سورة أو رقمها',
          filled: true, fillColor: Theme.of(c).cardColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 13), child: Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: () => _open(c, 1),
          icon: const Icon(Icons.auto_stories), label: const Text('فتح المصحف'))),
        const SizedBox(width: 8),
        Expanded(child: OutlinedButton.icon(onPressed: () => _pickPage(c),
          icon: const Icon(Icons.find_in_page), label: const Text('رقم الصفحة'))),
      ])),
      Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 12), itemCount: nums.length,
        itemBuilder: (c, i) {
          final n = nums[i], firstPage = quranPdfSurahStartPages[n - 1];
          return Card(child: ListTile(
            leading: CircleAvatar(backgroundColor: green, child: Text(n.toString(), style: const TextStyle(color: gold))),
            title: Text('سورة ' + quran.getSurahNameArabic(n), style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(quran.getVerseCount(n).toString() + ' آية • صفحة ' + firstPage.toString()),
            trailing: const Icon(Icons.chevron_left, color: gold), onTap: () => _open(c, firstPage)));
        })),
    ]));
  }
  void _open(BuildContext c, int page) => Navigator.push(c, MaterialPageRoute(
    builder: (_) => Directionality(textDirection: TextDirection.rtl, child: QuranReader(initialPage: page))));
  Future<void> _pickPage(BuildContext c) async {
    final controller = TextEditingController();
    final value = await showDialog<int>(context: c, builder: (d) => AlertDialog(
      title: const Text('الانتقال إلى صفحة'),
      content: TextField(controller: controller, keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: 'من 1 إلى 604')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d), child: const Text('إلغاء')),
        FilledButton(onPressed: () {
          final n = int.tryParse(controller.text.trim());
          if (n != null && n >= 1 && n <= 604) Navigator.pop(d, n);
        }, child: const Text('انتقال')),
      ]));
    controller.dispose();
    if (value != null && c.mounted) _open(c, value);
  }
}

class QuranReader extends StatefulWidget {
  final int initialPage;
  const QuranReader({super.key, this.initialPage = 1});
  @override
  State<QuranReader> createState() => _QuranReaderState();
}

class _QuranReaderState extends State<QuranReader> {
  late int page;
  bool failed = false;
  bool loading = true;
  final PdfViewerController controller = PdfViewerController();

  @override
  void initState() {
    super.initState();
    page = widget.initialPage.clamp(1, 604);
  }

  Future<void> _savePage(int? nextPage) async {
    if (nextPage == null || nextPage < 1 || nextPage > 604) return;
    if (page != nextPage && mounted) setState(() => page = nextPage);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_page', nextPage);
    final sections = quran.getPageData(nextPage);
    if (sections.isNotEmpty) {
      await prefs.setInt('last_surah', sections.first['surah'] as int);
      await prefs.setInt('last_ayah', sections.first['start'] as int);
    }
  }

  void _goToPage(int nextPage) {
    if (nextPage < 1 || nextPage > 604 || !controller.isReady) return;
    controller.goToPage(pageNumber: nextPage);
    _savePage(nextPage);
  }

  Future<void> _pickPage() async {
    final input = TextEditingController(text: page.toString());
    final selected = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('الانتقال إلى صفحة'),
        content: TextField(
          controller: input,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'أدخل رقمًا من 1 إلى 604'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(input.text.trim());
              if (value != null && value >= 1 && value <= 604) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('انتقال'),
          ),
        ],
      ),
    );
    input.dispose();
    if (selected != null) _goToPage(selected);
  }

  Future<void> _pickSurah() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(sheetContext).size.height * .78,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'فهرس السور',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 114,
                    itemBuilder: (context, index) {
                      final surah = index + 1;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: green,
                          child: Text(surah.toString(), style: const TextStyle(color: gold)),
                        ),
                        title: Text('سورة ' + quran.getSurahNameArabic(surah)),
                        subtitle: Text(quran.getVerseCount(surah).toString() + ' آية'),
                        onTap: () => Navigator.pop(
                          sheetContext,
                          quranPdfSurahStartPages[surah - 1],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (selected != null && mounted) {
      // Recreate the PDF reader at the selected surah's first page.
      // This avoids retaining the previous PDF viewport position.
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Directionality(
            textDirection: TextDirection.rtl,
            child: QuranReader(initialPage: selected),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE5D3),
      appBar: AppBar(
        title: Text('المصحف الشريف • صفحة ' + page.toString() + ' من 604'),
        actions: [
          IconButton(
            tooltip: 'فهرس السور',
            onPressed: _pickSurah,
            icon: const Icon(Icons.list_alt),
          ),
          IconButton(
            tooltip: 'الانتقال إلى صفحة',
            onPressed: _pickPage,
            icon: const Icon(Icons.find_in_page),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PdfViewer.asset(
              'assets/Holy-Quran-Mushaf.pdf',
              key: const ValueKey('local-original-mushaf-pdf'),
              controller: controller,
              initialPageNumber: page,
              params: PdfViewerParams(
                paging: const PdfPaging(),
                backgroundColor: const Color(0xFFEDE5D3),
                onPageChanged: (nextPage) {
                  if (nextPage != null) _savePage(nextPage);
                },
                onDocumentLoadFinished: (documentRef, success) {
                  if (!mounted) return;
                  setState(() {
                    loading = false;
                    failed = !success;
                  });
                  if (success && controller.isReady) {
                    controller.goToPage(pageNumber: widget.initialPage);
                    _savePage(widget.initialPage);
                  }
                },
              ),
            ),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: LinearProgressIndicator(minHeight: 2, color: gold),
            ),
          if (failed)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'تعذر فتح ملف المصحف المضمّن في التطبيق.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.fromLTRB(10, 7, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: page > 1 ? () => _goToPage(page - 1) : null,
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('السابقة'),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: page < 604 ? () => _goToPage(page + 1) : null,
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('التالية'),
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

class TasbeehPage extends StatefulWidget{const TasbeehPage({super.key});@override State<TasbeehPage> createState()=>_TasbeehPageState();}
class _TasbeehPageState extends State<TasbeehPage>{
  final choices=const ['سبحان الله','الحمد لله','الله أكبر','لا إله إلا الله','سبحان الله وبحمده','أستغفر الله','لا حول ولا قوة إلا بالله','اللهم صل وسلم على نبينا محمد'];String zekr='سبحان الله وبحمده';int count=0;
  @override void initState(){super.initState();load();}
  Future<void> load()async{final p=await SharedPreferences.getInstance();if(mounted)setState(()=>count=p.getInt('tasbeeh_'+zekr)??0);}
  Future<void> save()async{final p=await SharedPreferences.getInstance();await p.setInt('tasbeeh_'+zekr,count);}
  @override Widget build(BuildContext c)=>SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(16,0,16,22),children:[
    const Header('المسبحة الإلكترونية',Icons.radio_button_checked),
    const SizedBox(height:22),
    Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(gradient:const LinearGradient(begin:Alignment.topRight,end:Alignment.bottomLeft,colors:[green,darkGreen]),borderRadius:BorderRadius.circular(26),border:Border.all(color:gold,width:1.4),boxShadow:[BoxShadow(color:green.withOpacity(.16),blurRadius:15,offset:const Offset(0,6))]),child:Column(children:[
      const Text('وَرَطِّبْ لِسَانَكَ بِذِكْرِ اللَّه',textAlign:TextAlign.center,style:TextStyle(color:Color(0xFFF3D28D),fontSize:18,fontWeight:FontWeight.bold)),
      const SizedBox(height:5),const Text('ألا بذكر الله تطمئن القلوب',style:TextStyle(color:Colors.white70,fontSize:13)),
      const SizedBox(height:18),
      Container(padding:const EdgeInsets.symmetric(horizontal:14),decoration:BoxDecoration(color:const Color(0xFFFFFCF4),borderRadius:BorderRadius.circular(16),border:Border.all(color:gold)),child:DropdownButtonHideUnderline(child:DropdownButton<String>(isExpanded:true,value:zekr,items:choices.map((v)=>DropdownMenuItem(value:v,child:Text(v,textAlign:TextAlign.center,style:const TextStyle(color:green,fontWeight:FontWeight.bold)))).toList(),onChanged:(v)async{if(v==null)return;setState(()=>zekr=v);final p=await SharedPreferences.getInstance();if(mounted)setState(()=>count=p.getInt('tasbeeh_'+v)??0);}))),
      const SizedBox(height:22),
      GestureDetector(onTap:()async{await feedback();setState(()=>count++);await save();},child:Container(width:220,height:220,decoration:BoxDecoration(shape:BoxShape.circle,color:const Color(0xFFFFF8E8),border:Border.all(color:gold,width:7),boxShadow:[BoxShadow(color:Colors.black.withOpacity(.18),blurRadius:12,offset:const Offset(0,5))]),child:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text('$count',style:const TextStyle(color:green,fontSize:65,fontWeight:FontWeight.bold)),const Text('مرة',style:TextStyle(color:darkGreen,fontSize:17,fontWeight:FontWeight.bold)),const SizedBox(height:5),const Text('اضغط للعدّ',style:TextStyle(color:Colors.black54,fontSize:12))])))),
      const SizedBox(height:18),
      SizedBox(width:double.infinity,child:FilledButton.icon(style:FilledButton.styleFrom(backgroundColor:const Color(0xFF0C8B54),foregroundColor:Colors.white,padding:const EdgeInsets.symmetric(vertical:15),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(30),side:const BorderSide(color:gold,width:1))),onPressed:()async{await feedback();setState(()=>count++);await save();},icon:const Icon(Icons.touch_app_rounded),label:const Text('سبحان الله',style:TextStyle(fontSize:17,fontWeight:FontWeight.bold)))),
      const SizedBox(height:8),
      TextButton.icon(onPressed:()async{setState(()=>count=0);await save();},icon:const Icon(Icons.refresh,color:Color(0xFFF3D28D)),label:const Text('إعادة التعيين',style:TextStyle(color:Color(0xFFF3D28D)))),
    ])),
    const SizedBox(height:16),
    Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFFFFFCF4),borderRadius:BorderRadius.circular(18),border:Border.all(color:gold.withOpacity(.55))),child:Column(children:[
      const Text('هدف اليوم',style:TextStyle(color:green,fontSize:17,fontWeight:FontWeight.bold)),
      const SizedBox(height:6),Text('$count من 100 مرة',style:const TextStyle(color:darkGreen,fontWeight:FontWeight.w600)),
      const SizedBox(height:9),ClipRRect(borderRadius:BorderRadius.circular(20),child:LinearProgressIndicator(value:(count/100).clamp(0.0,1.0),minHeight:9,backgroundColor:gold.withOpacity(.2),color:green)),
    ])),
  ]));
}

class Dhikr{final String text;final int repeat;const Dhikr(this.text,this.repeat);}
class AzkarPage extends StatefulWidget{const AzkarPage({super.key});@override State<AzkarPage> createState()=>_AzkarPageState();}
class _AzkarPageState extends State<AzkarPage>{
  String selected='أذكار الصباح';final Map<String,int> counts={};
  final data=const <String,List<Dhikr>>{
    'أذكار الصباح':[Dhikr('أصبحنا وأصبح الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير. رب أسألك خير ما في هذا اليوم وخير ما بعده، وأعوذ بك من شر ما في هذا اليوم وشر ما بعده.',1),Dhikr('اللهم بك أصبحنا وبك أمسينا وبك نحيا وبك نموت وإليك النشور.',1),Dhikr('رضيت بالله ربًا، وبالإسلام دينًا، وبمحمد ﷺ نبيًا.',3),Dhikr('اللهم إني أسألك العفو والعافية في الدنيا والآخرة.',1),Dhikr('سبحان الله وبحمده.',100),Dhikr('أستغفر الله وأتوب إليه.',100)],
    'أذكار المساء':[Dhikr('أمسينا وأمسى الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير. رب أسألك خير ما في هذه الليلة وخير ما بعدها، وأعوذ بك من شر ما في هذه الليلة وشر ما بعدها.',1),Dhikr('اللهم بك أمسينا وبك أصبحنا وبك نحيا وبك نموت وإليك المصير.',1),Dhikr('رضيت بالله ربًا، وبالإسلام دينًا، وبمحمد ﷺ نبيًا.',3),Dhikr('اللهم إني أسألك العفو والعافية في الدنيا والآخرة.',1),Dhikr('سبحان الله وبحمده.',100)],
    'بعد الصلاة':[Dhikr('أستغفر الله.',3),Dhikr('اللهم أنت السلام ومنك السلام، تباركت يا ذا الجلال والإكرام.',1),Dhikr('سبحان الله.',33),Dhikr('الحمد لله.',33),Dhikr('الله أكبر.',33),Dhikr('لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',1)],
    'أذكار النوم':[Dhikr('باسمك اللهم أموت وأحيا.',1),Dhikr('سبحان الله.',33),Dhikr('الحمد لله.',33),Dhikr('الله أكبر.',34)],
    'أذكار الاستيقاظ':[Dhikr('الحمد لله الذي أحيانا بعدما أماتنا وإليه النشور.',1)]
  };
  String k(String cat,int i)=>'azkar_'+cat+'_'+i.toString();
  @override void initState(){super.initState();load();}
  Future<void> load()async{final p=await SharedPreferences.getInstance();for(final cat in data.keys){for(var i=0;i<data[cat]!.length;i++){counts[k(cat,i)]=p.getInt(k(cat,i))??0;}}if(mounted)setState((){});}
  Future<void> increment(int i)async{final key=k(selected,i),n=(counts[key]??0)+1;setState(()=>counts[key]=n);final p=await SharedPreferences.getInstance();await p.setInt(key,n);await feedback();}
  @override Widget build(BuildContext c){
    final list=data[selected]!;
    return SafeArea(child:Column(children:[
      const Header('الأذكار اليومية',Icons.volunteer_activism),
      Container(margin:const EdgeInsets.fromLTRB(14,12,14,5),padding:const EdgeInsets.all(14),decoration:BoxDecoration(gradient:const LinearGradient(colors:[green,darkGreen]),borderRadius:BorderRadius.circular(18),border:Border.all(color:gold.withOpacity(.8))),child:Row(children:[
        Container(width:43,height:43,decoration:BoxDecoration(shape:BoxShape.circle,color:gold.withOpacity(.15),border:Border.all(color:gold.withOpacity(.7))),child:const Icon(Icons.auto_awesome,color:gold)),
        const SizedBox(width:11),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(selected,style:const TextStyle(color:Color(0xFFF3D28D),fontSize:17,fontWeight:FontWeight.bold)),
          const SizedBox(height:3),const Text('اجعل لسانك رطبًا بذكر الله',style:TextStyle(color:Colors.white,fontSize:12)),
        ])),
      ])),
      SingleChildScrollView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:10,vertical:9),child:Row(children:data.keys.map((cat)=>Padding(padding:const EdgeInsets.symmetric(horizontal:3),child:ChoiceChip(
        label:Text(cat,style:TextStyle(color:selected==cat?Colors.white:green,fontWeight:FontWeight.bold,fontSize:12)),
        selected:selected==cat,selectedColor:green,backgroundColor:const Color(0xFFFFFCF4),side:BorderSide(color:gold.withOpacity(.6)),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(22)),onSelected:(_)=>setState(()=>selected=cat),
      ))).toList())),
      Expanded(child:ListView.builder(padding:const EdgeInsets.fromLTRB(13,4,13,18),itemCount:list.length,itemBuilder:(c,i){
        final d=list[i],n=counts[k(selected,i)]??0,done=n>=d.repeat;
        return Container(margin:const EdgeInsets.only(bottom:12),decoration:BoxDecoration(color:const Color(0xFFFFFCF4),borderRadius:BorderRadius.circular(19),border:Border.all(color:gold.withOpacity(.48)),boxShadow:[BoxShadow(color:green.withOpacity(.045),blurRadius:7,offset:const Offset(0,3))]),child:Column(children:[
          Container(height:5,decoration:BoxDecoration(color:done?const Color(0xFF4B9569):green,borderRadius:const BorderRadius.vertical(top:Radius.circular(19)))),
          Padding(padding:const EdgeInsets.fromLTRB(17,16,17,13),child:Column(children:[
            Text(d.text,textAlign:TextAlign.center,style:const TextStyle(color:Color(0xFF24342D),fontSize:18,height:1.95,fontWeight:FontWeight.w500)),
            const SizedBox(height:13),
            Row(mainAxisAlignment:MainAxisAlignment.center,children:[
              Container(padding:const EdgeInsets.symmetric(horizontal:13,vertical:7),decoration:BoxDecoration(color:done?const Color(0xFFE7F2E9):gold.withOpacity(.16),borderRadius:BorderRadius.circular(20)),child:Text(done?'اكتمل الذكر ✓':'التكرار  $n / ${d.repeat}',style:TextStyle(color:done?const Color(0xFF28734B):green,fontWeight:FontWeight.bold,fontSize:12))),
            ]),
            const SizedBox(height:12),
            Row(children:[
              Expanded(child:FilledButton.icon(onPressed:done?null:()=>increment(i),style:FilledButton.styleFrom(backgroundColor:green,foregroundColor:Colors.white,disabledBackgroundColor:const Color(0xFFE5EEE7),disabledForegroundColor:green,padding:const EdgeInsets.symmetric(vertical:12),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25))),icon:Icon(done?Icons.check_circle:Icons.touch_app_rounded,size:18),label:Text(done?'تم الذكر':'اضغط للتكرار',style:const TextStyle(fontWeight:FontWeight.bold)))),
              const SizedBox(width:9),
              OutlinedButton.icon(onPressed:()async{setState(()=>counts[k(selected,i)]=0);final p=await SharedPreferences.getInstance();await p.setInt(k(selected,i),0);},style:OutlinedButton.styleFrom(foregroundColor:green,side:BorderSide(color:gold.withOpacity(.8)),padding:const EdgeInsets.symmetric(horizontal:13,vertical:12),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25))),icon:const Icon(Icons.refresh,size:17),label:const Text('تصفير')),
            ]),
          ])),
        ]));
      })),
    ]));
  }
}

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});
  @override
  Widget build(BuildContext c) => SafeArea(child: Column(children: [
    const Header('قصص الأنبياء', Icons.auto_stories),
    const Padding(
      padding: EdgeInsets.all(12),
      child: Text('قصص الأنبياء المذكورين في القرآن الكريم، مع مواضع الآيات للاستزادة.',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
    ),
    Expanded(child: ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: prophetStories.length,
      itemBuilder: (c, i) {
        final story = prophetStories[i];
        return Card(child: ListTile(
          leading: CircleAvatar(backgroundColor: green,
              child: Text('${i + 1}', style: const TextStyle(color: gold))),
          title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('عرض القصة والتفاصيل والعبر'),
          trailing: const Icon(Icons.chevron_left, color: gold),
          onTap: () => Navigator.push(c, MaterialPageRoute(
            builder: (_) => Directionality(textDirection: TextDirection.rtl,
                child: StoryDetail(story: story))),
          ),
        ));
      },
    )),
  ]));
}

class StoryDetail extends StatelessWidget {
  final ProphetStory story;
  const StoryDetail({super.key, required this.story});
  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: Text(story.title)),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(18),
          border: Border.all(color: gold)),
        child: Text(story.title, textAlign: TextAlign.center,
          style: const TextStyle(color: gold, fontSize: 23, fontWeight: FontWeight.bold))),
      const SizedBox(height: 20),
      Text(story.body.trim(), textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 18, height: 2)),
      const SizedBox(height: 20),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('العبرة والفائدة', style: TextStyle(color: gold, fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(story.lesson, style: const TextStyle(fontSize: 17, height: 1.8)),
        ],
      ))),
      const SizedBox(height: 14),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('مواضع القصة في القرآن الكريم',
            style: TextStyle(color: gold, fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(story.references, style: const TextStyle(fontSize: 15, height: 1.8)),
        ],
      ))),
      const SizedBox(height: 12),
      const Text('اعتمدت هذه السيرة على ما ورد في القرآن الكريم. وقد تكون تفاصيل بعض الأنبياء موجزة لأن القرآن لم يسرد أحداث حياتهم كاملة؛ ولم تُضف روايات غير ثابتة.',
        textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, height: 1.7)),
    ]),
  );
}

class PrayerPage extends StatefulWidget{const PrayerPage({super.key});@override State<PrayerPage> createState()=>_PrayerPageState();}
class _PrayerPageState extends State<PrayerPage>{
  Position? position;bool loading=false;String error='',method='رابطة العالم الإسلامي';
  final methods=<String,CalculationParameters Function()>{'رابطة العالم الإسلامي':() => CalculationMethodParameters.muslimWorldLeague(),'الهيئة المصرية':() => CalculationMethodParameters.egyptian(),'أم القرى':() => CalculationMethodParameters.ummAlQura(),'كراتشي':() => CalculationMethodParameters.karachi()};
  Future<void> locate()async{setState((){loading=true;error='';});try{if(!await Geolocator.isLocationServiceEnabled())throw Exception('فعّل خدمة الموقع في الهاتف.');var perm=await Geolocator.checkPermission();if(perm==LocationPermission.denied)perm=await Geolocator.requestPermission();if(perm==LocationPermission.denied||perm==LocationPermission.deniedForever)throw Exception('لم يتم منح إذن الموقع.');final p=await Geolocator.getCurrentPosition(locationSettings:const LocationSettings(accuracy:LocationAccuracy.medium,timeLimit:Duration(seconds:20)));if(mounted)setState((){position=p;loading=false;});}catch(e){if(mounted)setState((){error=e.toString().replaceFirst('Exception: ','');loading=false;});}}
  String time(DateTime d){final t=d.toLocal(),h=t.hour%12==0?12:t.hour%12;return h.toString().padLeft(2,'0')+':'+t.minute.toString().padLeft(2,'0')+(t.hour>=12?' م':' ص');}
  @override Widget build(BuildContext c){
    final t=position==null?null:PrayerTimes(coordinates:Coordinates(position!.latitude,position!.longitude),date:DateTime.now(),calculationParameters:methods[method]!());
    final rows=t==null?<(String,String)>[]:[('الفجر',time(t.fajr)),('الشروق',time(t.sunrise)),('الظهر',time(t.dhuhr)),('العصر',time(t.asr)),('المغرب',time(t.maghrib)),('العشاء',time(t.isha))];
    return SafeArea(child:Column(children:[const Header('مواقيت الصلاة',Icons.access_time),Expanded(child:ListView(padding:const EdgeInsets.all(14),children:[
      Card(child:Padding(padding:const EdgeInsets.all(15),child:Column(children:[const Icon(Icons.location_on,color:gold,size:34),Text(position==null?'اعرض المواقيت حسب موقعك':'تم تحديد موقعك',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),if(position!=null)Text('الإحداثيات: '+position!.latitude.toStringAsFixed(3)+'، '+position!.longitude.toStringAsFixed(3),style:const TextStyle(color:Colors.grey)),const SizedBox(height:9),FilledButton.icon(onPressed:loading?null:locate,icon:loading?const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.my_location),label:Text(loading?'جارٍ تحديد الموقع':'تحديد موقعي')),if(error.isNotEmpty)Text(error,style:const TextStyle(color:Colors.red),textAlign:TextAlign.center)]))),
      Card(child:Padding(padding:const EdgeInsets.symmetric(horizontal:14),child:DropdownButtonFormField<String>(value:method,decoration:const InputDecoration(labelText:'طريقة حساب المواقيت',border:InputBorder.none),items:methods.keys.map((m)=>DropdownMenuItem(value:m,child:Text(m))).toList(),onChanged:(v)=>setState(()=>method=v??method)))),
      if(t==null)const Padding(padding:EdgeInsets.all(18),child:Text('امنح التطبيق إذن الموقع لعرض المواقيت. تتم الحسابات على جهازك ولا تُرسل إحداثياتك إلى خادم خارجي.',textAlign:TextAlign.center,style:TextStyle(color:Colors.grey,height:1.8))),
      ...rows.map((r)=>Card(child:ListTile(leading:const Icon(Icons.mosque,color:gold),title:Text(r.$1,style:const TextStyle(fontWeight:FontWeight.bold)),trailing:Text(r.$2,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:17,color:green))))),
      if(t!=null)const Text('قد تختلف الدقائق عن تقويم المسجد المحلي بحسب طريقة الحساب المعتمدة.',textAlign:TextAlign.center,style:TextStyle(color:Colors.grey))
    ]))]));
  }
}

class SettingsPage extends StatelessWidget{
  const SettingsPage({super.key});
  Future<void> contactDeveloper(BuildContext c)async{
    final uri=Uri.parse('https://wa.me/967771177633?text=%D8%A7%D9%84%D8%B3%D9%84%D8%A7%D9%85%20%D8%B9%D9%84%D9%8A%D9%83%D9%85%D8%8C%20%D8%A3%D8%AA%D9%88%D8%A7%D8%B5%D9%84%20%D9%85%D8%B9%D9%83%D9%85%20%D8%A8%D8%AE%D8%B5%D9%88%D8%B5%20%D8%AA%D8%B7%D8%A8%D9%8A%D9%82%20%D8%B1%D9%81%D9%8A%D9%82%20%D8%A7%D9%84%D9%85%D8%B3%D9%84%D9%85.');
    try{
      final ok=await launchUrl(uri,mode:LaunchMode.externalApplication);
      if(!ok&&c.mounted)ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('تعذر فتح واتساب. تأكد من تثبيته أو جرّب لاحقًا.')));
    }catch(_){
      if(c.mounted)ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('تعذر فتح واتساب على هذا الجهاز.')));
    }
  }
  @override Widget build(BuildContext c){
    final s=AppPrefs.instance;
    return SafeArea(child:Column(children:[
      const Header('الإعدادات',Icons.settings),
      Expanded(child:ListView(padding:const EdgeInsets.all(14),children:[
        Card(child:SwitchListTile(
          secondary:Icon(s.dark?Icons.dark_mode:Icons.light_mode,color:gold),
          title:const Text('الوضع الليلي',style:TextStyle(fontWeight:FontWeight.bold)),
          subtitle:Text(s.dark?'الوضع الليلي مفعّل':'الوضع العادي مفعّل'),
          value:s.dark,onChanged:(v)=>s.setDark(v),
        )),
        Card(child:SwitchListTile(
          secondary:const Icon(Icons.vibration,color:gold),
          title:const Text('الاهتزاز'),
          subtitle:const Text('اهتزاز خفيف عند التسبيح'),
          value:s.vibration,onChanged:(v)=>s.setVibration(v),
        )),
        Card(child:ListTile(
          leading:Container(width:42,height:42,decoration:BoxDecoration(color:green.withOpacity(.09),shape:BoxShape.circle),child:const Icon(Icons.support_agent,color:green)),
          title:const Text('التواصل مع مطوّر التطبيق',style:TextStyle(fontWeight:FontWeight.bold)),
          subtitle:const Text('راسلنا مباشرة عبر واتساب • 771177633'),
          trailing:const Icon(Icons.open_in_new,color:gold),
          onTap:()=>contactDeveloper(c),
        )),
        Card(child:ListTile(
          leading:const Icon(Icons.bookmark_remove,color:gold),
          title:const Text('مسح موضع القراءة المحفوظ'),
          onTap:()async{final p=await SharedPreferences.getInstance();await p.remove('last_surah');await p.remove('last_ayah');if(c.mounted)ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('تم مسح موضع القراءة.')));},
        )),
        const Card(child:ListTile(leading:Icon(Icons.info_outline,color:gold),title:Text('عن التطبيق'),subtitle:Text('رفيق المسلم • رفيقك إلى الطمأنينة • الإصدار 1.0.1'))),
        const Card(child:Padding(padding:EdgeInsets.all(16),child:Text('مواقيت الصلاة محسوبة على الجهاز وفق طريقة الحساب المختارة، وقد تحتاج إلى مطابقتها مع تقويم المسجد في منطقتك.',style:TextStyle(color:Colors.grey,height:1.7)))),
        const Center(child:Text('نسأل الله أن ينفع بهذا العمل ويتقبله.',style:TextStyle(color:gold,fontWeight:FontWeight.bold))),
      ])),
    ]));
  }
}
