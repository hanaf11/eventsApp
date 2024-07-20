import 'package:eventsappusers/models/korisnik.dart';

class KorisnikGlobal {
  static int? korisnikId;
  static String? username;
  static String? ime;
  static String? prezime;

  KorisnikGlobal(Korisnik k) {
    korisnikId = k.korisnikId;
    username = k.korisnickoIme;
    ime = k.ime;
    prezime = k.prezime;
  }
}
