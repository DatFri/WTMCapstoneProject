import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartfri/features/screens/nearby_places/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../providers/places_provider.dart';
import '../../palette.dart';
import '../appointment/pages/appointment_page.dart';
import '../nearby_places/pages/map_cards.dart';

class CarwashDetail extends StatefulWidget {
   CarwashDetail({Key? key, required this.place}) : super(key: key);
   final Place place;

  @override
  State<CarwashDetail> createState() => _CarwashDetailState();
}

class _CarwashDetailState extends State<CarwashDetail>with TickerProviderStateMixin  {
  late TabController tabController;

  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<PlacesProvider>(context);

    return SafeArea(child:
    Scaffold(

      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height * 0.4,
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back)),
                  places.fav.contains(widget.place.uid) ? IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.favorite),
                    color: Colors.lightBlueAccent,
                    onPressed: () {
                      places.removeFromFav(widget.place);

                    },
                  ):IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.favorite_outline),
                    color: Colors.lightBlueAccent,
                    onPressed: () {
                      places.addToFav(widget.place);
                    },
                  ),
                ],
              ),
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
                                  '${widget.place.imgUrl}',
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10)),
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${widget.place.name}',style: TextStyle(color: Colors.white,fontSize: 20),),
                            RatingBarIndicator(
                              rating: double.parse(widget.place.rating!),
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
                                  Services(place:widget.place),
                                  About(place:widget.place),

                                  Review(place:widget.place),
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
              Align(
                alignment: Alignment.center,
                child: Container(
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
                          return AppointmentFormPage(place: widget.place);
                        }),
                      );
                      // await login(authProvider);

                    },
                    child: Text('Book',),

                  ),
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
    ));
  }
}
