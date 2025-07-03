import 'package:eventsappusers/models/dobavljac.dart';
import 'package:eventsappusers/providers/base_provider.dart';

class DobavljacProvider extends BaseProvider<Dobavljac> {
  static String? _baseUrl;
  DobavljacProvider() : super("Dobavljaci") {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7294/");
  }

  @override
  Dobavljac fromJson(data) {
    return Dobavljac.fromJson(data);
  }
}
