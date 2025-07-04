import 'package:eventsappusers/models/tipkarte.dart';
import 'package:eventsappusers/providers/base_provider.dart';

class TipkarteProvider extends BaseProvider<TipKarte> {
  TipkarteProvider() : super("TipKarte");

  @override
  TipKarte fromJson(data) {
    return TipKarte.fromJson(data);
  }
}
