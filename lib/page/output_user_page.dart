// コミットの内容を編集・作成するページ。
import 'package:flutter/material.dart';


class OutputUserPage extends StatefulWidget {
  const OutputUserPage({
    super.key,
  });

  @override
  State<OutputUserPage> createState() => _OutputUserState();
}

class _OutputUserState extends State<OutputUserPage> {
  late TextEditingController _commitContentsController;

  @override
  void initState() {
    super.initState();
    // 初期値として前回のコミット内容をセット
    _commitContentsController = TextEditingController();
  }

  @override
  void dispose() {
    _commitContentsController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    // 画面の高さなどの情報を取得
    final mediaQuery = MediaQuery.of(context);
    // キーボード判定
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,      // ここは「画面上側スタート」
          end: Alignment.bottomCenter,     // ここは「画面下側に向かう」
          colors: [
            // Color.fromARGB(255, 249, 136, 194),
            // Color.fromARGB(255, 0, 204, 255), 
            // Color.fromARGB(193, 0, 5, 79),
            Color.fromARGB(255, 255, 0, 132),
            Color.fromARGB(255, 255, 0, 119),
            Color.fromARGB(255, 0, 255, 47),
            Color.fromARGB(255, 0, 79, 1),
            // Color.fromARGB(255, 0, 255, 47), 
            // Color.fromARGB(255, 0, 79, 1),
          ],
        ),
      ),     
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            '自宅サーバーから受信するページ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          // ここで全体をスクロール可能にする
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: mediaQuery.viewInsets.bottom + 16.0, // キーボード分＋余白
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 23, 140, 0),
                    ),
                    onPressed: () async {
                      // 編集後の内容を取得
                      final editingCommitContents = _commitContentsController.text;
                      debugPrint('サーバーからの受信ボタンが押されました。');
                      debugPrint('サーバーからの受信内容：$editingCommitContents');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.move_to_inbox,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'サーバーから受信',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),
                  
                  // 【修正ポイント】Expanded を削除しました。
                  // SingleChildScrollView の中では Expanded は使えません。
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        // 背景色に合わせて枠線が見えるように調整（任意）
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // ここにあった SingleChildScrollView も削除（親でスクロールさせているため不要）
                    child: TextField(
                      controller: _commitContentsController,
                      maxLines: null, // 無制限に伸びる
                      minLines: 15,   // 【重要】Expandedの代わりに高さを確保する
                      readOnly: true,  // 編集不可に設定
                      // keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        // border: InputBorder.none,
                        hintText: 'ここにサーバーからの受信内容が表示されます。',
                        filled:true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),                      
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}