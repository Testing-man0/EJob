import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  List matchedPairs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    final uri = Uri.parse("${Constants.uri}/matches/all-matches");
    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          matchedPairs = data['matchedPairs'];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load matches");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching matches: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : matchedPairs.isEmpty
              ? const Center(child: Text("No matches found."))
              : ListView.builder(
                  itemCount: matchedPairs.length,
                  itemBuilder: (context, index) {
                    final pair = matchedPairs[index];
                    final empA = pair['empA'];
                    final empB = pair['empB'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pair ${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildEmployeeRow("A", empA),
                            const SizedBox(height: 12),
                            _buildEmployeeRow("B", empB),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmployeeRow(String label, Map emp) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${emp['name']}"),
              Text("Emp ID: ${emp['empId']}"),
              Text("Designation: ${emp['designation']}"),
              Text("From: ${emp['currentPlace']} → To: ${emp['desiredPlace']}"),
              Text("Applied: ${emp['applied'] == true ? '✅ Applied' : '❌ Not Applied'}"),
              Text("Eligible: ${emp['eligible'] == true ? 'Yes' : 'No'}"),
            ],
          ),
        ),
      ],
    );
  }
}
