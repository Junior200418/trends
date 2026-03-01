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
    Key? key,
    this.repository = const InMemoryTrendRepository(),
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _kInitialPage = 10000;
  late final PageController _pageController;
  late Future<List<Trend>> _trendsFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _kInitialPage);
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

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
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
  const _LoadingView({Key? key}) : super(key: key);

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
  const _EmptyView({Key? key, required this.onRefresh}) : super(key: key);

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
              child: const Text('Refresh'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white12),
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
  const _ErrorView({Key? key, required this.message, required this.onRetry})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayMessage =
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
                displayMessage,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ...existing code...