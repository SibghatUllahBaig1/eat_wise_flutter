import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';

/// Returns true when [url] is a usable remote image URL.
bool isValidRecipeImageUrl(String? url) {
  if (url == null) return false;
  final trimmed = url.trim();
  if (trimmed.isEmpty) return false;
  return trimmed.startsWith('http://') || trimmed.startsWith('https://');
}

int? _memCacheDimension(double? logicalSize, BuildContext context) {
  if (logicalSize == null || !logicalSize.isFinite || logicalSize <= 0) {
    return null;
  }
  final dpr = MediaQuery.devicePixelRatioOf(context);
  return (logicalSize * dpr).round();
}

/// Placeholder shown when a recipe has no image (matches admin panel).
class RecipeImagePlaceholder extends StatelessWidget {
  const RecipeImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.iconSize,
  });

  final double? width;
  final double? height;
  final double? iconSize;

  double _resolveIconSize() {
    if (iconSize != null) return iconSize!;
    final h = height;
    if (h == null) return 48;
    if (h <= 32) return 16;
    if (h <= 120) return 40;
    if (h <= 200) return 48;
    return 64;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: width,
      height: height,
      color: theme.primaryBackground,
      alignment: Alignment.center,
      child: Icon(
        Icons.restaurant_menu_rounded,
        size: _resolveIconSize(),
        color: theme.primary.withValues(alpha: 0.4),
      ),
    );
  }
}

/// Cached remote image for recipes and other network images.
class RemoteImageWidget extends StatelessWidget {
  const RemoteImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    if (!isValidRecipeImageUrl(imageUrl)) {
      return errorWidget ??
          placeholder ??
          SizedBox(width: width, height: height);
    }

    final url = imageUrl!.trim();
    final memWidth = _memCacheDimension(width, context);
    final memHeight = _memCacheDimension(height, context);

    return CachedNetworkImage(
      imageUrl: url,
      cacheKey: url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: memWidth,
      memCacheHeight: memHeight,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (context, _) =>
          placeholder ?? SizedBox(width: width, height: height),
      errorWidget: (context, _, __) =>
          errorWidget ??
          placeholder ??
          SizedBox(width: width, height: height),
    );
  }
}

/// Recipe image with a consistent placeholder when missing or failed to load.
class RecipeImageWidget extends StatelessWidget {
  const RecipeImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.iconSize,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final placeholder = RecipeImagePlaceholder(
      width: width,
      height: height,
      iconSize: iconSize,
    );

    return RemoteImageWidget(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: placeholder,
    );
  }
}
