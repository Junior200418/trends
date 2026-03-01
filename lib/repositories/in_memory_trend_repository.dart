// ...new file...
import '../models/trend_model.dart';
import 'trend_repository.dart';

class InMemoryTrendRepository implements TrendRepository {
  const InMemoryTrendRepository();

  @override
  Future<List<Trend>> getPublishedTrends() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final now = DateTime.now();
    return List.generate(6, (i) {
      return Trend(
        id: '$i',
        category: 'FX',
        headline: 'Headline #$i',
        insight: 'Quick insight #$i',
        explanation: 'Expanded explanation for trend #$i',
        source: 'Source #$i',
        timestamp: now.subtract(Duration(hours: i)),
        published: true,
      );
    });
  }
}
