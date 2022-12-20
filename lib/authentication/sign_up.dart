import 'dart:typed_data';

import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcm/authentication/admin_sign_up_details.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/custom_text_form_field.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/auth_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';

import '../services/database_services.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, this.toggleView}) : super(key: key);
  final Function? toggleView;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  String? error = "";
  final companyNameController = TextEditingController();
  final companyRegistrationNoController = TextEditingController();
  final companyTelNoController = TextEditingController();
  final capitalAmountController = TextEditingController();
  String? governmentRegistered = "Yes";
  String? country = "";
  String? countryCode = "";
  String? _currency = "";

  bool? loading = false;
  bool isLoading = false;

  String? url = "";

  Future getImageAndUpload() async {
    setState(() {
      isLoading = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);

      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;

      // Upload file
      await FirebaseStorage.instance
          .ref()
          .child('${companyNameController.text}/${companyNameController.text}')
          .putData(fileBytes)
          .whenComplete(() => null)
          .then((value) {
        print('Upload Completed');
        value.ref.getDownloadURL().then((value) {
          updateUrlToFirestore(
              value, companyNameController.text, file.extension);
          setState(() {
            url = value;
          });
        });
        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        print(error);
        setState(() {
          isLoading = false;
        });
      });
    } else {
      // User canceled the picker
      setState(() {
        isLoading = false;
      });
    }
  }

  Future updateUrlToFirestore(
      String fileValue, String fileName, String? fileExtension) async {
    return await imagesCollection.doc().set({
      'companyName': companyNameController.text,
      'url': fileValue,
      'name': fileName,
      'type': fileExtension,
    }).then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    if (loading == false) {
      return Scaffold(
        backgroundColor: white,
        body: Padding(
          padding:
              EdgeInsets.fromLTRB(width * 5.1, height * 12, width * 5.1, 0.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: height * 2),
                  CustomTextBox(
                    textValue: 'Sign up',
                    textSize: 10,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: mainColor,
                  ),
                  SizedBox(height: height * 2),
                  Column(
                    children: [
                      CustomTextFormField(
                        label: 'Company Name',
                        controller: companyNameController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter company name' : null,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 2),
                  Column(
                    children: [
                      CustomTextBox(
                        textValue: 'Government registered',
                        textSize: 4,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SizedBox(height: height * 0.5),
                      Container(
                        width: width * 90,
                        height: height * 6.5,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(width * 3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: DropdownButton<String?>(
                            value: governmentRegistered,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: mainColor,
                            ),
                            iconSize: width * 9,
                            isExpanded: true,
                            elevation: 16,
                            style: const TextStyle(color: black),
                            underline: Container(),
                            onChanged: (String? newValue) {
                              setState(() {
                                governmentRegistered = newValue!;
                              });
                            },
                            items: <String>[
                              'Yes',
                              'No',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: width * 5,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 2),

                  governmentRegistered == "Yes"
                      ? Column(
                          children: [
                            CustomTextFormField(
                              label: 'Registration No.',
                              controller: companyRegistrationNoController,
                            ),
                            SizedBox(height: height * 2),
                          ],
                        )
                      : const SizedBox(),

                  Column(
                    children: [
                      CustomTextBox(
                        textValue: 'Country',
                        textSize: 4,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SizedBox(height: height * 0.5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 3),
                          ),
                        ),
                        onPressed: () {
                          showCountryPicker(
                            context: context,
                            // showPhoneCode:true, // optional. Shows phone code before the country name.
                            onSelect: (Country selectedCountry) {
                              setState(() {
                                country =
                                    selectedCountry.displayNameNoCountryCode;
                                countryCode = selectedCountry.phoneCode;
                              });
                            },
                          );
                        },
                        child: Container(
                          width: width * 90,
                          height: height * 6.5,
                          decoration: const BoxDecoration(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                country == "" ? "-country-" : country!,
                                style: TextStyle(
                                  fontSize: width * 5,
                                  color: black,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: width * 9,
                                color: mainColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 2),
                  Column(
                    children: [
                      CustomTextBox(
                        textValue: 'Currency',
                        textSize: 4,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SizedBox(height: height * 0.5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 3),
                          ),
                        ),
                        onPressed: () {
                          showCurrencyPicker(
                              context: context,
                              theme: CurrencyPickerThemeData(
                                flagSize: 25,
                                titleTextStyle: const TextStyle(fontSize: 17),
                                subtitleTextStyle: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).hintColor),
                              ),
                              onSelect: (Currency currency) {
                                print('Select currency: ${currency.code}');
                                setState(() {
                                  _currency = currency.code;
                                });
                              });
                        },
                        child: Container(
                          width: width * 90,
                          height: height * 6.5,
                          decoration: const BoxDecoration(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _currency == "" ? "-currency-" : _currency!,
                                style: TextStyle(
                                  fontSize: width * 5,
                                  color: black,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: width * 9,
                                color: mainColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 2),
                  Column(
                    children: [
                      CustomTextFormField(
                        label: 'Company Tel. No.',
                        controller: companyTelNoController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter company tel. no.' : null,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ],
                  ),
                  // CustomTextBox(
                  //   textValue: companyTelNoController.text,
                  //   textSize: 4,
                  //   textWeight: FontWeight.normal,
                  //   typeAlign: Alignment.topRight,
                  //   captionAlign: TextAlign.left,
                  //   textColor: black,
                  // ),
                  // SizedBox(height: height * 2),
                  SizedBox(height: height * 2),

                  Column(
                    children: [
                      CustomTextFormField(
                        label: 'Initial Deposit ($_currency)',
                        controller: capitalAmountController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a capital amount' : null,
                        // inputFormatters: <TextInputFormatter>[CustomInputFormatter],
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 2),
                  CustomTextBox(
                    textValue: 'Company logo',
                    textSize: 4,
                    textWeight: FontWeight.normal,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: black,
                  ),
                  SizedBox(height: height * 1),
                  Row(
                    children: [
                      Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                            color: url == "" ? Colors.grey : null,
                            image: DecorationImage(
                                image: NetworkImage(
                                  url!,
                                ),
                                fit: BoxFit.cover),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: isLoading == true
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : url == ""
                                ? const Icon(
                                    Icons.business,
                                    size: 36,
                                  )
                                : null,
                      ),
                      SizedBox(width: width * 10),
                      PositiveHalfElevatedButton(
                        label: "Upload",
                        onPressed: () {
                          getImageAndUpload();
                        },
                      ),
                    ],
                  ),
                  // SizedBox(height: height * 1),
                  CustomTextBox(
                    textValue: error!,
                    textSize: 3.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.center,
                    captionAlign: TextAlign.left,
                    textColor: accentColor,
                  ),
                  SizedBox(height: height * 8),
                  PositiveElevatedButton(
                    label: 'Next',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        Navigator.pushNamed(
                          context,
                          '/adminSignUpDetails',
                          arguments: AdminSignUpDetailsArgs(
                            companyName: companyNameController.text,
                            governmentRegistered: governmentRegistered,
                            companyRegistrationNo:
                                companyRegistrationNoController.text == ""
                                    ? ""
                                    : companyRegistrationNoController.text,
                            country: country,
                            countryCode: countryCode,
                            currency: _currency,
                            companyTelNo: companyTelNoController.text,
                            capitalAmount:
                                int.parse(capitalAmountController.text),
                          ),
                        );

                        setState(() {
                          loading = false;
                        });
                      }
                    },
                  ),
                  SizedBox(height: height * 2),
                  CustomTextBox(
                    textValue: 'or',
                    textSize: 4,
                    textWeight: FontWeight.normal,
                    typeAlign: Alignment.center,
                    captionAlign: TextAlign.center,
                    textColor: mainFontColor,
                  ),
                  SizedBox(height: height * 2),
                  NegativeElevatedButton(
                    label: 'Log In',
                    onPressed: () {
                      widget.toggleView!();
                    },
                  ),
                  SizedBox(height: height * 6),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const Loading();
    }
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(
            ' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
