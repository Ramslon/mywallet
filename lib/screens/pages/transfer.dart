import 'package:flutter/material.dart';
import 'package:my_pocket_wallet/theme/app_theme.dart';

// Refactored to rely on the global application Theme. Removed local MaterialApp
// wrapper and color literals; now uses semantic colors from AppColors.

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  _TransferPageState createState() =>
      _TransferPageState(); // Create the state for this widget
}

class _TransferPageState extends State<TransferPage> {
  int _currentPage =
      0; // Tracks the current page (0 = Search, 1 = Confirmation, 2 = Success)
  final TextEditingController _searchController =
      TextEditingController(); // For recipient input
  final TextEditingController _amountController =
      TextEditingController(); // For amount input
  final TextEditingController _pinController =
      TextEditingController(); // For PIN input
  String recipientName = ''; // Stores the recipient's name
  String amount = ''; // Stores the amount to transfer
  bool isProcessing = false; // Tracks if the transfer is being processed

  @override
  void dispose() {
    // Clean up controllers when the widget is removed
    _searchController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  // Navigate to the next page
  void _navigateToNextPage() {
    setState(() {
      if (_currentPage < 2) {
        _currentPage++; // Move to the next page
      }
    });
  }

  // Navigate to the previous page
  void _navigateToPreviousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--; // Move to the previous page
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0, // Remove shadow
        title: const Text(
          'Transfer Money',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.textPrimary),
        ),
        centerTitle: true, // Center the title
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed:
                    _navigateToPreviousPage, // Add back button for pages > 0
              )
            : null, // No back button on the first page
      ),
      body: IndexedStack(
        index: _currentPage, // More efficient than AnimatedSwitcher
        children: [
          _buildSearchScreen(),
          _buildConfirmationScreen(),
          _buildSuccessScreen(),
        ],
      ),
    );
  }



  // First Screen: Search for recipient and enter amount
  Widget _buildSearchScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0), // Add padding around the content
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align content to the left
        children: [
          const Text(
            'Transfer money to',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12), // Add spacing
          const Text(
            'Enter name, phone number, or account number',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // Recipient Input Field
          TextField(
            controller: _searchController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: _inputDecoration('Recipient Name / Phone / Account'),
          ),
          const SizedBox(height: 16),

          // Amount Input Field
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: _inputDecoration('Enter Amount'),
          ),
          const SizedBox(height: 20),

          // Continue Button
          ElevatedButton(
            onPressed: () {
              if (_searchController.text.isEmpty ||
                  _amountController.text.isEmpty) {
                _showErrorSnackbar(
                    'Please fill all fields'); // Show error if fields are empty
              } else {
                setState(() {
                  recipientName = _searchController.text; // Save recipient name
                  amount = '\$${_amountController.text}'; // Save amount
                });
                _navigateToNextPage(); // Move to the next page
              }
            },
            style: _buttonStyle(), // Custom button style
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  // Second Screen: Confirm transfer and enter PIN
  Widget _buildConfirmationScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirm Transfer',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 20),

          // Recipient Details
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.accent,
              child: Icon(Icons.person, color: AppColors.textPrimary),
            ),
            title: Text(
              recipientName,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            subtitle: Text(
              'Amount: $amount',
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 20),

          // PIN Input Field
          TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: _inputDecoration('Enter PIN'),
          ),
          const SizedBox(height: 20),

          // Confirm Transfer Button
          ElevatedButton(
            onPressed: () {
              if (_pinController.text.length < 4) {
                _showErrorSnackbar(
                    'Invalid PIN'); // Show error if PIN is too short
              } else {
                _navigateToNextPage(); // Move to the success page
              }
            },
            style: _buttonStyle(), // Custom button style
            child: isProcessing
                ? const CircularProgressIndicator(
                    color: Colors.white) // Show loading indicator
                : const Text('Confirm Transfer'),
          ),
        ],
      ),
    );
  }

  // Third Screen: Success Message
  Widget _buildSuccessScreen() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        children: [
      const Icon(Icons.check_circle, color: AppColors.success, size: 80),
          const SizedBox(height: 20),
          Text(
            'Success! $amount sent to $recipientName',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 30),

          // Done Button
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentPage = 0; // Reset to the first page
                _searchController.clear(); // Clear recipient input
                _amountController.clear(); // Clear amount input
                _pinController.clear(); // Clear PIN input
              });
            },
            style: _buttonStyle(), // Custom button style
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // Custom Input Decoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceAlt,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent),
      ),
    );
  }

  // Custom Button Style
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.textPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  // Show Error Snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
