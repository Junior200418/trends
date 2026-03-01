// ...existing code...
import 'package:flutter/material.dart';
import '../models/trend_model.dart';

class DetailPage extends StatelessWidget {
  final Trend trend;
  const DetailPage({Key? key, required this.trend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trend.headline,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                trend.explanation,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text('Source', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 6),
              Text(trend.source, style: const TextStyle(color: Colors.white54)),
              const SizedBox(height: 20),
              Text(
                'Published ${_formatTimestamp(trend.timestamp)}',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
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
