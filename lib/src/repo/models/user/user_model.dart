import 'dart:convert';

class User {
  final int? id;
  final String? email;
  final String? phone;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;
  final String? token;
  final String? code;

  const User({
    this.id,
    this.email,
    this.phone,
    this.username,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
    this.token,
    this.code,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      image: json['image'],
      token: json['token'],
      code: json['code'],
    );
  }
}

User modelUser(data) {
  return User.fromJson(jsonDecode(data));
}
