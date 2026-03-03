// ...existing code...
import 'package:flutter/widgets.dart';
import '../constants/categories.dart';
import '../models/trend_model.dart';

/// Service that deterministically picks a background asset for a Trend
/// and caches AssetImage instances to avoid flicker on rebuild.
class CategoryBackgroundService {
  CategoryBackgroundService._();

  static final CategoryBackgroundService instance =
      CategoryBackgroundService._();

  // Number of images available per category (adjust if different per category)
  static const int defaultImagesPerCategory = 5;

  // Per-category override counts (keep small if you have few assets)
  static const Map<Category, int> _imageCounts = {
    Category.OilAndGas: 5,
    Category.Politics: 5,
    Category.ForexCrypto: 5,
    Category.Inflation: 5,
    Category.Unknown: 5,
  };

  // Cache of AssetImage instances by asset path
  final Map<String, AssetImage> _imageCache = {};

  /// Deterministically returns the asset path for a given trend.
  /// Asset naming convention assumed: {category.assetPath}/img{n}.jpg
  /// Example: assets/images/oil_and_gas/img1.jpg
  String getAssetPathForTrend(Trend trend) {
    final category = Category.fromName(trend.category);
    final count = _imageCounts[category] ?? defaultImagesPerCategory;
    final seedSource =
        (trend.id.isNotEmpty)
            ? trend.id
            : trend.timestamp.millisecondsSinceEpoch.toString();
    final idx = (_djb2(seedSource) % count) + 1; // 1-based index
    return '${category.assetPath}/img$idx.jpg';
  }

  /// Returns a cached AssetImage for the trend's selected background.
  AssetImage getImageProviderForTrend(Trend trend) {
    final path = getAssetPathForTrend(trend);
    return _imageCache.putIfAbsent(path, () => AssetImage(path));
  }

  // Simple deterministic string hash (djb2)
  int _djb2(String str) {
    var hash = 5381;
    for (var codeUnit in str.codeUnits) {
      hash = ((hash << 5) + hash) + codeUnit; // hash * 33 + c
      // keep in 32-bit signed range
      hash &= 0x7FFFFFFF;
    }
    return hash;
  }
}
 // ...existing code...