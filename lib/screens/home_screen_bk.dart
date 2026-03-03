// ...existing code...
import 'package:flutter/material.dart';
import '../widgets/trend_card.dart';
import '../models/trend_model.dart';
import '../repositories/trend_repository.dart';
import '../repositories/in_memory_trend_repository.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final TrendRepository repository;

  /// Provide a repository (defaults to in-memory mock).
  const HomeScreen({
    super.key,
    this.repository = const InMemoryTrendRepository(),
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Multiplier to create a large but finite virtual list.
  // Adjust if you expect extremely long user sessions; 10k is typically fine.
  static const int _kLoopMultiplier = 10000;

  late final PageController _pageController;
  late Future<List<Trend>> _trendsFuture;
  int? _virtualItemCount;
  int? _centerPage;

  @override
  void initState() {
    super.initState();
    _loadTrends();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadTrends() {
    setState(() {
      _trendsFuture = widget.repository.getPublishedTrends();
    });
  }

  // Compute controller and virtual counts once trends are loaded.
  void _initLoopingController(int dataLength) {
    if (dataLength <= 0) return;

    // Create a large but finite virtual count to avoid unlimited index growth.
    final virtualCount = dataLength * _kLoopMultiplier;
    final center = virtualCount ~/ 2;

    _virtualItemCount = virtualCount;
    _centerPage = center;

    // dispose previous controller if any (safety)
    try {
      _pageController.dispose();
    } catch (_) {}

    _pageController = PageController(initialPage: center);
  }

  // If the user scrolls near the edges, jump back to a center page preserving logical index.
  void _recenterIfNeeded(int rawIndex, int dataLength) {
    final virtualCount = _virtualItemCount;
    final center = _centerPage;
    if (virtualCount == null || center == null) return;

    // threshold: when within one set of data from the start or end, recenter
    final threshold = dataLength * 2;
    if (rawIndex <= threshold || rawIndex >= virtualCount - threshold) {
      final logicalIndex = rawIndex % dataLength;
      final target = center + logicalIndex;
      // jump without animation to avoid visible jump; done on next frame to avoid modifying during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // only jump if still far from center to avoid unnecessary calls
        if ((_pageController.page ?? rawIndex).round() != target) {
          _pageController.jumpToPage(target);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Trend>>(
        future: _trendsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingView();
          }
          if (snapshot.hasError) {
            return _ErrorView(
              message: snapshot.error?.toString() ?? 'Unknown error',
              onRetry: _loadTrends,
            );
          }

          final trends = snapshot.data ?? [];
          if (trends.isEmpty) {
            return _EmptyView(onRefresh: _loadTrends);
          }

          // initialize controller and counts once trends are present
          if (_virtualItemCount == null || _centerPage == null) {
            _initLoopingController(trends.length);
          }

          final virtualCount = _virtualItemCount!;
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: virtualCount, // finite but large
            onPageChanged: (index) => _recenterIfNeeded(index, trends.length),
            itemBuilder: (context, index) {
              final trend = trends[index % trends.length];
              return TrendCard(trend: trend);
            },
          );
        },
      ),
    );
  }
}

/// Minimal centered loading indicator matching dark theme.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(child: CircularProgressIndicator(color: Colors.white70)),
    );
  }
}

/// Minimal empty state with refresh action.
class _EmptyView extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'No trends available',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white12),
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimal error view showing message and retry.
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final display =
        message.length > 120 ? '${message.substring(0, 120)}...' : message;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                display,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ...existing code...