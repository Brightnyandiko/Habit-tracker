import 'package:isar/isar.dart';

//run cmd to generate files: flutter pub run build_runner build
part 'app_settings.g.dart';

@collection()
class AppSettings {
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;

}