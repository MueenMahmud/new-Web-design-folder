import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/translation_model.dart';

abstract class LocalStorageSource {
  Future<List<TranslationModel>> getHistory();

  Future<void> saveToHistory(TranslationModel translation);

  Future<void> deleteFromHistory(String id);

  Future<void> clearHistory();

  Future<List<TranslationModel>> getFavorites();

  Future<void> addToFavorites(TranslationModel translation);

  Future<void> removeFromFavorites(String id);

  Future<bool> isFavorite(String id);

  Future<String?> getString(String key);

  Future<void> setString(String key, String value);

  Future<bool?> getBool(String key);

  Future<void> setBool(String key, bool value);
}

class LocalStorageSourceImpl implements LocalStorageSource {
  final SharedPreferences prefs;

  static const String _historyKey = 'translation_history';
  static const String _favoritesKey = 'translation_favorites';

  LocalStorageSourceImpl({required this.prefs});

  @override
  Future<List<TranslationModel>> getHistory() async {
    try {
      final jsonString = prefs.getString(_historyKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) =>
              TranslationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to load history: $e');
    }
  }

  @override
  Future<void> saveToHistory(TranslationModel translation) async {
    try {
      final history = await getHistory();
      history.insert(0, translation);

      if (history.length > AppConstants.maxHistoryItems) {
        history.removeRange(
            AppConstants.maxHistoryItems, history.length);
      }

      final jsonList = history
          .map((t) => TranslationModel.fromEntity(t).toJson())
          .toList();
      await prefs.setString(_historyKey, json.encode(jsonList));
    } catch (e) {
      throw CacheException(message: 'Failed to save to history: $e');
    }
  }

  @override
  Future<void> deleteFromHistory(String id) async {
    try {
      final history = await getHistory();
      history.removeWhere((t) => t.id == id);

      final jsonList = history
          .map((t) => TranslationModel.fromEntity(t).toJson())
          .toList();
      await prefs.setString(_historyKey, json.encode(jsonList));
    } catch (e) {
      throw CacheException(message: 'Failed to delete from history: $e');
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      await prefs.remove(_historyKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear history: $e');
    }
  }

  @override
  Future<List<TranslationModel>> getFavorites() async {
    try {
      final jsonString = prefs.getString(_favoritesKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) =>
              TranslationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to load favorites: $e');
    }
  }

  @override
  Future<void> addToFavorites(TranslationModel translation) async {
    try {
      final favorites = await getFavorites();
      if (favorites.any((t) => t.id == translation.id)) return;

      favorites.insert(0, translation);

      if (favorites.length > AppConstants.maxFavoriteItems) {
        favorites.removeRange(
            AppConstants.maxFavoriteItems, favorites.length);
      }

      final jsonList = favorites
          .map((t) => TranslationModel.fromEntity(t).toJson())
          .toList();
      await prefs.setString(_favoritesKey, json.encode(jsonList));
    } catch (e) {
      throw CacheException(message: 'Failed to add to favorites: $e');
    }
  }

  @override
  Future<void> removeFromFavorites(String id) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((t) => t.id == id);

      final jsonList = favorites
          .map((t) => TranslationModel.fromEntity(t).toJson())
          .toList();
      await prefs.setString(_favoritesKey, json.encode(jsonList));
    } catch (e) {
      throw CacheException(message: 'Failed to remove from favorites: $e');
    }
  }

  @override
  Future<bool> isFavorite(String id) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((t) => t.id == id);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> getString(String key) async {
    return prefs.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return prefs.getBool(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }
}
