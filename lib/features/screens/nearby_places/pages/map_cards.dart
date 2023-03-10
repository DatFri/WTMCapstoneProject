
import 'package:dartfri/features/screens/nearby_places/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Services extends StatelessWidget {
  Services({
    Key? key, required this.place,
  }) : super(key: key);
  List services =["Car Polish","Car Shine",'Mobile Services'];
  List servicesRate =["UGX 10,000","UGX 10,000",'UGX 20,000'];

  final Place place;

  @override
  Widget build(BuildContext context)  {
    // final appointmentProvider = Provider.of<AppointmentProvider>(context);
    // final userProvider = Provider.of<UserProvider>(context);
    Stream<List> getAppointements () async* {



      yield services;
    }
    // List<dynamic> appointments = await appointmentProvider.getAppointments(userProvider.user.uid!);
    return StreamBuilder<Object>(
        stream: getAppointements(),
        builder: (context, snapshot) {
          return  snapshot.hasData ? Container(
            // padding: EdgeInsets.all(6),
            child: ListView.builder(

                physics: ScrollPhysics(),
                // shrinkWrap: true,
                itemCount:snapshot.hasData ? services.length : 0,
                scrollDirection: Axis.vertical,
                itemBuilder: (context,index){

                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${services[index]}'),
                            Text('${servicesRate[index]}')
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ):Container();
        }
    );
  }
}

class About extends StatelessWidget {
  About({
    Key? key, required this.place,
  }) : super(key: key);
  final Place place;
  String description = "We are available 24/7 and offer mobile services";
  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    // final appointmentProvider = Provider.of<AppointmentProvider>(context);
    // List appointments = appointmentProvider.appointments;
    Stream<String> getAppointements () async* {

      yield description;
    }
    return StreamBuilder<Object>(
        stream: getAppointements(),
        builder: (context, snapshot) {
          return snapshot.hasData ? Container(
            // padding: EdgeInsets.all(6),
            child:
                SizedBox(
                  height: 50,
                  child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Availability'),
                            Text('24/7')
                          ],
                        ),
                      ),

          ),
                )):Container();
        }
    );
  }
}

class Review extends StatelessWidget {
  Review({
    Key? key, required this.place,
  }) : super(key: key);
  List reviews =["Best place to polish","Quite polite services"];
  final Place place;

  @override
  Widget build(BuildContext context) {
    // final appointmentProvider = Provider.of<AppointmentProvider>(context);
    // final userProvider = Provider.of<UserProvider>(context);

    Stream<List> getAppointements () async* {

      yield reviews;
    }
    return StreamBuilder<Object>(
        stream: getAppointements(),
        builder: (context, snapshot) {
          return snapshot.hasData ? Container(
            // padding: EdgeInsets.all(6),
              child: ListView.builder(

                  physics: ScrollPhysics(),
                  // shrinkWrap: true,
                  itemCount:snapshot.hasData ? reviews.length : 0,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context,index){

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(

                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Pamella Teddy'),
                                  Text('23/03/2023'),
                                ],
                              ),
                            ),
                         Text('\"${reviews[0]}\"')
                          ],
                        ),
                      ),
                    );
                  })
          ):Container();
        }
    );
  }}