import 'package:expense/features/update/domain/models/update_info.dart';

abstract class UpdateRepository {
  /// Fetches latest version and download URL from remote YAML.
  Future<UpdateInfo> fetchLatestVersion();
}
