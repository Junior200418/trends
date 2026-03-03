// ...existing code...
import 'package:flutter/material.dart';
import '../models/trend_model.dart';
import 'detail_page.dart';
import '../constants/categories.dart';
import '../services/category_background_service.dart';

class TrendCard extends StatefulWidget {
  final Trend trend;
  const TrendCard({super.key, required this.trend});

  @override
  State<TrendCard> createState() => _TrendCardState();
}

class _TrendCardState extends State<TrendCard> {
  final PageController _horizontalController = PageController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryEnum = Category.fromName(widget.trend.category);
    final accent = categoryEnum.accent;

    // Get cached AssetImage (synchronous) — stable mapping per trend.id
    final imageProvider = CategoryBackgroundService.instance
        .getImageProviderForTrend(widget.trend);

    return Stack(
      children: [
        // Background image (uses Image with errorBuilder to avoid blank if asset missing)
        Positioned.fill(
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
            // show accent color fallback if asset can't be loaded
            errorBuilder: (context, error, stackTrace) {
              return Container(color: accent.withOpacity(0.12));
            },
          ),
        ),

        // Dark gradient overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Horizontal PageView: main + details
        PageView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          children: [
            _buildMainPage(categoryEnum, accent),
            DetailPage(trend: widget.trend),
          ],
        ),
      ],
    );
  }

  Widget _buildMainPage(Category categoryEnum, Color accent) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // push down to avoid floating header
            const SizedBox(height: 60),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: accent.withOpacity(0.22)),
                  ),
                  child: Text(
                    categoryEnum.label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: const [
                    Icon(Icons.swipe, color: Colors.white38, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Details',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),

            // ...rest unchanged
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime ts) {
    final diff = DateTime.now().difference(ts);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
// ...existing code...
// good so far