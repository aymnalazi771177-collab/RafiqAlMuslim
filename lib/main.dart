import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran/quran.dart' as quran;
import 'package:adhan_dart/adhan_dart.dart';
import 'package:geolocator/geolocator.dart';
import 'data/prophet_stories.dart';

const green=Color(0xFF073F35), darkGreen=Color(0xFF052F28), gold=Color(0xFFD5B16A), cream=Color(0xFFF8F4E9);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.instance.load();
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
  Future<void> setDark(bool v) async { dark=v; final p=await SharedPreferences.getInstance(); await p.setBool('dark_mode',v); notifyListeners(); }
  Future<void> setVibration(bool v) async { vibration=v; final p=await SharedPreferences.getInstance(); await p.setBool('vibration',v); notifyListeners(); }
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
      theme:ThemeData(useMaterial3:true,scaffoldBackgroundColor:cream,colorScheme:ColorScheme.fromSeed(seedColor:green,primary:green,secondary:gold),appBarTheme:const AppBarTheme(backgroundColor:green,foregroundColor:gold,centerTitle:true),cardTheme:CardThemeData(color:Colors.white,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18)))),
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
  static const items=[('القرآن الكريم',Icons.menu_book,1),('الأذكار اليومية',Icons.volunteer_activism,3),('المسبحة الإلكترونية',Icons.radio_button_checked,2),('قصص الأنبياء',Icons.auto_stories,4),('مواقيت الصلاة',Icons.access_time,5),('الإعدادات',Icons.settings,6)];
  @override Widget build(BuildContext context)=>SafeArea(child:ListView(padding:const EdgeInsets.all(17),children:[
    Container(padding:const EdgeInsets.all(23),decoration:BoxDecoration(gradient:const LinearGradient(colors:[green,darkGreen]),borderRadius:BorderRadius.circular(25),border:Border.all(color:gold)),child:const Column(children:[
      Icon(Icons.mosque,color:gold,size:52),SizedBox(height:10),Text('رفيق المسلم',style:TextStyle(color:gold,fontSize:29,fontWeight:FontWeight.bold)),Text('رفيقك إلى الطمأنينة',style:TextStyle(color:Colors.white)),SizedBox(height:18),
      Text('أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontSize:20,height:1.8))
    ])),
    const SizedBox(height:22),const Text('أقسام التطبيق',style:TextStyle(color:green,fontSize:21,fontWeight:FontWeight.bold)),const SizedBox(height:12),
    GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:items.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:1.12),itemBuilder:(c,i){
      final x=items[i];return InkWell(borderRadius:BorderRadius.circular(18),onTap:(){feedback();open(x.$3);},child:Container(decoration:BoxDecoration(color:Theme.of(c).cardColor,borderRadius:BorderRadius.circular(18),border:Border.all(color:gold.withOpacity(.6))),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(x.$2,color:gold,size:38),const SizedBox(height:10),Text(x.$1,style:TextStyle(color:Theme.of(c).colorScheme.primary,fontWeight:FontWeight.bold))])));
    }),
    Card(child:ListTile(leading:const Icon(Icons.bookmark,color:gold),title:const Text('متابعة القراءة'),subtitle:const Text('العودة إلى آخر موضع حفظته'),onTap:()async{final p=await SharedPreferences.getInstance();final page=p.getInt('last_page')??1;if(!context.mounted)return;Navigator.push(context,MaterialPageRoute(builder:(_)=>Directionality(textDirection:TextDirection.rtl,child:QuranReader(initialPage:page))));}))
  ]));
}

