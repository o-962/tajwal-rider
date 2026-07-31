import 'package:shared/models/api_dto.dart';

/// Implemented by any order controller that can be quoted before submitting.
///
/// Mirrors the [OrderLocationTarget] pattern: the shared summary screen stays
/// flow-agnostic, and each flow (passengers, gifts, …) registers itself under
/// this type before opening the summary, so the summary controller always talks
/// to whichever flow the rider is actually in.
abstract class OrderSummaryTarget {
  /// POST the draft to this flow's `/summary` endpoint. Returns the parsed body
  /// so the summary controller can read `data.summary` (and surface errors).
  ///
  Future<ApiDto> requestSummary({String? discountCode});

  /// Create the order for real. The flow owns what happens next (it already
  /// hydrates the current-order controller and navigates).
  Future<void> submitOrder({String? discountCode});
}
