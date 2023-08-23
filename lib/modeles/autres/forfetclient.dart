import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:taxischrono/modeles/autres/package.dart';
import '../../varibles/variables.dart';

class ForfetClients {
  final String idForfait;
  final Packages package;
  DateTime activationDate;
  int nombreDeTicketRestant;
  int nombreDeTicketsUtilise;

  final String idUser;
  ForfetClients({
    required this.idUser,
    required this.activationDate,
    required this.nombreDeTicketRestant,
    required this.nombreDeTicketsUtilise,
    required this.idForfait,
    required this.package,
  });

  Map<String, dynamic> toMap() => {
        "idForfait": idForfait,
        "package": package.toMap(),
        "idUser": idUser,
        "activationDate": Timestamp.fromDate(activationDate),
        'nombreDeTicketRestant': nombreDeTicketRestant,
        "nombreDeTicketsUtilise": nombreDeTicketsUtilise,
      };

  factory ForfetClients.fromJson(Map<String, dynamic> forfait) => ForfetClients(
        idUser: forfait['idUser'],
        activationDate: (forfait['activationDate'] as Timestamp).toDate(),
        idForfait: forfait['idForfait'],
        package: Packages.fromMap(forfait['package']),
        nombreDeTicketRestant: forfait['nombreDeTicketRestant'],
        nombreDeTicketsUtilise: forfait['nombreDeTicketsUtilise'],
      );

  DocumentReference<Map<String, dynamic>> forfetCollection() => firestore
      .collection('Clients')
      .doc(idUser)
      .collection("ForfetsActifs")
      .doc(idForfait);

  // activer un forfait
  activerForfait() async {
    await firestore
        .collection('Clients')
        .doc(idUser)
        .update({"tickets": FieldValue.increment(package.nombreDeTickets)});
    await forfetCollection().set(toMap());
  }

  static utiliserUnTicket(idClient) async {
    await firestore
        .collection('Clients')
        .doc(idClient)
        .update({"tickets": FieldValue.increment(-1)});
    await listDesForFaitsACtifeFuture(idClient).then((value) async {
      var forf = value[0];
      await firestore
          .collection('Clients')
          .doc(idClient)
          .collection("ForfetsActifs")
          .doc(forf.idForfait)
          .update({
        "nombreDeTicketRestant": FieldValue.increment(-1),
        "nombreDeTicketsUtilise": FieldValue.increment(1)
      });
    });
  }

  static Stream<List<ForfetClients>> listDesForFaitsACtife(userid) => firestore
      .collection('Clients')
      .doc(userid)
      .collection("ForfetsActifs")
      .where(isGreaterThan: 0, 'nombreDeTicketRestant')
      .snapshots()
      .map((event) => event.docs
          .map((forfait) => ForfetClients.fromJson(forfait.data()))
          .toList());

  static Future<List<ForfetClients>> listDesForFaitsACtifeFuture(userid) =>
      firestore
          .collection('Clients')
          .doc(userid)
          .collection("ForfetsActifs")
          // .orderBy("activationDate", descending: true)
          .where(
            'nombreDeTicketRestant',
            isGreaterThan: 0,
          )
          .get()
          .then((event) => event.docs
              .map(
                (forfait) => ForfetClients.fromJson(forfait.data()),
              )
              .toList());
}
