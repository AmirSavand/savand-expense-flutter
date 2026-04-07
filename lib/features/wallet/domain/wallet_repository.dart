import 'package:expense/features/wallet/domain/models/wallet.dart';
import 'package:expense/features/wallet/domain/models/wallet_form.dart';

/// Abstract interface for wallet operations.
/// Implemented by [WalletRepositoryImpl] in the data layer.
abstract class WalletRepository {
  Future<List<Wallet>> list(int profileId);

  Future<Wallet> create(WalletForm payload);

  Future<Wallet> update(int id, WalletForm payload);

  Future<Wallet> retrieve(int id);

  Future<void> destroy(int id);
}
