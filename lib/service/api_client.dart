//ダミー通信層を作る　ここが将来 HTTP / TCP / gRPC に置き換わる

import 'package:flutter/material.dart';

class ApiClient {
  // 内容を送信する
  Future<void> sendMessage(String message) async {
    // 今は何もしない
    debugPrint('サーバーへ送信した内容: $message');
  }

  // 内容を取得する
  Future<String> fetchMessage() async {
    return 'サーバーからのデータ';
  }
}
