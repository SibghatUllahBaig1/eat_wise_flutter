import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/backend/backend_manager.dart';
import '/recipes/components/recipe_image_widget.dart';

/// Shared in-memory + disk-backed cache for recipe metadata and image prefetch.
class RecipeCacheService {
  RecipeCacheService._();
  static final RecipeCacheService instance = RecipeCacheService._();

  static const _prefsRecipesKey = 'cached_recipes_v1';
  static const _prefsFetchedAtKey = 'cached_recipes_fetched_at_v1';
  static const _cacheTtl = Duration(minutes: 30);

  List<Map<String, dynamic>> _recipes = [];
  DateTime? _lastFetchedAt;
  Future<List<Map<String, dynamic>>>? _inFlightFetch;

  List<Map<String, dynamic>> get recipes => List.unmodifiable(_recipes);

  bool get hasCachedRecipes => _recipes.isNotEmpty;

  bool get _isStale {
    if (_lastFetchedAt == null) return true;
    return DateTime.now().difference(_lastFetchedAt!) > _cacheTtl;
  }

  /// Returns cached recipes when fresh; use [forceRefresh] to await Firestore.
  Future<List<Map<String, dynamic>>> getRecipes({
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      return _fetchFromFirestore();
    }

    if (_recipes.isEmpty) {
      await _loadFromPrefs();
    }

    if (_recipes.isNotEmpty) {
      if (_isStale) {
        unawaited(_refreshInBackground());
      }
      return _recipes;
    }

    return _fetchFromFirestore();
  }

  Future<void> _refreshInBackground() async {
    try {
      await _fetchFromFirestore();
    } catch (e) {
      debugPrint('RecipeCacheService: background refresh failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchFromFirestore() async {
    if (_inFlightFetch != null) {
      return _inFlightFetch!;
    }

    _inFlightFetch = _doFetchFromFirestore();
    try {
      return await _inFlightFetch!;
    } finally {
      _inFlightFetch = null;
    }
  }

  Future<List<Map<String, dynamic>>> _doFetchFromFirestore() async {
    final backend = BackendManager();
    final fetched = await backend.recipeService.getAllRecipes();
    _recipes = fetched;
    _lastFetchedAt = DateTime.now();
    await _saveToPrefs();
    debugPrint('RecipeCacheService: loaded ${fetched.length} recipes');
    return _recipes;
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_prefsRecipesKey);
      if (json == null || json.isEmpty) return;

      final decoded = jsonDecode(json);
      if (decoded is! List) return;

      _recipes = decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      _lastFetchedAt =
          DateTime.tryParse(prefs.getString(_prefsFetchedAtKey) ?? '');
      debugPrint(
          'RecipeCacheService: restored ${_recipes.length} recipes from prefs');
    } catch (e) {
      debugPrint('RecipeCacheService: prefs restore failed: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsRecipesKey, jsonEncode(_recipes));
      await prefs.setString(
        _prefsFetchedAtKey,
        (_lastFetchedAt ?? DateTime.now()).toIso8601String(),
      );
    } catch (e) {
      debugPrint('RecipeCacheService: prefs save failed: $e');
    }
  }

  /// Prefetch the first [limit] valid recipe image URLs into disk cache.
  Future<void> prefetchVisibleImages(
    List<Map<String, dynamic>> recipes, {
    int limit = 10,
  }) async {
    final cache = DefaultCacheManager();
    var count = 0;

    for (final recipe in recipes) {
      if (count >= limit) break;
      final url = recipe['imageUrl'] as String?;
      if (!isValidRecipeImageUrl(url)) continue;

      count++;
      unawaited(() async {
        try {
          await cache.downloadFile(url!.trim());
        } catch (e) {
          debugPrint('RecipeCacheService: prefetch failed for $url: $e');
        }
      }());
    }
  }

  /// Invalidate memory cache (e.g. after admin edits). Next read refetches.
  void invalidate() {
    _recipes = [];
    _lastFetchedAt = null;
  }
}
