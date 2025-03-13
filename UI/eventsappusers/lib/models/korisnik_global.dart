import 'package:eventsappusers/models/korisnik.dart';

class KorisnikGlobal {
  static int? korisnikId;
  static String? username;
  static String? ime;
  static String? prezime;
  static String? lokacija;
  static String? slika;

  KorisnikGlobal(Korisnik k) {
    korisnikId = k.korisnikId;
    username = k.korisnickoIme;
    ime = k.ime;
    prezime = k.prezime;
    lokacija = k.adresa;
    slika = k.slika;
  }

  static void clear() {
    korisnikId = null;
    username = null;
    ime = null;
    prezime = null;
    lokacija = null;
    slika = null;
  }
}
