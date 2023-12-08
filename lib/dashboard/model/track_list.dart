import 'track.dart';

class TrackList {
  List<Track> _body = [];
  int _length = 0;

  int getLength() {
    return _length;
  }

  TrackList(List<Track> any) {
    _body = any;
    _length = any.length;
  }

  List<Track> getBody() {
    return _body;
  }

  TrackList.fromJson(Map<String, dynamic> json) {
    List<Track> trackList = [];
    if (json.containsKey('track_list')) {
      List<dynamic> any = json['track_list'];
      for (var element in any) {
        trackList.add(
          Track.construct(
            operator: element['operator'],
            major: element['major'],
            minor: element['minor'],
            permission: element['permission'],
            request: element['request'].toString(),
            response: element['response'].toString(),
            timestamp: element['timestamp'],
          ),
        );
      }
    }
    _body = trackList;
  }
}
