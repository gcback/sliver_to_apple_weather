import 'dart:math';
import 'package:mylib/mylib.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: OutlinedButton(
              child: const Text('Start'),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const HomePage())),
            ),
          ),
        );
      }),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  static String title = 'Home';
  static double expandedHeight = 130.0;
  static double collapsedHeight = 96.0;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final controller = useScrollController();
    final opacity = useState(0.0);
    useEffectOnce(() {
      controller.addListener(() {
        final maxExt = expandedHeight - collapsedHeight;
        opacity.value =
            max(0.0, controller.offset / maxExt - 0.8).clamp(0.0, 1.0);
      });
    });

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: 8.0.horiInsets,
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              backgroundColor: backgroundColor.withOpacity(1 - opacity.value),
              automaticallyImplyLeading: false,
              toolbarHeight: kToolbarHeight * 0.6,
              flexibleSpace: FlexibleSpaceBar(
                  background:
                      ColoredBox(color: backgroundColor.withAlpha(240))),
              pinned: true,
              floating: true,
              elevation: 0.0,
              titleSpacing: 0.0,
              title: Text(
                '날씨',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(opacity.value)),
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.pending_outlined),
                )
              ],
            ),
            SliverToBoxAdapter(
                child: Text(
              '날씨',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color:
                    Colors.white.withOpacity(opacity.value > 0.1 ? 0.0 : 1.0),
              ),
            )),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverSearchBar(background: backgroundColor),
            ),
            SliverList.builder(
              itemCount: 10,
              itemBuilder: (context, index) => DumCard(
                height: 150.0,
                color: index.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SliverSearchBar extends SliverPersistentHeaderDelegate {
  const SliverSearchBar({required this.background});

  final Color background;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: Container(
        color: background.withAlpha(240),
        child: Opacity(
          opacity: 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    constraints: const BoxConstraints(
                      minHeight: 36.0,
                      maxHeight: 36.0,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    // fillColor: background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: '도시 또는 공항검색',
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(covariant SliverSearchBar oldDelegate) => true;
}
