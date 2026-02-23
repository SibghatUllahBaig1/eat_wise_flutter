import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Dynamic widget that fetches diet categories from Firestore and displays them
/// in a wrap layout (for Pick Your Diet section)
class DynamicDietsWidget extends StatelessWidget {
  const DynamicDietsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('diet_categories')
          .orderBy('name')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Error loading diet categories'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final categories = snapshot.data?.docs ?? [];

        if (categories.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No diet categories available'),
            ),
          );
        }

        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.start,
            verticalDirection: VerticalDirection.down,
            clipBehavior: Clip.none,
            children: categories.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final emoji = data['emoji'] ?? '🍽️';
              final name = data['name'] ?? 'Unnamed';
              final key = data['key'] ?? '';

              return InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed(
                    DietsWidget.routeName,
                    queryParameters: {
                      'diets': serializeParam(
                        name,
                        ParamType.String,
                      ),
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
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Emoji icon (no background)
                        SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: Center(
                            child: Text(
                              emoji,
                              style: TextStyle(fontSize: 28.0),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.0),
                        // Category name
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
