// Importing necessary packages and files.
import 'package:flutter/material.dart'; // Flutter's material design package for UI components.
import 'package:my_pocket_wallet/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_pocket_wallet/screens/pages/account.dart';
import 'package:my_pocket_wallet/screens/pages/mobile_recharge.dart';
import 'package:my_pocket_wallet/screens/pages/pay_bill.dart'; // Pay the Bill page.
import 'package:my_pocket_wallet/screens/pages/transfer.dart';
import 'package:my_pocket_wallet/screens/pages/withdraw.dart'; // Transfer page.

// Optimized Menu Item Widget for better performance
class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // Add RepaintBoundary for better performance
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.surface,
              child: Icon(icon, color: AppColors.accent, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Homecontent widget represents the main screen of the app.
class Homecontent extends StatelessWidget {
  const Homecontent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0, // No shadow for the app bar.
        automaticallyImplyLeading:
            false, // Removes the back arrow from the app bar.
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                try {
                  // Force a server fetch for latest values
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .get(const GetOptions(source: Source.server));
                  // Simple feedback
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data refreshed')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Refresh failed')),
                    );
                  }
                }
              }
            },
          ),
          IconButton(
            tooltip: 'Back to login',
            icon: const Icon(Icons.logout, color: AppColors.textPrimary),
            onPressed: () async {
              // If a user is signed in, sign them out first
              if (FirebaseAuth.instance.currentUser != null) {
                try {
                  await FirebaseAuth.instance.signOut();
                } catch (_) {}
              }
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (_) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final uid = FirebaseAuth.instance.currentUser?.uid;
            if (uid != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .get(const GetOptions(source: Source.server));
            } else {
              await Future.delayed(const Duration(milliseconds: 400));
            }
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user == null) ...[
                        _upperTextStatic(),
                      ] else ...[
                        _userHeaderAndCard(user.uid),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildListDelegate([
                    MenuItemWidget(
                      icon: Icons.account_balance_wallet,
                      label: 'Account\nand Card',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AccountAndCardPage()),
                      ),
                    ),
                    MenuItemWidget(
                      icon: Icons.swap_horiz,
                      label: 'Transfer',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TransferPage()),
                      ),
                    ),
                    MenuItemWidget(
                      icon: Icons.attach_money,
                      label: 'Withdraw',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WithdrawPage()),
                      ),
                    ),
                    MenuItemWidget(
                      icon: Icons.phone_android,
                      label: 'Mobile\nrecharge',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MobileRechargePage()),
                      ),
                    ),
                    MenuItemWidget(
                      icon: Icons.receipt,
                      label: 'Pay the bill',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PayTheBillPage()),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Grid now lives in a SliverGrid above; method removed
}

// Static greeting for guests (no auth)
Widget _upperTextStatic() {
  final greeting = _greetingForTime();
  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$greeting,', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const Text('Guest!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.accent)),
        const SizedBox(height: 20),
      ],
    ),
  );
}

// Greeting + realtime balance card for signed-in user
Widget _userHeaderAndCard(String uid) {
  final userDoc =
      FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  final greeting = _greetingForTime();
  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    stream: userDoc,
    builder: (context, snapshot) {
      final data = snapshot.data?.data();
      final name = (data?['displayName'] as String?)?.trim();
      final greetingName =
          (name == null || name.isEmpty) ? 'Friend' : name.split(' ').first;
      final balance = (data?['balance'] is num)
          ? (data!['balance'] as num).toDouble()
          : 0.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$greeting,', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text('$greetingName!', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.accent)),
                const SizedBox(height: 20),
              ],
            ),
          ),
          _balanceCard(name ?? 'Account', balance),
        ],
      );
    },
  );
}

Widget _balanceCard(String title, double balance) {
  return RepaintBoundary(
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surface,
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Current balance', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('•••• •••• •••• 9018', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                Text(
                  _formatCurrency(balance),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Align(alignment: Alignment.bottomRight, child: Text('VISA', style: TextStyle(color: AppColors.accent, fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    ),
  );
}

String _greetingForTime() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

String _formatCurrency(double amount) {
  // Lightweight USD formatting without intl dependency
  return '\$' + amount.toStringAsFixed(2);
}
