import 'package:expense/shared/utils/display_color.dart';
import 'package:expense/shared/utils/display_icon.dart';
import 'package:expense/shared/widgets/app_tile_icon.dart';

class AppTileIconForModel extends AppTileIcon {
  AppTileIconForModel({
    super.key,
    required String icon,
    required String color,
    super.size,
  }) : super(icon: displayIcon(icon), color: displayColor(color));
}
