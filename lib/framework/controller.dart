import 'packet_client.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'routing.dart';

class Controller {
  final Map<String, Function> _handlers = {};

  int register(String key, Function handler) {
    if (_handlers[key] != null) {
      return Code.entryAlreadyExists;
    }
    _handlers[key] = handler;
    return Code.oK;
  }

  int unRegister(String key) {
    try {
      if (_handlers[key] != null) {
        _handlers.remove(key);
        return Code.oK;
      } else {
        print('Controller.unRegister entryNotFound');
        return Code.entryNotFound;
      }
    } catch (e) {
      print('Controller.unregister.e: ${e.toString()}, key: $key');
      return Code.internalError;
    }
  }

  int clear() {
    try {
      _handlers.clear();
      return Code.oK;
    } catch (e) {
      print('Controller.clear.e: ${e.toString()}');
      return Code.internalError;
    }
  }

  void handle(String key, Map<String, dynamic> body) {
    try {
      _handlers[key]!(body);
    } catch (e) {
      print('Controller.handle.e: ${e.toString()}, key: $key');
      return;
    }
  }

  void dispatch(PacketClient packet) {
    // print("Controller.dispatch: major: ${packet.getHeader().getMajor()}, minor: ${packet.getHeader().getMinor()}");
    var key = Routing.key(
      major: packet.getHeader().getMajor(),
      minor: packet.getHeader().getMinor(),
    );
    try {
      if (_handlers[key] != null) {
        handle(key, packet.getBody());
        return;
      }
      print('Controller.dispatch entryNotFound');
      return;
    } catch (e) {
      print('Controller.dispatch.e: ${e.toString()}, key: $key');
      return;
    }
  }
}
