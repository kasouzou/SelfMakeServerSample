import 'package:flutter/material.dart';
import 'package:selfmakeserver/page/input_user_page.dart';
import 'package:selfmakeserver/page/output_user_page.dart';

// なるほど — 見た目が黒くなるのはよくあるハマりで、原因はだいたいこのどれか：
// BottomNavigationBar を包む Material（内部的に使われるもの）が デフォルトで暗い色を描画している
// Scaffold がボトム領域を覆っていて 透過が効いていない（extendBody が無い）
// Material3 の surfaceTintColor / テーマが干渉して、透明にしても暗めのオーバーレイが乗る

// ▼ user-defined（自分で定義する StatefulWidget）
class YoutubeLikeBottomNavigationBar extends StatefulWidget {
  const YoutubeLikeBottomNavigationBar({super.key});

  @override
  State<YoutubeLikeBottomNavigationBar> createState() => _YoutubeLikeBottomNavigationBarState();
}

// ▼ user-defined（自分の State クラス）
class _YoutubeLikeBottomNavigationBarState extends State<YoutubeLikeBottomNavigationBar> {
  // ▼ user-defined: 今選ばれてるタブ index
  int selectedTabIndex = 0;

  // ▼ user-defined: 各タブ用の NavigatorState を外部から操作するための GlobalKey
  final List<GlobalKey<NavigatorState>> navigatorKeys = List.generate(
    2, // タブ数（必要なら増やす）
    (_) => GlobalKey<NavigatorState>(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      // outer background（user-defined）: 画面全体に薄い白を重ねる例
      decoration: const BoxDecoration(
        color: Color.fromARGB(34, 255, 255, 255),
      ),
      child: Scaffold(
        // ★ 重要: extendBody を true にして、body が bottomNavigationBar の背後まで伸びるようにする
        extendBody: true,

        // 既にやってるけど念押し：Scaffold の背景は透明にしておく
        backgroundColor: Colors.transparent,

        body: IndexedStack(
          index: selectedTabIndex,
          children: [
            _buildTabNavigator(0, const InputUserPage()),
            _buildTabNavigator(1, const OutputUserPage()),
          ],
        ),

        // ★ BottomNavigationBar を Material でラップして内部 Material の色/影を潰す
        bottomNavigationBar: Material(
          color: Colors.transparent, // Material自体の色を透明に（これが効かないと黒っぽさが残る）
          // color: const Color.fromARGB(0, 255, 255, 255),
          elevation: 0, // Material の影を消す（念のため）BottomNavigationBar を包む Material（内部的に使われるもの）が デフォルトで暗い色を描画している
          child: BottomNavigationBar(
            // バー自体も透明に
            backgroundColor: const Color.fromARGB(0, 98, 255, 0),
            elevation: 0, // アイコンの下の影を消す
            type: BottomNavigationBarType
                .fixed, // アイテムがシフトして見た目が変わるのを抑える（安定）
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(255, 218, 218, 218),
            currentIndex: selectedTabIndex,
            onTap: _onTapBottomNavItem,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.send_outlined,
                  size:32,
                ), // 未選択時: アウトライン
                activeIcon: Icon(
                  Icons.send,
                  size:32,
                ),    // 選択時: 塗りつぶし (Filled)
                label: "送信"
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.move_to_inbox_outlined,
                  size:32,),
                activeIcon: Icon(
                  Icons.move_to_inbox,
                  size:32,
                ), // 選択時: 塗りつぶし (Filled)
                label: "受信"
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabNavigator(int tabIndex, Widget rootPage) {
    return Navigator(
      key: navigatorKeys[tabIndex],
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => rootPage,
      ),
    );
  }

  void _onTapBottomNavItem(int tappedTabIndex) {
    if (tappedTabIndex == selectedTabIndex) {
      final navState = navigatorKeys[tappedTabIndex].currentState;
      if (navState != null) {
        navState.popUntil((route) => route.isFirst);
      }
    } else {
      setState(() {
        selectedTabIndex = tappedTabIndex;
      });
    }
  }
}
