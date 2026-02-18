import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiManagementPage extends StatefulWidget {
  const ApiManagementPage({super.key});

  @override
  State<ApiManagementPage> createState() => _ApiManagementPageState();
}

class _ApiManagementPageState extends State<ApiManagementPage> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API Keys Configuration',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage API keys for external services',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // OpenAI API
            _ApiKeyCard(
              title: 'OpenAI API',
              description: 'Used for AI-powered food image analysis',
              icon: Icons.psychology,
              color: Colors.green,
              documentId: 'openai',
              keyFields: const ['apiKey'],
            ),

            const SizedBox(height: 16),

            // USDA API
            _ApiKeyCard(
              title: 'USDA Food Data API',
              description: 'Used for nutritional information lookup',
              icon: Icons.local_dining,
              color: Colors.orange,
              documentId: 'usda',
              keyFields: const ['apiKey'],
            ),

            const SizedBox(height: 16),

            // RevenueCat API
            _ApiKeyCard(
              title: 'RevenueCat',
              description: 'Used for subscription management',
              icon: Icons.payment,
              color: Colors.blue,
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
      final doc = await _firestore
          .collection('api_keys')
          .doc(widget.documentId)
          .get();

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

      await _firestore
          .collection('api_keys')
          .doc(widget.documentId)
          .set(data, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('API keys updated successfully')),
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving keys: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _maskKey(String key) {
    if (key.isEmpty) return 'Not configured';
    if (key.length <= 8) return '••••••••';
    return '${key.substring(0, 4)}••••${key.substring(key.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, color: widget.color, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (!_isEditing) ...[
              // View mode
              StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection('api_keys')
                    .doc(widget.documentId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final data = snapshot.data?.data() as Map<String, dynamic>?;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var field in widget.keyFields) ...[
                        Text(
                          field,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _maskKey(data?[field] ?? ''),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  );
                },
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _loadKeys();
                  setState(() => _isEditing = true);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
            ] else ...[
              // Edit mode
              for (var field in widget.keyFields) ...[
                TextField(
                  controller: _controllers[field],
                  decoration: InputDecoration(
                    labelText: field,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _saveKeys,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
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
      ),
    );
  }
}

