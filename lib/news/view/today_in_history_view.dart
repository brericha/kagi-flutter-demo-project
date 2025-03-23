import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kite/news/widget/people_avatar.dart';
import 'package:kite/util/string_ext.dart';
import 'package:kite/widget/timeline_list.dart';
import 'package:kite_api_client/kite_api_client.dart';
import 'package:url_launcher/url_launcher.dart';

class TodayInHistoryView extends StatelessWidget {
  const TodayInHistoryView(this.allEvents, {super.key});

  final List<Event> allEvents;

  @override
  Widget build(BuildContext context) {
    final events =
        allEvents.where((e) => e.type == 'event').sortedByCompare(
          (k) => k.sortYear,
          (a, b) {
            return b.compareTo(a);
          },
        ).toList();
    final people =
        allEvents.where((e) => e.type == 'people').sortedByCompare(
          (k) => k.sortYear,
          (a, b) {
            return b.compareTo(a);
          },
        ).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Text('Events', style: Theme.of(context).textTheme.headlineMedium),
          EventsView(events),
          Text('People', style: Theme.of(context).textTheme.headlineMedium),
          PeopleView(people),
        ],
      ),
    );
  }
}

class EventsView extends StatelessWidget {
  const EventsView(this.events, {super.key});

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return TimelineList(
      itemCount: events.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      contentLength: (context, index) {
        var length = 0;
        length += events[index].year.length;
        length += events[index].content.stripHtml().length;
        return length;
      },
      contentBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 6, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                events[index].year,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Html(
                data: events[index].content,
                onLinkTap: (url, _, _) {
                  if (url != null) launchUrl(Uri.parse(url));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class PeopleView extends StatelessWidget {
  const PeopleView(this.events, {super.key});

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return TimelineList(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      contentBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 6, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                events[index].year,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Html(
                data: events[index].content,
                onLinkTap: (url, _, _) {
                  if (url != null) launchUrl(Uri.parse(url));
                },
              ),
            ],
          ),
        );
      },
      contentLength: (context, index) {
        var length = 0;
        length += events[index].year.length;
        length += events[index].content.stripHtml().length;
        return length;
      },
      nodeBuilder: (context, index) {
        return PeopleAvatar(events[index].content);
      },
    );
  }
}
