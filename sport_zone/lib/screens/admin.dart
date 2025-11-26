import 'package:flutter/material.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardTab(),
    const AccountsTab(),
    const ActionLogsTab(),
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
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Colors.black),
            label: 'Summary',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: Colors.black),
            label: 'Accounts',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history, color: Colors.black),
            label: 'Logs',
          ),
        ],
      ),
    );
  }
}

// ================== TAB 1: SUMMARY / DASHBOARD ==================

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADMIN DASHBOARD')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistik Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              children: const [
                StatCard(
                  title: 'Total Users',
                  count: '1,240',
                  icon: Icons.group,
                ),
                StatCard(
                  title: 'Total Articles',
                  count: '85',
                  icon: Icons.article,
                ),
                StatCard(
                  title: 'Total Products',
                  count: '342',
                  icon: Icons.shopping_bag,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activity Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {}, // Navigate to Logs Tab logically
                  child: const Text('View All', style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
            const SizedBox(height: 8),

            // Preview Logs (Hanya 3 teratas)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return LogListTile(
                  timestamp: '2024-09-10 14:23',
                  user: 'admin${index + 1}',
                  action: index % 2 == 0 ? 'Created a new article' : 'Deleted a user',
                  isCompact: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ================== TAB 2: MANAGE ACCOUNTS ==================

class AccountsTab extends StatelessWidget {
  const AccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<Map<String, dynamic>> users = [
      {'username': 'josh_christmas', 'role': ['Admin', 'Author'], 'pic': 'https://placehold.co/100/black/white?text=JC'},
      {'username': 'seller_official', 'role': ['Seller'], 'pic': 'https://placehold.co/100/blue/white?text=SO'},
      {'username': 'guest_user_99', 'role': [], 'pic': null}, // No Pic
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('MANAGE ACCOUNTS')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              hintText: 'Cari username...',
              leading: const Icon(Icons.search, color: Colors.grey),
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300)
              )),
            ),
          ),

          // List Accounts
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: users.length,
              separatorBuilder: (c, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = users[index];
                final roles = user['role'] as List;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      // Profile Pic
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: user['pic'] != null
                            ? NetworkImage(user['pic'])
                            : null,
                        child: user['pic'] == null
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 12),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['username'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            // Role Badges
                            Wrap(
                              spacing: 4,
                              children: roles.isEmpty
                                  ? [const RoleBadge(text: 'User', color: Colors.grey)]
                                  : roles.map((r) => RoleBadge(
                                  text: r,
                                  color: r == 'Admin' ? Colors.red : (r == 'Seller' ? Colors.blue : Colors.green)
                              )).toList(),
                            )
                          ],
                        ),
                      ),

                      // Actions
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showEditModal(context, user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Menghapus akun...')),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Sheet untuk Edit Akun (Pengganti Modal HTML)
  void _showEditModal(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16, right: 16, top: 16
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Edit Akun', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 16),

              const TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Baru (Opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              const Text('Roles', style: TextStyle(fontWeight: FontWeight.bold)),
              CheckboxListTile(
                value: true,
                title: const Text('Staff / Admin'),
                activeColor: Colors.black,
                onChanged: (val) {},
              ),
              CheckboxListTile(
                value: false,
                title: const Text('Author'),
                activeColor: Colors.black,
                onChanged: (val) {},
              ),
              CheckboxListTile(
                value: false,
                title: const Text('Seller'),
                activeColor: Colors.black,
                onChanged: (val) {},
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('SIMPAN PERUBAHAN'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

// ================== TAB 3: ACTION LOGS ==================

class ActionLogsTab extends StatelessWidget {
  const ActionLogsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ACTION LOGS')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key('log_$index'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              // Logika hapus log
            },
            child: LogListTile(
              timestamp: '2024-09-10 14:${index + 10}:00',
              user: index % 3 == 0 ? 'admin1' : 'user_test',
              action: index % 2 == 0 ? 'Updated product details' : 'Deleted a comment',
              isCompact: false,
            ),
          );
        },
      ),
    );
  }
}

// ================== WIDGET KECIL (COMPONENTS) ==================

class StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 28, color: Colors.grey[800]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class LogListTile extends StatelessWidget {
  final String timestamp;
  final String user;
  final String action;
  final bool isCompact;

  const LogListTile({
    super.key,
    required this.timestamp,
    required this.user,
    required this.action,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: isCompact ? null : Border(bottom: BorderSide(color: Colors.grey.shade200)),
        borderRadius: isCompact ? BorderRadius.circular(8) : null,
      ),
      child: ListTile(
        contentPadding: isCompact ? const EdgeInsets.symmetric(horizontal: 12) : null,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.history, size: 16, color: Colors.black),
        ),
        title: Text(action, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: Text('$user • $timestamp', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: isCompact ? null : IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          onPressed: () {},
        ),
      ),
    );
  }
}

class RoleBadge extends StatelessWidget {
  final String text;
  final Color color;

  const RoleBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
