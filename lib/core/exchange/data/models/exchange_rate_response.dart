import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate_response.g.dart';

/// Response shape of `api.frankfurter.app/latest`.
///
/// `rates` maps a currency code to how many units of it one [base] unit buys,
/// e.g. with `base=INR`, `{"USD": 0.0116}` means 1 INR = 0.0116 USD.
@JsonSerializable()
class ExchangeRateResponse {
  const ExchangeRateResponse({
    required this.base,
    required this.date,
    required this.rates,
  });

  final String base;
  final String date;
  final Map<String, num> rates;

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateResponseToJson(this);
}
