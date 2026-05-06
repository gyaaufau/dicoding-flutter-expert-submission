import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'about_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: kMikadoYellow,
            child: Text(
              'AF',
              style: kHeading5.copyWith(
                color: kRichBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Argya Aulia Fauzandika',
            textAlign: TextAlign.center,
            style: kHeading5.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Flutter Developer',
            textAlign: TextAlign.center,
            style: kSubtitle.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang Saya',
                    style: kHeading6.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Halo, saya Argya Aulia Fauzandika. Halaman ini dibuat untuk kebutuhan submission Dicoding kelas Flutter Expert.',
                    style: kBodyText.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About App'),
              subtitle: const Text(
                'Informasi singkat tentang aplikasi Ditonton',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push(AboutPage.routeName),
            ),
          ),
        ],
      ),
    );
  }
}
