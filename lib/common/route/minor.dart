import 'account.dart' as account_;
import 'generic.dart' as generic_;
import 'sms.dart' as sms_;
import 'backend.dart' as backend_;

class Minor {
  static generic_.Generic generic = generic_.Generic();
  static account_.Account account = account_.Account();
  static sms_.SMS sms = sms_.SMS();
  static backend_.Backend backend = backend_.Backend();
}
