class Driver {
  final String id;
  final String firstName;
  final String lastName;

  Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
