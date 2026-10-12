class Announcement {
  final int id;
  final String title;
  final String description;
  final String priority;
  final String startsAt;
  final String endsAt;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.startsAt,
    required this.endsAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? 'normal',
      startsAt: json['starts_at'] ?? '',
      endsAt: json['ends_at'] ?? '',
    );
  }
}
