//ダミー通信層を作る　ここが将来 HTTP / TCP / gRPC に置き換わる

import 'dart:convert';
import 'package:http/http.dart' as http;

/// user-defined: 自宅サーバーとの通信を担当するクラス
class ApiClient {
  /// user-defined: サーバーのベースURL
  static const String baseUrl = 'http://192.168.1.2:8000';
  
  /// POST /message を叩く
  Future<void> sendMessage(String message) async {
    final uri = Uri.parse('$baseUrl/message');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('送信に失敗しました: ${response.statusCode}');
    }
  }

  Future<String?> fetchMessage() async {
    final uri = Uri.parse('$baseUrl/message');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('取得に失敗しました: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    return decoded['message'];
  }
}

