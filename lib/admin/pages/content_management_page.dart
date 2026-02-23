import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../backend/services/legal_content_service.dart';
import '../theme/admin_theme.dart';

class ContentManagementPage extends StatefulWidget {
  const ContentManagementPage({super.key});

  @override
  State<ContentManagementPage> createState() => _ContentManagementPageState();
}

class _ContentManagementPageState extends State<ContentManagementPage> {
  final List<_LegalDocument> _documents = [
    _LegalDocument(
      id: 'terms_of_service',
      title: 'Terms of Service',
      icon: Icons.description_rounded,
      color: AdminTheme.cardBlue,
    ),
    _LegalDocument(
      id: 'privacy_policy',
      title: 'Privacy Policy',
      icon: Icons.privacy_tip_rounded,
      color: AdminTheme.cardGreen,
    ),
    _LegalDocument(
      id: 'about_us',
      title: 'About Us',
      icon: Icons.info_rounded,
      color: AdminTheme.cardOrange,
    ),
    _LegalDocument(
      id: 'contact_us',
      title: 'Contact Us',
      icon: Icons.contact_mail_rounded,
      color: AdminTheme.cardPurple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Content', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text('Manage legal documents and information pages',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            ..._documents.map((doc) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ContentCard(
                      document: doc, onEdit: () => _showEditDialog(doc)),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AdminTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: document.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(document.icon, color: document.color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(document.title,
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AdminTheme.textPrimary)),
                const SizedBox(height: 4),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('legal')
                      .doc(document.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading...',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AdminTheme.textHint));
                    }
                    final data = snapshot.data?.data() as Map<String, dynamic>?;
                    final lastUpdated = data?['lastUpdated'] as Timestamp?;
                    return Text(
                      lastUpdated != null
                          ? 'Last updated: ${_formatDate(lastUpdated.toDate())}'
                          : 'Not yet created',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: AdminTheme.textSecondary),
                    );
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onEdit,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_rounded, size: 16),
                SizedBox(width: 8),
                Text('Edit'),
              ],
            ),
          ),
        ],
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
        documentId: widget.document.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Content updated successfully'),
            backgroundColor: AdminTheme.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving content: $e'),
            backgroundColor: AdminTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 700,
        height: 640,
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.document.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.document.icon,
                      color: widget.document.color, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  'Edit ${widget.document.title}',
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AdminTheme.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_isLoadingData)
              const Expanded(
                  child: Center(
                      child:
                          CircularProgressIndicator(color: AdminTheme.primary)))
            else ...[
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    hintText: 'Enter content in markdown format...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tip: Use markdown formatting (# for headings, ** for bold, * for lists)',
                style:
                    GoogleFonts.inter(fontSize: 12, color: AdminTheme.textHint),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveContent,
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
}
