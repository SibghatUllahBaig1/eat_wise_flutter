import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../backend/firestore/recipe_service.dart';
import '../theme/admin_theme.dart';
import '../utils/upload_hardcoded_recipes.dart';

class RecipeManagementPage extends StatefulWidget {
  const RecipeManagementPage({super.key});

  @override
  State<RecipeManagementPage> createState() => _RecipeManagementPageState();
}

class _RecipeManagementPageState extends State<RecipeManagementPage> {
  final _recipeService = RecipeService();
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recipes',
                              style: Theme.of(context).textTheme.headlineLarge),
                          const SizedBox(height: 4),
                          Text('Manage recipes and meal plans',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _uploadHardcodedRecipes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Upload Hardcoded Recipes'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _showAddRecipeDialog(),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Add Recipe'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search recipes...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFFB0B8C4), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AdminTheme.primary, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('diet_categories')
                          .snapshots(),
                      builder: (context, snapshot) {
                        final categories = snapshot.data?.docs ?? [];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AdminTheme.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFFB0B8C4), width: 1.5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              hint: Text('All Categories',
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AdminTheme.textHint)),
                              style: GoogleFonts.inter(
                                  fontSize: 14, color: AdminTheme.textPrimary),
                              items: [
                                DropdownMenuItem(
                                    value: null,
                                    child: Text('All Categories',
                                        style:
                                            GoogleFonts.inter(fontSize: 14))),
                                ...categories.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  final categoryName = data['name'] ?? '';
                                  return DropdownMenuItem(
                                      value: categoryName,
                                      child: Text(categoryName,
                                          style:
                                              GoogleFonts.inter(fontSize: 14)));
                                }),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Recipe list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('recipes').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: AdminTheme.primary));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text('No recipes found',
                          style: GoogleFonts.inter(
                              color: AdminTheme.textSecondary)));
                }

                var recipes = snapshot.data!.docs;

                if (_searchQuery.isNotEmpty) {
                  recipes = recipes.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    return name.contains(_searchQuery);
                  }).toList();
                }

                if (_selectedCategory != null) {
                  recipes = recipes.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final categories =
                        List<String>.from(data['dietCategories'] ?? []);
                    return categories.contains(_selectedCategory);
                  }).toList();
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipeDoc = recipes[index];
                    final recipeData = recipeDoc.data() as Map<String, dynamic>;
                    return _RecipeCard(
                      recipeId: recipeDoc.id,
                      recipeData: recipeData,
                      onEdit: () =>
                          _showEditRecipeDialog(recipeDoc.id, recipeData),
                      onDelete: () => _deleteRecipe(recipeDoc.id),
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

  Future<void> _uploadHardcodedRecipes() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Hardcoded Recipes'),
        content: const Text(
          'This will upload 10 hardcoded recipes to Firebase. This should only be done once. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Upload'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Show loading dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Uploading recipes...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      try {
        final result = await uploadHardcodedRecipes();

        if (mounted) {
          Navigator.pop(context); // Close loading dialog

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Upload complete! Success: ${result['success']}, Errors: ${result['errors']}',
              ),
              backgroundColor:
                  result['errors'] == 0 ? AdminTheme.success : Colors.orange,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Close loading dialog

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error uploading recipes: $e'),
              backgroundColor: AdminTheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _showAddRecipeDialog() {
    showDialog(
      context: context,
      builder: (context) => const _RecipeEditDialog(),
    );
  }

  void _showEditRecipeDialog(String recipeId, Map<String, dynamic> recipeData) {
    showDialog(
      context: context,
      builder: (context) => _RecipeEditDialog(
        recipeId: recipeId,
        recipeData: recipeData,
      ),
    );
  }

  Future<void> _deleteRecipe(String recipeId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text('Are you sure you want to delete this recipe?'),
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
        await _recipeService.deleteRecipe(recipeId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Recipe deleted successfully'),
              backgroundColor: AdminTheme.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting recipe: $e'),
              backgroundColor: AdminTheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}

class _RecipeCard extends StatelessWidget {
  final String recipeId;
  final Map<String, dynamic> recipeData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RecipeCard({
    required this.recipeId,
    required this.recipeData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final name = recipeData['name'] ?? 'Unnamed Recipe';
    final imageUrl = recipeData['imageUrl'] ?? '';
    final calories = recipeData['calories'] ?? 0;
    final categories = List<String>.from(recipeData['dietCategories'] ?? []);

    // Debug: Log recipe data
    debugPrint(
        'Recipe Card - Name: $name, ImageUrl: $imageUrl, Calories: $calories');

    return Container(
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AdminTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AdminTheme.background,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading image: $imageUrl - $error');
                      return Container(
                        color: AdminTheme.background,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant_menu_rounded,
                                size: 48,
                                color:
                                    AdminTheme.primary.withValues(alpha: 0.4)),
                            const SizedBox(height: 8),
                            Text(
                              'Image failed to load',
                              style: TextStyle(
                                fontSize: 12,
                                color: AdminTheme.textSecondary,
                              ),
                            ),
                          ],
                        )),
                      );
                    },
                  )
                : Container(
                    color: AdminTheme.background,
                    child: Center(
                        child: Icon(Icons.restaurant_menu_rounded,
                            size: 48,
                            color: AdminTheme.primary.withValues(alpha: 0.4))),
                  ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AdminTheme.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded,
                        size: 14, color: AdminTheme.cardOrange),
                    const SizedBox(width: 4),
                    Text('$calories cal',
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AdminTheme.textSecondary)),
                  ],
                ),
                if (categories.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: categories.take(2).map((category) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AdminTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(category,
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AdminTheme.primary)),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, size: 20),
                      color: AdminTheme.textSecondary,
                      onPressed: onEdit,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      color: AdminTheme.error,
                      onPressed: onDelete,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeEditDialog extends StatefulWidget {
  final String? recipeId;
  final Map<String, dynamic>? recipeData;

  const _RecipeEditDialog({
    this.recipeId,
    this.recipeData,
  });

  @override
  State<_RecipeEditDialog> createState() => _RecipeEditDialogState();
}

