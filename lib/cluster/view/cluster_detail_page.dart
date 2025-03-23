import 'package:flutter/material.dart';
import 'package:kite/cluster/widget/article_image.dart';
import 'package:kite/cluster/widget/did_you_know.dart';
import 'package:kite/cluster/widget/highlights.dart';
import 'package:kite/cluster/widget/international_reactions.dart';
import 'package:kite/cluster/widget/location.dart';
import 'package:kite/cluster/widget/perspectives.dart';
import 'package:kite/cluster/widget/quote.dart';
import 'package:kite/cluster/widget/section.dart';
import 'package:kite/cluster/widget/sources.dart';
import 'package:kite/cluster/widget/timeline.dart';
import 'package:kite/cluster/widget/user_action_items.dart';
import 'package:kite_api_client/kite_api_client.dart';

class ClusterDetailPage extends StatelessWidget {
  const ClusterDetailPage(this.cluster, {super.key});

  final Cluster cluster;

  List<Widget> _buildSections() {
    final sections = <Widget>[];
    final specialSections = [
      'timeline',
      'international_reactions',
      'user_action_items',
    ];

    for (final section in cluster.sections.keys) {
      if (!specialSections.contains(section)) {
        sections.add(Section(name: section, data: cluster.sections[section]!));
      }
    }

    if (cluster.sections.containsKey('international_reactions')) {
      sections.add(
        InternationalReactions(cluster.sections['international_reactions']!),
      );
    }

    if (cluster.sections.containsKey('timeline')) {
      sections.add(Timeline(cluster.sections['timeline']!));
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final articlesWithImages =
        cluster.articles.where((e) => e.image?.isNotEmpty ?? false).toList();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [const SliverAppBar(floating: true)];
        },
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cluster.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                cluster.shortSummary,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (cluster.location.isNotEmpty) Location(cluster.location),
              if (articlesWithImages.isNotEmpty)
                ArticleImage(articlesWithImages.first),
              if (cluster.talkingPoints.isNotEmpty)
                Highlights(cluster.talkingPoints),
              if (cluster.quote.isNotEmpty)
                Quote(
                  quote: cluster.quote,
                  quoteAuthor: cluster.quoteAuthor,
                  quoteSource: cluster.quoteSourceDomain,
                  quoteSourceUrl: cluster.quoteSourceUrl,
                ),
              if (articlesWithImages.length > 1)
                ArticleImage(articlesWithImages[1]),
              if (cluster.perspectives.isNotEmpty)
                Perspectives(cluster.perspectives),
              ..._buildSections(),
              Sources(articles: cluster.articles, domains: cluster.domains),
              if (cluster.sections.containsKey('user_action_items'))
                UserActionItems(cluster.sections['user_action_items']!),
              DidYouKnow(cluster.didYouKnow),
            ],
          ),
        ),
      ),
    );
  }
}
