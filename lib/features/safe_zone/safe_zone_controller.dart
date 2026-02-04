import 'dart:ui';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../routes/app_pages.dart';

class SafeZoneController extends GetxController {

  final RxDouble radius = 500.0.obs;

  GoogleMapController? mapController;

  Rx<LatLng> center = const LatLng(31.5204, 74.3587).obs;

  RxSet<Circle> circles = <Circle>{}.obs;
  RxSet<Marker> markers = <Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    drawCircle();
    addMarker();
  }

  Future<void> getCurrentLocation() async {

    LocationPermission permission = await Geolocator.requestPermission();

    if(permission == LocationPermission.denied ||
       permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    center.value = LatLng(position.latitude, position.longitude);

    mapController?.animateCamera(
      CameraUpdate.newLatLng(center.value),
    );

    drawCircle();
    addMarker();
  }

  void drawCircle() {

    circles.clear();

    circles.add(
      Circle(
        circleId: const CircleId("safe_zone"),
        center: center.value,
        radius: radius.value,
        fillColor: const Color(0x332196F3),
        strokeColor: const Color(0xFF2196F3),
        strokeWidth: 2,
      ),
    );
  }

  void addMarker() {

    markers.clear();

    markers.add(
      Marker(
        markerId: const MarkerId("marker"),
        position: center.value,
        draggable: true,
        onDragEnd: (LatLng newPosition) {
          center.value = newPosition;
          drawCircle();
        },
      ),
    );
  }

  void updateRadius(double value) {
    radius.value = value;
    drawCircle();
  }

  void confirmSafeZone() {
    Get.offAllNamed(Routes.DASHBOARD);
  }
}