class _RecipeEditDialogState extends State<_RecipeEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _ingredientsController;
  late TextEditingController _instructionsController;
  late TextEditingController _imageUrlController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  late TextEditingController _timeController;
  late TextEditingController _difficultyController;
  // Nutrition fields
  late TextEditingController _gramsController;
  late TextEditingController _cholesterolMgController;
  late TextEditingController _cholesterolPctController;
  late TextEditingController _sodiumMgController;
  late TextEditingController _sodiumPctController;
  // Mineral fields (mg + percentage)
  late TextEditingController _calciumMgController;
  late TextEditingController _calciumPctController;
  late TextEditingController _ironMgController;
  late TextEditingController _ironPctController;
  late TextEditingController _potassiumMgController;
  late TextEditingController _potassiumPctController;
  late TextEditingController _magnesiumMgController;
  late TextEditingController _magnesiumPctController;
  late TextEditingController _phosphorusMgController;
  late TextEditingController _phosphorusPctController;
  late TextEditingController _zincMgController;
  late TextEditingController _zincPctController;
  late TextEditingController _copperMgController;
  late TextEditingController _copperPctController;
  late TextEditingController _seleniumMgController;
  late TextEditingController _seleniumPctController;
  List<String> _selectedCategories = [];
  bool _isLoading = false;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  String? _imageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.recipeData?['name'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.recipeData?['description'] ?? '',
    );
    _ingredientsController = TextEditingController(
      text: (widget.recipeData?['ingredients'] as List?)?.join('\n') ?? '',
    );
    _instructionsController = TextEditingController(
      text: (widget.recipeData?['instructions'] as List?)?.join('\n') ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.recipeData?['imageUrl'] ?? '',
    );
    _imageUrl = widget.recipeData?['imageUrl'];
    _caloriesController = TextEditingController(
      text: widget.recipeData?['calories']?.toString() ?? '',
    );
    _proteinController = TextEditingController(
      text: widget.recipeData?['protein']?.toString() ?? '',
    );
    _carbsController = TextEditingController(
      text: widget.recipeData?['carbs']?.toString() ?? '',
    );
    _fatController = TextEditingController(
      text: widget.recipeData?['fat']?.toString() ?? '',
    );
    _timeController = TextEditingController(
      text: widget.recipeData?['time']?.toString() ?? '',
    );
    _difficultyController = TextEditingController(
      text: widget.recipeData?['difficulty'] ?? '',
    );
    _selectedCategories =
        List<String>.from(widget.recipeData?['dietCategories'] ?? []);

    // Nutrition fields initialization
    _gramsController = TextEditingController(
      text: widget.recipeData?['grams']?.toString() ?? '',
    );
    final cholesterolData =
        widget.recipeData?['cholesterol'] as Map<String, dynamic>? ?? {};
    _cholesterolMgController = TextEditingController(
      text: cholesterolData['mg']?.toString() ?? '',
    );
    _cholesterolPctController = TextEditingController(
      text: cholesterolData['percentage']?.toString() ?? '',
    );
    final sodiumData =
        widget.recipeData?['sodium'] as Map<String, dynamic>? ?? {};
    _sodiumMgController = TextEditingController(
      text: sodiumData['mg']?.toString() ?? '',
    );
    _sodiumPctController = TextEditingController(
      text: sodiumData['percentage']?.toString() ?? '',
    );

    // Minerals initialization
    final mineralsData =
        widget.recipeData?['minerals'] as Map<String, dynamic>? ?? {};
    final calciumData = mineralsData['calcium'] as Map<String, dynamic>? ?? {};
    _calciumMgController =
        TextEditingController(text: calciumData['mg']?.toString() ?? '');
    _calciumPctController = TextEditingController(
        text: calciumData['percentage']?.toString() ?? '');
    final ironData = mineralsData['iron'] as Map<String, dynamic>? ?? {};
    _ironMgController =
        TextEditingController(text: ironData['mg']?.toString() ?? '');
    _ironPctController =
        TextEditingController(text: ironData['percentage']?.toString() ?? '');
    final potassiumData =
        mineralsData['potassium'] as Map<String, dynamic>? ?? {};
    _potassiumMgController =
        TextEditingController(text: potassiumData['mg']?.toString() ?? '');
    _potassiumPctController = TextEditingController(
        text: potassiumData['percentage']?.toString() ?? '');
    final magnesiumData =
        mineralsData['magnesium'] as Map<String, dynamic>? ?? {};
    _magnesiumMgController =
        TextEditingController(text: magnesiumData['mg']?.toString() ?? '');
    _magnesiumPctController = TextEditingController(
        text: magnesiumData['percentage']?.toString() ?? '');
    final phosphorusData =
        mineralsData['phosphorus'] as Map<String, dynamic>? ?? {};
    _phosphorusMgController =
        TextEditingController(text: phosphorusData['mg']?.toString() ?? '');
    _phosphorusPctController = TextEditingController(
        text: phosphorusData['percentage']?.toString() ?? '');
    final zincData = mineralsData['zinc'] as Map<String, dynamic>? ?? {};
    _zincMgController =
        TextEditingController(text: zincData['mg']?.toString() ?? '');
    _zincPctController =
        TextEditingController(text: zincData['percentage']?.toString() ?? '');
    final copperData = mineralsData['copper'] as Map<String, dynamic>? ?? {};
    _copperMgController =
        TextEditingController(text: copperData['mg']?.toString() ?? '');
    _copperPctController =
        TextEditingController(text: copperData['percentage']?.toString() ?? '');
    final seleniumData =
        mineralsData['selenium'] as Map<String, dynamic>? ?? {};
    _seleniumMgController =
        TextEditingController(text: seleniumData['mg']?.toString() ?? '');
    _seleniumPctController = TextEditingController(
        text: seleniumData['percentage']?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _imageUrlController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _timeController.dispose();
    _difficultyController.dispose();
    _gramsController.dispose();
    _cholesterolMgController.dispose();
    _cholesterolPctController.dispose();
    _sodiumMgController.dispose();
    _sodiumPctController.dispose();
    _calciumMgController.dispose();
    _calciumPctController.dispose();
    _ironMgController.dispose();
    _ironPctController.dispose();
    _potassiumMgController.dispose();
    _potassiumPctController.dispose();
    _magnesiumMgController.dispose();
    _magnesiumPctController.dispose();
    _phosphorusMgController.dispose();
    _phosphorusPctController.dispose();
    _zincMgController.dispose();
    _zincPctController.dispose();
    _copperMgController.dispose();
    _copperPctController.dispose();
    _seleniumMgController.dispose();
    _seleniumPctController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = pickedFile;
        _selectedImageBytes = bytes;
        debugPrint(
            'Image selected: ${pickedFile.name}, Size: ${bytes.length} bytes');
      });
    }
  }

  Future<String?> _uploadImage(XFile imageFile) async {
    try {
      setState(() => _isUploadingImage = true);
      final fileName =
          'recipes/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      final bytes = await imageFile.readAsBytes();
      await ref.putData(bytes);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
      return null;
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Upload image if a new one was selected
      String imageUrlToSave = _imageUrl ?? '';
      if (_selectedImage != null) {
        final uploadedUrl = await _uploadImage(_selectedImage!);
        if (uploadedUrl != null) {
          imageUrlToSave = uploadedUrl;
        } else {
          return; // Stop if upload failed
        }
      }

      final recipeData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'ingredients': _ingredientsController.text
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList(),
        'instructions': _instructionsController.text
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList(),
        'imageUrl': imageUrlToSave,
        'calories': int.tryParse(_caloriesController.text) ?? 0,
        'protein': double.tryParse(_proteinController.text) ?? 0.0,
        'carbs': double.tryParse(_carbsController.text) ?? 0.0,
        'fat': double.tryParse(_fatController.text) ?? 0.0,
        'time': int.tryParse(_timeController.text) ?? 0,
        'difficulty': _difficultyController.text.trim(),
        'dietCategories': _selectedCategories,
        'grams': double.tryParse(_gramsController.text) ?? 0.0,
        'cholesterol': {
          'mg': double.tryParse(_cholesterolMgController.text) ?? 0.0,
          'percentage': double.tryParse(_cholesterolPctController.text) ?? 0.0,
        },
        'sodium': {
          'mg': double.tryParse(_sodiumMgController.text) ?? 0.0,
          'percentage': double.tryParse(_sodiumPctController.text) ?? 0.0,
        },
        'minerals': {
          'calcium': {
            'mg': double.tryParse(_calciumMgController.text) ?? 0.0,
            'percentage': double.tryParse(_calciumPctController.text) ?? 0.0,
          },
          'iron': {
            'mg': double.tryParse(_ironMgController.text) ?? 0.0,
            'percentage': double.tryParse(_ironPctController.text) ?? 0.0,
          },
          'potassium': {
            'mg': double.tryParse(_potassiumMgController.text) ?? 0.0,
            'percentage': double.tryParse(_potassiumPctController.text) ?? 0.0,
          },
          'magnesium': {
            'mg': double.tryParse(_magnesiumMgController.text) ?? 0.0,
            'percentage': double.tryParse(_magnesiumPctController.text) ?? 0.0,
          },
          'phosphorus': {
            'mg': double.tryParse(_phosphorusMgController.text) ?? 0.0,
            'percentage': double.tryParse(_phosphorusPctController.text) ?? 0.0,
          },
          'zinc': {
            'mg': double.tryParse(_zincMgController.text) ?? 0.0,
            'percentage': double.tryParse(_zincPctController.text) ?? 0.0,
          },
          'copper': {
            'mg': double.tryParse(_copperMgController.text) ?? 0.0,
            'percentage': double.tryParse(_copperPctController.text) ?? 0.0,
          },
          'selenium': {
            'mg': double.tryParse(_seleniumMgController.text) ?? 0.0,
            'percentage': double.tryParse(_seleniumPctController.text) ?? 0.0,
          },
        },
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.recipeId == null) {
        // Add new recipe
        recipeData['createdAt'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance.collection('recipes').add(recipeData);
      } else {
        // Update existing recipe
        await FirebaseFirestore.instance
            .collection('recipes')
            .doc(widget.recipeId)
            .update(recipeData);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.recipeId == null
                ? 'Recipe added successfully'
                : 'Recipe updated successfully'),
            backgroundColor: AdminTheme.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving recipe: $e'),
            backgroundColor: AdminTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildMineralRow(
    String label,
    TextEditingController mgController,
    TextEditingController pctController,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: mgController,
            decoration: InputDecoration(labelText: '$label (mg)'),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: pctController,
            decoration: InputDecoration(labelText: '$label (%)'),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.recipeId != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 640,
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
                  child: const Icon(Icons.restaurant_menu_rounded,
                      color: AdminTheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  isEditing ? 'Edit Recipe' : 'Add Recipe',
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                            labelText: 'Recipe Name *',
                            prefixIcon: Icon(Icons.fastfood_rounded)),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter a recipe name'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            labelText: 'Description',
                            prefixIcon: Icon(Icons.notes_rounded)),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _ingredientsController,
                        decoration: const InputDecoration(
                            labelText: 'Ingredients (one per line)',
                            prefixIcon: Icon(Icons.list_rounded),
                            alignLabelWithHint: true),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _instructionsController,
                        decoration: const InputDecoration(
                            labelText: 'Instructions (one per line)',
                            prefixIcon:
                                Icon(Icons.format_list_numbered_rounded),
                            alignLabelWithHint: true),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 14),
                      // Image Upload Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recipe Image',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AdminTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AdminTheme.textSecondary
                                    .withValues(alpha: 0.3),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                if (_selectedImage != null || _imageUrl != null)
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (_selectedImageBytes != null)
                                          Image.memory(
                                            _selectedImageBytes!,
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        else if (_imageUrl != null &&
                                            _imageUrl!.isNotEmpty)
                                          Image.network(
                                            _imageUrl!,
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                height: 150,
                                                color: Colors.grey[300],
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    size: 48,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _selectedImageBytes != null
                                                  ? 'New image selected'
                                                  : 'Current image',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: AdminTheme.textSecondary,
                                              ),
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: _isUploadingImage
                                                  ? null
                                                  : _pickImage,
                                              icon: const Icon(Icons.edit),
                                              label: const Text('Change'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AdminTheme.primary,
                                                foregroundColor: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.cloud_upload_rounded,
                                          size: 48,
                                          color: AdminTheme.textSecondary
                                              .withValues(alpha: 0.5),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Upload Recipe Image',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AdminTheme.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Click to select an image from your device',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: AdminTheme.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed: _isUploadingImage
                                              ? null
                                              : _pickImage,
                                          icon: const Icon(
                                              Icons.add_photo_alternate),
                                          label: const Text('Select Image'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AdminTheme.primary,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                                  controller: _caloriesController,
                                  decoration: const InputDecoration(
                                      labelText: 'Calories'),
                                  keyboardType: TextInputType.number)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: TextFormField(
                                  controller: _proteinController,
                                  decoration: const InputDecoration(
                                      labelText: 'Protein (g)'),
                                  keyboardType: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                                  controller: _carbsController,
                                  decoration: const InputDecoration(
                                      labelText: 'Carbs (g)'),
                                  keyboardType: TextInputType.number)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: TextFormField(
                                  controller: _fatController,
                                  decoration: const InputDecoration(
                                      labelText: 'Fat (g)'),
                                  keyboardType: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Grams (total serving weight)
                      TextFormField(
                        controller: _gramsController,
                        decoration: const InputDecoration(
                            labelText: 'Total Grams (serving weight)',
                            prefixIcon: Icon(Icons.scale_rounded)),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),
                      // Cholesterol & Sodium
                      Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                                  controller: _cholesterolMgController,
                                  decoration: const InputDecoration(
                                      labelText: 'Cholesterol (mg)'),
                                  keyboardType: TextInputType.number)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: TextFormField(
                                  controller: _cholesterolPctController,
                                  decoration: const InputDecoration(
                                      labelText: 'Cholesterol (%)'),
                                  keyboardType: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                                  controller: _sodiumMgController,
                                  decoration: const InputDecoration(
                                      labelText: 'Sodium (mg)'),
                                  keyboardType: TextInputType.number)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: TextFormField(
                                  controller: _sodiumPctController,
                                  decoration: const InputDecoration(
                                      labelText: 'Sodium (%)'),
                                  keyboardType: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Minerals Section Header
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Minerals',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AdminTheme.textPrimary)),
                      ),
                      const SizedBox(height: 10),
                      _buildMineralRow('Calcium', _calciumMgController,
                          _calciumPctController),
                      const SizedBox(height: 10),
                      _buildMineralRow(
                          'Iron', _ironMgController, _ironPctController),
                      const SizedBox(height: 10),
                      _buildMineralRow('Potassium', _potassiumMgController,
                          _potassiumPctController),
                      const SizedBox(height: 10),
                      _buildMineralRow('Magnesium', _magnesiumMgController,
                          _magnesiumPctController),
                      const SizedBox(height: 10),
                      _buildMineralRow('Phosphorus', _phosphorusMgController,
                          _phosphorusPctController),
                      const SizedBox(height: 10),
                      _buildMineralRow(
                          'Zinc', _zincMgController, _zincPctController),
                      const SizedBox(height: 10),
                      _buildMineralRow(
                          'Copper', _copperMgController, _copperPctController),
                      const SizedBox(height: 10),
                      _buildMineralRow('Selenium', _seleniumMgController,
                          _seleniumPctController),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                                  controller: _timeController,
                                  decoration: const InputDecoration(
                                      labelText: 'Cooking Time (minutes)'),
                                  keyboardType: TextInputType.number)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: TextFormField(
                                  controller: _difficultyController,
                                  decoration: const InputDecoration(
                                      labelText:
                                          'Difficulty (e.g., Easy, Medium, Hard)'),
                                  keyboardType: TextInputType.text)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Diet Categories',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AdminTheme.textPrimary)),
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('diet_categories')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: AdminTheme.primary));
                          }

                          final categories = snapshot.data?.docs ?? [];

                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: categories.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final categoryName = data['name'] ?? '';
                              final emoji = data['emoji'] ?? '🍽️';
                              final isSelected =
                                  _selectedCategories.contains(categoryName);
                              return FilterChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(emoji,
                                        style: const TextStyle(fontSize: 16)),
                                    const SizedBox(width: 6),
                                    Text(categoryName),
                                  ],
                                ),
                                selected: isSelected,
                                selectedColor:
                                    AdminTheme.primary.withValues(alpha: 0.15),
                                checkmarkColor: AdminTheme.primary,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedCategories.add(categoryName);
                                    } else {
                                      _selectedCategories.remove(categoryName);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveRecipe,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text(isEditing ? 'Save Changes' : 'Add Recipe'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
