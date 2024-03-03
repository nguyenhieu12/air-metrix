import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key, required this.index, required this.onTap});

  final int index;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0,
        color: Colors.green,
        padding: EdgeInsets.zero,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              navItem(Icons.dashboard, index, index == 0,
                  onTap: () => onTap(0)),
              navItem(Icons.air, index, index == 1, onTap: () => onTap(1)),
              navItem(Icons.article_outlined, index, index == 2,
                  onTap: () => onTap(2)),
              navItem(Icons.map, index, index == 3, onTap: () => onTap(3))
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, int index, bool selected, {Function()? onTap}) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 25,
        color: selected ? Colors.white : Colors.white.withOpacity(0.4),
      ),
    ));
  }
}
