import 'package:expense/core/service_locator.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/wallet/domain/models/wallet.dart';
import 'package:expense/features/wallet/domain/models/wallet_form.dart';
import 'package:expense/features/wallet/domain/wallet_repository.dart';
import 'package:expense/shared/utils/display_error.dart';
import 'package:expense/shared/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logger instance
final _logger = Logger('Wallet');

/// Global provider for [WalletNotifier] exposing [WalletState].
final walletProvider = NotifierProvider<WalletNotifier, WalletState>(
  () => WalletNotifier(),
);

// State

/// Base class for all possible wallet states.
sealed class WalletState {}

/// Initial state before wallets have been loaded.
class WalletInitial extends WalletState {}

/// Emitted while wallets are being fetched.
class WalletLoading extends WalletState {}

/// Emitted when wallets are loaded. Holds the current list.
class WalletLoaded extends WalletState {
  final List<Wallet> wallets;

  WalletLoaded(this.wallets) {
    _logger.log(['Loaded:', wallets.length, 'items']);
  }
}

/// Emitted when a wallet operation fails.
class WalletError extends WalletState {
  final String message;

  WalletError(this.message);
}

// Notifier

/// Manages wallet state and fetches wallets from the repository.
class WalletNotifier extends Notifier<WalletState> {
  late WalletRepository _repo;

  @override
  WalletState build() {
    _repo = getIt<WalletRepository>();
    final currentProfile = ref.read(currentProfileProvider);
    if (currentProfile != null) {
      Future.microtask(() => initiate(currentProfile.id));
    }
    return WalletInitial();
  }

  /// Fetches wallets for [profileId].
  /// Shows existing data immediately while fetching fresh data in background.
  Future<void> initiate(int profileId) async {
    // If already loaded, keep showing current data while refreshing.
    if (state is! WalletLoaded) {
      state = WalletLoading();
    }
    try {
      final wallets = await _repo.list(profileId);
      state = WalletLoaded(wallets);
    } catch (e) {
      state = WalletError(displayError(e));
    }
  }

  Future<Wallet> create(WalletForm data) async {
    final loaded = state as WalletLoaded;
    Wallet created = await _repo.create(data);
    if (data.initialBalance > 0) {
      created = created.copyWith(used: 1);
    }
    state = WalletLoaded([...loaded.wallets, created]);
    return created;
  }

  Future<Wallet> update(int id, WalletForm data) async {
    final loaded = state as WalletLoaded;
    final updated = await _repo.update(id, data);
    final wallets = loaded.wallets
        .map((e) => e.id == id ? updated : e)
        .toList();
    state = WalletLoaded(wallets);
    return updated;
  }

  Future<void> destroy(int id) async {
    final loaded = state as WalletLoaded;
    await _repo.destroy(id);
    final wallets = loaded.wallets.where((e) => e.id != id).toList();
    state = WalletLoaded(wallets);
  }
}
