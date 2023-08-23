import 'package:taxischrono/varibles/variables.dart';

class Reponse {
  String idChauffeur;
  String idRservation;
  String idClient;
  bool accept;

  Reponse({
    required this.accept,
    required this.idChauffeur,
    required this.idClient,
    required this.idRservation,
  });

  Map<String, dynamic> toJson() => {
        'client': idClient,
        "chauffeur": idChauffeur,
        'reponse': accept,
        'reservation': idRservation,
      };

  factory Reponse.fromMap(map) => Reponse(
      accept: map['reponse'],
      idChauffeur: map['chauffeur'],
      idClient: map['client'],
      idRservation: map['reservation']);

  creerUnereponse() async {
    await datatbase.ref("Response").child(idRservation).set(toJson());
  }

  static Stream<Reponse> reponseTempReel(idRservation) => datatbase
      .ref('Response')
      .child(idRservation)
      .onValue
      .map((event) => Reponse.fromMap(event.snapshot.value));

  // fin de la classe
}
// la classe reponse permet de lier les réactuions des deux utilisateurs le chauffeur modifie la reponse qui est crée avec l'émission de la requette.