import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/users/users_bloc.dart';
import '../../models/user_model.dart';
import '../../widgets/user_card.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  UserFilterType _currentFilter = UserFilterType.all;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Load users when screen initializes
    context.read<UsersBloc>().add(LoadUsers());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<UsersBloc>().add(SearchUsers(_searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<UsersBloc>().add(RefreshUsers()),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(child: _buildUsersList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search users...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', UserFilterType.all),
            const SizedBox(width: 8),
            _buildFilterChip('Active', UserFilterType.active),
            const SizedBox(width: 8),
            _buildFilterChip('Inactive', UserFilterType.inactive),
            const SizedBox(width: 8),
            _buildFilterChip('Premium', UserFilterType.premium),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, UserFilterType filter) {
    return FilterChip(
      label: Text(label),
      selected: _currentFilter == filter,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentFilter = filter;
          });
          context.read<UsersBloc>().add(FilterUsers(filter));
        }
      },
    );
  }

  Widget _buildUsersList() {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UsersError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<UsersBloc>().add(LoadUsers()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is UsersLoaded) {
          if (state.filteredUsers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No users found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.filteredUsers.length,
            itemBuilder: (context, index) {
              final user = state.filteredUsers[index];
              return UserCard(
                user: user,
                onTap: () => _showUserDetails(user),
                onEdit: () => _editUser(user),
                onDelete: () => _deleteUser(user),
                onToggleStatus: () => _toggleUserStatus(user),
              );
            },
          );
        }

        return const Center(child: Text('Something went wrong'));
      },
    );
  }

  void _showUserDetails(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user.email}'),
            Text('Role: ${user.role}'),
            Text('Status: ${user.isActive ? 'Active' : 'Inactive'}'),
            Text('Subscription: ${user.subscription}'),
            Text('CVs: ${user.cvCount}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editUser(UserModel user) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit feature coming soon!')),
    );
  }

  void _deleteUser(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<UsersBloc>().add(DeleteUser(user.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleUserStatus(UserModel user) {
    context.read<UsersBloc>().add(ToggleUserStatus(user.id, !user.isActive));
  }
}
