//ダミー通信層を作る　ここが将来 HTTP / TCP / gRPC に置き換わる

import 'dart:convert';
import 'package:http/http.dart' as http;

/// user-defined: 自宅サーバーとの通信を担当するクラス
class ApiClient {
  /// user-defined: サーバーのベースURL
  static const String baseUrl = 'http://192.168.1.4:8000';

  /// GET /hello を叩く
  Future<String> fetchHello() async {
    final uri = Uri.parse('$baseUrl/hello'); // Uri.parse は公式関数

    final response = await http.get(uri); // http.get は公式API

    if (response.statusCode != 200) {
      throw Exception('HTTP error: ${response.statusCode}');
    }

    // response.body は String（JSON文字列）
    final decoded = jsonDecode(response.body); // dart:convert の公式関数
    return decoded['message']; // FastAPI が返す JSON 構造に依存
  }
}

