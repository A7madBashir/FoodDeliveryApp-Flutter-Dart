import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart';
// import 'package:google_map_polyline/google_map_polyline.dart';

class LocationProvider with ChangeNotifier {
  BitmapDescriptor _pinLocationIcon;
  BitmapDescriptor _deliverylocation;
  Map<MarkerId, Marker> _markers;
  Map<MarkerId, Marker> get markers => _markers;
  final MarkerId markerId = MarkerId("1");

  GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  Location _location;
  Location get location => _location;
  BitmapDescriptor get pinLocationIcon => _pinLocationIcon;
  BitmapDescriptor get deliverylocation => _deliverylocation;
  LatLng _locationPosition;
  LatLng get locationPosition => _locationPosition;

  final Set<Polyline> polyline = {};

  bool locationServiceActive = true;

  LocationProvider() {
    _location = new Location();
    _markers = <MarkerId, Marker>{};
  }

  initialization() async {
    await getUserLocation();
    await setCustomMapPin();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.onLocationChanged.listen(
      (LocationData currentLocation) {
        _locationPosition = LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        );

        print(_locationPosition);

        _markers.clear();

        Marker marker = Marker(
          markerId: markerId,
          position: LatLng(
            _locationPosition.latitude,
            _locationPosition.longitude,
          ),
          icon: pinLocationIcon,
          draggable: true,
          onDragEnd: ((newPosition) {
            _locationPosition = LatLng(
              newPosition.latitude,
              newPosition.longitude,
            );

            notifyListeners();
          }),
        );

        _markers[markerId] = marker;

        notifyListeners();
      },
    );
  }

  setMapController(GoogleMapController controller) {
    _mapController = controller;

    notifyListeners();
  }

  polyLine(var recivelatitude, var recivelongitude) {
    polyline.clear();
    polyline.add(Polyline(
      polylineId: PolylineId('route1'),
      // visible: true,
      points: [
        //Here Should Be The Delivery Location
        LatLng(locationPosition.latitude, locationPosition.longitude),
        //Here Should Be The Customer Location
        LatLng(recivelatitude, recivelongitude)
      ],
      width: 4,
      color: Colors.redAccent,
      // startCap: Cap.roundCap,
      // endCap: Cap.customCapFromBitmap(deliverylocation),
    ));
    Marker marker2 = Marker(
        markerId: MarkerId("2"),
        position: LatLng(recivelatitude, recivelongitude),
        icon: deliverylocation);
    _markers[MarkerId("2")] = marker2;
    return polyline;
  }

  setCustomMapPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/location.png',
    );
    _deliverylocation = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/delivery.png');
  }

  takeSnapshot() {
    return _mapController.takeSnapshot();
  }
}
