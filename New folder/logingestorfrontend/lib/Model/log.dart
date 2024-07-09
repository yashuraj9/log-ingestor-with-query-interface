
class Log {
  final int id;
  final String level;
  final String message;
  final String resourceId;
  final String timestamp;
  final String traceId;
  final String spanId;
  final String commit;
  final String metadata;

  Log ({
    required this.id,
    required this.level,
    required this.message,
    required this.resourceId,
    required this.timestamp,
    required this.traceId,
    required this.spanId,
    required this.commit,
    required this.metadata,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'] ?? '',
      level: json['level'] ?? '',
      message: json['message'] ?? '',
      resourceId: json['resourceId'] ?? '',
      timestamp: json['timestamp'] ?? '',
      traceId: json['traceId'] ?? '',
      spanId: json['spanId'] ?? '',
      commit: json['commit'] ?? '',
      metadata: json['metadata'] ?? '',
    );
  }

  Map<String,dynamic> toJson() {
    return {
      'level': level,
      'message': message,
      'resourceId': resourceId,
      'timestamp': timestamp,
      'traceId': traceId,
      'spanId': spanId,
      'commit': commit,
      'metadata': metadata,
    };
  }
}