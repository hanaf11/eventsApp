import 'package:eventsappusers/models/kategorija.dart';

import 'base_provider.dart';

class KategorijeProvider extends BaseProvider<Kategorija> {
  KategorijeProvider() : super("Kategorije");

  @override
  Kategorija fromJson(data) {
    return Kategorija.fromJson(data);
  }
}
