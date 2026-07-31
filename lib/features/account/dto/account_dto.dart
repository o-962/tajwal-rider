/// The rider's account details, as returned by `GET /auth/sign/account`.
class AccountDto {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String phoneNumber;

  const AccountDto({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
  });

  String get fullName => [firstName, lastName]
      .where((p) => p.trim().isNotEmpty)
      .join(' ')
      .trim();

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => (v ?? '').toString();
    return AccountDto(
      firstName: s(json['firstName']),
      lastName: s(json['lastName']),
      userName: s(json['userName']),
      email: s(json['email']),
      phoneNumber: s(json['phoneNumber']),
    );
  }
}
