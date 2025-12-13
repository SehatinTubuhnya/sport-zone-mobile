import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_zone/news/screens/news_entry_list.dart'; // Add intl package in pubspec.yaml for currency formatting
import 'package:sport_zone/screens/product_list.dart';
import 'package:sport_zone/screens/profile.dart';
import 'package:sport_zone/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sport_zone/providers/user_provider.dart';

class SportZoneApp extends StatelessWidget {
  const SportZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportZone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          secondary: const Color(0xFF202124),
          surface: Colors.white,
          background: const Color(0xFFF3F4F6), // Matches bg-gray-100
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        popupMenuTheme: PopupMenuThemeData(color: Colors.white),
        fontFamily: 'Roboto', // Or use GoogleFonts if added
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const NewsEntryListPage(),
    const ProductList(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.black.withOpacity(0.1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper, color: Colors.black),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag, color: Colors.black),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final articles = [
      {
        'title': 'Timnas Indonesia Siap Hadapi Kualifikasi Piala Dunia',
        'category': 'Match',
        'date': '26 Nov 2023',
        'image': 'https://placehold.co/600x400/png?text=Timnas',
      },
      {
        'title': 'Update Transfer Liga 1: Pemain Asing Baru',
        'category': 'Transfer',
        'date': '25 Nov 2023',
        'image': 'https://placehold.co/600x400/png?text=Transfer',
      },
      {
        'title': 'Analisis Taktik Permainan Manchester City',
        'category': 'Analysis',
        'date': '24 Nov 2023',
        'image': 'https://placehold.co/600x400/png?text=Analysis',
      },
    ];

    final products = [
      {
        'name': 'Jersey Home 2024',
        'price': 750000,
        'image': 'https://placehold.co/400x400/png?text=Jersey',
      },
      {
        'name': 'Sepatu Lari Pro',
        'price': 1200000,
        'image': 'https://placehold.co/400x400/png?text=Shoes',
      },
      {
        'name': 'Bola Sepak Official',
        'price': 500000,
        'image': 'https://placehold.co/400x400/png?text=Ball',
      },
      {
        'name': 'Tas Gym Sport',
        'price': 350000,
        'image': 'https://placehold.co/400x400/png?text=Bag',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SPORTZONE',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        actions: [
          Builder(
            builder: (context) {
              final request = Provider.of<CookieRequest>(context);
              final user = Provider.of<UserProvider>(context);
              if (request.loggedIn) {
                final uname = user.username ?? 'No username';
                final avatar = user.avatarUrl;
                return Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Profile()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            if (avatar != null && avatar.isNotEmpty)
                              CircleAvatar(backgroundImage: NetworkImage(avatar))
                            else
                              CircleAvatar(child: Text(uname.isNotEmpty ? uname[0].toUpperCase() : 'U')),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$uname', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Logout button with red background
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Replace URL if needed; keep trailing slash
                          final response = await request.logout("http://localhost:8000/auth/logout/");
                          String message = response["message"] ?? "Logout selesai";
                          if (response['status'] == true) {
                            try {
                              context.read<UserProvider>().clear();
                            } catch (_) {}
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(content: Text(message)));
                              // Do not navigate to LoginPage — stay on current screen
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)..showSnackBar(SnackBar(content: Text(message)));
                            }
                          }
                        },
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red background as requested
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero / Banner Section
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  // Request PNG explicitly to avoid SVG response (web can't decode SVG via ImageProvider)
                  image: NetworkImage('https://placehold.co/800x400/202124/FFFFFF.png?text=SPORTZONE+EVENT'),
                  fit: BoxFit.cover,
                  opacity: 0.7,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DISKON AKHIR TAHUN',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Hingga 50% All Items',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Artikel Terbaru Section
            SectionHeader(title: 'ARTIKEL TERBARU', onTapViewAll: () {}),
            SizedBox(
              height: 260,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return ArticleCard(data: articles[index]);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Produk Featured Section
            SectionHeader(title: 'PRODUK FEATURED', onTapViewAll: () {}),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(data: products[index]);
              },
            ),

            const SizedBox(height: 80), // Bottom spacing
          ],
        ),
      ),
    );
  }
}

// --- WIDGET COMPONENTS ---

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTapViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onTapViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
            ),
          ),
          GestureDetector(
            onTap: onTapViewAll,
            child: const Row(
              children: [
                Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                Icon(Icons.arrow_forward_ios, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ArticleCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                data['image'],
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 140,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data['category'],
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data['date'],
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProductCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                data['image'],
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormatter.format(data['price']),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Beli', style: TextStyle(fontSize: 12)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
