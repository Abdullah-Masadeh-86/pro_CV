part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserModel> users;
  final List<UserModel> filteredUsers;

  const UsersLoaded({
    required this.users,
    required this.filteredUsers,
  });

  @override
  List<Object> get props => [users, filteredUsers];

  UsersLoaded copyWith({
    List<UserModel>? users,
    List<UserModel>? filteredUsers,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
    );
  }
}

class UsersError extends UsersState {
  final String message;

  const UsersError({required this.message});

  @override
  List<Object> get props => [message];
}

class UsersOperationSuccess extends UsersState {
  final String message;

  const UsersOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
