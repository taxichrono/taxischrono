import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taxischrono/screens/homepage.dart';

import '../../modeles/applicationuser/appliactionuser.dart';
import '../../varibles/variables.dart';
import '../composants/delayed_animation.dart';
import 'otppage.dart';

class LoginNumber extends StatefulWidget {
  const LoginNumber({super.key});

  @override
  State<LoginNumber> createState() => _LoginNumberState();
}

class _LoginNumberState extends State<LoginNumber> {
  bool loader = false;
  final globalkey = GlobalKey<ScaffoldState>();
  PhoneNumber? numberSubmited;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalkey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: loader
            ? const LoadingComponen()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    spacerHeight(100),
                    DelayedAnimation(
                      delay: 1000,
                      child: Text(
                        "Vérification de votre numéro de téléphone",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    spacerHeight(180),
                    DelayedAnimation(
                      delay: 1500,
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (number) {
                          setState(() {
                            numberSubmited = number;
                          });
                        },
                        hintText: "Votre Numéro de téléphone",
                        textStyle: police,
                        validator: (val) {
                          return val == null || val.length < 13
                              ? "entrez un numéro de téléphone valide"
                              : null;
                        },
                        inputBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: grey!),
                        ),
                        maxLength: 13,
                        initialValue: PhoneNumber(isoCode: "CM"),
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                      ),
                    ),
                    spacerHeight(180),
                    DelayedAnimation(
                      delay: 2000,
                      child: boutonText(
                          context: context,
                          action: () async {
                            if (numberSubmited != null &&
                                numberSubmited!.phoneNumber!.trim().length ==
                                    13) {
                              loader = true;
                              setState(() {});
                              await ApplicationUser.authenticatePhonNumber(
                                phonNumber: numberSubmited!.phoneNumber!,
                                onCodeSend: (verificationId, resendToken) {
                                  Navigator.of(context).push(PageTransition(
                                      child: OtpPage(
                                        isauthentication: true,
                                        phone: numberSubmited!.phoneNumber!,
                                        verificationId: verificationId,
                                      ),
                                      type: PageTransitionType.leftToRight));
                                },
                                verificationCompleted: (credential) async {
                                  await authentication
                                      .signInWithCredential(credential)
                                      .then((value) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        PageTransition(
                                            child: const HomePage(),
                                            type:
                                                PageTransitionType.leftToRight),
                                        (route) => false);
                                  });
                                },
                                verificationFailed: (except) {
                                  debugPrint(except.code);

                                  getsnac(
                                    msg:
                                        "Une erreur est survenu l'or de la vérification veillez reéssayer ou utiliser une autre méthode",
                                    title: "Erreur de vérification",
                                    error: true,
                                    duration: const Duration(seconds: 7),
                                    icons: Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  );
                                },
                                global: globalkey,
                              );

                              loader = false;
                              setState(() {});
                            } else {
                              loader = false;
                              setState(() {});
                              Fluttertoast.showToast(
                                msg: "Entrez un numéro de téléphone correcte",
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.red,
                              );
                            }
                          },
                          text: "Valider"),
                    ),
                    spacerHeight(100),
                  ],
                ),
              ),
      ),
    );
  }
}
