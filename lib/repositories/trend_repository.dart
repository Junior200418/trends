// ...new file...
import '../models/trend_model.dart';

abstract class TrendRepository {
  /// Return published trends ordered newest → oldest.
  Future<List<Trend>> getPublishedTrends();
}
