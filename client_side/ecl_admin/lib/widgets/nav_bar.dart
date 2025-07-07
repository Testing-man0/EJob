import 'package:flutter/material.dart';

class SideNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SideNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.work, 'label': 'Transfer'},
      {'icon': Icons.people, 'label': 'Employees'},
      {'icon': Icons.local_convenience_store, 'label': 'Status'},

    ];

    return Container(
      width: 220,
      color: Colors.deepPurple.shade50,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            "ECL Admin",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
          ),
          const SizedBox(height: 24),
          ...List.generate(navItems.length, (index) {
            final item = navItems[index];
            final isSelected = selectedIndex == index;

            return ListTile(
              leading: Icon(
                item['icon'] as IconData,
                color: isSelected ? Colors.deepPurple : Colors.black54,
              ),
              title: Text(
                item['label'] as String,
                style: TextStyle(
                  color: isSelected ? Colors.deepPurple : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedTileColor: Colors.deepPurple.shade100.withOpacity(0.3),
              onTap: () => onItemSelected(index),
            );
          }),
        ],
      ),
    );
  }
}
