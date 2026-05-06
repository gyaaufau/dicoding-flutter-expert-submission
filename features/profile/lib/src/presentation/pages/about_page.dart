import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resources/resources.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('About'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: kPrussianBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Image.asset(
                ResourceAssets.circleG,
                package: ResourceAssets.packageName,
                width: 96,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Ditonton',
            textAlign: TextAlign.center,
            style: kHeading5.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            'Ditonton adalah aplikasi katalog movie dan TV show yang dibuat sebagai proyek awal submission Dicoding kelas Flutter Expert.',
            textAlign: TextAlign.center,
            style: kSubtitle.copyWith(height: 1.5),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer',
                    style: kHeading6.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Argya Aulia Fauzandika',
                    style: kSubtitle.copyWith(color: kMikadoYellow),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aplikasi ini dikembangkan menggunakan Flutter dengan fokus pada clean architecture, state management, dan integrasi data movie serta TV show.',
                    style: kBodyText.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
