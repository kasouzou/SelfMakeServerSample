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
}