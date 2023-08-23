import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taxischrono/modeles/autres/transaction.dart';
import 'package:taxischrono/screens/homepage.dart';
import 'package:taxischrono/varibles/variables.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CoursRunning extends StatefulWidget {
  const CoursRunning({super.key, required this.transactionApp});

  final TransactionApp transactionApp;

  @override
  State<CoursRunning> createState() => _CoursRunningState();
}

class _CoursRunningState extends State<CoursRunning> {
  var ratte = 2.5;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              ratte = rating;
            },
          ),
          spacerHeight(20),
          ElevatedButton.icon(
              icon: const Icon(Icons.warning, size: 30.0),
              onPressed: () async {
                TextEditingController controllerUrgence =
                    TextEditingController();
                signalerUrgence(context, controllerUrgence);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: dredColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  )),
              label: Text('Signaler une urgence', style: police)),
          spacerHeight(15),
          ElevatedButton.icon(
            icon: const Icon(Icons.comment, size: 30.0),
            onPressed: () async {
              TextEditingController controllerMessage = TextEditingController();
              await commentercourse(context, controllerMessage);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            label: Text('commentaire sur la course', style: police),
          ),
          spacerHeight(20),
          boutonText(
              context: context,
              action: () async {
                Fluttertoast.showToast(msg: "Merci d'utiliser Taxi Chrono");
                Navigator.of(context).pushAndRemoveUntil(
                    PageTransition(
                        child: const HomePage(),
                        type: PageTransitionType.leftToRight),
                    (route) => false);
                await widget.transactionApp.modifierEtat(2);
                await widget.transactionApp.noterChauffeur(ratte);
              },
              text: "Terminer la course")
        ],
      ),
    );
  }

  commentercourse(
      BuildContext context, TextEditingController controllerMessage) async {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                spacerHeight(30),
                Text(
                  "Taxis Chrono vous remercie de donner votre avie sur le voyage celà nous aide beaucoup",
                  style: police.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                spacerHeight(30),
                TextFormField(
                  controller: controllerMessage,
                  style: police,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "entrez votre commentaire ici",
                    hintStyle: police,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: dredColor),
                    ),
                  ),
                ),
                spacerHeight(120),
                boutonText(
                    context: context,
                    action: () async {
                      if (controllerMessage.text.trim().isEmpty) {
                        Fluttertoast.showToast(
                            msg:
                                "Vous devez d'abords remplire le champ du mesage");
                      } else {
                        Navigator.of(context).pop();
                        await widget.transactionApp
                            .commenterSurLaconduiteDuChauffeur(
                                controllerMessage.text)
                            .then((val) {
                          Fluttertoast.showToast(
                              msg:
                                  "Taxi Chrono vous remerci pour votre commentaire");
                        });
                      }
                    },
                    text: 'Valider',
                    couleur: Colors.green),
                spacerHeight(15),
                boutonText(
                    context: context,
                    action: () => Navigator.pop(context),
                    text: "Annuler")
              ],
            ),
          ));
        });
  }

  signalerUrgence(
      BuildContext context, TextEditingController controllerMessage) async {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                spacerHeight(30),
                Text(
                  "Salut comment pouvons nous vous aider?\n Veillez nous dire quel est votre problème",
                  style: police.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                spacerHeight(30),
                TextFormField(
                  controller: controllerMessage,
                  style: police,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "entrez votre commentaire ici",
                    hintStyle: police,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: dredColor),
                    ),
                  ),
                ),
                spacerHeight(120),
                boutonText(
                    context: context,
                    action: () async {
                      if (controllerMessage.text.trim().isEmpty) {
                        Fluttertoast.showToast(
                            msg:
                                "Vous devez d'abords remplire le champ du mesage");
                      } else {
                        Navigator.of(context).pop();
                        await widget.transactionApp
                            .commenterSurLaconduiteDuChauffeur(
                                controllerMessage.text)
                            .then((val) {
                          Fluttertoast.showToast(
                              msg:
                                  "Taxi Chrono vous remerci nous vous revenons dans une seconde");
                        });
                      }
                    },
                    text: 'Valider',
                    couleur: Colors.green),
                spacerHeight(15),
                boutonText(
                    context: context,
                    action: () => Navigator.pop(context),
                    text: "Annuler")
              ],
            ),
          ));
        });
  }
}
