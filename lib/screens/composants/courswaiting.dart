import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taxischronouser/modeles/autres/reservation.dart';
import 'package:taxischronouser/modeles/autres/transaction.dart';
import 'package:taxischronouser/screens/composants/maprequest.dart';
import 'package:taxischronouser/screens/homepage.dart';
import 'package:taxischronouser/varibles/variables.dart';

import '../../modeles/applicationuser/appliactionuser.dart';
// import '../../modeles/applicationuser/client.dart';

class MapWaiting extends StatefulWidget {
  final TransactionApp transactionApp;
  final bool? isVieuw;
  const MapWaiting({super.key, this.isVieuw, required this.transactionApp});

  @override
  State<MapWaiting> createState() => _MapWaitingState();
}

class _MapWaitingState extends State<MapWaiting> {
  String phoneChauffeur = '';
  setClientPhone() async {
    final userclient =
        await ApplicationUser.infos(widget.transactionApp.idChauffer);
    setState(() {
      phoneChauffeur = userclient.userTelephone!;
    });
  }

  @override
  void initState() {
    setClientPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Reservation>(
        stream:
            Reservation.reservationStream(widget.transactionApp.idReservation),
        builder: (context, snapshot) {
          return (!snapshot.hasError && snapshot.hasData)
              ? Container(
                  height: widget.isVieuw != null ? 470 : 550,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      spacerHeight(15),
                      RequestCard(
                          reservation: snapshot.data!,
                          idchauffeur: widget.transactionApp.idChauffer),
                      spacerHeight(widget.isVieuw != null ? 1 : 20),
                      widget.isVieuw != null
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                    icon: const Icon(Icons.close, size: 30.0),
                                    onPressed: () async {
                                      await snapshot.data!
                                          .annuletReservation()
                                          .then(
                                            (value) => Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    PageTransition(
                                                        child: const HomePage(),
                                                        type: PageTransitionType
                                                            .leftToRight),
                                                    (route) => false),
                                          );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: dredColor,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        )),
                                    label: Text('Annuler', style: police)),
                                phoneChauffeur.trim().isNotEmpty
                                    ? ElevatedButton.icon(
                                        icon:
                                            const Icon(Icons.phone, size: 30.0),
                                        onPressed: () async {
                                          await FlutterPhoneDirectCaller
                                              .callNumber(phoneChauffeur);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 9),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            )),
                                        label: Text('chauffeur',
                                            style:
                                                police.copyWith(fontSize: 12)),
                                      )
                                    : shimmer(40.0, 70.0),
                              ],
                            ),
                      spacerHeight(widget.isVieuw != null ? 0 : 20),
                      widget.isVieuw != null
                          ? SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Text(
                                    widget.transactionApp.etatTransaction == 0
                                        ? "En attente"
                                        : widget.transactionApp
                                                    .etatTransaction ==
                                                1
                                            ? "En cours"
                                            : widget.transactionApp
                                                        .etatTransaction ==
                                                    -1
                                                ? "Annulé"
                                                : "Terminée",
                                    style: police.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          : boutonText(
                              context: context,
                              couleur: Colors.green.shade300,
                              action: () async {
                                await widget.transactionApp.modifierEtat(1);
                              },
                              text: 'Démarer')
                    ],
                  ),
                )
              : snapshot.hasError
                  ? Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: police,
                      ),
                    )
                  : const Center(
                      child: LoadingComponen(),
                    );
        });
  }
}
