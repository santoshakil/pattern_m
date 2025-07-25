import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/env.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/presentation/providers/auth.p.dart';
import '../../../../shared/presentation/providers/theme.p.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          // Theme Section
          _buildSection(
            context,
            title: 'Appearance',
            children: [
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme'),
                subtitle: Text(_getThemeModeText(themeMode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(context, ref),
              ),
            ],
          ),
          
          // App Info Section
          _buildSection(
            context,
            title: 'About',
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Environment'),
                subtitle: Text(Env.current.name),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Licenses'),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: Env.appName,
                  applicationVersion: '1.0.0',
                ),
              ),
            ],
          ),
          
          // Developer Section (only in dev mode)
          if (Env.isDev) ...[
            _buildSection(
              context,
              title: 'Developer Options',
              children: [
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('Debug Logs'),
                  onTap: () => _showDebugLogs(context),
                ),
                ListTile(
                  leading: const Icon(Icons.api),
                  title: const Text('API Base URL'),
                  subtitle: Text(Env.apiBaseUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Clear Storage'),
                  onTap: () => _clearStorage(context, ref),
                ),
              ],
            ),
          ],
          
          // Account Section
          _buildSection(
            context,
            title: 'Account',
            children: [
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: context.errorColor,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(color: context.errorColor),
                ),
                onTap: () => _logout(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.primaryColor,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }
  
  String _getThemeModeText(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System',
    };
  }
  
  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeModeText(mode)),
              value: mode,
              groupValue: ref.watch(themeModeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
  
  void _showDebugLogs(BuildContext context) {
    context.showAppBottomSheet(
      isScrollControlled: true,
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      'Debug Logs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 50, // Example log entries
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      title: Text('Log entry $index'),
                      subtitle: Text('Timestamp: ${DateTime.now()}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  void _clearStorage(BuildContext context, WidgetRef ref) async {
    final confirmed = await context.showAppDialog<bool>(
      child: AlertDialog(
        title: const Text('Clear Storage'),
        content: const Text('This will clear all app data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Clear',
              style: TextStyle(color: context.errorColor),
            ),
          ),
        ],
      ),
    );
    
    if (confirmed == true && context.mounted) {
      // TODO: Implement storage clearing
      context.showSuccessSnackBar('Storage cleared');
    }
  }
  
  void _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await context.showAppDialog<bool>(
      child: AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: TextStyle(color: context.errorColor),
            ),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await ref.read(authStateProvider.notifier).logout();
    }
  }
}