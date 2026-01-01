// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    super.key,
    this.width,
    this.height,
    this.backgroundColorSliverAppBar,
    this.expandedHeightAppBAr,
    this.shareborderRadius,
    required this.homepage,
    required this.pageSimpleAppBar,
    required this.pageSliverAppBar,
  });

  final double? width;
  final double? height;
  final Color? backgroundColorSliverAppBar;
  final double? expandedHeightAppBAr;

  final double? shareborderRadius;
  final Widget Function() homepage;
  final Widget Function() pageSimpleAppBar;
  final Widget Function() pageSliverAppBar;

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  ScrollController? _scrollController;
  bool lastStatus = true;
  double height = 200;

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 0,
              backgroundColor:
                  widget.backgroundColorSliverAppBar ?? Colors.transparent,
              pinned: true,
              expandedHeight: widget.expandedHeightAppBAr ?? 300,
              automaticallyImplyLeading: false, // Убирает кнопку назад
              shape: ContinuousRectangleBorder(
                borderRadius:
                    BorderRadius.circular(widget.shareborderRadius ?? 0.0),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: SafeArea(
                  child: widget.pageSliverAppBar(),
                ),
              ),
              actions: _isShrink
                  ? [
                      Expanded(
                        child: widget.pageSimpleAppBar(),
                      ),
                    ]
                  : null,
            ),
          ];
        },
        body: widget.homepage(),
      ),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
