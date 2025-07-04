import 'package:eventsappadmin/models/tipkarte.dart';
import 'package:eventsappadmin/providers/base_provider.dart';

class TipkarteProvider extends BaseProvider<TipKarte> {
  TipkarteProvider() : super("TipKarte");

  @override
  TipKarte fromJson(data) {
    return TipKarte.fromJson(data);
  }
}
