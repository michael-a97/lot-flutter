import 'package:equatable/equatable.dart';
export 'sign_up_request.dart';

enum Role { user, attendant }

class UserDto extends Equatable {
  final int id;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final Role role;

  const UserDto({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  @override
  List<Object> get props => [id, phoneNumber, firstName, lastName, role];
}
