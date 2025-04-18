import 'package:eventsappadmin/models/korisnik.dart';

class KorisnikGlobal {
  static int? korisnikId;

  KorisnikGlobal(Korisnik k) {
    korisnikId = k.korisnikId;
  }

  static void clear() {
    korisnikId = null;
  }
}
