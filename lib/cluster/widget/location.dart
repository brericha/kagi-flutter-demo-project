import 'package:flutter/material.dart';

/// Display a relevant location if there is one.
class Location extends StatelessWidget {
  const Location(this.location, {super.key});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        const Icon(Icons.location_on_outlined),
        Text(
          location,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
