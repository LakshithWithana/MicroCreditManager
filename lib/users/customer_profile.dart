import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../reusable_components/custom_elevated_buttons.dart';
import '../reusable_components/custom_text_form_field.dart';
import '../reusable_components/loading.dart';
import '../reusable_components/ratings.dart';
import '../services/database_services.dart';
import '../shared/colors.dart';
import '../shared/text.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({Key? key}) : super(key: key);

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final DatabaseServices _databaseServices = DatabaseServices();

  String? companyTelNo = "";
  String? firstName = "";
  String? lastName = "";
  String? nicNumber = "";
  String? phoneNumber = "";
  bool? readOnly = true;

  bool isLoading = false;

  String? url = "";

  Future getImageAndUpload({String? userId}) async {
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
          .child('customers/$userId')
          .putData(fileBytes)
          .whenComplete(() => null)
          .then((value) {
        print('Upload Completed');
        value.ref.getDownloadURL().then((value) {
          updateUrlToFirestore(value, userId!, file.extension, userId);
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

  Future updateUrlToFirestore(String fileValue, String fileName,
      String? fileExtension, String? userId) async {
    return await imagesCollection.doc().set({
      'companyName': userId,
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

    final user = Provider.of<mcmUser?>(context);
    return StreamBuilder<UserDetails>(
        stream: DatabaseServices(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;

            getUrl() async {
              final ref = FirebaseStorage.instance
                  .ref()
                  .child("customers/${userDetails!.userId}");
              // no need of then file extension, the name will do fine.
              try {
                var urlLoaded = await ref.getDownloadURL();
                if (mounted) {
                  setState(() {
                    url = urlLoaded;
                  });
                }
              } catch (error) {
                print('file not found');
              }

              print(url);
            }

            getUrl();

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: mainColor),
                elevation: 0.0,
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height * 2),
                      CustomTextBox(
                        textValue: 'Profile',
                        textSize: 10,
                        textWeight: FontWeight.bold,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SizedBox(height: height * 2),
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: width * 10,
                                    child: isLoading == true
                                        ? const CircularProgressIndicator()
                                        : url == ""
                                            ? Icon(
                                                Icons.person,
                                                size: width * 8,
                                              )
                                            : Container(
                                                height: 120.0,
                                                width: 120.0,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          url!,
                                                        ),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                              ),
                                  ),
                                  Positioned(
                                    right: -10,
                                    bottom: -10,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        getImageAndUpload(
                                            userId: userDetails!.uid);
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: width * 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextBox(
                                    textValue:
                                        "${userDetails!.firstName!} ${userDetails.lastName!}",
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: userDetails.userId!,
                                    textSize: 4,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  SizedBox(height: height * 1),
                                  Rating(totalPoints: userDetails.points),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 5),
                      CustomTextFormField(
                        initialValue: userDetails.firstName,
                        readOnly: readOnly,
                        label: 'First Name',
                        onChanged: (value) {
                          setState(() {
                            firstName = value;
                          });
                        },
                        // validator: (value) =>
                        //     value!.isEmpty ? 'Enter your first name' : null,
                      ),
                      SizedBox(height: height * 2),
                      CustomTextFormField(
                        initialValue: userDetails.lastName,
                        readOnly: readOnly,
                        label: 'Last Name',
                        onChanged: (value) {
                          setState(() {
                            lastName = value;
                          });
                        },
                        // validator: (value) =>
                        //     value!.isEmpty ? 'Enter your last name' : null,
                      ),
                      SizedBox(height: height * 2),
                      CustomTextFormField(
                        initialValue: userDetails.email,
                        readOnly: true,
                        label: 'Email (Can not change)',
                        validator:
                            EmailValidator(errorText: 'Enter a valid Email'),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp(" "),
                          )
                        ],
                      ),
                      SizedBox(height: height * 2),
                      CustomTextFormField(
                        initialValue: userDetails.govtID,
                        readOnly: true,
                        label: 'NIC Number (Can not change)',

                        // validator: (value) =>
                        //     value!.isEmpty ? 'Enter your NIC number' : null,
                      ),
                      SizedBox(height: height * 2),
                      CustomTextFormField(
                        initialValue: userDetails.companyName,
                        readOnly: true,
                        label: 'Company Name (Can not change)',
                        // validator: (value) =>
                        //     value!.isEmpty ? 'Enter your first name' : null,
                      ),
                      // SizedBox(height: height * 2),
                      // CustomTextFormField(
                      //   initialValue: userDetails.companyTelNo,
                      //   readOnly: userDetails.isAdmin == true ? readOnly : true,
                      //   label: 'Company Tel. No.',
                      //   // controller: companyTelNoController,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       companyTelNo = value;
                      //     });
                      //   },
                      //   // validator: (value) =>
                      //   //     value!.isEmpty ? 'Enter company tel. no.' : null,
                      //   inputFormatters: <TextInputFormatter>[
                      //     FilteringTextInputFormatter.digitsOnly
                      //   ],
                      // ),
                      SizedBox(height: height * 4),
                      PositiveElevatedButton(
                          label: readOnly == true ? "Edit" : "Save",
                          onPressed: readOnly == true
                              ? () {
                                  setState(() {
                                    readOnly = false;
                                  });
                                }
                              : () {
                                  setState(() {
                                    readOnly = true;
                                  });
                                  _databaseServices
                                      .editUserData(
                                    uid: user.uid!,
                                    companyTelNo: companyTelNo == ""
                                        ? userDetails.companyTelNo
                                        : companyTelNo,
                                    firstName: firstName == ""
                                        ? userDetails.firstName
                                        : firstName,
                                    lastName: lastName == ""
                                        ? userDetails.lastName
                                        : lastName,
                                  )
                                      .then((value) {
                                    const snackBar = SnackBar(
                                      content: Text("Details updated."),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  });
                                }),
                      SizedBox(height: height * 10),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
