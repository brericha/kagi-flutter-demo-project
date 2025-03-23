import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/l10n/l10n.dart';

class Section extends StatelessWidget {
  const Section({required this.name, required this.data, super.key});

  final String name;
  final List<String> data;

  String _getTitle(BuildContext context) {
    switch (name) {
      case 'geopolitical_context':
        return context.l10n.clusterGeopoliticalContext;
      case 'historical_background':
        return context.l10n.clusterHistoricalBackground;
      case 'humanitarian_impact':
        return context.l10n.clusterHumanitarianImpact;
      case 'future_outlook':
        return context.l10n.clusterFutureOutlook;
      case 'key_players':
        return context.l10n.clusterKeyPlayers;
      case 'technical_details':
        return context.l10n.clusterTechnicalDetails;
      case 'business_angle_text':
        return context.l10n.clusterBusinessAngleText;
      case 'business_angle_points':
        return context.l10n.clusterBusinessAnglePoints;
      case 'scientific_significance':
        return context.l10n.clusterScientificSignificance;
      case 'travel_advisory':
        return context.l10n.clusterTravelAdvisory;
      case 'destination_highlights':
        return context.l10n.clusterDestinationHighlights;
      case 'culinary_significance':
        return context.l10n.clusterCulinarySignificance;
      case 'performance_statistics':
        return context.l10n.clusterPerformanceStatistics;
      case 'league_standings':
        return context.l10n.clusterLeagueStandings;
      case 'diy_tips':
        return context.l10n.clusterDiyTips;
      case 'design_principles':
        return context.l10n.clusterDesignPrinciples;
      case 'user_experience_impact':
        return context.l10n.clusterUserExperienceImpact;
      case 'gameplay_mechanics':
        return context.l10n.clusterGameplayMechanics;
      case 'industry_impact':
        return context.l10n.clusterIndustryImpact;
      case 'technical_specifications':
        return context.l10n.clusterTechnicalSpecifications;
      default:
        // Converts something like "new_features" into "New features"
        return toBeginningOfSentenceCase(name.replaceAll('_', ' '));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (data.length == 1) {
      body = Text(data.first);
    } else {
      body = ListView.builder(
        itemCount: data.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Text('• ${data[index]}');
        },
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          _getTitle(context),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        body,
      ],
    );
  }
}
