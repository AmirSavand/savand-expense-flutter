import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _secureStorage = FlutterSecureStorage();

class StorageField {
  final String key;

  const StorageField(this.key);

  Future<String?> read() {
    return _secureStorage.read(key: key);
  }

  Future<void> write(String value) {
    return _secureStorage.write(key: key, value: value);
  }

  Future<void> delete() {
    return _secureStorage.delete(key: key);
  }

  Future<bool> exists() async {
    return (await read()) != null;
  }
}

class StorageService {
  final access = StorageField('access');
  final refresh = StorageField('refresh');
  final user = StorageField('user');
  final profile = StorageField('profile');

  Future<void> flush() {
    return _secureStorage.deleteAll();
  }
}
