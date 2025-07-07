import 'package:ecl_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  final String empId;
  const NotificationsPage({super.key, required this.empId});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List notifications = [];
  bool isLoading = true;
  bool applied = false;
  bool applying = false;

  Future<void> fetchNotifications() async {
    final uri = Uri.parse("${Constants.uri}/api/notifications/${widget.empId}");
    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        setState(() {
          notifications = json.decode(res.body);
        });
        await fetchEmployeeStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error fetching notifications")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchEmployeeStatus() async {
    final uri = Uri.parse("${Constants.uri}/api/jobs/status/${widget.empId}");
    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          applied = data['applied'] ?? false;
        });
      }
    } catch (_) {}
  }

  Future<void> applyForTransfer() async {
    if (applied || applying) return;
    setState(() => applying = true);

    final uri = Uri.parse("${Constants.uri}/api/jobs/apply/${widget.empId}");
    try {
      final res = await http.post(uri);
      if (res.statusCode == 200) {
        setState(() {
          applied = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully applied for transfer")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to apply for transfer")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => applying = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  String formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple.shade700,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(
                  child: Text(
                    "No transfer alerts found.\nPlease check back later.",
                    style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 37, 37)),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notifications.length,
                        itemBuilder: (_, index) {
                          final note = notifications[index];
                          final message = note['message'] ?? 'No message';
                          final createdAt = note['createdAt'] ?? '';
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.deepPurple.shade100,
                                child: const Icon(Icons.notifications, color: Colors.deepPurple),
                              ),
                              title: Text(
                                message,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                formatDate(createdAt),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: applied
                                  ? Colors.grey
                                  : const Color.fromARGB(255, 0, 255, 64),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            icon: const Icon(Icons.assignment_turned_in, color: Colors.white),
                            label: Text(
                              applied ? "Already Applied" : "Apply for Transfer",
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: applied ? null : applyForTransfer,
                          ),
                          const SizedBox(height: 8),
                          if (applied)
                            const Text(
                              "✅ You have already applied.",
                              style: TextStyle(color: Colors.green),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
