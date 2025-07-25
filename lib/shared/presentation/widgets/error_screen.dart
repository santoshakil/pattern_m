import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/context_extensions.dart';

class ErrorScreen extends StatelessWidget {
  final Exception? error;
  
  const ErrorScreen({
    super.key,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: context.errorColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 50,
                    color: context.errorColor,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Error title
                Text(
                  'Oops! Something went wrong',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                // Error message
                Text(
                  error?.toString() ?? 'An unexpected error occurred',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.hintColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 32),
                
                // Actions
                Column(
                  children: [
                    // Go back button
                    if (context.canPop())
                      ElevatedButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Go Back'),
                      ),
                    const SizedBox(height: 12),
                    
                    // Go home button
                    OutlinedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.home),
                      label: const Text('Go Home'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}