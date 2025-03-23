class TimelineEvent {
  const TimelineEvent({
    required this.date,
    required this.description,
  });

  /// Parse from formatted string "date:: description"
  factory TimelineEvent.fromString(String formattedString) {
    final parts = formattedString.split(':: ');
    if (parts.length != 2) {
      throw FormatException('Invalid timeline event format: $formattedString');
    }
    return TimelineEvent(
      date: parts[0],
      description: parts[1],
    );
  }

  final String date;
  final String description;
}
