import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/ThemeNotifier.dart';

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  String _selectedTheme = "light";

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTheme = prefs.getString('theme') ?? "light";
    });
  }

  Future<void> _saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    setState(() {
      _selectedTheme = theme;
    });

    Provider.of<ThemeNotifier>(context, listen: false).setTheme(theme);
  }

  @override
  Widget build(BuildContext context) {
    final themes = ["light", "red - light", "dark", "red - dark"];

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: themes.map((theme) {
          return ListTile(
            title: Text("${theme[0].toUpperCase()}${theme.substring(1)} Theme"),
            trailing: _selectedTheme == theme
                ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                : null,
            onTap: () {
              _saveTheme(theme); // Save and apply the selected theme
            },
          );
        }).toList(),
      ),
    );
  }
}
