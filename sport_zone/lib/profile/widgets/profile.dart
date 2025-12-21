import 'package:flutter/material.dart';
import 'package:sport_zone/admin/screens/admin.dart';
import 'package:sport_zone/profile/models/profile_detail.dart';
import 'package:sport_zone/profile/models/profile_content.dart';
import 'package:sport_zone/home/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';

class Profile extends StatelessWidget {
  final String? username;
  final bool shouldShowAdmin;

  const Profile({super.key, this.username, this.shouldShowAdmin = false});

  Future<ProfileDetail> _fetchProfileDetail(CookieRequest request) async {
    final response = await request.get(
      'http://localhost:8000/profile/api/detail/${username ?? ''}',
    );

    return ProfileDetail.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder(
      future: _fetchProfileDetail(request),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data'));
        } else {
          final profileDetail = snapshot.data!;
          return ProfileDisplay(
            profileDetail: profileDetail,
            shouldShowAdmin: shouldShowAdmin,
          );
        }
      },
    );
  }
}

class ProfileDisplay extends StatefulWidget {
  final ProfileDetail profileDetail;
  final bool shouldShowAdmin;

  const ProfileDisplay({
    super.key,
    required this.profileDetail,
    this.shouldShowAdmin = false,
  });

  @override
  State<ProfileDisplay> createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _birthDateController = TextEditingController();
  String? _editPfp;
  DateTime _editBirthDate = DateTime.now();
  String? _editPassword;
  String? _editConfirmPassword;

  late TabController _tabController;
  final List<String> _tabs = ['Tentang'];

