import 'package:collection/collection.dart';
import 'package:expense/features/wallet/domain/models/wallet.dart';
import 'package:expense/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletByIdProvider = Provider.family<Wallet?, int>((ref, id) {
  final state = ref.watch(walletProvider);
  if (state is! WalletLoaded) {
    return null;
  }
  return state.wallets.firstWhereOrNull((e) => e.id == id);
});
