import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'iap_coins_service.dart';

/// Controller for managing coins store state.
class CoinsController extends ChangeNotifier {
  final IapCoinsService _iapService = IapCoinsService();

  bool _loading = false;
  List<ProductDetails> _products = [];
  bool _storeAvailable = false;
  String? _errorMessage;
  bool _purchasing = false;
  bool _restoring = false;
  bool _disposed = false;

  bool get loading => _loading;
  List<ProductDetails> get products => _products;
  bool get storeAvailable => _storeAvailable;
  String? get errorMessage => _errorMessage;
  bool get purchasing => _purchasing;
  bool get restoring => _restoring;

  void _notifySafe() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  /// Initialize and load products.
  Future<void> init() async {
    try {
      _loading = true;
      _notifySafe();

      // 1. Skip IAP init - already done in HomeHub._initIap() with idempotency
      // This prevents duplicate GooglePlay queries
      _storeAvailable = _iapService.isAvailable;

      // 2. Load products
      await loadProducts();

      _storeAvailable = _iapService.isAvailable;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[CoinsController] Init error: $e');
        debugPrint('[CoinsController] StackTrace: $st');
      }
      // Set error state but don't crash
      _errorMessage = 'Failed to initialize store.';
      _storeAvailable = false;
    } finally {
      _loading = false;
      _notifySafe();
    }
  }

  /// Load products from the store.
  Future<void> loadProducts() async {
    _loading = true;
    _errorMessage = null;
    _notifySafe();

    try {
      _storeAvailable = _iapService.isAvailable;
      final products = await _iapService.loadProducts();

      if (products.isEmpty && _storeAvailable) {
        _errorMessage = 'No products available. Please try again later.';
      } else if (!_storeAvailable) {
        _errorMessage = 'Store not available. Please check your connection.';
      }

      _products = products;
    } catch (e) {
      _errorMessage = 'Failed to load products. Please try again.';
      if (kDebugMode) {
        debugPrint('[CoinsController] Error loading products: $e');
      }
    } finally {
      _loading = false;
      _notifySafe();
    }
  }

  /// Buy a coin pack by product ID.
  Future<bool> buyPack(String productId) async {
    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found: $productId'),
    );

    _purchasing = true;
    _errorMessage = null;
    _notifySafe();

    try {
      final success = await _iapService.buy(product);
      if (!success) {
        _errorMessage = 'Failed to initiate purchase. Please try again.';
        _notifySafe();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Purchase failed: ${e.toString()}';
      if (kDebugMode) {
        debugPrint('[CoinsController] Purchase error: $e');
      }
      _notifySafe();
      return false;
    } finally {
      _purchasing = false;
      _notifySafe();
    }
  }

  /// Restore/sync past purchases.
  /// This queries and processes any unconsumed purchases.
  Future<void> restorePurchases() async {
    if (_restoring) return; // Prevent multiple simultaneous restore operations

    _restoring = true;
    _errorMessage = null;
    _notifySafe();

    try {
      await _iapService.restorePurchases();
      if (kDebugMode) {
        debugPrint('[CoinsController] Restore purchases completed');
      }
    } catch (e) {
      _errorMessage = 'Failed to restore purchases. Please try again.';
      if (kDebugMode) {
        debugPrint('[CoinsController] Restore error: $e');
      }
    } finally {
      _restoring = false;
      _notifySafe();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
