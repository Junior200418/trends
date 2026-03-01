// ...existing code...
import 'package:flutter/material.dart';

enum Category {
  FX(displayName: 'FX', assetFolder: 'fx', accent: Color(0xFF7DD3FC)),
  Oil(displayName: 'Oil', assetFolder: 'oil', accent: Color(0xFFF97316)),
  Inflation(
    displayName: 'Inflation',
    assetFolder: 'inflation',
    accent: Color(0xFFFCA5A5),
  ),
  Equities(
    displayName: 'Equities',
    assetFolder: 'equities',
    accent: Color(0xFF60A5FA),
  ),
  Crypto(
    displayName: 'Crypto',
    assetFolder: 'crypto',
    accent: Color(0xFFA78BFA),
  ),
  Policy(
    displayName: 'Policy',
    assetFolder: 'policy',
    accent: Color(0xFF34D399),
  ),
  Global(
    displayName: 'Global',
    assetFolder: 'global',
    accent: Color(0xFF94A3B8),
  ),
  Commodities(
    displayName: 'Commodities',
    assetFolder: 'commodities',
    accent: Color(0xFFFDE68A),
  ),
  Unknown(
    displayName: 'Unknown',
    assetFolder: 'misc',
    accent: Colors.blueAccent,
  );

  final String displayName;
  final String assetFolder;
  final Color accent;

  const Category({
    required this.displayName,
    required this.assetFolder,
    required this.accent,
  });

  /// Parse a category name (case-insensitive). Returns Category.Unknown if no match.
  static Category fromName(String? name) {
    if (name == null) return Category.Unknown;
    final normalized = name.trim().toLowerCase();
    try {
      return Category.values.firstWhere(
        (c) =>
            c.displayName.toLowerCase() == normalized ||
            c.name.toLowerCase() == normalized,
      );
    } catch (_) {
      return Category.Unknown;
    }
  }

  /// Convenience: get asset folder path for this category
  String get assetPath => 'assets/images/$assetFolder';

  /// Convenience: get a human readable label (useful in UI)
  @override
  String toString() => displayName;
}

extension CategoryHelpers on Category {
  Color get accentColor => accent;
  String get folderName => assetFolder;
  String get label => displayName;
}
 // ...existing code...