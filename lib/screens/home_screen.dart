import 'package:flutter/material.dart';
import '../models/trend_model.dart';
import '../repositories/trend_repository.dart';
import '../repositories/in_memory_trend_repository.dart';
import '../constants/categories.dart';
import '../widgets/trend_card.dart';

final ValueNotifier<int> _verticalPageIndex = ValueNotifier<int>(0);

enum TopTab { ForYou, Categories, Selections }

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final TrendRepository repository;

  const HomeScreen({
    super.key,
    this.repository = const InMemoryTrendRepository(),
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _kLoopMultiplier = 10000;

  late final PageController _pageController;
  late Future<List<Trend>> _trendsFuture;

  int? _virtualItemCount;
  int? _centerPage;
  Category? _selectedCategory;
  bool _showCategoriesOverlay = false;
  TopTab _currentTab = TopTab.ForYou;

  @override
  void initState() {
    super.initState();
    _loadTrends();
  }

  void _loadTrends() {
    setState(() {
      _trendsFuture = widget.repository.getPublishedTrends();
    });
  }

  void _initLoopingController(int dataLength) {
    if (dataLength <= 0) return;
    final virtualCount = dataLength * _kLoopMultiplier;
    final center = virtualCount ~/ 2;

    _virtualItemCount = virtualCount;
    _centerPage = center;

    try {
      _pageController.dispose();
    } catch (_) {}

    _pageController = PageController(initialPage: center);
  }

  void _recenterIfNeeded(int rawIndex, int dataLength) {
    final virtualCount = _virtualItemCount;
    final center = _centerPage;
    if (virtualCount == null || center == null) return;

    final threshold = dataLength * 2;
    if (rawIndex <= threshold || rawIndex >= virtualCount - threshold) {
      final logicalIndex = rawIndex % dataLength;
      final target = center + logicalIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if ((_pageController.page ?? rawIndex).round() != target) {
          _pageController.jumpToPage(target);
        }
      });
    }
  }

  void _toggleCategoriesOverlay() {
    setState(() {
      _showCategoriesOverlay = !_showCategoriesOverlay;
      _currentTab = TopTab.Categories;
    });
  }

  void _selectCategory(Category category) {
    setState(() {
      _selectedCategory = category;
      _showCategoriesOverlay = false;
      _currentTab = TopTab.Selections;
    });
  }

  List<Trend> _filterTrends(List<Trend> trends) {
    if (_selectedCategory == null) return trends;
    return trends
        .where((t) => Category.fromName(t.category) == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Trend>>(
        future: _trendsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white70),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    snapshot.error?.toString() ?? 'Unknown error',
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadTrends,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final trends = _filterTrends(snapshot.data ?? []);
          if (trends.isEmpty) {
            return Center(
              child: Text(
                'No trends available',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          if (_virtualItemCount == null || _centerPage == null) {
            _initLoopingController(trends.length);
          }

          // MAIN STACK: vertical PageView + floating top selections
          return Stack(
            children: [
              // Vertical looping trends
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _virtualItemCount,
                onPageChanged: (index) {
                  _recenterIfNeeded(index, trends.length);
                  _verticalPageIndex.value = index % trends.length;
                },
                itemBuilder: (context, index) {
                  final trend = trends[index % trends.length];
                  // TrendCard now fully isolated; horizontal swipe won't show floating headers
                  return TrendCard(trend: trend);
                },
              ),

              // Floating top selections (always above vertical PageView only)
              SafeArea(
                child: ValueListenableBuilder<int>(
                  valueListenable: _verticalPageIndex,
                  builder: (_, __, ___) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTopButton(
                            'For You',
                            Icons.home,
                            TopTab.ForYou,
                            () {
                              setState(() {
                                _selectedCategory = null;
                                _currentTab = TopTab.ForYou;
                              });
                            },
                          ),
                          _buildTopButton(
                            'Categories',
                            Icons.search,
                            TopTab.Categories,
                            _toggleCategoriesOverlay,
                          ),
                          _buildTopButton(
                            'Selections',
                            Icons.filter_alt,
                            TopTab.Selections,
                            () {
                              setState(() {
                                _currentTab = TopTab.Selections;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Categories overlay
              if (_showCategoriesOverlay) _buildCategoriesOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopButton(
    String label,
    IconData icon,
    TopTab tab,
    VoidCallback onTap,
  ) {
    final isActive = _currentTab == tab;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration:
            isActive
                ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.12),
                      Colors.white.withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                )
                : null,
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesOverlay() {
    final categories = [
      Category.OilAndGas,
      Category.Politics,
      Category.ForexCrypto,
      Category.Inflation,
      Category.Unknown,
    ];

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.black.withOpacity(0.9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              categories
                  .map(
                    (cat) => ListTile(
                      leading: _getCategoryIcon(cat),
                      title: Text(
                        cat.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => _selectCategory(cat),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _getCategoryIcon(Category cat) {
    switch (cat) {
      case Category.OilAndGas:
        return const Icon(Icons.local_gas_station, color: Colors.white70);
      case Category.Politics:
        return const Icon(Icons.how_to_vote, color: Colors.white70);
      case Category.ForexCrypto:
        return const Icon(Icons.currency_bitcoin, color: Colors.white70);
      case Category.Inflation:
        return const Icon(Icons.show_chart, color: Colors.white70);
      default:
        return const Icon(Icons.category, color: Colors.white70);
    }
  }
}
