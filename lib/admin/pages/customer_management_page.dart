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
  Map<String, Map<String, dynamic>> _profileCache = {};
  String? _loadedUserIdsKey;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshProfileCache(List<QueryDocumentSnapshot> users) async {
    if (users.isEmpty) {
      if (mounted) setState(() => _profileCache = {});
      return;
    }

    final entries = await Future.wait(
      users.map((doc) async {
        final snap =
            await doc.reference.collection('profile').doc('data').get();
        return MapEntry(doc.id, snap.data() ?? <String, dynamic>{});
      }),
    );

    if (!mounted) return;

    final cache = Map<String, Map<String, dynamic>>.fromEntries(entries);
    setState(() => _profileCache = cache);

    for (final doc in users) {
      _maybeBackfillIdentity(
        doc.id,
        doc.data() as Map<String, dynamic>,
        cache[doc.id],
      );
    }
  }

  void _maybeBackfillIdentity(
    String userId,
    Map<String, dynamic> root,
    Map<String, dynamic>? profile,
  ) {
    if (profile == null || profile.isEmpty) return;

    final resolvedName = UserService.resolveDisplayName(root, profile);
    final resolvedEmail = UserService.resolveEmail(root, profile);
    final updates = <String, dynamic>{};

    if ((root['displayName'] ?? '').toString().trim().isEmpty &&
        resolvedName.isNotEmpty) {
      updates['displayName'] = resolvedName;
    }
    if ((root['email'] ?? '').toString().trim().isEmpty &&
        resolvedEmail.isNotEmpty) {
      updates['email'] = resolvedEmail;
    }
    if (updates.isEmpty) return;

    _firestore.collection('users').doc(userId).set(
          updates,
          SetOptions(merge: true),
        );
  }

  bool _matchesSearch(
    Map<String, dynamic> userData,
    String userId,
    String query,
  ) {
    if (query.isEmpty) return true;

    final profile = _profileCache[userId];
    final name =
        UserService.resolveDisplayName(userData, profile).toLowerCase();
    final email = UserService.resolveEmail(userData, profile).toLowerCase();
    return name.contains(query) || email.contains(query);
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
                final userIdsKey = users.map((doc) => doc.id).join('|');
                if (_loadedUserIdsKey != userIdsKey) {
                  _loadedUserIdsKey = userIdsKey;
                  _refreshProfileCache(users);
                }

                if (_searchQuery.isNotEmpty) {
                  users = users.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _matchesSearch(data, doc.id, _searchQuery);
                  }).toList();
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userDoc = users[index];
                    final userData = userDoc.data() as Map<String, dynamic>;
                    final profile = _profileCache[userDoc.id];

                    return _UserListTile(
                      userId: userDoc.id,
                      userData: userData,
                      profileData: profile,
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
  final Map<String, dynamic>? profileData;
  final VoidCallback onDelete;

  const _UserListTile({
    required this.userId,
    required this.userData,
    this.profileData,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final name = UserService.resolveDisplayName(userData, profileData);
    final email = UserService.resolveEmail(userData, profileData);
    final displayName = name.isNotEmpty ? name : 'No name';
    final displayEmail = email.isNotEmpty ? email : 'No email';
    final isAdmin = userData['isAdmin'] == true;
    final isSuspended = userData['isSuspended'] == true;
    final isBlocked = userData['isBlocked'] == true;
    final proGranted = userData['proGranted'] == true;

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
            name: displayName,
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
                      displayName,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AdminTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isAdmin) _statusBadge('Admin', AdminTheme.cardPurple),
                    if (proGranted)
                      _statusBadge('Pro', AdminTheme.primary),
                    if (isSuspended)
                      _statusBadge('Suspended', AdminTheme.warning),
                    if (isBlocked) _statusBadge('Blocked', AdminTheme.error),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  displayEmail,
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
        profileData: profileData,
      ),
    );
  }
}

class _UserEditDialog extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;
  final Map<String, dynamic>? profileData;

  const _UserEditDialog({
    required this.userId,
    required this.userData,
    this.profileData,
  });

  @override
  State<_UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<_UserEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late bool _isSuspended;
  late bool _isBlocked;
  late bool _proGranted;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final resolvedName =
        UserService.resolveDisplayName(widget.userData, widget.profileData);
    final resolvedEmail =
        UserService.resolveEmail(widget.userData, widget.profileData);
    _nameController = TextEditingController(text: resolvedName);
    _emailController = TextEditingController(text: resolvedEmail);
    _isSuspended = widget.userData['isSuspended'] == true;
    _isBlocked = widget.userData['isBlocked'] == true;
    _proGranted = widget.userData['proGranted'] == true;
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
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'displayName': name,
        'email': email,
        'isSuspended': _isSuspended,
        'isBlocked': _isBlocked,
        'proGranted': _proGranted,
      });

      if (name.isNotEmpty || email.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('profile')
            .doc('data')
            .set(
          {
            if (name.isNotEmpty) 'fullName': name,
            if (email.isNotEmpty) 'email': email,
          },
          SetOptions(merge: true),
        );
      }

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
            const SizedBox(height: 12),
            _switchRow(
                'Pro Features',
                Icons.workspace_premium_rounded,
                AdminTheme.primary,
                _proGranted,
                (v) => setState(() => _proGranted = v)),
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
