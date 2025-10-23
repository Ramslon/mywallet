import 'package:flutter/material.dart';

// Optimized dropdown widget to prevent unnecessary rebuilds
class _BillTypeDropdown extends StatelessWidget {
  final String selectedBillType;
  final ValueChanged<String?> onChanged;

  const _BillTypeDropdown({
    required this.selectedBillType,
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
          value: selectedBillType,
          dropdownColor: Colors.blue[700],
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: ['Electricity', 'Water', 'Internet', 'Rent'].map((String value) {
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
class _OptimizedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  const _OptimizedTextField({
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

class PayTheBillPage extends StatefulWidget {
  const PayTheBillPage({super.key});

  @override
  _PayTheBillPageState createState() => _PayTheBillPageState();
}

class _PayTheBillPageState extends State<PayTheBillPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _billNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedBillType = 'Electricity'; // Default selection

  @override
  void dispose() {
    _billNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _payBill() {
    if (_formKey.currentState!.validate()) {
      String billNumber = _billNumberController.text;
      String amount = _amountController.text;
      String billType = _selectedBillType;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Paying $amount for $billType to bill number $billNumber'),
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
        title: const Text('Pay the Bill', style: TextStyle(color: Colors.white)),
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
                _BillTypeDropdown(
                  selectedBillType: _selectedBillType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBillType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _OptimizedTextField(
                  controller: _billNumberController,
                  label: 'Bill Number',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _OptimizedTextField(
                  controller: _amountController,
                  label: 'Amount',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                _buildPayButton(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }



  /// Builds the "Pay Bill" button
  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _payBill,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange, // Orange button
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Pay Bill',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
