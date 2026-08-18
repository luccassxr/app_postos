class UserModel {
  const UserModel({required this.id, required this.name, required this.cpf, required this.phone, required this.email, required this.passwordHash});

  final String id;
  final String name;
  final String cpf;
  final String phone;
  final String email;
  final String passwordHash;

  Map<String, Object?> toJson() => {'id': id, 'name': name, 'cpf': cpf, 'phone': phone, 'email': email, 'passwordHash': passwordHash};
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(id: json['id'] as String, name: json['name'] as String, cpf: json['cpf'] as String, phone: json['phone'] as String, email: json['email'] as String, passwordHash: json['passwordHash'] as String);
}
