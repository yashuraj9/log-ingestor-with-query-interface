import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

import '../Model/log.dart';

class ApiService{
  static const String url = 'http://localhost:8080/logs';


  static Future<List<Log>> fetchLogs() async{
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Log> logs = body.map((dynamic item) => Log.fromJson(item)).toList();
      return logs;
    } else {
      throw Exception("Failed to load logs");
    }
  } 

  static Future<List<Log>> searchLogs({
    String? level,
    String? message,
    String? resourceId,
    String? timestamp,
    String? traceId,
    String? spanId,
    String? commit,
    String? metadata,
  }) async {
    final queryParameters = {
      'level': level,
      'message': message,
      'resourceId': resourceId,
      'timestamp': timestamp,
      'traceId': traceId,
      'spanId': spanId,
      'commit': commit,
      'metadata': metadata,
    }..removeWhere((key,value) => value == null || value.isEmpty);

    final uri = Uri.http('localhost:8080', '/logs/search', queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((log) => Log.fromJson(log)).toList();
    } else {
      throw Exception("Failed to search logs");
    }
  }

  static Future<void> deleteLog(int logId) async {
    final url = Uri.parse('http://localhost:8080/logs/${logId}');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        //Log deleted successfully
      } else {
        throw Exception("Failed to delete log");
      }
  } catch (e) {
    throw Exception("Failed to delete log: $e");
  }
}
}