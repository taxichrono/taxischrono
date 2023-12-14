import 'dart:async';
// import 'dart:typed_data';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:page_transition/page_transition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:taxischronouser/modeles/autres/reservation.dart';
import 'package:taxischronouser/modeles/autres/transaction.dart';
import 'package:taxischronouser/modeles/autres/vehicule.dart';
import 'package:taxischronouser/screens/composants/coursrunning.dart';
import 'package:taxischronouser/screens/composants/courswaiting.dart';
import 'package:taxischronouser/screens/etineraires.dart';
import 'package:taxischronouser/screens/composants/sidebar.dart';
import 'package:taxischronouser/services/mapservice.dart';

import 'package:taxischronouser/varibles/variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///////////////////
  ///les variables
  ///////////////.
  Completer controllerMap = Completer<GoogleMapController>();
  ScrollController controllerSlide = ScrollController();

  late Widget estVisible;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool voirs = false;
  LatLng? location;
  LatLng? lastposition;

  Set<Marker> markersSets = {};

  Future<void> setMarkers() async {
    // Récupérer les bytes de l'image à partir de l'URL
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
        .buffer
        .asUint8List();

    if (location != null) {
      markersSets.add(
        Marker(
          markerId: MarkerId(authentication.currentUser?.uid ?? ''),
          position: location!,
          infoWindow: const InfoWindow(
            title: "Votre Position actuelle",
          ),
          icon: BitmapDescriptor.fromBytes(bytes),
        ),
      );
    }
  }

  // Location? userCurrentLocation;
  lastLocotionInit() async {
    await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true)
        .then((value) {
      lastposition = LatLng(value!.latitude, value.longitude);
      setState(() {});
    });
  }

  fromCurrentPosition() async {
    var permissison = await GooGleMapServices.handleLocationPermission();
    if (permissison) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((value) {
        setState(() {
          location = LatLng(value.latitude, value.longitude);
          setMarkers();
        });
      });
    }

    Geolocator.getPositionStream().listen((event) {
      setState(() {
        location = LatLng(event.latitude, event.longitude);
        setMarkers();
      });
    });
  }

  voirMaPosition() async {
    GoogleMapController googleMapController = await controllerMap.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location!,
          zoom: 16,
        ),
      ),
    );
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylinesSets = {};

  ///////////////////
  ///les fonctions
  ///////////////.

  @override
  void initState() {
    GooGleMapServices.requestLocation();
    fromCurrentPosition();

    lastLocotionInit();
    estVisible = boutoon();

    reservationEncour();
    setMarkers();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const SafeArea(child: SideBar()),
      body: SafeArea(
        child: Stack(
          children: [
            SlidingUpPanel(
                parallaxEnabled: true,
                minHeight: taille(context).height * 0.15,
                maxHeight: 480,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                body: GoogleMap(
                  myLocationEnabled: true,
                  // myLocationButtonEnabled: true,
                  polylines: Set<Polyline>.of(polylinesSets.values),
                  markers: markersSets,
                  onMapCreated: (control) {
                    controllerMap.complete(control);
                  },
                  initialCameraPosition: CameraPosition(
                      target: location != null
                          ? location!
                          : lastposition != null
                              ? lastposition!
                              : younde,
                      zoom: 16),
                ),
                panelBuilder: (controller) {
                  return SafeArea(
                    child: ListView(
                      controller: controller,
                      children: [
                        Center(
                          child: SizedBox(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 10,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        estVisible,
                      ],
                    ),
                  );
                }),
            Positioned(
              top: 10,
              left: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: InkWell(
                  onTap: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: dredColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.menu,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  if (location != null) {
                    voirMaPosition();
                    setMarkers();
                    setState(() {});
                  } else {
                    demandePosition();
                  }
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: dredColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(Icons.podcasts, size: 30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Uint8List> bitcone(imgurli) async {
    return (await NetworkAssetBundle(Uri.parse(imgurli)).load(imgurli))
        .buffer
        .asUint8List();
  }

  String imgurl =
      "https://firebasestorage.googleapis.com/v0/b/taxischrono-c12c9.appspot.com/o/Bonhomme%20LOca122%20(2).png?alt=media&token=a1394dea-4b12-4d90-b223-4473746317ef";
  String carUrl =
      "https://firebasestorage.googleapis.com/v0/b/taxischrono-c12c9.appspot.com/o/Bonhomme%20LOca%20voit.png?alt=media&token=c10224dc-8e5b-48fe-b713-d01f70eb6866";
  // fonction demandant l'activation des données

  demandePosition() {
    scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        height: 300,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              leading: const Icon(Icons.location_disabled_sharp, size: 30),
              title: Text('vous dever activer la localisation', style: police),
            ),
            spacerHeight(20),
            boutonText(
                context: context,
                action: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openLocationSettings();
                  // .then((value) {
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     PageTransition(
                  //         child: const HomePage(),
                  //         type: PageTransitionType.fade),
                  //     (route) => false);
                  // });
                  fromCurrentPosition();
                },
                text: "Activer ma localisation"),
            spacerHeight(15),
            boutonText(
                context: context,
                action: () {
                  Navigator.of(context).pop();
                },
                text: "Annuler"),
          ],
        ),
      );
    });
  }

  Widget boutoon() => Padding(
        padding: const EdgeInsets.all(15.0),
        child: boutonText(
            context: context,
            text: 'Ou Allons nous',
            action: () {
              Navigator.of(context).push(PageTransition(
                  child: const SearchDestinaitionPage(),
                  type: PageTransitionType.bottomToTop));
            }),
      );

  // permet de chercher si l'utilisteur a une reservation en cours donc
  reservationEncour() {
    if (authentication.currentUser != null) {
      TransactionApp.currentTransaction(authentication.currentUser!.uid)
          .listen((event) {
        if (event != null && event.isNotEmpty) {
          setState(() {
            estVisible = MapWaiting(transactionApp: event[0]);
          });

          if (event[0].etatTransaction == 0) {
            Reservation.reservationStream(event[0].idReservation)
                .listen((reserva) {
              Vehicule.vehiculeStrem(event[0].idChauffer).listen((vale) async {
                final bites = await bitcone(imgurl);
                final bitechau = await bitcone(carUrl);
                Set<Marker> sets = {
                  Marker(
                    markerId: const MarkerId("monChauffeur"),
                    infoWindow: const InfoWindow(
                        title: "Position actuelle du chauffeur"),
                    position: vale!.position!,
                    icon: BitmapDescriptor.fromBytes(bitechau),
                  ),
                  Marker(
                    markerId: MarkerId(authentication.currentUser!.uid),
                    infoWindow: const InfoWindow(title: "Ma position"),
                    position: reserva.pointDepart.adresseposition,
                    icon: BitmapDescriptor.fromBytes(bites),
                  ),
                };
                setState(() {
                  markersSets = sets;
                });
                getPolilineLines(
                  vale.position!,
                  reserva.pointDepart.adresseposition,
                  polylinePoints,
                  polylinesSets,
                );
                setState(() {});
              });
            });
            setState(() {});
          } else if (event[0].etatTransaction == 1) {
            Reservation.reservationStream(event[0].idReservation)
                .listen((reserv) async {
              setState(() {
                estVisible = CoursRunning(transactionApp: event[0]);
              });
              final bites = await bitcone(imgurl);
              Set<Marker> sets = {
                Marker(
                  markerId: MarkerId(authentication.currentUser!.uid),
                  infoWindow: const InfoWindow(title: "Ma position"),
                  position: location!,
                  icon: BitmapDescriptor.fromBytes(bites),
                ),
              };
              setState(() {
                markersSets = sets;
              });
              getPolilineLines(
                  reserv.pointDepart.adresseposition,
                  reserv.pointArrive.adresseposition,
                  polylinePoints,
                  polylinesSets);
            });
          }
        } else {
          setState(() {
            estVisible = boutoon();
          });
          setMarkers();
          setState(() {});
        }
      });
    }
  }
}
