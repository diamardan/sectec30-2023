// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? imageUrl;
  final String? payload;
  final String? smallIcon;

  ReceivedNotification(this.id, this.title, this.body, this.imageUrl,
      this.payload, this.smallIcon);

  @override
  String toString() {
    return 'ReceivedNotification(id: $id, title: $title, body: $body, imageUrl: $imageUrl, payload: $payload, smallIcon: $smallIcon)';
  }

  @override
  bool operator ==(covariant ReceivedNotification other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.body == body &&
        other.imageUrl == imageUrl &&
        other.payload == payload &&
        other.smallIcon == smallIcon;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        imageUrl.hashCode ^
        payload.hashCode ^
        smallIcon.hashCode;
  }
}
