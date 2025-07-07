import 'package:flutter/material.dart';
import 'notifications_page.dart';
import 'package:http/http.dart' as http;
import 'package:ecl_client/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _empIdController = TextEditingController();
  bool isLoading = false;

  Future<void> _goToNotifications() async {
    final empId = _empIdController.text.trim();
    if (empId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your Employee ID")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // First call: mutual match checker
      final uri1 = Uri.parse('${Constants.uri}/api/jobs/mutual');
      final res1 = await http.get(uri1);
      print('🔄 Match check triggered. Status: ${res1.statusCode}');

      // Optional: show error if res1.statusCode != 200
    } catch (e) {
      print('❌ Error calling mutual API: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error triggering mutual check: $e")),
      );
      setState(() => isLoading = false);
      return;
    }

    setState(() => isLoading = false);

    // Proceed to notifications page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationsPage(empId: empId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check My Swap Alerts")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Your Employee ID",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _empIdController,
              decoration: const InputDecoration(
                hintText: "e.g. EMP001",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _goToNotifications,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("View Notifications"),
                  ),
          ],
        ),
      ),
    );
  }
}
