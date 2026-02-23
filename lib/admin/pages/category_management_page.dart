import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/admin_theme.dart';
import '../../constants/diet_categories.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final _firestore = FirebaseFirestore.instance;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Initialize categories from hardcoded list if Firestore is empty
  Future<void> _initializeCategories() async {
    final snapshot = await _firestore.collection('diet_categories').get();
    if (snapshot.docs.isEmpty) {
      // Prepopulate with default categories
      for (final category in DietCategories.categories) {
        await _firestore.collection('diet_categories').add({
          'name': category['name'],
          'key': category['key'],
          'emoji': category['emoji'],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Diet Categories',
                              style: Theme.of(context).textTheme.headlineLarge),
                          const SizedBox(height: 4),
                          Text('Manage diet categories for recipes',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showAddCategoryDialog(),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Add Category'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
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

          // Categories list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('diet_categories').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: AdminTheme.primary));
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}',
                        style:
                            GoogleFonts.inter(color: AdminTheme.textSecondary)),
                  );
                }

                var categories = snapshot.data?.docs ?? [];

                if (_searchQuery.isNotEmpty) {
                  categories = categories.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    final key = (data['key'] ?? '').toString().toLowerCase();
                    return name.contains(_searchQuery) ||
                        key.contains(_searchQuery);
                  }).toList();
                }

                if (categories.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No categories found. Add one to get started!'
                          : 'No categories match your search.',
                      style: GoogleFonts.inter(color: AdminTheme.textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final doc = categories[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final emoji = data['emoji'] ?? '🍽️';
                    final name = data['name'] ?? 'Unnamed';
                    final key = data['key'] ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AdminTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AdminTheme.border),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AdminTheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(emoji,
                                style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                        title: Text(name,
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AdminTheme.textPrimary)),
                        subtitle: Text('Key: $key',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: AdminTheme.textSecondary)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_rounded, size: 20),
                              color: AdminTheme.textSecondary,
                              onPressed: () =>
                                  _showEditCategoryDialog(doc.id, data),
                              tooltip: 'Edit',
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 20),
                              color: AdminTheme.error,
                              onPressed: () => _deleteCategory(doc.id, name),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ),
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

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => const _CategoryEditDialog(),
    );
  }

  void _showEditCategoryDialog(String docId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => _CategoryEditDialog(
        docId: docId,
        categoryData: data,
      ),
    );
  }

  Future<void> _deleteCategory(String docId, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _firestore.collection('diet_categories').doc(docId).delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting category: $e')),
          );
        }
      }
    }
  }
}

class _CategoryEditDialog extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? categoryData;

  const _CategoryEditDialog({
    this.docId,
    this.categoryData,
  });

  @override
  State<_CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<_CategoryEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _keyController;
  late TextEditingController _emojiController;
  bool _isLoading = false;

  // Common food emojis for quick selection
  final List<String> _commonEmojis = [
    '🌱',
    '🥗',
    '🌿',
    '🤏',
    '🐟',
    '🥩',
    '🥑',
    '🍖',
    '🌾',
    '🥛',
    '🧼',
    '🍎',
    '🫒',
    '❤️',
    '🍽️',
    '🥘',
    '🍲',
    '🥙',
    '🌮',
    '🍱',
    '🍜',
    '🍝',
    '🥗',
    '🥙',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.categoryData?['name'] ?? '',
    );
    _keyController = TextEditingController(
      text: widget.categoryData?['key'] ?? '',
    );
    _emojiController = TextEditingController(
      text: widget.categoryData?['emoji'] ?? '🍽️',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _keyController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (_nameController.text.isEmpty ||
        _keyController.text.isEmpty ||
        _emojiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final categoryData = {
        'name': _nameController.text.trim(),
        'key': _keyController.text.trim(),
        'emoji': _emojiController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.docId == null) {
        categoryData['createdAt'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance
            .collection('diet_categories')
            .add(categoryData);
      } else {
        await FirebaseFirestore.instance
            .collection('diet_categories')
            .doc(widget.docId)
            .update(categoryData);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.docId == null
                  ? 'Category added successfully'
                  : 'Category updated successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving category: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.docId != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 540,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AdminTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.category_rounded,
                      color: AdminTheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  isEditing ? 'Edit Category' : 'Add Category',
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AdminTheme.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Category Name *',
                        hintText: 'e.g., Vegan Diet',
                        prefixIcon: Icon(Icons.label_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _keyController,
                      decoration: const InputDecoration(
                        labelText: 'Category Key *',
                        hintText: 'e.g., vegan (lowercase, no spaces)',
                        prefixIcon: Icon(Icons.key_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emojiController,
                      decoration: const InputDecoration(
                        labelText: 'Emoji *',
                        hintText: 'Select or paste emoji',
                        prefixIcon: Icon(Icons.emoji_emotions_rounded),
                      ),
                      maxLength: 2,
                    ),
                    const SizedBox(height: 20),
                    Text('Quick Emoji Selection',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AdminTheme.textPrimary)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _commonEmojis.map((emoji) {
                        final isSelected = _emojiController.text == emoji;
                        return GestureDetector(
                          onTap: () {
                            _emojiController.text = emoji;
                            setState(() {});
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AdminTheme.primary.withValues(alpha: 0.1)
                                  : AdminTheme.surface,
                              border: Border.all(
                                color: isSelected
                                    ? AdminTheme.primary
                                    : AdminTheme.border,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(emoji,
                                  style: const TextStyle(fontSize: 22)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text('Cancel',
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AdminTheme.textSecondary)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text('Save',
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
