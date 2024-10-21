import 'package:flutter/material.dart';

class MenuOption {
  final String optionName;
  final IconData icon;
  final VoidCallback function;
  final Color? color;

  const MenuOption({
    required this.optionName,
    required this.icon,
    required this.function,
    this.color,
  });
}

class MoreButton extends StatelessWidget {
  final List<MenuOption> options;

  const MoreButton({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: const MenuStyle(),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: const Icon(Icons.more_vert, color: Colors.white),
          ),
        );
      },
      menuChildren: [
        for (int i = 0; i < options.length; i++)
          MenuItemButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.fromLTRB(12, 8, 26, 8),
              ),
            ),
            leadingIcon: Icon(options[i].icon, color: options[i].color),
            onPressed: options[i].function,
            child: Text(
              options[i].optionName,
              style: TextStyle(fontSize: 19, color: options[i].color),
            ),
          ),
      ],
    );
  }
}
