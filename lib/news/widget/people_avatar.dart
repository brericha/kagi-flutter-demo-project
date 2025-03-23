import 'package:flutter/material.dart';
import 'package:kite/news/data/wikipedia_client.dart';

class PeopleAvatar extends StatelessWidget {
  const PeopleAvatar(this.content, {super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: WikipediaClient.fetchWikiImage(content),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.requireData != null) {
            return CircleAvatar(
              backgroundImage: NetworkImage(snapshot.requireData!),
              radius: 20,
            );
          } else {
            return const CircleAvatar();
          }
        } else {
          return const CircleAvatar();
        }
      },
    );
  }
}
