class RegisterData {
  int? id;
  String? name;
  RegisterData({
    this.id,
    this.name,
  });

  factory RegisterData.fromMap(Map<String, dynamic> json) => RegisterData(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      "name": name,
    };
  }
}
