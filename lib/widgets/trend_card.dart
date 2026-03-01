// ...existing code...
import 'package:flutter/material.dart';
import '../models/trend_model.dart';
import 'detail_page.dart';
import '../constants/categories.dart';

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

    return Stack(
      children: [
        // Background (replace with Image.asset(...) when assets ready)
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            // Example for later: add image per category
            // image: DecorationImage(image: AssetImage('${categoryEnum.assetPath}/img1.jpg'), fit: BoxFit.cover),
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
            // Top row: category tag + optional accent
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
                // small hint to swipe horizontally
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

            // Headline
            Center(
              child: Text(
                widget.trend.headline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Insight line
            Center(
              child: Text(
                widget.trend.insight,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),

            const Spacer(),

            // Timestamp row
            Row(
              children: [
                Text(
                  _formatTimestamp(widget.trend.timestamp),
                  style: const TextStyle(fontSize: 12, color: Colors.white54),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.white12,
                    shape: BoxShape.circle,
                  ),
                ),
                const Spacer(),
                // optional category accent dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
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
