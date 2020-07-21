class LogDTO {
  final int user_id;
  final String action;
  final String user_name;
  final String date_create;

  LogDTO({
    this.user_id,
    this.action,
    this.user_name,
    this.date_create,
  });

  factory LogDTO.fromJson(Map<String, dynamic> json) {
    return LogDTO(
      user_id: json['user_id'],
      action: json['action'],
      user_name: json['user_name'],
      date_create: json['date_create'],
    );
  }
}
