import 'package:eventsappadmin/models/korisnik.dart';

class KorisnikGlobal {
  static int? korisnikId;
  static List<String>? uloge;

  KorisnikGlobal(Korisnik k) {
    korisnikId = k.korisnikId;
    uloge = k.uloge;
  }

  static void clear() {
    korisnikId = null;
    uloge = null;
  }
}
