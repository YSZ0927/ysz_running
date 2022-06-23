import 'package:flutter/material.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class StartRunning extends StatefulWidget {
  StartRunning({Key? key}) : super(key: key);

  @override
  State<StartRunning> createState() => _StartRunningState();
}

class _StartRunningState extends State<StartRunning> {
  static const AMapApiKey amapApiKeys =
      AMapApiKey(iosKey: '8bdaaa9732d343fbadcd430eeb8117c5');

  static const AMapPrivacyStatement amapPrivacyStatement =
      AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);

  AMapController? mapController;
  AMapFlutterLocation? location;
  CameraPosition? currentLocation;

  @override
  void initState() {
    super.initState();
    AMapFlutterLocation.setApiKey('', "8bdaaa9732d343fbadcd430eeb8117c5");
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.updatePrivacyShow(true, true);

    requestLocation();
  }

  void requestLocation() {
    location = AMapFlutterLocation()
      ..setLocationOption(AMapLocationOption())
      ..onLocationChanged().listen((event) {
        double? latitude = double.parse(event['latitude'] as String);
        double? longitude = double.parse(event['longitude'] as String);
        if (latitude != null && longitude != null) {
          setState(() {
            currentLocation = CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 17,
            );
            print('currentLocation:');
            print(currentLocation);
          });
        }
      })
      ..startLocation();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var stops2 = [0.0, 0.4, 1.0];
    var container = Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: RadialGradient(
              center: const Alignment(0.0, -0.5),
              focalRadius: 80.0,
              colors: const [
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 0.2),
                Color.fromARGB(255, 255, 255, 255)
              ],
              radius: 0.7,
              stops: stops2), // this list must have the same length as colors.
        ));
    return Stack(
      children: [
        currentLocation == null
            ? Container()
            : Container(
                constraints: BoxConstraints.tightFor(
                    width: MediaQuery.of(context).size.width, height: 400.0),
                child: AMapWidget(
                    apiKey: amapApiKeys,
                    initialCameraPosition: currentLocation!,
                    myLocationStyleOptions: MyLocationStyleOptions(true),
                    privacyStatement: amapPrivacyStatement)),
        Positioned(
          child: container,
        )
      ],
    );
  }
}
