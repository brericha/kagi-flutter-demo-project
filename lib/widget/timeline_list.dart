import 'package:flutter/material.dart';

class TimelineList extends StatelessWidget {
  const TimelineList({
    required this.itemCount,
    required this.contentBuilder,
    required this.contentLength,
    this.lineWidth = 2,
    this.nodeSize = 20,
    this.nodeBuilder,
    this.shrinkWrap = false,
    this.padding,
    this.physics,
    super.key,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) contentBuilder;
  final int Function(BuildContext context, int index) contentLength;
  final Widget Function(BuildContext context, int index)? nodeBuilder;
  final double lineWidth;
  final double nodeSize;

  // ListView attributes
  final bool shrinkWrap;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  double _calculateLineHeight(int contentLength) {
    return 120 + (contentLength / 4);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primaryContainer;

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      padding: padding,
      physics: physics,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final isLast = index == itemCount - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                if (!isLast)
                  Container(
                    width: lineWidth,
                    height: _calculateLineHeight(contentLength(context, index)),
                    color: color,
                  ),

                if (nodeBuilder != null)
                  nodeBuilder!(context, index)
                else
                  CircleAvatar(radius: nodeSize),
              ],
            ),
            Expanded(child: contentBuilder(context, index)),
          ],
        );
      },
    );
  }
}
