part of 'ride_services.dart';

extension RideCancellation on RideService {
  Future<void> cancelOrder() async {
    try {
      await ApiServices.dio.post('/orders/cancel', data: {
        'reason': 'cancelled_by_rider',
      });
    } catch (e, stackTrace) {
      AppLogger.error('Error cancelling order', error: e, stackTrace: stackTrace);
      Crashlytics().logError(e, stackTrace: stackTrace);
    }
  }
}