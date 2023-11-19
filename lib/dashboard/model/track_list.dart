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

  factory TrackList.fromJson(Map<String, dynamic> json) {
    List<Track> tl = [];
    try {
      List<Track> trackList = [];
      if (json['track_list'] != null) {
        List<dynamic> any = json['track_list'];
        any.forEach((element) {
          trackList.add(Track.fromJson(element));
        });
      }
      return TrackList(trackList);
    } catch (e) {
      print('TrackList failure, e: $e');
    }

    return TrackList(tl);
  }
}
