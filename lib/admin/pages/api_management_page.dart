import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/admin_theme.dart';

class ApiManagementPage extends StatefulWidget {
  const ApiManagementPage({super.key});

  @override
  State<ApiManagementPage> createState() => _ApiManagementPageState();
}

class _ApiManagementPageState extends State<ApiManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('API Keys', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text(
              'Manage API keys for external services',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            _ApiKeyCard(
              title: 'OpenAI API',
              description: 'AI-powered food image analysis & text recognition',
              icon: Icons.psychology_rounded,
              color: AdminTheme.cardGreen,
              documentId: 'openai',
              keyFields: const ['apiKey'],
            ),
            const SizedBox(height: 16),
            _ApiKeyCard(
              title: 'USDA Food Data API',
              description: 'Nutritional information lookup service',
              icon: Icons.local_dining_rounded,
              color: AdminTheme.cardOrange,
              documentId: 'usda',
              keyFields: const ['apiKey'],
            ),
            const SizedBox(height: 16),
            _ApiKeyCard(
              title: 'RevenueCat',
              description: 'Subscription & in-app purchase management',
              icon: Icons.payment_rounded,
              color: AdminTheme.cardBlue,
              documentId: 'revenuecat',
              keyFields: const ['iosApiKey', 'androidApiKey'],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApiKeyCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String documentId;
  final List<String> keyFields;

  const _ApiKeyCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.documentId,
    required this.keyFields,
  });

  @override
  State<_ApiKeyCard> createState() => _ApiKeyCardState();
}

class _ApiKeyCardState extends State<_ApiKeyCard> {
  final _firestore = FirebaseFirestore.instance;
  bool _isEditing = false;
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var field in widget.keyFields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadKeys() async {
    setState(() => _isLoading = true);
    try {
      final doc =
          await _firestore.collection('api_keys').doc(widget.documentId).get();
      if (doc.exists) {
        final data = doc.data()!;
        for (var field in widget.keyFields) {
          _controllers[field]!.text = data[field] ?? '';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading keys: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveKeys() async {
    setState(() => _isLoading = true);
    try {
      final data = <String, dynamic>{};
      for (var field in widget.keyFields) {
        data[field] = _controllers[field]!.text.trim();
      }
      data['updatedAt'] = FieldValue.serverTimestamp();
      data['service'] = widget.documentId;
      data['description'] = widget.description;

      await _firestore
          .collection('api_keys')
          .doc(widget.documentId)
          .set(data, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('API key updated successfully'),
            backgroundColor: AdminTheme.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving keys: $e'),
            backgroundColor: AdminTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _maskKey(String key) {
    if (key.isEmpty) return 'Not configured';
    if (key.length <= 8) return '••••••••';
    return '${key.substring(0, 4)}${'•' * 12}${key.substring(key.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: widget.color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AdminTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AdminTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection('api_keys')
                    .doc(widget.documentId)
                    .snapshots(),
                builder: (context, snapshot) {
                  final hasKey = snapshot.hasData &&
                      snapshot.data!.exists &&
                      (snapshot.data!.data() as Map<String, dynamic>?)?[
                              widget.keyFields.first] !=
                          null &&
                      ((snapshot.data!.data() as Map<String, dynamic>?)?[
                                  widget.keyFields.first] as String?)
                              ?.isNotEmpty ==
                          true;
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: hasKey
                          ? AdminTheme.success.withValues(alpha: 0.1)
                          : AdminTheme.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          hasKey
                              ? Icons.check_circle_rounded
                              : Icons.warning_rounded,
                          size: 14,
                          color:
                              hasKey ? AdminTheme.success : AdminTheme.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hasKey ? 'Active' : 'Not Set',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: hasKey
                                ? AdminTheme.success
                                : AdminTheme.warning,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          if (!_isEditing) ...[
            // View mode
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('api_keys')
                  .doc(widget.documentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                final data = snapshot.data?.data() as Map<String, dynamic>?;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var field in widget.keyFields) ...[
                      Text(
                        field,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AdminTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AdminTheme.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AdminTheme.border),
                        ),
                        child: Text(
                          _maskKey(data?[field] ?? ''),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AdminTheme.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 4),
            OutlinedButton(
              onPressed: () {
                _loadKeys();
                setState(() => _isEditing = true);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('Edit Keys'),
                ],
              ),
            ),
          ] else ...[
            // Edit mode
            for (var field in widget.keyFields) ...[
              Text(
                field,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AdminTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _controllers[field],
                decoration: InputDecoration(
                  hintText: 'Enter $field...',
                ),
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveKeys,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      else
                        const Icon(Icons.save_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(_isLoading ? 'Saving...' : 'Save'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _isLoading
                      ? null
                      : () => setState(() => _isEditing = false),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
