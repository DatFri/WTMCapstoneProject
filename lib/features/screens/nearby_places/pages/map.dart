import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../providers/places_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../palette.dart';

import '../../appointment/pages/appointment_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  late LatLng _center;
  late BitmapDescriptor pinLocationIcon;
  final Set<Marker> _markers = new Set();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<LatLng> getMarkers(userProvider) async {
    _center = LatLng(userProvider.currentPosition.latitude,
        userProvider.currentPosition.longitude);
    final Uint8List markerIcon = await getBytesFromAsset('assets/map.png', 100);
    // final Marker marker = Marker(icon: BitmapDescriptor.fromBytes(markerIcon));
    // BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(),
    //   "assets/map.png",
    // );

    _markers.add(Marker(
        markerId: MarkerId(Uuid().v4()),
        position: LatLng(_center.latitude, _center.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),

        infoWindow: InfoWindow(
            title: "My location",
            onTap: () {
              var bottomSheetController =
              scaffoldKey.currentState?.showBottomSheet(
                    (context) => Container(
                  height: 250,
                  color: Colors.white,
                  child: getBottomSheet(),
                ),
              );
            },
            snippet: "My location")));
    return _center;
  }

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);
    final places = Provider.of<PlacesProvider>(context);

    return SafeArea(
        child:
        Scaffold(
          key: scaffoldKey,
          body: FutureBuilder(
            builder: (ctx, snapshot) {
              // Checking if future is resolved or not
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occured',
                      style: TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object
                  return SingleChildScrollView(

                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: GoogleMap(
                              compassEnabled: true,
                              markers: _markers,

                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: this._center,
                                zoom: 18.0,
                              ),
                            ),
                          ),
                          Container(
                            height: 90,
                            child:

                            ListView.builder(
                              itemCount: places.places.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return AppointmentFormPage(place: places.places[index]);
                                        }),
                                      );
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>NearbyPlaces()));
                                    },
                                    child: Card(
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          width: 250,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            // color: Color(0xFFD3FBFF),
                                            // color: Palette.primaryDartfri,
                                            // border: Border.all(color: Palette.primaryDartfri,width: 1.5),
                                            borderRadius: BorderRadius.circular(20),

                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                          '${places.places[index].imgUrl}',
                                                        ),
                                                        fit: BoxFit.cover),
                                                    borderRadius: BorderRadius.circular(10)),
                                                height: 70,
                                                width: 80,
                                              ),
                                           SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text(places.places[index].name!,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on_outlined),
                                                      Text(places.places[index].address!,style: TextStyle(fontSize: 12),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  RatingBarIndicator(
                                                    rating: double.parse(places.places[index].rating!),
                                                    itemBuilder: (context, index) => Icon(
                                                      Icons.star,
                                                      color: Palette.primaryDartfri,
                                                    ),
                                                    itemCount: 5,
                                                    itemSize: 15.0,
                                                    direction: Axis.horizontal,
                                                  )
                                                ],
                                              ),

                                            ],
                                          )),
                                    )
                                );
                              },

                            ),),
                        ],
                      ));

                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return Center(
                child: CircularProgressIndicator(color: Palette.primaryDartfri,),
              );
            },

            // Future that needs to be resolved
            // inorder to display something on the Canvas
            future: getMarkers(userProvider),
          ),
        ));
  }
  Widget getBottomSheet() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Palette.primaryDartfri,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),

                // color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Location",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          // Text(info,
                          //     style:
                          //         TextStyle(color: Colors.white, fontSize: 12)),
                          // mj
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('${_center.latitude} ${_center.longitude}',

                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 140,
                height: 40,


                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(

                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )
                    ),

                    shadowColor:MaterialStateProperty.all<Color>(Color.fromRGBO(8, 143, 129, 0.4)) ,
                    elevation: MaterialStateProperty.all<double>(20),

                  ),
                  onPressed: () async {


                    // await login(authProvider);

                  },
                  child: Text('Book',),

                ),
              ),
              // Row(
              //   children: <Widget>[
              //     SizedBox(
              //       width: 20,
              //     ),
              //      Icon(
              //       Icons.map,
              //       color: Palette.primaryDartfri,
              //     ),
              //     SizedBox(
              //       width: 20,
              //     ),
              //     Text("${_center.latitude}" + "  " + "${_center.longitude}")
              //   ],
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.call,
                    color: Palette.primaryDartfri,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("ji")
                ],
              )
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                  backgroundColor:Colors.white ,
                  child: Icon(Icons.more,color: Palette.primaryDartfri,),
                  onPressed: () {

                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => HomeDetail(datas: a)));
                    //   Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (context) => HomeDetail(datas: this.data)));
                    // }),
                  }),
            ))
      ],
    );
  }
}
