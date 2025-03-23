import 'package:flutter/material.dart';
import 'package:kite/cluster/view/source_dialog.dart';
import 'package:kite/l10n/l10n.dart';
import 'package:kite_api_client/kite_api_client.dart';

class Sources extends StatefulWidget {
  const Sources({required this.articles, required this.domains, super.key});

  final List<Article> articles;
  final List<Domain> domains;

  @override
  State<Sources> createState() => _SourcesState();
}

class _SourcesState extends State<Sources> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _expanded = false;

  Map<Domain, List<Article>> _buildDomainMap() {
    final domainMap = <Domain, List<Article>>{};

    for (final domain in widget.domains) {
      final thisDomain = widget.articles.where((e) => e.domain == domain.name);
      domainMap[domain] = thisDomain.toList();
    }

    return domainMap;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final domainMap = _buildDomainMap();
    final keys = domainMap.keys.toList();

    final collapsedLength = keys.length < 6 ? keys.length : 6;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (_expanded) {
                _controller.reverse(from: 0.5);
              } else {
                _controller.forward(from: 0);
              }
              _expanded = !_expanded;
            });
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.clusterSources,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                  child: const Icon(Icons.expand_less),
                ),
              ),
            ],
          ),
        ),
        // TODO(brericha): See about making the expanding animation better
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: GridView.builder(
            itemCount: !_expanded ? collapsedLength : keys.length,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
            ),
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final domain = keys[index];
              final articles = domainMap[domain]!;

              return InkWell(
                onTap:
                    () => SourceDialog.show(
                      context,
                      domain: domain,
                      articles: articles,
                    ),
                child: Row(
                  spacing: 12,
                  children: [
                    Image.network(domain.favicon),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            domain.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(context.l10n.articleCount(articles.length)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
