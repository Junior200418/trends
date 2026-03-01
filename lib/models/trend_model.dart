// ...existing code...
import 'package:equatable/equatable.dart';

/// Domain data model for a Trend.
/// Immutable, Equatable, and includes JSON (de)serialization + copyWith.
class Trend extends Equatable {
  final String id;
  final String category;
  final String headline;
  final String insight;
  final String explanation;
  final String source;
  final DateTime timestamp;
  final bool published;

  const Trend({
    required this.id,
    required this.category,
    required this.headline,
    required this.insight,
    required this.explanation,
    required this.source,
    required this.timestamp,
    this.published = false,
  });

  Trend copyWith({
    String? id,
    String? category,
    String? headline,
    String? insight,
    String? explanation,
    String? source,
    DateTime? timestamp,
    bool? published,
  }) {
    return Trend(
      id: id ?? this.id,
      category: category ?? this.category,
      headline: headline ?? this.headline,
      insight: insight ?? this.insight,
      explanation: explanation ?? this.explanation,
      source: source ?? this.source,
      timestamp: timestamp ?? this.timestamp,
      published: published ?? this.published,
    );
  }

  /// Robust JSON factory. Accepts int (ms), ISO string, DateTime, or Firestore-like map.
  factory Trend.fromJson(Map<String, dynamic> json, {String? id}) {
    return Trend(
      id: id ?? (json['id']?.toString() ?? ''),
      category: json['category']?.toString() ?? '',
      headline: json['headline']?.toString() ?? '',
      insight: json['insight']?.toString() ?? '',
      explanation: json['explanation']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      timestamp: _parseTimestamp(json['timestamp']),
      published: json['published'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'headline': headline,
    'insight': insight,
    'explanation': explanation,
    'source': source,
    // Use ISO string here; service layer can convert to Firestore Timestamp if needed
    'timestamp': timestamp.toIso8601String(),
    'published': published,
  };

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is double) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    if (value is Map) {
      // Firestore-like map: {seconds: <int/num>, nanoseconds: <int/num>}
      final seconds = value['seconds'];
      final nanos = value['nanoseconds'] ?? 0;
      if (seconds != null) {
        final intSec =
            (seconds is num)
                ? seconds.toInt()
                : int.tryParse(seconds.toString()) ?? 0;
        final intNanos =
            (nanos is num)
                ? nanos.toInt()
                : int.tryParse(nanos.toString()) ?? 0;
        final int ms = intSec * 1000 + (intNanos ~/ 1000000);
        return DateTime.fromMillisecondsSinceEpoch(ms);
      }
    }
    return DateTime.now();
  }

  @override
  List<Object?> get props => [
    id,
    category,
    headline,
    insight,
    explanation,
    source,
    timestamp,
    published,
  ];

  @override
  String toString() =>
      'Trend(id: $id, category: $category, headline: $headline)';
}
// ...existing code...