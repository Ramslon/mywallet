import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_pocket_wallet/screens/pages/add_acard.dart';

class AccountAndCardPage extends StatefulWidget {
  const AccountAndCardPage({super.key});

  @override
  _AccountAndCardPageState createState() => _AccountAndCardPageState();
}

class _AccountAndCardPageState extends State<AccountAndCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900, // Consistent background
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        title: const Text(
          'Cards & Accounts',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCardsList(context)),
              const SizedBox(height: 16),
              _buildAddCardButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardsList(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Center(
        child: Text(
          'Please log in to view your cards.',
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
      );
    }

    final cardsQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cards')
        .orderBy('createdAt', descending: true);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: cardsQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
                color: Colors.orangeAccent, strokeWidth: 2),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load cards',
              style: TextStyle(color: Colors.redAccent.shade100),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.credit_card_off,
                    size: 48, color: Colors.white.withOpacity(0.6)),
                const SizedBox(height: 12),
                Text('No cards yet',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 16)),
                const SizedBox(height: 8),
                Text('Tap "Add Card" to create your first card.',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();
            final holder = (data['holderName'] ?? '').toString();
            final acct = (data['accountNumber'] ?? '').toString();
            final phone = (data['phoneNumber'] ?? '').toString();

            String masked = acct;
            if (acct.length >= 4) {
              final last4 = acct.substring(acct.length - 4);
              masked = '•••• $last4';
            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading:
                    const Icon(Icons.credit_card, color: Colors.orangeAccent),
                title: Text(holder.isEmpty ? 'Unnamed card' : holder,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(masked, style: const TextStyle(color: Colors.white70)),
                    if (phone.isNotEmpty)
                      Text(phone,
                          style: const TextStyle(color: Colors.white54)),
                  ],
                ),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit, color: Colors.white70),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddAcard(cardId: doc.id, initial: data),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _confirmDelete(context, uid, doc.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, String uid, String cardId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Delete Card', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this card?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cards')
          .doc(cardId)
          .delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Card deleted'),
            backgroundColor: Colors.orangeAccent),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to delete card'),
            backgroundColor: Colors.redAccent),
      );
    }
  }

  Widget _buildAddCardButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55, // Same button size as TransferPage
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.orangeAccent, // Matches TransferPage button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Same rounded corners
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAcard()),
          );
        },
        child: const Text(
          'Add Card',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Maintains contrast
          ),
        ),
      ),
    );
  }
}
