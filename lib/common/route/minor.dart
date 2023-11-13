import 'account.dart' as account_;
import 'generic.dart' as generic_;
import 'sms.dart' as sms_;
import 'backend.dart' as backend_;
import 'gateway.dart' as gateway_;

class Minor {
  static gateway_.Gateway gateway = gateway_.Gateway();
  static generic_.Generic generic = generic_.Generic();
  static account_.Account account = account_.Account();
  static sms_.SMS sms = sms_.SMS();
  static backend_.Backend backend = backend_.Backend();
}
