import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taxischrono/modeles/applicationuser/client.dart';
import 'package:taxischrono/modeles/autres/forfetclient.dart';
import 'package:taxischrono/modeles/autres/transaction.dart';
import 'package:taxischrono/screens/homepage.dart';
import 'package:taxischrono/services/firebaseauthservice.dart';

import 'package:taxischrono/varibles/variables.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: dredColor,
        body: SingleChildScrollView(
          // physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Authservices().logOut().then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  child: const HomePage(),
                                  type: PageTransitionType.leftToRight),
                              (route) => false);
                          Fluttertoast.showToast(
                              msg: "Vous ètes déconneté avec succès");
                        });
                      },
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          await Authservices().logOut();
                        },
                        child: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Mon Profil',
                  textAlign: TextAlign.center,
                  style: police.copyWith(
                      fontSize: 30, fontWeight: FontWeight.w800, color: blanc),
                ),
                const SizedBox(
                  height: 22,
                ),
                SizedBox(
                  height: height * 0.43,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double innerHeight = constraints.maxHeight;
                      double innerWidth = constraints.maxWidth;
                      return Stack(
                        // fit: StackFit.expand,
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: innerHeight * 0.72,
                              width: innerWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 80,
                                    ),
                                    Text(
                                        authentication
                                            .currentUser!.displayName!,
                                        textAlign: TextAlign.center,
                                        style: police.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Mes Tickets',
                                              style: police.copyWith(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700),
                                            ),
                                            FutureBuilder<int>(
                                                future: Client.ticketCount(
                                                    authentication
                                                        .currentUser!.uid),
                                                builder: (context, snapshot) {
                                                  return Text(
                                                    !snapshot.hasError &&
                                                            snapshot.hasData
                                                        ? snapshot.data!
                                                            .toString()
                                                        : 'O',
                                                    style: police.copyWith(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .grey.shade700),
                                                  );
                                                }),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 8,
                                          ),
                                          child: Container(
                                            height: 50,
                                            width: 3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Mes Trajets',
                                              style: police.copyWith(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700),
                                            ),
                                            StreamBuilder<List<TransactionApp>>(
                                                stream: TransactionApp
                                                    .allTransaction(
                                                        authentication
                                                            .currentUser!.uid),
                                                builder: (context, snapshot) {
                                                  return Text(
                                                    !snapshot.hasError &&
                                                            snapshot.hasData
                                                        ? snapshot.data!.length
                                                            .toString()
                                                        : '0',
                                                    style: police.copyWith(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .grey.shade700),
                                                  );
                                                }),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   top: 110,
                          //   right: 20,
                          //   child: Icon(
                          //     Icons.settings,
                          //     color: Colors.grey[700],
                          //     size: 30,
                          //   ),
                          // ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Image.asset(
                                'images/user.png',
                                width: innerWidth * 0.45,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: height * 0.5,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        spacerHeight(20),
                        Text(
                          'Mes forfaits actis',
                          style: police.copyWith(
                              color: const Color.fromRGBO(39, 105, 171, 1),
                              fontSize: 25),
                        ),
                        const Divider(
                          thickness: 1.5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: StreamBuilder<List<ForfetClients>>(
                              stream: ForfetClients.listDesForFaitsACtife(
                                  authentication.currentUser!.uid),
                              builder: (context, snaps) {
                                return snaps.hasError
                                    ? Text(snaps.error.toString())
                                    : !snaps.hasError && snaps.data != null
                                        ? ListView.separated(
                                            itemCount: snaps.data!.length,
                                            separatorBuilder: (context, index) {
                                              return const Divider(
                                                thickness: 2,
                                              );
                                            },
                                            itemBuilder: (context, index) {
                                              final data = snaps.data!;
                                              return ListTile(
                                                horizontalTitleGap: 12,
                                                contentPadding: EdgeInsets.zero,
                                                trailing: Column(
                                                  children: [
                                                    Text(
                                                      data[index]
                                                          .package
                                                          .nombreDeTickets
                                                          .toString(),
                                                      style: police.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "Total",
                                                      style: police,
                                                    )
                                                  ],
                                                ),
                                                title: Text(
                                                  "Pack :${data[index].package.prixPackage} XFA",
                                                  style: police.copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: RichText(
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text:
                                                          "Utilisé: ${data[index].nombreDeTicketsUtilise}  ",
                                                      style: police.copyWith(
                                                          color: noire,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    TextSpan(
                                                        text: "|",
                                                        style: police.copyWith(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: noire,
                                                            fontSize: 18)),
                                                    TextSpan(
                                                      text:
                                                          "  Restant: ${data[index].nombreDeTicketRestant}",
                                                      style: police.copyWith(
                                                          color: noire,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ]),
                                                  // " |   ",
                                                  // style: police,
                                                ),
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey.shade400,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.bookmark,
                                                      size: 30,
                                                      color: dredColor,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })
                                        : snaps.data != null &&
                                                snaps.data!.isEmpty
                                            ? Center(
                                                child: Text(
                                                  'Vous n\'avez aucun forfait actif',
                                                  style: police.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              )
                                            : const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: Center(
                                                  child: LoadingComponen(),
                                                ),
                                              );
                              }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
