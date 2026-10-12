class Activity {
  final int id;
  final String title;
  final String category;
  final String activityDate;
  final String location;
  final String pic;
  final String status;

  Activity({
    required this.id,
    required this.title,
    required this.category,
    required this.activityDate,
    required this.location,
    required this.pic,
    required this.status,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      activityDate: json['activity_date'] ?? '',
      location: json['location'] ?? '',
      pic: json['pic'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
