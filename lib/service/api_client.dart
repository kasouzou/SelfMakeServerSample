import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 【公式】パッケージを http という名前で使う
import 'dart:convert';               // 【標準】JSON変換用

class ApiClient {
  // 1. ベースとなるURLを定義
  // ツッコミ：最後を / で終わらせないのがコツ。エンドポイント結合時にミスを防げる。
  static const String baseUrl = 'https://kasouzou.com';

  /// サーバーから全メッセージを取得する
  /// 戻り値: Future<List<dynamic>> (どんな型が入るか不明なリストの予約票)
  Future<List<dynamic>> fetchMessages() async {
    final uri = Uri.parse('$baseUrl/messages');
    
    // ツッコミ：awaitを忘れると、中身ではなく「予約票」そのものを操作しようとしてエラーになるぞ
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // 1. response.body (ただの文字列)をjsonDecode で Dartのオブジェクトに変換
      // ここで [ { "message": "..." }, ... ] という「List」に変わる
      final List<dynamic> decodedData = jsonDecode(response.body);
      return decodedData;
    } else {
      // 失敗した時は、潔くエラーを投げる。これがエラーハンドリングの第一歩だ。
      throw Exception('サーバー接続失敗: ${response.statusCode}');
    }
  }

  /// POST /messages
  /// メッセージをサーバーに送信してDBに保存させる
  Future<void> sendMessage(String text) async {
    final uri = Uri.parse('$baseUrl/messages');

    // 1. 送るデータを Map (連想配列) で作る
    // 【最重要】キー名は FastAPI の schemas.py と一字一句合わせる！
    final Map<String, dynamic> body = {
      'content': text,  
    };

    debugPrint('送信中: $uri, body: $body');

    // 2. HTTP POST リクエスト送信
    final response = await http.post(
      uri,
      // 【ツッコミ】これを忘れるとサーバーは「ただの文字列」として受け取ってしまい失敗する
      headers: {
        'Content-Type': 'application/json',
      },
      // 3. Map を JSON文字列に変換して送る
      body: jsonEncode(body),
    );

    // 4. 結果判定
    if (response.statusCode == 200 || response.statusCode == 201) { // 200:OK, 201:Created
      debugPrint('送信成功！ レスポンス: ${response.body}');
    } else {
      debugPrint('送信失敗: ${response.statusCode}');
      debugPrint('エラー詳細: ${response.body}');
      throw Exception('送信エラー: ${response.statusCode}');
    }
  }
}