class Header extends StatelessWidget{final String title;final IconData icon;const Header(this.title,this.icon,{super.key});@override Widget build(BuildContext c)=>Container(width:double.infinity,padding:const EdgeInsets.symmetric(vertical:20),decoration:const BoxDecoration(color:green,borderRadius:BorderRadius.vertical(bottom:Radius.circular(24))),child:Column(children:[Icon(icon,color:gold,size:36),const SizedBox(height:8),Text(title,style:const TextStyle(color:gold,fontSize:23,fontWeight:FontWeight.bold))]));}

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
          final n = nums[i], firstPage = quran.getPageNumber(n, 1);
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

  static final Uri mushafUri = Uri.parse(
    'https://www.pdfquran.com/download/standard1/standard1-quran.pdf',
  );

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
                          quran.getPageNumber(surah, 1),
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
    if (selected != null) _goToPage(selected);
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
            child: PdfViewer.uri(
              mushafUri,
              key: const ValueKey('standard1-original-pdf'),
              controller: controller,
              initialPageNumber: page,
              preferRangeAccess: true,
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
                'تعذر فتح ملف المصحف. تحقق من اتصال الإنترنت ثم أعد المحاولة.',
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
  @override Widget build(BuildContext c)=>SafeArea(child:Column(children:[
    const Header('المسبحة الإلكترونية',Icons.radio_button_checked),const Spacer(),const Text('الذكر الحالي',style:TextStyle(color:Colors.grey)),
    DropdownButton<String>(value:zekr,items:choices.map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v)async{if(v==null)return;setState(()=>zekr=v);final p=await SharedPreferences.getInstance();if(mounted)setState(()=>count=p.getInt('tasbeeh_'+v)??0);}),
    const SizedBox(height:20),Container(width:205,height:205,decoration:BoxDecoration(shape:BoxShape.circle,color:green,border:Border.all(color:gold,width:6)),child:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text('$count',style:const TextStyle(color:gold,fontSize:62,fontWeight:FontWeight.bold)),const Text('تسبيحة',style:TextStyle(color:Colors.white70))]))),
    const SizedBox(height:20),Text(zekr,style:const TextStyle(fontSize:20,color:green,fontWeight:FontWeight.bold)),const SizedBox(height:15),
    ElevatedButton.icon(style:ElevatedButton.styleFrom(backgroundColor:green,foregroundColor:Colors.white,padding:const EdgeInsets.symmetric(horizontal:45,vertical:15)),onPressed:()async{await feedback();setState(()=>count++);await save();},icon:const Icon(Icons.touch_app),label:const Text('تسبيح')),
    TextButton(onPressed:()async{setState(()=>count=0);await save();},child:const Text('إعادة العداد')),const Spacer()
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
  @override Widget build(BuildContext c){final list=data[selected]!;return SafeArea(child:Column(children:[
    const Header('الأذكار اليومية',Icons.volunteer_activism),
    SingleChildScrollView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.all(9),child:Row(children:data.keys.map((cat)=>Padding(padding:const EdgeInsets.symmetric(horizontal:3),child:ChoiceChip(label:Text(cat),selected:selected==cat,selectedColor:gold.withOpacity(.3),onSelected:(_)=>setState(()=>selected=cat)))).toList())),
    Expanded(child:ListView.builder(padding:const EdgeInsets.all(12),itemCount:list.length,itemBuilder:(c,i){final d=list[i],n=counts[k(selected,i)]??0,done=n>=d.repeat;return Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(children:[
      Text(d.text,textAlign:TextAlign.center,style:const TextStyle(fontSize:18,height:1.9)),const SizedBox(height:9),
      Text(done?'اكتمل الذكر ✓':'التكرار: '+n.toString()+' من '+d.repeat.toString(),style:TextStyle(color:done?Colors.green:Colors.grey,fontWeight:FontWeight.bold)),
      Row(mainAxisAlignment:MainAxisAlignment.center,children:[ElevatedButton(onPressed:done?null:()=>increment(i),style:ElevatedButton.styleFrom(backgroundColor:green,foregroundColor:Colors.white),child:const Text('اضغط للتكرار')),const SizedBox(width:8),OutlinedButton(onPressed:()async{setState(()=>counts[k(selected,i)]=0);final p=await SharedPreferences.getInstance();await p.setInt(k(selected,i),0);},child:const Text('تصفير'))])
    ])));})),
  ]));}
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

class SettingsPage extends StatelessWidget{const SettingsPage({super.key});@override Widget build(BuildContext c){final s=AppPrefs.instance;return SafeArea(child:Column(children:[const Header('الإعدادات',Icons.settings),Expanded(child:ListView(padding:const EdgeInsets.all(14),children:[
  Card(child:SwitchListTile(secondary:const Icon(Icons.dark_mode,color:gold),title:const Text('الوضع الليلي'),value:s.dark,onChanged:s.setDark)),
  Card(child:SwitchListTile(secondary:const Icon(Icons.vibration,color:gold),title:const Text('الاهتزاز'),subtitle:const Text('اهتزاز خفيف عند التسبيح'),value:s.vibration,onChanged:s.setVibration)),
  Card(child:ListTile(leading:const Icon(Icons.bookmark_remove,color:gold),title:const Text('مسح موضع القراءة المحفوظ'),onTap:()async{final p=await SharedPreferences.getInstance();await p.remove('last_surah');await p.remove('last_ayah');if(c.mounted)ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('تم مسح موضع القراءة.')));})),
  const Card(child:ListTile(leading:Icon(Icons.info_outline,color:gold),title:Text('عن التطبيق'),subtitle:Text('رفيق المسلم • رفيقك إلى الطمأنينة • الإصدار 1.0.1'))),
  const Card(child:Padding(padding:EdgeInsets.all(16),child:Text('مواقيت الصلاة محسوبة على الجهاز وفق طريقة الحساب المختارة، وقد تحتاج إلى مطابقتها مع تقويم المسجد في منطقتك.',style:TextStyle(color:Colors.grey,height:1.7)))),
  const Center(child:Text('نسأل الله أن ينفع بهذا العمل ويتقبله.',style:TextStyle(color:gold,fontWeight:FontWeight.bold)))
]))]));}}
