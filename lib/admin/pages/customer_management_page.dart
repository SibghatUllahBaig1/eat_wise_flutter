import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../backend/firestore/user_service.dart';
import '../theme/admin_theme.dart';

class CustomerManagementPage extends StatefulWidget {
  const CustomerManagementPage({super.key});

  @override
  State<CustomerManagementPage> createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  final _firestore = FirebaseFirestore.instance;
  final _userService = UserService();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customers',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text('Manage user accounts and permissions',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or email...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xFFB0B8C4), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AdminTheme.primary, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // User list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: AdminTheme.primary));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No users found',
                        style:
                            GoogleFonts.inter(color: AdminTheme.textSecondary)),
                  );
                }

                var users = snapshot.data!.docs;

                if (_searchQuery.isNotEmpty) {
                  users = users.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name =
                        (data['displayName'] ?? '').toString().toLowerCase();
                    final email =
                        (data['email'] ?? '').toString().toLowerCase();
                    return name.contains(_searchQuery) ||
                        email.contains(_searchQuery);
                  }).toList();
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userDoc = users[index];
                    final userData = userDoc.data() as Map<String, dynamic>;

                    return _UserListTile(
                      userId: userDoc.id,
                      userData: userData,
                      onDelete: () => _deleteUser(userDoc.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text(
          'Are you sure you want to delete this user? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _userService.deleteUserAccount(userId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('User deleted successfully'),
              backgroundColor: AdminTheme.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting user: $e'),
              backgroundColor: AdminTheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}

Widget _statusBadge(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: GoogleFonts.inter(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _UserListTile extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userData;
  final VoidCallback onDelete;

  const _UserListTile({
    required this.userId,
    required this.userData,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final name = userData['displayName'] ?? 'No name';
    final email = userData['email'] ?? 'No email';
    final isAdmin = userData['isAdmin'] == true;
    final isSuspended = userData['isSuspended'] == true;
    final isBlocked = userData['isBlocked'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminTheme.border),
      ),
      child: Row(
        children: [
          _buildProfileAvatar(
            name: name,
            photoUrl: userData['photoUrl'] as String?,
            isAdmin: isAdmin,
            isSuspended: isSuspended,
            isBlocked: isBlocked,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AdminTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isAdmin) _statusBadge('Admin', AdminTheme.cardPurple),
                    if (isSuspended)
                      _statusBadge('Suspended', AdminTheme.warning),
                    if (isBlocked) _statusBadge('Blocked', AdminTheme.error),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AdminTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, size: 20),
            color: AdminTheme.textSecondary,
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            color: AdminTheme.error,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar({
    required String name,
    String? photoUrl,
    required bool isAdmin,
    required bool isSuspended,
    required bool isBlocked,
  }) {
    final backgroundColor = isAdmin
        ? AdminTheme.cardPurple
        : isSuspended || isBlocked
            ? AdminTheme.error
            : AdminTheme.primary;

    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: 22,
      backgroundImage: photoUrl != null && photoUrl.isNotEmpty
          ? CachedNetworkImageProvider(photoUrl)
          : null,
      child: photoUrl == null || photoUrl.isEmpty
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            )
          : null,
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _UserEditDialog(
        userId: userId,
        userData: userData,
      ),
    );
  }
}

class _UserEditDialog extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const _UserEditDialog({
    required this.userId,
    required this.userData,
  });

  @override
  State<_UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<_UserEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late bool _isSuspended;
  late bool _isBlocked;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.userData['displayName'] ?? '');
    _emailController =
        TextEditingController(text: widget.userData['email'] ?? '');
    _isSuspended = widget.userData['isSuspended'] == true;
    _isBlocked = widget.userData['isBlocked'] == true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'displayName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'isSuspended': _isSuspended,
        'isBlocked': _isBlocked,
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('User updated successfully'),
            backgroundColor: AdminTheme.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating user: $e'),
            backgroundColor: AdminTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 440,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AdminTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_rounded,
                      color: AdminTheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Text('Edit User',
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AdminTheme.textPrimary)),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_rounded),
              ),
            ),
            const SizedBox(height: 20),
            _switchRow(
                'Suspended',
                Icons.pause_circle_rounded,
                AdminTheme.warning,
                _isSuspended,
                (v) => setState(() => _isSuspended = v)),
            const SizedBox(height: 12),
            _switchRow('Blocked', Icons.block_rounded, AdminTheme.error,
                _isBlocked, (v) => setState(() => _isBlocked = v)),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Save Changes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchRow(String label, IconData icon, Color color, bool value,
      ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: value ? color.withValues(alpha: 0.06) : AdminTheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: value ? color.withValues(alpha: 0.3) : AdminTheme.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? color : AdminTheme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AdminTheme.textPrimary))),
          Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: color,
              activeTrackColor: color.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
