import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';
import '../../services/firebase_service.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final FirebaseService _firebaseService;

  UsersBloc(this._firebaseService) : super(UsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<SearchUsers>(_onSearchUsers);
    on<FilterUsers>(_onFilterUsers);
    on<DeleteUser>(_onDeleteUser);
    on<ToggleUserStatus>(_onToggleUserStatus);
    on<RefreshUsers>(_onRefreshUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      final users = await _firebaseService.getAllUsers();
      emit(UsersLoaded(users: users, filteredUsers: users));
    } catch (e) {
      emit(UsersError(message: 'Failed to load users: $e'));
    }
  }

  Future<void> _onSearchUsers(SearchUsers event, Emitter<UsersState> emit) async {
    if (state is UsersLoaded) {
      final currentState = state as UsersLoaded;
      final filteredUsers = currentState.users.where((user) {
        final query = event.query.toLowerCase();
        return user.displayName.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query) ||
            user.role.toLowerCase().contains(query);
      }).toList();
      
      emit(currentState.copyWith(filteredUsers: filteredUsers));
    }
  }

  Future<void> _onFilterUsers(FilterUsers event, Emitter<UsersState> emit) async {
    if (state is UsersLoaded) {
      final currentState = state as UsersLoaded;
      var filteredUsers = List<UserModel>.from(currentState.users);
      
      switch (event.filterType) {
        case UserFilterType.active:
          filteredUsers = filteredUsers.where((user) => user.isActive).toList();
          break;
        case UserFilterType.inactive:
          filteredUsers = filteredUsers.where((user) => !user.isActive).toList();
          break;
        case UserFilterType.premium:
          filteredUsers = filteredUsers.where((user) => user.isPremium).toList();
          break;
        case UserFilterType.recent:
          filteredUsers = filteredUsers.where((user) => user.isRecent).toList();
          break;
        case UserFilterType.all:
          break;
      }
      
      emit(currentState.copyWith(filteredUsers: filteredUsers));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UsersState> emit) async {
    if (state is UsersLoaded) {
      try {
        await _firebaseService.deleteUser(event.userId);
        final currentState = state as UsersLoaded;
        final updatedUsers = currentState.users.where((user) => user.id != event.userId).toList();
        final updatedFiltered = currentState.filteredUsers.where((user) => user.id != event.userId).toList();
        
        emit(currentState.copyWith(
          users: updatedUsers,
          filteredUsers: updatedFiltered,
        ));
        
        emit(UsersOperationSuccess(message: 'User deleted successfully'));
      } catch (e) {
        emit(UsersError(message: 'Failed to delete user: $e'));
      }
    }
  }

  Future<void> _onToggleUserStatus(ToggleUserStatus event, Emitter<UsersState> emit) async {
    if (state is UsersLoaded) {
      try {
        await _firebaseService.toggleUserStatus(event.userId, event.isActive);
        final currentState = state as UsersLoaded;
        final updatedUsers = currentState.users.map((user) {
          if (user.id == event.userId) {
            return user.copyWith(isActive: event.isActive);
          }
          return user;
        }).toList();
        
        final updatedFiltered = currentState.filteredUsers.map((user) {
          if (user.id == event.userId) {
            return user.copyWith(isActive: event.isActive);
          }
          return user;
        }).toList();
        
        emit(currentState.copyWith(
          users: updatedUsers,
          filteredUsers: updatedFiltered,
        ));
        
        emit(UsersOperationSuccess(
          message: event.isActive ? 'User activated successfully' : 'User deactivated successfully'
        ));
      } catch (e) {
        emit(UsersError(message: 'Failed to update user status: $e'));
      }
    }
  }

  Future<void> _onRefreshUsers(RefreshUsers event, Emitter<UsersState> emit) async {
    add(LoadUsers());
  }
}

enum UserFilterType { all, active, inactive, premium, recent }
