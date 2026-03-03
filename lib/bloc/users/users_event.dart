part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UsersEvent {}

class SearchUsers extends UsersEvent {
  final String query;

  const SearchUsers(this.query);

  @override
  List<Object> get props => [query];
}

class FilterUsers extends UsersEvent {
  final UserFilterType filterType;

  const FilterUsers(this.filterType);

  @override
  List<Object> get props => [filterType];
}

class DeleteUser extends UsersEvent {
  final String userId;

  const DeleteUser(this.userId);

  @override
  List<Object> get props => [userId];
}

class ToggleUserStatus extends UsersEvent {
  final String userId;
  final bool isActive;

  const ToggleUserStatus(this.userId, this.isActive);

  @override
  List<Object> get props => [userId, isActive];
}

class RefreshUsers extends UsersEvent {}
