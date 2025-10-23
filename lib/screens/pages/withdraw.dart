import 'package:flutter/material.dart';

// Optimized dropdown widget to prevent unnecessary rebuilds
class _WithdrawMethodDropdown extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String?> onChanged;

  const _WithdrawMethodDropdown({
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMethod,
          dropdownColor: Colors.blue[700],
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: ['Bank Transfer', 'Mobile Money', 'Crypto Wallet'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// Optimized text field widget
class _OptimizedWithdrawTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  const _OptimizedWithdrawTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blue[700],
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = 'Bank Transfer'; // Default withdrawal method

  @override
  void dispose() {
    _accountNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _withdraw() {
    if (_formKey.currentState!.validate()) {
      String accountNumber = _accountNumberController.text;
      String amount = _amountController.text;
      String method = _selectedMethod;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Withdrawing $amount via $method to account $accountNumber'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F), // Dark blue background
      appBar: AppBar(
        title: const Text('Withdraw', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WithdrawMethodDropdown(
                  selectedMethod: _selectedMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMethod = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _OptimizedWithdrawTextField(
                  controller: _accountNumberController,
                  label: 'Account Number',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _OptimizedWithdrawTextField(
                  controller: _amountController,
                  label: 'Amount',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                _buildWithdrawButton(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }



  /// Builds the "Withdraw" button
  Widget _buildWithdrawButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _withdraw,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange, // Orange button
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Withdraw', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}