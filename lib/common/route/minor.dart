import 'account.dart' as account_;
import 'generic.dart' as generic_;
import 'sms.dart' as sms_;
import 'admin.dart' as admin_;
import 'backend_gateway.dart' as backend_gateway_;

class Minor {
  static backend_gateway_.BackendGateway backendGateway = backend_gateway_.BackendGateway();
  static generic_.Generic generic = generic_.Generic();
  static account_.Account account = account_.Account();
  static sms_.SMS sms = sms_.SMS();
  static admin_.Admin admin = admin_.Admin();
}