  @override
  void initState() {
    super.initState();

    if (widget.profileDetail.isSeller) _tabs.add('Produk');
    if (widget.profileDetail.isAuthor) _tabs.add('Artikel');

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ProfileArticleContent> _mapProfileArticleContent(List<dynamic> data) {
    return data.map((e) => ProfileArticleContent.fromJson(e)).toList();
  }

  Future<List<ProfileArticleContent>> _fetchProfileArticleContent(
    CookieRequest request,
    int userId,
  ) async {
    final response = await request.get(
      'http://localhost:8000/profile/api/$userId/content?tab=artikel',
    );

    return _mapProfileArticleContent(response["data"]);
  }

  List<ProfileProductContent> _mapProfileProductContent(List<dynamic> data) {
    return data.map((e) => ProfileProductContent.fromJson(e)).toList();
  }

  Future<List<ProfileProductContent>> _fetchProfileProductContent(
    CookieRequest request,
    int userId,
  ) async {
    final response = await request.get(
      'http://localhost:8000/profile/api/$userId/content?tab=produk',
    );

    return _mapProfileProductContent(response["data"]);
  }

  Future<String> _fetchProfileAboutContent(
    CookieRequest request,
    int userId,
  ) async {
    final response = await request.get(
      'http://localhost:8000/profile/api/$userId/content',
    );

    return response["data"];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    final showAdmin =
        widget.profileDetail.isSelf &&
        widget.profileDetail.isAdmin &&
        widget.shouldShowAdmin;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: showAdmin ? 420 : 340,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              title: Text(
                innerBoxIsScrolled ? widget.profileDetail.username : 'Profil',
                style: TextStyle(
                  color: innerBoxIsScrolled ? Colors.black : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: const Color(0xFFF3F4F6),
                  padding: const EdgeInsets.only(
                    top: 100,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                widget.profileDetail.profilePic,
                              ),
                            ),
                          ),
                          // Edit Icon Badge
                          if (widget.profileDetail.isSelf)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    _showEditProfileSheet(context, request),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 2. Username & Info
                      Text(
                        widget.profileDetail.username,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Joined ${widget.profileDetail.dateJoinedDisplay}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 3. Badges
                      Wrap(
                        spacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          if (widget.profileDetail.isAdmin)
                            _buildBadge('Admin', Colors.red),
                          if (widget.profileDetail.isSeller)
                            _buildBadge('Seller', Colors.blue),
                          if (widget.profileDetail.isAuthor)
                            _buildBadge('Author', Colors.green),
                        ],
                      ),

                      // 4. ADMIN DASHBOARD ENTRY (Penyatuan Aplikasi)
                      if (showAdmin) ...[
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            // Navigasi ke Halaman Admin (Import class AdminMainScreen dari jawaban sebelumnya)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminMainScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.admin_panel_settings,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Admin Dashboard',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Kelola user & konten',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Sticky Tab Bar
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  indicatorWeight: 3,
                  tabs: _tabs.map((t) => Tab(text: t.toUpperCase())).toList(),
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Tentang
            _buildAboutTab(request),

            // Tab 2: Produk (Jika Seller)
            if (widget.profileDetail.isSeller) _buildProductsTab(request),

            // Tab 3: Artikel (Jika Author)
            if (widget.profileDetail.isAuthor) _buildArticlesTab(request),
          ],
        ),
      ),
    );
  }

  // === WIDGETS BUILDER ===

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildAboutTab(CookieRequest request) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: FutureBuilder(
        future: _fetchProfileAboutContent(request, widget.profileDetail.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tentang Saya',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.data!,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.cake,
                  'Tanggal Lahir',
                  widget.profileDetail.birthDateDisplay,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.calendar_month,
                  'Bergabung',
                  widget.profileDetail.dateJoinedDisplay,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductsTab(CookieRequest request) {
    return FutureBuilder(
      future: _fetchProfileProductContent(request, widget.profileDetail.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada produk yang dijual.'));
          }

          final formatter = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
          );

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final p = snapshot.data![index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        child: Image.network(
                          p.thumbnail,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatter.format(p.price),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildArticlesTab(CookieRequest request) {
    return FutureBuilder(
      future: _fetchProfileArticleContent(request, widget.profileDetail.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final a = snapshot.data![index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatter.format(a.createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      a.snippet,
                      style: const TextStyle(color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  // === EDIT PROFILE SHEET (Pengganti Modal HTML) ===
  void _showEditProfileSheet(BuildContext context, CookieRequest request) {
    final formatter = DateFormat('dd MMM yyyy');

    setState(() {
      _editPfp = widget.profileDetail.profilePic.isEmpty
          ? null
          : widget.profileDetail.profilePic;
      _editBirthDate = widget.profileDetail.birthDateIso;
      _editPassword = "";
      _editConfirmPassword = "";

      _birthDateController.text = formatter.format(_editBirthDate);
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Profil & Akun',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Section 1: Update Info
                  const Text(
                    'Update Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: widget.profileDetail.profilePic,
                    decoration: const InputDecoration(
                      labelText: 'URL Foto Profil',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _editPfp = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Lahir',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final newDate = await showDatePicker(
                        context: context,
                        initialDate: _editBirthDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (newDate != null) {
                        setState(() {
                          _editBirthDate = newDate;
                          _birthDateController.text = formatter.format(newDate);
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  // Section 2: Ganti Password
                  const Text(
                    'Ganti Password (Opsional)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _editPassword = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _editConfirmPassword = value;
                      });
                    },
                    validator: (value) {
                      if (value != _editPassword) {
                        return 'Konfirmasi password tidak sesuai';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final response = await request.postJson(
                            'http://localhost:8000/profile/api/update/',
                            jsonEncode({
                              "new_password": _editPassword,
                              "profile_pic": _editPfp,
                              "birth_date": DateFormat(
                                'yyyy-MM-dd',
                              ).format(_editBirthDate),
                            }),
                          );

                          if (context.mounted) {
                            if (response["success"]) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainScreen(initialIndex: 3),
                                ),
                                (route) => false,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profil berhasil diperbarui'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Terjadi kesalahan saat memperbarui profil",
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Simpan Perubahan'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper Class untuk Sticky Header TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white, // Background putih agar tidak transparan saat scroll
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
