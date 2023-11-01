import 'packet_client.dart';
import 'controller.dart';

class MessageHook {
  final Controller _controller = Controller();

  MessageHook();

  void observe(PacketClient packet) {
    try {
      _controller.dispatch(packet);
    } catch (e) {
      return;
    }
  }

  void register(String key, Function handler) {
    print('MessageHook.register.key: $key');
    _controller.register(key, handler);
  }

  void unRegister(String key) {
    print('MessageHook.unregister.key: $key');
    _controller.unRegister(key);
  }

  void clear() {
    _controller.clear();
  }
}
