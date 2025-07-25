import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/home.p.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome message
            Text(
              'Welcome to Pattern M',
              style: context.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Enterprise Flutter Architecture',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.theme.hintColor,
              ),
            ),
            const SizedBox(height: 48),
            
            // Counter demo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Counter Demo',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You have pushed the button this many times:',
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$counter',
                      style: context.textTheme.displaySmall?.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.filled(
                          onPressed: () => ref.read(counterProvider.notifier).decrement(),
                          icon: const Icon(Icons.remove),
                          tooltip: 'Decrement',
                        ),
                        const SizedBox(width: 16),
                        IconButton.filled(
                          onPressed: () => ref.read(counterProvider.notifier).reset(),
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Reset',
                        ),
                        const SizedBox(width: 16),
                        IconButton.filled(
                          onPressed: () => ref.read(counterProvider.notifier).increment(),
                          icon: const Icon(Icons.add),
                          tooltip: 'Increment',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Feature examples
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  label: const Text('Show Snackbar'),
                  onPressed: () => context.showSuccessSnackBar('Hello from Pattern M!'),
                  avatar: const Icon(Icons.message, size: 18),
                ),
                ActionChip(
                  label: const Text('Show Error'),
                  onPressed: () => context.showErrorSnackBar('This is an error message'),
                  avatar: const Icon(Icons.error_outline, size: 18),
                ),
                ActionChip(
                  label: const Text('Show Dialog'),
                  onPressed: () => _showExampleDialog(context),
                  avatar: const Icon(Icons.info_outline, size: 18),
                ),
                ActionChip(
                  label: const Text('Bottom Sheet'),
                  onPressed: () => _showExampleBottomSheet(context),
                  avatar: const Icon(Icons.vertical_align_bottom, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showExampleDialog(BuildContext context) {
    context.showAppDialog(
      child: AlertDialog(
        title: const Text('Example Dialog'),
        content: const Text('This is an example dialog from Pattern M enterprise template.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _showExampleBottomSheet(BuildContext context) {
    context.showAppBottomSheet(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Example Bottom Sheet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('This is an example bottom sheet with drag handle.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}