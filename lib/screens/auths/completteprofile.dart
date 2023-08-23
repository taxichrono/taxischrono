import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:page_transition/page_transition.dart';

import '../../modeles/applicationuser/appliactionuser.dart';
import '../../varibles/variables.dart';

import '../composants/delayed_animation.dart';
import '../homepage.dart';
import 'otppage.dart';

class CompletteProfile extends StatefulWidget {
  final ApplicationUser applicationUser;
  const CompletteProfile({super.key, required this.applicationUser});

  @override
  State<CompletteProfile> createState() => _CompletteProfileState();
}

class _CompletteProfileState extends State<CompletteProfile> {
  TextEditingController controllerPhone = TextEditingController();
  bool loader = false;
  PhoneNumber? phoneNumber;
  TextEditingController controllerAdresse = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close, color: dredColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: loader
          ? const LoadingComponen()
          : Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DelayedAnimation(
                        delay: 1500,
                        child: Text(
                          "Finalisez votre inscription à TAXICHRONO",
                          style: police.copyWith(
                            fontSize: 25,
                            color: dredColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      DelayedAnimation(
                        delay: 3500,
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (number) {
                            phoneNumber = number;
                          },
                          hintText: "Votre Numéro de téléphone",
                          textStyle: police,
                          validator: (val) {
                            return val!.length != 13 || phoneNumber == null
                                ? 'Entrez un numérode téléphone correcte'
                                : null;
                          },
                          textFieldController: controllerPhone,
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
                      const SizedBox(height: 10),
                      widget.applicationUser.userAdresse!.trim().isEmpty
                          ? DelayedAnimation(
                              delay: 3500,
                              child: TextFormField(
                                style: police,
                                validator: (val) {
                                  return val!.length < 3
                                      ? 'Entrez une adresse correcte vous pouvez donner le nom de votre quartier si vouslez'
                                      : null;
                                },
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.person_pin_circle),
                                  hintStyle: police,
                                  labelText: 'Votre Adresse',
                                  hintText: "Exemple : Essos Rue 802",
                                  labelStyle: police.copyWith(color: grey),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 130),
                      SizedBox(
                        width: double.infinity,
                        child: DelayedAnimation(
                          delay: 5500,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                  shape: const StadiumBorder(),
                                  backgroundColor: dredColor,
                                  padding: const EdgeInsets.symmetric(
                                    // horizontal: 125,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  'VALIDER',
                                  style: police.copyWith(
                                      letterSpacing: 4,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: noire),
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    loader = true;
                                    setState(() {});
                                    final applicationUser = ApplicationUser(
                                      userEmail:
                                          widget.applicationUser.userEmail,
                                      userName: widget.applicationUser.userName,
                                      userTelephone: controllerPhone.text,
                                    );
                                    await authentication.verifyPhoneNumber(
                                        verificationCompleted:
                                            (credential) async {
                                          await authentication.currentUser!
                                              .updatePhoneNumber(credential);

                                          await applicationUser
                                              .saveUser()
                                              .then((value) {
                                            loader = false;
                                            setState(() {});
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                PageTransition(
                                                    child: const HomePage(),
                                                    type: PageTransitionType
                                                        .leftToRight),
                                                (route) => false);
                                          });
                                        },
                                        verificationFailed: (exception) {
                                          loader = false;
                                          setState(() {});
                                          getsnac(
                                              title: "Erreur de vérification",
                                              msg: exception.code);
                                        },
                                        timeout: const Duration(seconds: 60),
                                        codeSent: (verificationId,
                                            forresendIdTokend) async {
                                          await Navigator.of(context).push(
                                              PageTransition(
                                                  child: OtpPage(
                                                    verificationId:
                                                        verificationId,
                                                    isauthentication: true,
                                                    phone: phoneNumber!
                                                        .phoneNumber,
                                                    // utilisateur: applicationUser,
                                                  ),
                                                  type: PageTransitionType
                                                      .leftToRight));
                                        },
                                        codeAutoRetrievalTimeout: (val) {});
                                  }
                                }),
                          ),
                        ),
                      ),
                      spacerHeight(10),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
