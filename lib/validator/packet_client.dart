import '../framework/packet_client.dart';
import '../../../common/code/code.dart';

int isPacketClientValid(PacketClient packet) {
  if (packet.getHeader().getMajor().isNotEmpty &&
      packet.getHeader().getMajor().isNotEmpty &&
      packet.getBody().isNotEmpty) {
    return Code.oK;
  }
  return Code.invalidDataType;
}
