class UserModel {
  String uID;
  String? email;
  String? password;
  List<String> channels;

  UserModel({
    required this.uID,
    this.email,
    this.password,
    this.channels = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uID: data['uID'],
      email: data['email'],
      password: data['password'],
      channels: (data['channels'] as List<String>?)?.toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uID': uID,
      'email': email,
      'password': password,
      'channels': channels.toList(),
    };
  }
}
