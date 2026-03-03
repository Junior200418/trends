// ...existing code...
import '../models/trend_model.dart';
import 'trend_repository.dart';
import '../constants/categories.dart';

class InMemoryTrendRepository implements TrendRepository {
  const InMemoryTrendRepository();

  @override
  Future<List<Trend>> getPublishedTrends() async {
    // simulate IO delay
    await Future.delayed(const Duration(milliseconds: 150));

    final now = DateTime.now();

    // categories to sample (use display names so Category.fromName() works)
    final sampleCategories = [
      Category.OilAndGas,
      Category.Politics,
      Category.ForexCrypto,
      Category.Inflation,
      Category.Unknown,
    ];

    // produce deterministic list (ids stable across runs)
    return List.generate(20, (i) {
      final cat = sampleCategories[i % sampleCategories.length];
      return Trend(
        id: 'sample-$i',
        category: cat.displayName,
        headline: 'Headline #$i — ${cat.displayName}',
        insight: 'Quick insight for ${cat.displayName} #$i',
        explanation:
            'Expanded explanation for trend #$i in ${cat.displayName}.',
        source: 'Source ${i + 1}',
        timestamp: now.subtract(Duration(hours: i)),
        published: true,
      );
    });
  }
}
