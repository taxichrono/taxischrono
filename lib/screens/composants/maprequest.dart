import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../modeles/applicationuser/appliactionuser.dart';
import '../../modeles/autres/reservation.dart';
import '../../services/mapservice.dart';
import '../../varibles/variables.dart';

class RequestCard extends StatefulWidget {
  const RequestCard({Key? key, required this.reservation, this.idchauffeur})
      : super(key: key);

  final Reservation reservation;
  final String? idchauffeur;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  int valueconut = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prix = widget.reservation.prixReservation;
    final depart = widget.reservation.pointDepart;
    final arrive = widget.reservation.pointArrive;
    final type = widget.reservation.typeReservation;
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_taxi,
                    size: 30,
                    color: dredColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(type,
                      style: police.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  const Expanded(child: SizedBox()),
                  Text("$prix XFA",
                      style: police.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
              spacerHeight(8),
              FutureBuilder<ApplicationUser>(
                  future: widget.idchauffeur == null
                      ? ApplicationUser.infos(widget.reservation.idClient)
                      : ApplicationUser.infos(widget.idchauffeur),
                  builder: (context, snapshot) {
                    return (!snapshot.hasError && snapshot.hasData)
                        ? ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              snapshot.data!.userName,
                              maxLines: 1,
                              style: police.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.0),
                            ),
                            horizontalTitleGap: 5,
                            subtitle: Text(
                              snapshot.data!.userTelephone ??
                                  snapshot.data!.userEmail,
                              style: police.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: dredColor,
                                  letterSpacing: 3),
                            ),
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "images/user.png",
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ),
                            trailing: FutureBuilder<RouteModel?>(
                                future: GooGleMapServices().getRoute(
                                    start: depart.adresseposition,
                                    end: arrive.adresseposition),
                                builder: (context, snapshot) {
                                  return (!snapshot.hasError &&
                                          snapshot.hasData)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data!.distance.text,
                                              style: police,
                                            ),
                                            Text(
                                              snapshot
                                                  .data!.tempsNecessaire.text,
                                              style:
                                                  police.copyWith(fontSize: 12),
                                            ),
                                          ],
                                        )
                                      : shimmer(50.0, 60.0);
                                }),
                          )
                        // : snapshot.hasError
                        //     ? Text(snapshot.error.toString())
                        //     : !snapshot.hasData
                        //         ? Text("Aucunne donné")
                        : shimmer(60.0, double.infinity);
                  }),
              spacerHeight(12),
              ListTile(
                leading: Icon(Icons.pin_drop, color: dredColor, size: 30),
                horizontalTitleGap: 8,
                title: Text(
                  'Point de départ',
                  style: police.copyWith(fontSize: 12),
                ),
                subtitle: Text(
                  depart.adresseName,
                  maxLines: 2,
                  style: police.copyWith(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.0),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.watch_later_outlined,
                  color: Colors.blueGrey.shade500,
                ),
                title: Text(
                  DateFormat("EEEE d MMMM y")
                      .format(widget.reservation.dateReserVation),
                  style: police.copyWith(
                      color: valueconut > 5 ? Colors.black : dredColor,
                      fontSize: 13,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.location_history, color: dredColor, size: 30),
                horizontalTitleGap: 8,
                title: Text(
                  'point d\'arrivé',
                  style: police.copyWith(fontSize: 12),
                ),
                subtitle: Text(
                  arrive.adresseName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: police.copyWith(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.0),
                ),
              ),
              // spacerHeight(15),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     ElevatedButton.icon(
              //         icon: const Icon(Icons.close, size: 30.0),
              //         onPressed: () async {},
              //         style: ElevatedButton.styleFrom(
              //             backgroundColor: dredColor,
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 10, vertical: 9),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(9),
              //             )),
              //         label: Text('Annuler', style: police)),
              //     ElevatedButton.icon(
              //       icon: const Icon(Icons.check, size: 30.0),
              //       onPressed: () async {},
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.green,
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 25, vertical: 9),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(9),
              //           )),
              //       label: Text('Valider', style: police),
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
