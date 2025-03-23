import 'package:flutter/material.dart';

/// Make a Widget "bounce" up and down.
/// [heightDelta] - How much to move up and down.
/// [duration] - Duration of one complete animation cycle.
class Bouncing extends StatefulWidget {
  const Bouncing({
    required this.child,
    this.heightDelta = 20,
    this.duration = const Duration(milliseconds: 500),
    super.key,
  });

  final double heightDelta;
  final Duration duration;
  final Widget child;

  @override
  State<Bouncing> createState() => _BouncingState();
}

class _BouncingState extends State<Bouncing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -widget.heightDelta * _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
