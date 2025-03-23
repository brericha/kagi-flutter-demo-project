import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/l10n/l10n.dart';

/// Shown when an error occurs while loading data. Presents a retry button that
/// triggers the [onRetryPressed] callback function.
// TODO(brericha): More specific error messages for different errors
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.error,
    required this.onRetryPressed,
    super.key,
  });

  final Exception error;
  final VoidCallback onRetryPressed;

  double get _padding => 16;

  Future<void> _showErrorDetails(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.errorDetails),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: error.toString()));
                if (context.mounted) Navigator.of(context).pop();
              },
              child: Text(context.l10n.copy),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.ok),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top + _padding,
            bottom: MediaQuery.of(context).viewPadding.bottom + _padding,
            left: MediaQuery.of(context).viewPadding.left + _padding,
            right: MediaQuery.of(context).viewPadding.right + _padding,
          ),
          child: Column(
            spacing: 30,
            children: [
              const Icon(Icons.error_outline, size: 125),
              Text(
                context.l10n.errorTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                context.l10n.errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              FilledButton(
                onPressed: onRetryPressed,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                ),
                child: Text(
                  context.l10n.errorRetry,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              FilledButton(
                onPressed: () => _showErrorDetails(context),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                ),
                child: Text(
                  context.l10n.errorDetails,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
