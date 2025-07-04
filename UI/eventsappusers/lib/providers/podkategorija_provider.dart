import 'package:eventsappusers/providers/base_provider.dart';
import '../models/podkategorija.dart';

class PodkategorijaProvider extends BaseProvider<Podkategorija> {
  PodkategorijaProvider() : super("Podkategorije");

  @override
  Podkategorija fromJson(data) {
    return Podkategorija.fromJson(data);
  }
}
