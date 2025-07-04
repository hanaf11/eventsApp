import 'package:eventsappusers/models/dobavljac.dart';
import 'package:eventsappusers/providers/base_provider.dart';

class DobavljacProvider extends BaseProvider<Dobavljac> {
  DobavljacProvider() : super("Dobavljaci");

  @override
  Dobavljac fromJson(data) {
    return Dobavljac.fromJson(data);
  }
}
