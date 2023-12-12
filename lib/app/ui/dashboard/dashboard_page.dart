import 'package:flutter/material.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/ui/animal_form/animal_form_page.dart';
import 'package:lestari_admin/app/ui/article_form/article_form_page.dart';
import 'package:lestari_admin/app/ui/dashboard/animals/animals_page.dart';
import 'package:lestari_admin/app/ui/dashboard/articles/articles_page.dart';
import 'package:lestari_admin/app/ui/dashboard/campaigns/campaigns_page.dart';
import 'package:lestari_admin/app/ui/dashboard/profile/profile_page.dart';

class DashboardPage extends StatefulWidget {
  final int initialIndex;
  const DashboardPage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, Widget>> _navigationItems = [];
  List<Widget> _navigationViews = [];
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex.value = widget.initialIndex;

    _navigationItems = [
      {'Hewan': const Icon(Icons.pets)},
      {'Kampanye': const Icon(Icons.campaign)},
      {'Artikel': const Icon(Icons.article)},
      // {'Laporan': const Icon(Icons.flag)},
      {'Profil': const Icon(Icons.account_circle)},
    ];

    _navigationViews = [
      const AnimalsPage(),
      const CampaignsPage(),
      const ArticlesPage(),
      // const ReportsPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, _, __) {
          return Scaffold(
            body: IndexedStack(index: _selectedIndex.value, children: _navigationViews),
            floatingActionButton:
                (_selectedIndex.value == 0 || _selectedIndex.value == 2)
                    ? _buildFloatingActionButton(_selectedIndex.value)
                    : null,
            bottomNavigationBar: BottomNavigationBar(
              items: _navigationItems
                  .map((item) => BottomNavigationBarItem(
                      icon: item.values.first, label: item.keys.first))
                  .toList(),
              currentIndex: _selectedIndex.value,
              type: BottomNavigationBarType.fixed,
              onTap: (index) => _selectedIndex.value = index,
            ),
          );
        });
  }

  FloatingActionButton _buildFloatingActionButton(int index) {
    return FloatingActionButton(
      onPressed: () {
        if (index == 0) SharedCode.navigatorPush(context, const AnimalFormPage());
        if (index == 2) SharedCode.navigatorPush(context, const ArticleFormPage());
      },
      elevation: 1.0,
      child: const Icon(Icons.add, color: Colors.white, size: 35.0),
    );
  }
}
