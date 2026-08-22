import 'package:expense_tracker/core/database/dao/key_value_store_dao.dart';
import 'package:expense_tracker/core/database/key_value_store_keys.dart';
import 'package:expense_tracker/core/exchange/domain/entities/exchange_rates.dart';

class ExchangeRateLocalDataSource {
  ExchangeRateLocalDataSource(this._keyValueStoreDao);

  final KeyValueStoreDao _keyValueStoreDao;

  Future<ExchangeRates?> readCachedRates() async {
    final raw = await _keyValueStoreDao
        .getValue<Map<String, dynamic>>(AppPreferences.exchangeRates.key);
    if (raw == null) return null;
    return ExchangeRates.fromJson(raw);
  }

  Future<void> writeCachedRates(ExchangeRates rates) {
    return _keyValueStoreDao.setValue<Map<String, dynamic>>(
      AppPreferences.exchangeRates.key,
      rates.toJson(),
    );
  }
}
