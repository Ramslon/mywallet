import 'package:flutter/material.dart';

class MobileRechargePage extends StatelessWidget {
  const MobileRechargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F), // Dark blue background
      appBar: AppBar(
        title: const Text(
          'Recharge Mobile',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter phone number",
                hintStyle: const TextStyle(color: Colors.white70),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.blue[700], // Matches input field style
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildRecipientTile(context, "Jane Cooper"),
                _buildRecipientTile(context, "Wade Warren"),
                _buildRecipientTile(context, "Esther Howard"),
                _buildRecipientTile(context, "Cameron Williamson"),
                _buildRecipientTile(context, "Brooklyn Simmons"),
                _buildRecipientTile(context, "Leslie Alexander"),
                _buildRecipientTile(context, "Jenny Wilson"),
                _buildRecipientTile(context, "Guy Hawkins"),
                _buildRecipientTile(context, "Jacob Jones"),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildRecipientTile(BuildContext context, String name) {
    return ListTile(
      title:
          Text(name, style: const TextStyle(fontSize: 16, color: Colors.white)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TransferAmountScreen(name: name)),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.blue[800],
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white70,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.mail), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
      ],
    );
  }
}

class TransferAmountScreen extends StatelessWidget {
  final String name;
  const TransferAmountScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        title: const Text('Transfer money to',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            RepaintBoundary(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/picsolo.jpeg'),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const Text("3248 **** **** 3422",
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            const Text("\$320.00",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const Text("No fee", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RepaintBoundary(
                    child: Image.asset(
                      'assets/images/mastercard.png',
                      width: 40,
                      cacheWidth: 40,
                    ),
                  ),
                  const Text("**** 2236",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  const Text("Balance: \$530.00",
                      style: TextStyle(color: Colors.white70)),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TransferSuccessScreen(name: name)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}

class TransferSuccessScreen extends StatelessWidget {
  final String name;
  const TransferSuccessScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              Text(
                "\$320 has been sent to $name!",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.orange),
                  ),
                ),
                child: const Text("View receipt"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
