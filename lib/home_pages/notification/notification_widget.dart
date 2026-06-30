import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_model.dart';
export 'notification_model.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  static String routeName = 'Notification';
  static String routePath = '/notification';

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late NotificationModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Returns the Firestore stream for the current user's notifications,
  /// newest first.
  Stream<QuerySnapshot<Map<String, dynamic>>>? _notificationsStream;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationModel());

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _notificationsStream = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Marks a single notification document as read.
  Future<void> _markAsRead(String docId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(docId)
        .update({'read': true});
  }

  /// Marks ALL unread notifications as read.
  Future<void> _markAllAsRead(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in docs) {
      if (doc.data()['read'] != true) {
        batch.update(doc.reference, {'read': true});
      }
    }
    await batch.commit();
  }

  /// Returns the appropriate icon for each notification type.
  Widget _iconForType(String type, BuildContext context) {
    final color = FlutterFlowTheme.of(context).info;
    switch (type) {
      case 'subscription_renewal':
        return Icon(Icons.credit_card_rounded, color: color, size: 22);
      case 'upgrade_prompt':
        return Icon(Icons.workspace_premium_rounded, color: color, size: 22);
      case 'monthly_encouragement':
        return Icon(Icons.emoji_events_rounded, color: color, size: 22);
      case 'inactivity_reminder':
        return Icon(Icons.restaurant_rounded, color: color, size: 22);
      case 'water_reminder':
        return Icon(Icons.water_drop_rounded, color: color, size: 22);
      case 'step_reminder':
        return Icon(Icons.directions_walk_rounded, color: color, size: 22);
      case 'weight_reminder':
        return Icon(Icons.monitor_weight_rounded, color: color, size: 22);
      case 'test_notification':
        return Icon(Icons.notifications_active_rounded, color: color, size: 22);
      default:
        return Icon(Icons.notifications_rounded, color: color, size: 22);
    }
  }

  /// Formats a Firestore Timestamp for display.
  String _formatTimestamp(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate().toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dtDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(dtDay).inDays;

    final timeStr =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    if (diff == 0) return 'Today, $timeStr';
    if (diff == 1) return 'Yesterday, $timeStr';
    return '${dateTimeFormat('MMMd', dt)}, $timeStr';
  }

  /// Returns the day-label string for grouping (e.g. "Today", "Mar 29").
  String _dayLabel(Timestamp? ts) {
    if (ts == null) return 'Earlier';
    final dt = ts.toDate().toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dtDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(dtDay).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return dateTimeFormat('MMMd', dt);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 24.0,
              borderWidth: 1.0,
              buttonSize: 44.0,
              icon: Icon(
                FFIcons.karrowLeft,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async => context.pop(),
            ),
          ),
          title: Text(
            'Notifications',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: _notificationsStream == null
            ? _buildEmpty(context)
            : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _notificationsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong.',
                          style: FlutterFlowTheme.of(context).bodyMedium),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) return _buildEmpty(context);

                  // Group by day label
                  final groups = <String,
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>>{};
                  final groupOrder = <String>[];

                  for (final doc in docs) {
                    final ts = doc.data()['createdAt'] as Timestamp?;
                    final label = _dayLabel(ts);
                    if (!groups.containsKey(label)) {
                      groups[label] = [];
                      groupOrder.add(label);
                    }
                    groups[label]!.add(doc);
                  }

                  // "Mark all as read" fab
                  final hasUnread = docs.any((d) => d.data()['read'] != true);

                  return Stack(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.only(top: 12, bottom: 96),
                        itemCount: groupOrder.length,
                        itemBuilder: (context, gi) {
                          final label = groupOrder[gi];
                          final items = groups[label]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, gi == 0 ? 0 : 20, 16, 8),
                                child: Text(
                                  label,
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        lineHeight: 1.0,
                                      ),
                                ),
                              ),
                              ...items.map((doc) {
                                final data = doc.data();
                                final type =
                                    (data['type'] as String?) ?? 'default';
                                final title = (data['title'] as String?) ??
                                    'Notification';
                                final body = (data['body'] as String?) ?? '';
                                final read = data['read'] == true;
                                final ts = data['createdAt'] as Timestamp?;

                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!read) _markAsRead(doc.id);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: read
                                            ? null
                                            : Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary
                                                        .withValues(alpha: 0.4),
                                                width: 1.5,
                                              ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Icon
                                            Container(
                                              width: 44.0,
                                              height: 44.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              child:
                                                  _iconForType(type, context),
                                            ),
                                            // Text content
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(16, 0, 8, 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      title,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            lineHeight: 1.0,
                                                          ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 8, 0, 0),
                                                      child: Text(
                                                        body,
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .labelMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(),
                                                              letterSpacing:
                                                                  0.0,
                                                              lineHeight: 1.5,
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 8, 0, 0),
                                                      child: Text(
                                                        _formatTimestamp(ts),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .inter(),
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Unread dot
                                            if (!read)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                      ),

                      // "Mark all as read" button at the bottom
                      if (hasUnread)
                        Positioned(
                          bottom: 24,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => _markAllAsRead(docs),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: FlutterFlowTheme.of(context)
                                          .primary
                                          .withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Mark all as read',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 72,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.inter(),
                  letterSpacing: 0,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'When you receive notifications about your health progress, reminders, and updates, they\'ll appear here.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.inter(),
                    letterSpacing: 0,
                    lineHeight: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
