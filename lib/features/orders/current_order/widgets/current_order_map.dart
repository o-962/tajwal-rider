import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/shared/constants/map_options.dart';
import 'package:tajwal_rider/features/orders/current_order/model/current_order_model.dart';

/// Full-screen, freely draggable map behind the details sheet. Shows pickup,
/// drop-off, and the driver's live location (which keeps updating as the
/// backend pushes it on `rider:refresh`).
///
/// `initialCameraPosition` only applies on first build, so live location
/// updates move the driver marker without yanking the camera back — the rider
/// stays in control of panning/zooming.
class CurrentOrderMap extends StatelessWidget {
  const CurrentOrderMap({super.key, required this.order});

  final CurrentOrderModel order;

  @override
  Widget build(BuildContext context) {
    final d = order.details;
    final driver = order.driver;

    final markers = <Marker>{};
    if (d.hasPickup) {
      markers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(d.pickupLat, d.pickupLng),
        infoWindow: const InfoWindow(title: 'Pickup'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }
    if (d.hasDropoff) {
      markers.add(Marker(
        markerId: const MarkerId('dropoff'),
        position: LatLng(d.dropoffLat, d.dropoffLng),
        infoWindow: const InfoWindow(title: 'Drop-off'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    }
    if (driver != null && driver.hasLocation) {
      markers.add(Marker(
        markerId: const MarkerId('driver'),
        position: LatLng(driver.lat!, driver.lng!),
        infoWindow: InfoWindow(title: driver.name.isEmpty ? 'Driver' : driver.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
    }

    final LatLng target = (driver != null && driver.hasLocation)
        ? LatLng(driver.lat!, driver.lng!)
        : d.hasPickup
            ? LatLng(d.pickupLat, d.pickupLng)
            : d.hasDropoff
                ? LatLng(d.dropoffLat, d.dropoffLng)
                : MapOptions.initialPosition;

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: target, zoom: 13),
      markers: markers,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      // Bottom padding keeps Google's logo/controls above the details sheet.
      padding: const EdgeInsets.only(bottom: 320),
    );
  }
}
