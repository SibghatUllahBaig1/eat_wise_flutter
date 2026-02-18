import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../backend/services/legal_content_service.dart';

class ContentManagementPage extends StatefulWidget {
  const ContentManagementPage({super.key});

  @override
  State<ContentManagementPage> createState() => _ContentManagementPageState();
}

class _ContentManagementPageState extends State<ContentManagementPage> {
  final _legalService = LegalContentService();

  final List<_LegalDocument> _documents = [
    _LegalDocument(
      id: 'terms_of_service',
      title: 'Terms of Service',
      icon: Icons.description,
      color: Colors.blue,
    ),
    _LegalDocument(
      id: 'privacy_policy',
      title: 'Privacy Policy',
      icon: Icons.privacy_tip,
      color: Colors.green,
    ),
    _LegalDocument(
      id: 'about_us',
      title: 'About Us',
      icon: Icons.info,
      color: Colors.orange,
    ),
    _LegalDocument(
      id: 'contact_us',
      title: 'Contact Us',
      icon: Icons.contact_mail,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Legal & Information Pages',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage legal documents and information pages',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Document cards
            ..._documents.map((doc) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ContentCard(
                    document: doc,
                    onEdit: () => _showEditDialog(doc),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(_LegalDocument doc) {
    showDialog(
      context: context,
      builder: (context) => _ContentEditDialog(document: doc),
    );
  }
}

class _LegalDocument {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  _LegalDocument({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class _ContentCard extends StatelessWidget {
  final _LegalDocument document;
  final VoidCallback onEdit;

  const _ContentCard({
    required this.document,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(document.icon, color: document.color, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('legal')
                        .doc(document.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('Loading...');
                      }

                      final data = snapshot.data?.data() as Map<String, dynamic>?;
                      final lastUpdated = data?['lastUpdated'] as Timestamp?;

                      return Text(
                        lastUpdated != null
                            ? 'Last updated: ${_formatDate(lastUpdated.toDate())}'
                            : 'Not yet created',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _ContentEditDialog extends StatefulWidget {
  final _LegalDocument document;

  const _ContentEditDialog({required this.document});

  @override
  State<_ContentEditDialog> createState() => _ContentEditDialogState();
}

class _ContentEditDialogState extends State<_ContentEditDialog> {
  final _legalService = LegalContentService();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isLoading = false;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _loadContent();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadContent() async {
    setState(() => _isLoadingData = true);
    try {
      final content = await _legalService.getLegalContent(widget.document.id);
      if (content != null && mounted) {
        _titleController.text = content['title'] ?? widget.document.title;
        _contentController.text = content['content'] ?? '';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading content: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  Future<void> _saveContent() async {
    setState(() => _isLoading = true);
    try {
      await _legalService.updateLegalContent(
        widget.document.id,
        _titleController.text.trim(),
        _contentController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Content updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving content: $e')),
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
    return AlertDialog(
      title: Text('Edit ${widget.document.title}'),
      content: SizedBox(
        width: 700,
        height: 600,
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                        hintText: 'Enter content in markdown format...',
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tip: Use markdown formatting (# for headings, ** for bold, * for lists)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveContent,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}

