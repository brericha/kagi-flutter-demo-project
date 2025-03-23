import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kite/l10n/l10n.dart';
import 'package:kite/widget/bouncing.dart';

/// Shown while the app is loading data after launching.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 30,
          children: [
            Bouncing(
              child: SvgPicture.asset(
                'assets/kite.svg',
                width: 100,
                height: 100,
              ),
            ),
            Text(
              context.l10n.appTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              context.l10n.loadingMessage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
