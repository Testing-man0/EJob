import 'package:ecl_admin/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Employee {
  final String empId;
  final String name;
  final String currentPlace;
  final String desiredPlace;
  final String designation;

  Employee({
    required this.empId,
    required this.name,
    required this.currentPlace,
    required this.desiredPlace,
    required this.designation,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      empId: json['empId'],
      name: json['name'],
      currentPlace: json['currentPlace'],
      desiredPlace: json['desiredPlace'],
      designation: json['designation'],
    );
  }
}

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  Map<String, List<Employee>> groupedEmployees = {};

  Future<void> fetchEmployees() async {
    final res = await http.get(Uri.parse("${Constants.uri}/jobs/all"));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      Map<String, List<Employee>> tempMap = {};

      for (var item in data) {
        final employee = Employee.fromJson(item);
        tempMap.putIfAbsent(employee.designation, () => []).add(employee);
      }

      setState(() {
        groupedEmployees = tempMap;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to fetch employees")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Employees by Designation"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: groupedEmployees.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: groupedEmployees.entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    title: Text(
                      "${entry.key} (${entry.value.length})",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    children: entry.value.map((emp) {
                      return ListTile(
                        title: Text("${emp.name} (${emp.empId})"),
                        subtitle: Text(
                          "Current: ${emp.currentPlace} → Desired: ${emp.desiredPlace}",
                        ),
                        leading: const Icon(Icons.person_outline),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
