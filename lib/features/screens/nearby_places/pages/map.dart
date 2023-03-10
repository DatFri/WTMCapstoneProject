import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartfri/features/screens/nearby_places/models/place.dart';
import 'package:dartfri/features/screens/nearby_places/pages/map_cards.dart';
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
import '../../bookings/bookings_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin{
  late GoogleMapController mapController;
  late LatLng _center;
  late BitmapDescriptor pinLocationIcon;
   Set<Marker> _markers = new Set();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController tabController;


  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }


  Future<Set<Marker>> getMarkers(UserProvider userProvider ,PlacesProvider placesProvider) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/pin.png', 70);

    await updateMarkers(markerIcon,placesProvider);

    _center = LatLng(userProvider.currentPosition.latitude,
        userProvider.currentPosition.longitude);
    // final Marker marker = Marker(icon: BitmapDescriptor.fromBytes(markerIcon));
    // BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(),
    //   "assets/map.png",
    // );
    //     print('numbbbbbbbbbbbbbbbbbbbbbbb ${placesProvider.places.length}');
        // for (int i = 0; i < placesProvider.places.length;i++){
            // placesProvider.setMarkers(_markers);
    // print('mmmmmmmmmmmmmmmmmmmmmmmmmm ${placesProvider.markers.length}');
    // print('________mmmmmmmmmmmmmmmmmmmmmmmmmm ${_markers.length}');

    //  }

    return _markers;
  }
  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);
    final placesProvider = Provider.of<PlacesProvider>(context);

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
                              itemCount: placesProvider.places.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: (){

                                      showModalBottomSheet(context: context, builder: (context)=>getBottomSheet(placesProvider.places[index]));

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
                                                          '${placesProvider.places[index].imgUrl}',
                                                        ),
                                                        fit: BoxFit.cover),
                                                    borderRadius: BorderRadius.circular(10)),
                                                height: 70,
                                                width: 80,
                                              ),
                                           SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text(placesProvider.places[index].name!,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on_outlined),
                                                      Text(placesProvider.places[index].address!,style: TextStyle(fontSize: 12),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  RatingBarIndicator(
                                                    rating: double.parse(placesProvider.places[index].rating!),
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
            future: getMarkers(userProvider,placesProvider),
          ),
        ));
  }
  Widget getBottomSheet(Place place) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.4,
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    // color: Palette.primaryDartfri,
                    borderRadius: BorderRadius.all(Radius.circular(20)),

                  ),

                  // color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    '${place.imgUrl}',
                                  ),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10)),
                          height: MediaQuery.of(context).size.height * 0.18,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${place.name}',style: TextStyle(color: Colors.white,fontSize: 20),),
                              RatingBarIndicator(
                                rating: double.parse(place.rating!),
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
                        ),
                        Container(
                          decoration: BoxDecoration(
                            //This is for background color
                              color: Colors.white.withOpacity(0.0),
                              //This is for bottom border that is needed
                              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8))),
                          child: TabBar(
                              controller: tabController,
                              labelColor: Palette.primaryDartfri,
                              unselectedLabelColor: Colors.black,
                              indicatorColor:Palette.primaryDartfri ,
                              tabs:[
                                Tab(text: "Services",),
                                Tab(text: "About",),
                                Tab(text: "Review",),
                              ]

                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.15,
                          child: Expanded(
                            // width: double.maxFinite,
                              child:TabBarView(
                                  controller: tabController,
                                  children:  [
                                    Services(place:place),
                                    About(place:place),

                                    Review(place:place),
                                  ]
                              )
                          ),
                        ),
                        // Text(
                        //   "Location",
                        //   style: TextStyle(color: Colors.black, fontSize: 14),
                        // ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // Row(
                        //   children: <Widget>[
                        //     // Text(info,
                        //     //     style:
                        //     //         TextStyle(color: Colors.white, fontSize: 12)),
                        //     // mj
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // Text('${place.latitude} ${place.longitude}',
                        //
                        //     style: TextStyle(color: Colors.white, fontSize: 14)),
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

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return AppointmentFormPage(place: place);
                        }),
                      );
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
                // Row(
                //   children: <Widget>[
                //     SizedBox(
                //       width: 20,
                //     ),
                //     Icon(
                //       Icons.call,
                //       color: Palette.primaryDartfri,
                //     ),
                //     SizedBox(
                //       width: 20,
                //     ),
                //     Text("ji")
                //   ],
                // )
              ],
            ),
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


   addmarker(markerIcon,Place place,placesProvider) {
    _markers.add(Marker(
        markerId: MarkerId(Uuid().v4()),
        position: LatLng(double.parse(place.latitude!), double.parse(place.longitude!)),
        icon: BitmapDescriptor.fromBytes(markerIcon),

        infoWindow: InfoWindow(
            title: "${place.name}",
            onTap: () {
              showModalBottomSheet(context: context, builder: (context)=>getBottomSheet(place));
              // var bottomSheetController =
              // scaffoldKey.currentState?.showModalBottomSheet(
              //       (context) => Container(
              //     // height: MediaQuery.of(context).size.height * 0.1,
              //     color: Colors.white,
              //     child: getBottomSheet(place),
               // ),
            //  );
            },
            snippet: "${place.address}")));

  }

  updateMarkers(markerIcon,placesProvider) async {
    await placesProvider.newPlaces.forEach((element) async {
      Place place = Place.fromJson(element.toJson());
     await  addmarker(markerIcon, place,placesProvider);
      // print('numbbbbbbbbbbbbbbbbbbbbbbb ${placesProvider.newPlaces.length}');

    });
  }
}
