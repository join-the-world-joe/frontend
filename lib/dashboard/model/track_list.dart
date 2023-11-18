import 'track.dart';

class TrackList {
  List<Track> _body;
  int _length;

  int getLength() {
    return _length;
  }

  TrackList(this._body, this._length);

  List<Track> getBody() {
    return _body;
  }

  factory TrackList.fromJson(Map<String, dynamic> json) {
    List<Track> tl = [];
    try {
      // print('json: $json');
      int length = 0;
      List<Track> trackList = [];
      if (json['length'] != null) {
        // print('length: ${json['length']}');
        length = json['length'];
      }
      if (json['track_list'] != null) {
        List<dynamic> any = json['track_list'];
        any.forEach((element) {
          trackList.add(Track.fromJson(element));
        });
        // any.forEach((key, value) {
        //   // trackList.add(Track.fromJson(value));
        // });
      }
      return TrackList(trackList, length);
      // List<String> operatorList = List<String>.from(json['operator_list']);
      // List<String> majorList = List<String>.from(json['major_list']);
      // List<String> minorList = List<String>.from(json['minor_list']);
      // List<String> permissionList = List<String>.from(json['permission_list']);
      // List<String> requestList = List<String>.from(json['request_list']);
      // List<String> responseList = List<String>.from(json['response_list']);
      // List<String> timestampList = List<String>.from(json['timestamp_list']);
      // for (var i = 0; i < operatorList.length; i++) {
      //   tl.add(
      //     Track(
      //       operatorList[i],
      //       majorList[i],
      //       minorList[i],
      //       permissionList[i],
      //       requestList[i],
      //       responseList[i],
      //       timestampList[i],
      //     ),
      //   );
      // }
    } catch (e) {
      print('TrackList failure, e: $e');
    }

    return TrackList(tl, 0);
  }
}
