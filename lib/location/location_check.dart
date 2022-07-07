import 'package:firestart/location/location_show.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';



class LocationCheck extends StatelessWidget {

 late LocationPermission permission;

 Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
              child:  ElevatedButton(
                  onPressed: ()async{
                     permission = await Geolocator.requestPermission();
                     if(permission == LocationPermission.denied){
                       permission = await Geolocator.requestPermission();
                     }else if(permission == LocationPermission.deniedForever){
                         await Geolocator.openAppSettings();
                     }

                     if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
                        position = await Geolocator.getCurrentPosition();
                        if(position !=null){
                      final placeMarks = await placemarkFromCoordinates(position!.latitude, position!.longitude);
                       Get.to(() => MapSample(position!.latitude, position!.longitude));
                        }
                     }

                  }, child: Text('location')
              ),
            )
        )
    );
  }
}
