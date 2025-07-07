import 'package:ecl_admin/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobFormPage extends StatefulWidget {
  const JobFormPage({super.key});

  @override
  State<JobFormPage> createState() => _JobFormPageState();
}

class _JobFormPageState extends State<JobFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _name = TextEditingController();

  String? _currentPlace;
  String? _desiredPlace;
  String? _designation;

  final List<String> _places = [
    'Durgapur', 'Asansol', 'Kolkata', 'Ranchi', 'Bokaro', 'Jamshedpur'
  ];

  final List<String> _designations = [
    'Manager', 'Deputy Manager', 'Staff', 'Assistant'
  ];

  Future<void> submitEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "empId": _id.text.trim(),
      "name": _name.text.trim(),
      "currentPlace": _currentPlace,
      "desiredPlace": _desiredPlace,
      "designation": _designation,
    };

    final response = await http.post(
      Uri.parse("${Constants.uri}/jobs/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Employee added successfully")),
      );
      _id.clear();
      _name.clear();
      setState(() {
        _currentPlace = null;
        _desiredPlace = null;
        _designation = null;
      });
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to add employee';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Add Employee"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Card(
          elevation: 12,
          shadowColor: Colors.deepPurple.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 500,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Employee Transfer Request",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                    ),
                    const SizedBox(height: 24),

                    /// Employee ID
                    TextFormField(
                      controller: _id,
                      decoration: InputDecoration(
                        labelText: "Employee ID",
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? "Enter Employee ID" : null,
                    ),
                    const SizedBox(height: 16),

                    /// Name
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? "Enter Name" : null,
                    ),
                    const SizedBox(height: 16),

                    /// Current Place
                    DropdownButtonFormField<String>(
                      value: _currentPlace,
                      decoration: InputDecoration(
                        labelText: "Current Place",
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _places
                          .map((place) => DropdownMenuItem(
                                value: place,
                                child: Text(place),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _currentPlace = val),
                      validator: (val) => val == null ? "Select Current Place" : null,
                    ),
                    const SizedBox(height: 16),

                    /// Desired Place
                    DropdownButtonFormField<String>(
                      value: _desiredPlace,
                      decoration: InputDecoration(
                        labelText: "Desired Place",
                        prefixIcon: const Icon(Icons.location_searching),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _places
                          .map((place) => DropdownMenuItem(
                                value: place,
                                child: Text(place),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _desiredPlace = val),
                      validator: (val) => val == null ? "Select Desired Place" : null,
                    ),
                    const SizedBox(height: 16),

                    /// Designation
                    DropdownButtonFormField<String>(
                      value: _designation,
                      decoration: InputDecoration(
                        labelText: "Designation",
                        prefixIcon: const Icon(Icons.work),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _designations
                          .map((desig) => DropdownMenuItem(
                                value: desig,
                                child: Text(desig),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _designation = val),
                      validator: (val) => val == null ? "Select Designation" : null,
                    ),
                    const SizedBox(height: 24),

                    /// Submit Button
                    ElevatedButton.icon(
                      onPressed: submitEmployee,
                      icon: const Icon(Icons.send_rounded),
                      label: const Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
