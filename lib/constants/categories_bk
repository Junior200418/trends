// ...existing code...
import 'package:flutter/material.dart';

enum Category {
  OilAndGas(
    displayName: 'Oil & Gas',
    assetFolder: 'oil_and_gas',
    accent: Color(0xFFF97316),
  ),
  Politics(
    displayName: 'Politics',
    assetFolder: 'politics',
    accent: Color(0xFF34D399),
  ),
  ForexCrypto(
    displayName: 'Forex & Crypto',
    assetFolder: 'forex_crypto',
    accent: Color(0xFF7DD3FC),
  ),
  Inflation(
    displayName: 'Inflation',
    assetFolder: 'inflation',
    accent: Color(0xFFFCA5A5),
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

  /// Parse a category name (case-insensitive) and common aliases.
  /// Returns Category.Unknown if no match.
  static Category fromName(String? name) {
    if (name == null) return Category.Unknown;
    final n = name.trim().toLowerCase();
    if (n.isEmpty) return Category.Unknown;

    // common aliases mapping
    if (n.contains('oil') ||
        n.contains('gas') ||
        n.contains('oil&gas') ||
        n.contains('oil & gas')) {
      return Category.OilAndGas;
    }
    if (n.contains('polit') || n.contains('policy') || n.contains('politics')) {
      return Category.Politics;
    }
    if (n == 'fx' ||
        n.contains('forex') ||
        n.contains('crypto') ||
        n.contains('bitcoin') ||
        n.contains('btc')) {
      return Category.ForexCrypto;
    }
    if (n.contains('inflation') || n.contains('cpi')) {
      return Category.Inflation;
    }

    // fallback: try matching enum name or displayName
    try {
      return Category.values.firstWhere(
        (c) => c.name.toLowerCase() == n || c.displayName.toLowerCase() == n,
      );
    } catch (_) {
      return Category.Unknown;
    }
  }

  /// Asset path base for this category (folder path).
  String get assetPath => 'assets/images/$assetFolder';

  /// Human readable label
  String get label => displayName;
}
 // ...existing code...