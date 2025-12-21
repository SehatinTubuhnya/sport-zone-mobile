import 'package:flutter/material.dart';
import 'package:sport_zone/admin/models/admin_summary.dart';
import 'package:sport_zone/admin/models/action_log.dart';
import 'package:sport_zone/admin/models/account.dart';
import 'package:sport_zone/config.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AdminMainScreen extends StatefulWidget {
  final int selectedIndex;
  const AdminMainScreen({super.key, this.selectedIndex = 0});

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
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

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

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  Future<AdminSummary> fetchData(CookieRequest request) async {
    final response = await request.get('$SPORTZONE_URL/admin/api/summary');

    return AdminSummary.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: FutureBuilder<AdminSummary>(
        future: fetchData(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final formatter = NumberFormat.compact();
            final summary = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.3,
                    children: [
                      StatCard(
                        title: 'Total Users',
                        count: formatter.format(summary.userCount),
                        icon: Icons.group,
                      ),
                      StatCard(
                        title: 'Total Articles',
                        count: formatter.format(summary.articleCount),
                        icon: Icons.article,
                      ),
                      StatCard(
                        title: 'Total Products',
                        count: formatter.format(summary.productCount),
                        icon: Icons.shopping_bag,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdminMainScreen(selectedIndex: 2),
                            ),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ListView(
                    shrinkWrap: true,
                    children: summary.recentLogs.map((log) {
                      return LogListTile(
                        timestamp: log.timestamp.toString(),
                        actor: log.actor,
                        action: log.action,
                        isCompact: true,
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class AccountsTab extends StatefulWidget {
  const AccountsTab({super.key});

  @override
  State<AccountsTab> createState() => _AccountsTabState();
}

class _AccountsTabState extends State<AccountsTab> {
  List<Account>? accounts;
  String? error;

  final _formKey = GlobalKey<FormState>();
  String _editUsername = "";
  String? _editPassword;
  String? _editPfp;
  bool _editIsAdmin = false;
  bool _editIsAuthor = false;
  bool _editIsSeller = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final request = context.watch<CookieRequest>();
    fetchAccounts(request);
  }

  List<Account> _mapAccounts(List<dynamic> data) {
    return data.map((item) => Account.fromJson(item)).toList();
  }

  Future<void> fetchAccounts(CookieRequest request, [bool? isRefresh]) async {
    if (isRefresh == true) {
      setState(() {
        accounts = null;
        error = null;
      });
    }

    try {
      final response = await request.get(
        "$SPORTZONE_URL/admin/api/accounts/all",
      );

      setState(() {
        accounts = _mapAccounts(response["accounts"]);
        error = null;
      });
    } catch (e) {
      setState(() {
        accounts = null;
        error = e.toString();
      });
    }
  }

  Future<void> deleteAccount(
    BuildContext context,
    CookieRequest request,
    int id,
  ) async {
    final response = await request.postJson(
      "$SPORTZONE_URL/admin/api/accounts/delete",
      jsonEncode({"id": id}),
    );

    if (context.mounted) {
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Akun berhasil dihapus')));
        fetchAccounts(request, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus akun')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (accounts == null && error == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Manage Accounts')),
        body: Center(child: Text('Error: ${error!}')),
      );
    }

    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Accounts')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: accounts?.length ?? 0,
        separatorBuilder: (c, i) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final account = accounts![index];
          final roles = [
            if (account.isAdmin) "Admin",
            if (account.isAuthor) "Author",
            if (account.isSeller) "Seller",
          ];

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
                  backgroundImage: account.profilePic != null
                      ? NetworkImage(account.profilePic!)
                      : null,
                  child: account.profilePic == null
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
                        account.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Role Badges
                      Wrap(
                        spacing: 4,
                        children: roles.isEmpty
                            ? [
                                const RoleBadge(
                                  text: 'User',
                                  color: Colors.grey,
                                ),
                              ]
                            : roles
                                  .map(
                                    (r) => RoleBadge(
                                      text: r,
                                      color: r == 'Admin'
                                          ? Colors.red
                                          : (r == 'Seller'
                                                ? Colors.blue
                                                : Colors.green),
                                    ),
                                  )
                                  .toList(),
                      ),
                    ],
                  ),
                ),

                // Actions
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () =>
                          _showEditModal(context, request, account),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteAccount(context, request, account.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Bottom Sheet untuk Edit Akun (Pengganti Modal HTML)
  void _showEditModal(
    BuildContext context,
    CookieRequest request,
    Account account,
  ) {
    _editUsername = account.username;
    _editPassword = "";
    _editPfp = account.profilePic;
    _editIsAdmin = account.isAdmin;
    _editIsAuthor = account.isAuthor;
    _editIsSeller = account.isSeller;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
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
                          'Edit Akun',
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
                    const SizedBox(height: 16),

                    TextFormField(
                      initialValue: _editUsername,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          _editUsername = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _editPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password Baru (Opsional)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          _editPassword = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      initialValue: _editPfp,
                      decoration: InputDecoration(
                        labelText: 'Foto Profil (Opsional)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          _editPfp = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Roles',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CheckboxListTile(
                      value: _editIsAdmin,
                      title: const Text('Admin'),
                      activeColor: Colors.black,
                      onChanged: (val) {
                        setModalState(() {
                          _editIsAdmin = val ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      value: _editIsAuthor,
                      title: const Text('Author'),
                      activeColor: Colors.black,
                      onChanged: (val) {
                        setModalState(() {
                          _editIsAuthor = val ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      value: _editIsSeller,
                      title: const Text('Seller'),
                      activeColor: Colors.black,
                      onChanged: (val) {
                        setModalState(() {
                          _editIsSeller = val ?? false;
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final response = await request.postJson(
                              '$SPORTZONE_URL/admin/api/accounts/edit',
                              jsonEncode({
                                "id": account.id,
                                "username": _editUsername,
                                "profile_pic": _editPfp,
                                "password": _editPassword,
                                "is_admin": _editIsAdmin ? "on" : "off",
                                "is_author": _editIsAuthor ? "on" : "off",
                                "is_seller": _editIsSeller ? "on" : "off",
                              }),
                            );

                            if (context.mounted) {
                              if (response["status"] == "success") {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Akun berhasil diperbarui'),
                                  ),
                                );

                                fetchAccounts(request, true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Terjadi kesalahan saat memperbarui akun",
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Simpan Perubahan'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ActionLogsTab extends StatefulWidget {
  const ActionLogsTab({super.key});

  @override
  State<ActionLogsTab> createState() => _ActionLogsTabState();
}

class _ActionLogsTabState extends State<ActionLogsTab> {
  List<ActionLog>? actionLogs;
  String? error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final request = context.watch<CookieRequest>();
    fetchActionLogs(request, true);
  }

  List<ActionLog> _mapActionLogs(List<dynamic> json) {
    return json.map((json) => ActionLog.fromJson(json)).toList();
  }

  Future<void> fetchActionLogs(CookieRequest request, [bool? isRefresh]) async {
    if (isRefresh == true) {
      setState(() {
        actionLogs = null;
        error = null;
      });
    }

    try {
      final response = await request.get(
        "$SPORTZONE_URL/admin/api/action-logs/all",
      );

      setState(() {
        actionLogs = _mapActionLogs(response["logs"]);
        error = null;
      });
    } catch (e) {
      setState(() {
        actionLogs = null;
        error = e.toString();
      });
    }
  }

  Future<void> deleteActionLog(
    BuildContext context,
    CookieRequest request,
    String id,
  ) async {
    final response = await request.postJson(
      '$SPORTZONE_URL/admin/api/action-logs/delete',
      jsonEncode({
        "ids": [id],
      }),
    );

    if (context.mounted) {
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Log berhasil dihapus')));
        fetchActionLogs(request, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus log')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (actionLogs == null && error == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Action Logs')),
        body: Center(child: Text('Error: ${error!}')),
      );
    }

    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text('Action Logs')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: actionLogs?.length ?? 0,
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
              deleteActionLog(context, request, actionLogs![index].id);
            },
            child: LogListTile(
              timestamp: formatter.format(actionLogs![index].timestamp),
              actor: actionLogs![index].actor,
              action: actionLogs![index].action,
              isCompact: false,
              onDelTap: () {
                deleteActionLog(context, request, actionLogs![index].id);
              },
            ),
          );
        },
      ),
    );
  }
}

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
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LogListTile extends StatelessWidget {
  final String timestamp;
  final String actor;
  final String action;
  final bool isCompact;
  final void Function()? onDelTap;

  const LogListTile({
    super.key,
    required this.timestamp,
    required this.actor,
    required this.action,
    required this.isCompact,
    this.onDelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: isCompact
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade200)),
        borderRadius: isCompact ? BorderRadius.circular(8) : null,
      ),
      child: ListTile(
        contentPadding: isCompact
            ? const EdgeInsets.symmetric(horizontal: 12)
            : null,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.history, size: 16, color: Colors.black),
        ),
        title: Text(
          action,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '$actor • $timestamp',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: isCompact
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
                onPressed: () {
                  onDelTap?.call();
                },
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
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
