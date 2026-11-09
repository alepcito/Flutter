import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://localhost:3000";
  // Cambia esta URL por tu Python backend real cuando tengas acceso

  late final Dio _dio = Dio();

  Future<Map<String, dynamic>> getPerfil() async {
    final response = await _dio.post(
      "$baseUrl/graphql",
      data: jsonEncode({
        "query": """
        { perfil { id nombre email telefono } }
        """,
      }),
      options: Options(headers: {"Content-Type": "application/json"}),
    );

    return response.data;
  }

  Future<Map<String, dynamic>> actualizarTelefono(String telefono) async {
    final response = await _dio.post(
      "$baseUrl/graphql",
      data: jsonEncode({
        "mutation": """
        mutation { actualizar_telefono(telefono: "$telefono") { id nombre email telefono } }
        """,
      }),
    );

    return response.data;
  }
}
