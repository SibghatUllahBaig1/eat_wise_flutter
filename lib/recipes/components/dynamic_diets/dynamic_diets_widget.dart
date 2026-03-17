import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Dynamic widget that fetches diet categories from Firestore and displays them
/// in a wrap layout (for Pick Your Diet section).
/// Uses a static cache so data is not reloaded on every navigation return.
class DynamicDietsWidget extends StatefulWidget {
  const DynamicDietsWidget({super.key});

  @override
  State<DynamicDietsWidget> createState() => _DynamicDietsWidgetState();
}

class _DynamicDietsWidgetState extends State<DynamicDietsWidget> {
  // Static cache shared across all instances — survives navigation
  static List<Map<String, dynamic>>? _cachedDiets;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('diet_categories')
          .orderBy('name')
          .snapshots(),
      builder: (context, snapshot) {
        // Update cache whenever fresh data arrives
        if (snapshot.hasData) {
          _cachedDiets = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        }

        // Use cached data immediately — no loading flash on navigation return
        final categories = _cachedDiets ?? [];

        // Only show spinner on the very first load (cache is empty)
        if (categories.isEmpty &&
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (categories.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No diet categories available'),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.start,
            verticalDirection: VerticalDirection.down,
            clipBehavior: Clip.none,
            children: categories.map((data) {
              final emoji = data['emoji'] ?? '🍽️';
              final name = data['name'] ?? 'Unnamed';

              return InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed(
                    DietsWidget.routeName,
                    queryParameters: {
                      'diets': serializeParam(name, ParamType.String),
                    }.withoutNulls,
                  );
                },
                child: Container(
                  width: (MediaQuery.sizeOf(context).width - 44) / 2,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: Center(
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 28.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
