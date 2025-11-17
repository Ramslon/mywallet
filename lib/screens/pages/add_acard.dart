import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_pocket_wallet/theme/app_theme.dart';

class AddAcard extends StatefulWidget {
  final String? cardId; // if provided, we are editing
  final Map<String, dynamic>? initial; // prefill values when editing

  const AddAcard({Key? key, this.cardId, this.initial}) : super(key: key);

  @override
  _AddAcardState createState() => _AddAcardState();
}

class _AddAcardState extends State<AddAcard> {
  // Form key for validation and submission
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _accountNumberController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Prefill when editing
    final init = widget.initial;
    if (init != null) {
      _accountNumberController.text = (init['accountNumber'] ?? '').toString();
      _cardHolderNameController.text = (init['holderName'] ?? '').toString();
      _phoneNumberController.text = (init['phoneNumber'] ?? '').toString();
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _accountNumberController.dispose();
    _cardHolderNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Function to handle form submission (create or update)
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to manage cards.'), backgroundColor: Colors.redAccent),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final data = {
        'holderName': _cardHolderNameController.text.trim(),
        'accountNumber': _accountNumberController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      final col = FirebaseFirestore.instance.collection('users').doc(uid).collection('cards');
      if (widget.cardId == null) {
        await col.add({
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card added successfully!'), backgroundColor: Colors.green),
        );
      } else {
        await col.doc(widget.cardId).update(data);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card updated successfully!'), backgroundColor: Colors.green),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save card.'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Add Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
  iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardSection(),
                const SizedBox(height: 20),
                // Account Number Field
                TextFormField(
                  controller: _accountNumberController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Account Number', hintText: '12345678912356'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the account number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Card Holder Name Field
                TextFormField(
                  controller: _cardHolderNameController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Card Holder Name', hintText: 'John Doe'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the card holder name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Phone Number Field
                TextFormField(
                  controller: _phoneNumberController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Phone Number', hintText: '+1234567890'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.accentContrast,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _saving ? null : _submitForm,
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
                          )
                        : Text(
                            widget.cardId == null ? 'Submit' : 'Update',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentContrast,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceAlt,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            const Text('Gega Smith', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              'OverBridge Expert',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('4756 •••• •••• 9018', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                Text('\$3,469.52', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: Text('VISA', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}