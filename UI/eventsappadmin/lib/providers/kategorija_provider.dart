import 'package:eventsappadmin/providers/base_provider.dart';
import '../models/kategorija.dart';

class KategorijaProvider extends BaseProvider<Kategorija> {
  KategorijaProvider() : super("Kategorije");

  @override
  Kategorija fromJson(data) {
    return Kategorija.fromJson(data);
  }
}
