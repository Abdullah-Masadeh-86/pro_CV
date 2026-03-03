import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../models/cv_models.dart';
import '../../services/firebase_service.dart';
import '../../widgets/cv_card.dart';
import 'cv_preview_screen.dart';
import 'create_cv_screen.dart';

class CVListScreen extends StatefulWidget {
  const CVListScreen({super.key});

  @override
  State<CVListScreen> createState() => _CVListScreenState();
}

class _CVListScreenState extends State<CVListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<CV> _userCVs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserCVs();
  }

  Future<void> _loadUserCVs() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      if (!mounted) return;
      setState(() {
        _userCVs = [];
        _isLoading = false;
      });
      return;
    }

    final user = authState.user;
    try {
      final cvs = await _firebaseService.getUserCVs(user.uid);
      if (!mounted) return;
      setState(() {
        _userCVs = cvs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading CVs: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My CVs'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userCVs.isEmpty
              ? _buildEmptyState()
              : _buildCVList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => const CreateCVScreen(),
            ),
          );

          if (result == true) {
            await _loadUserCVs();
            if (!mounted) return;
            messenger.showSnackBar(
              const SnackBar(content: Text('CV saved successfully')),
            );
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No CVs yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Create your first professional CV to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => const CreateCVScreen(),
                  ),
                );

                if (result == true) {
                  await _loadUserCVs();
                  if (!mounted) return;
                  messenger.showSnackBar(
                    const SnackBar(content: Text('CV saved successfully')),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Your First CV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCVList() {
    return RefreshIndicator(
      onRefresh: _loadUserCVs,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: _userCVs.length,
        itemBuilder: (context, index) {
          final cv = _userCVs[index];
          return CVCard(
            cv: cv,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CVPreviewScreen(cv: cv),
                ),
              );
            },
            onEdit: () async {
              final messenger = ScaffoldMessenger.of(context);
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateCVScreen(cv: cv),
                ),
              );

              if (result == true) {
                await _loadUserCVs();
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(content: Text('CV updated successfully')),
                );
              }
            },
            onDelete: () => _showDeleteDialog(cv),
            onPreview: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CVPreviewScreen(cv: cv),
                ),
              );
            },
            onDownload: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download feature coming soon!')),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(CV cv) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete CV'),
        content: Text('Are you sure you want to delete "${cv.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await _firebaseService.deleteCV(cv.id);
                _loadUserCVs();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('CV deleted successfully')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting CV: $e')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
