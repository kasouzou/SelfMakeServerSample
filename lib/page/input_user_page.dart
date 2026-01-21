// コミットの内容を編集・作成するページ。
import 'package:flutter/material.dart';
import 'package:selfmakeserver/service/api_client.dart';


class InputUserPage extends StatefulWidget {
  const InputUserPage({
    super.key,
  });

  @override
  State<InputUserPage> createState() => _InputUserState();
}

class _InputUserState extends State<InputUserPage> {
  late TextEditingController _commitContentsController;
  // late の意味 「initStateで必ず初期化するからnullにならないよ」という約束を表します。

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
            Color.fromARGB(255, 255, 0, 132),
            Color.fromARGB(255, 0, 204, 255),
          ],
        ),
      ),     
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            '自宅サーバーに送信するページ',
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
                      backgroundColor: const Color.fromARGB(255, 0, 157, 255),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      // 1. 入力されたテキストを取得
                      final text = _commitContentsController.text;

                      // 空文字なら何もしない（ガード節）
                      if (text.isEmpty) {
                        debugPrint('文字が入ってないぞ');
                        return;
                      }

                      // キーボードを閉じる（UX向上）
                      FocusScope.of(context).unfocus();

                      try {
                        final apiClient = ApiClient();
                        
                        // 2. 送信実行！
                        await apiClient.sendMessage(text);

                        // 3. 成功したら入力欄をクリア
                        _commitContentsController.clear();

                        // ユーザーにフィードバック（スナックバー）
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('サーバーに保存しました！'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                      } catch (e) {
                        // エラー時のフィードバック
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('送信失敗: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'サーバーに送信',
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
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        // border: InputBorder.none,
                        hintText: 'サーバーに送信する内容を入力してください。',
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