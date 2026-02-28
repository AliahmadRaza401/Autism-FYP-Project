import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/child_model.dart';
import '../../../data/repositories/child_repository.dart';
import '../../../core/services/role_auth_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/services/location_service.dart';

class ChildDashboardController extends GetxController {
  final ChildRepository _childRepository = Get.find<ChildRepository>();
  final RoleAuthService _roleAuthService = Get.find<RoleAuthService>();
  final LocationService _locationService = Get.find<LocationService>();
  
  final Rx<ChildModel?> currentChild = Rx<ChildModel?>(null);
  final RxBool isLoading = false.obs;
  
  GoogleMapController? mapController;
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxString distanceToCenter = "".obs;

  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null && Get.arguments is ChildModel) {
      currentChild.value = Get.arguments as ChildModel;
      _getCurrentLocation();
    } else {
      _loadChildProfile().then((_) => _getCurrentLocation());
    }
  }

  Future<void> _loadChildProfile() async {
    try {
      isLoading.value = true;
      final currentUser = _roleAuthService.firebaseUser;
      if (currentUser != null) {
        final childDoc = await _childRepository.getChild(currentUser.uid);
        currentChild.value = childDoc;
      }
    } catch (e) {
      dev.log("Error loading child: $e", name: "CHILD_DASHBOARD");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      isLoading.value = true;
      final position = await _locationService.getCurrentPosition();
      
      if (position == null) {
        ErrorHandler.showErrorSnackBar('Location permissions are denied or service is disabled.');
        return;
      }

      currentPosition.value = position;
      
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: currentChild.value?.childName ?? 'Current Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        )
      );

      // Add a simulated medical facility marker to demonstrate distance calculation ok Muhammad
      final facilityLat = position.latitude + 0.05;
      final facilityLng = position.longitude + 0.05;
      
      markers.add(
        Marker(
          markerId: const MarkerId('medical_facility'),
          position: LatLng(facilityLat, facilityLng),
          infoWindow: const InfoWindow(title: 'Blue Circle Medical Center'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        )
      );

      final distanceInMeters = _locationService.calculateDistance(
        position.latitude, position.longitude,
        facilityLat, facilityLng
      );
      
      distanceToCenter.value = (distanceInMeters / 1000).toStringAsFixed(2);
      
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude), 
            13
          )
        );
      }
    } catch (e) {
      dev.log("Error getting location: $e", name: "CHILD_DASHBOARD");
    } finally {
      isLoading.value = false;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentPosition.value != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(currentPosition.value!.latitude, currentPosition.value!.longitude), 
          13
        )
      );
    }
  }

  Future<void> openInGoogleMaps() async {
    if (currentPosition.value == null) return;
    
    final lat = currentPosition.value!.latitude;
    final lng = currentPosition.value!.longitude;
    // this is url for query
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=medical+facilities&ll=$lat,$lng');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ErrorHandler.showErrorSnackBar('Could not open Google Maps');
    }
  }
}

