import 'package:eventsappusers/models/korisnik.dart';

class KorisnikGlobal {
  static String? username;
  static String? ime;
  static String? prezime;

  KorisnikGlobal(Korisnik k) {
    username = k.korisnickoIme;
    ime = k.ime;
    prezime = k.prezime;
  }
}
