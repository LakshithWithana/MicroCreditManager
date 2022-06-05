import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcm/admins/models/single_collection_model.dart';
import 'package:mcm/admins/view_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../reusable_components/custom_elevated_buttons.dart';
import '../reusable_components/loading.dart';
import '../services/database_services.dart';
import '../shared/colors.dart';
import '../shared/text.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Downloads extends StatefulWidget {
  Downloads({Key? key}) : super(key: key);

  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  String? startDate = "";
  String? endDate = "";

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  pw.Widget divider(double width) {
    return pw.Container(
      height: 3,
      width: width,
      decoration: pw.BoxDecoration(
        color: PdfColors.grey,
      ),
    );
  }

  tableRow(List<String> attributes, pw.TextStyle textStyle, double width) {
    return pw.TableRow(
      children: attributes
          .map((e) => pw.Container(
                width: width,
                child: pw.Text(
                  " " + e,
                  style: textStyle,
                ),
              ))
          .toList(),
    );
  }

  pw.Widget textRow(List<String> titleList, pw.TextStyle textStyle) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: titleList
          .map(
            (e) => pw.Text(
              e,
              style: textStyle,
            ),
          )
          .toList(),
    );
  }

  pw.Widget specialTextRow(List<String> titleList, pw.TextStyle textStyle) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: titleList
          .map(
            (e) => pw.Text(
              e,
              style: textStyle,
            ),
          )
          .toList(),
    );
  }

  pw.TextStyle textStyle1() {
    return pw.TextStyle(
      color: PdfColors.grey800,
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
    );
  }

  pw.TextStyle textStyle2() {
    return pw.TextStyle(
      color: PdfColors.grey,
      fontSize: 12,
    );
  }

  pw.Widget spaceDivider(double height) {
    return pw.SizedBox(height: height);
  }

  List pwFilteredCollections = [];
  List pwFilteredExpenses = [];
  double pwTotalProfit = 0.0;
  double pwTotalCollection = 0.0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);

    String formattedDate = formatter.format(now);

    // if (mounted == true) {
    Future<void> downloadPDF(
      UserDetails userDetails,
      String toDate,
      String fromDate,
      user,
      double totalCollection,
      double totalProfit,
      double totalExpenses,
    ) async {
      transactionsCollection.doc(user.uid).get().then((value) {
        List collection = (value.data() as dynamic)['collection'].toList();
        List expenses = (value.data() as dynamic)['expenses'].toList();

        pwFilteredCollections = [];
        pwFilteredExpenses = [];

        if (mounted == true) {
          setState(() {
            pwFilteredCollections.addAll(collection.where((element) {
              return DateTime(
                          int.parse(endDate!.split('-').first),
                          int.parse(endDate!.split('-')[1]),
                          int.parse(endDate!.split('-').last))
                      .isAfter(DateTime(
                          int.parse(element['date'].split('-').first),
                          int.parse(element['date'].split('-')[1]),
                          int.parse(element['date'].split('-').last))) &&
                  DateTime(
                          int.parse(startDate!.split('-').first),
                          int.parse(startDate!.split('-')[1]),
                          int.parse(startDate!.split('-').last))
                      .isBefore(DateTime(
                          int.parse(element['date'].split('-').first),
                          int.parse(element['date'].split('-')[1]),
                          int.parse(element['date'].split('-').last)));
            }).toList());
            pwFilteredExpenses.addAll(expenses.where((element) {
              return DateTime(
                          int.parse(endDate!.split('-').first),
                          int.parse(endDate!.split('-')[1]),
                          int.parse(endDate!.split('-').last))
                      .isAfter(DateTime(
                          int.parse(element['date'].split('-').first),
                          int.parse(element['date'].split('-')[1]),
                          int.parse(element['date'].split('-').last))) &&
                  DateTime(
                          int.parse(startDate!.split('-').first),
                          int.parse(startDate!.split('-')[1]),
                          int.parse(startDate!.split('-').last))
                      .isBefore(DateTime(
                          int.parse(element['date'].split('-').first),
                          int.parse(element['date'].split('-')[1]),
                          int.parse(element['date'].split('-').last)));
            }).toList());
          });
        }
      });
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          orientation: pw.PageOrientation.portrait,
          build: (context) => [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                divider(500),
                spaceDivider(10),
                pw.Container(
                  color: PdfColor.fromInt(0xFF80FFDB),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10.0),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${userDetails.companyName}',
                              style: pw.TextStyle(
                                  fontSize: 20, color: PdfColors.black),
                            ),
                            spaceDivider(5),
                            pw.Text(
                              "Downloaded Report",
                              style: pw.TextStyle(
                                  fontSize: 16, color: PdfColors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                spaceDivider(10),
                divider(500),
                spaceDivider(10),
                pw.Container(
                  height: 80,
                  width: 500,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color:
                          PdfColor.fromInt(0xFF80FFDB), // red as border color
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Container(
                        height: 80,
                        width: 180,
                        child: pw.Padding(
                          padding: pw.EdgeInsets.all(10.0),
                          child: pw.Column(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(
                                    'Downloaded by:',
                                    style: pw.TextStyle(
                                        fontSize: 12, color: PdfColors.black),
                                  ),
                                  pw.Text(
                                    userDetails.firstName! +
                                        " " +
                                        userDetails.lastName!,
                                    style: pw.TextStyle(
                                        fontSize: 12, color: PdfColors.grey),
                                  ),
                                ],
                              ),
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(
                                    'Date:',
                                    style: pw.TextStyle(
                                        fontSize: 12, color: PdfColors.black),
                                  ),
                                  pw.Text(
                                    formattedDate,
                                    style: pw.TextStyle(
                                        fontSize: 12, color: PdfColors.grey),
                                  ),
                                ],
                              ),
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(
                                    'Controller type:',
                                    style: pw.TextStyle(
                                        fontSize: 12, color: PdfColors.black),
                                  ),
                                  pw.Text(
                                    userDetails.isAdmin == true
                                        ? "Admin"
                                        : "Agent",
                                    style: pw.TextStyle(
                                        fontSize: 12, color: PdfColors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        width: 150,
                        child: pw.Padding(
                          padding:
                              pw.EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(
                                    'From:',
                                    style: pw.TextStyle(
                                        fontSize: 12, color: PdfColors.black),
                                  ),
                                  pw.Text(
                                    fromDate,
                                    style: pw.TextStyle(
                                        fontSize: 12, color: PdfColors.grey),
                                  ),
                                ],
                              ),
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(
                                    'To',
                                    style: pw.TextStyle(
                                        fontSize: 12, color: PdfColors.black),
                                  ),
                                  pw.Text(
                                    toDate,
                                    style: pw.TextStyle(
                                        fontSize: 12, color: PdfColors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                spaceDivider(20),
                pw.Text(
                  'COLLECTIONS',
                  style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
                ),
                pw.Container(
                  color: PdfColors.white,
                  child: pw.Column(
                    children: [
                      pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.black),
                        children: [
                          tableRow([
                            "Date",
                            "Customer",
                            "Collected By",
                            "Amount",
                            "Profit"
                          ], textStyle1(), 90),
                        ],
                      ),
                      pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.black),
                        children: pwFilteredCollections.map((item) {
                          return pw.TableRow(
                            children: [
                              item["date"],
                              item['loanUser'],
                              item['collector'],
                              item['amount'].toStringAsFixed(2),
                              item['profit'].toStringAsFixed(2),
                            ]
                                .map((e) => pw.Container(
                                      width: 90,
                                      child: pw.Text(
                                        " " + e,
                                        style: textStyle2(),
                                      ),
                                    ))
                                .toList(),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      width: 75,
                      child: textRow([
                        "Total",
                      ], textStyle1()),
                    ),
                    pw.Container(
                      width: 95,
                      child: textRow([
                        totalCollection.toStringAsFixed(2),
                      ], textStyle2()),
                    ),
                    pw.Container(
                      width: 95,
                      child: textRow([
                        totalProfit.toStringAsFixed(2),
                      ], textStyle2()),
                    ),
                  ],
                ),
                spaceDivider(20),
                pw.Text(
                  'EXPENSES',
                  style: pw.TextStyle(fontSize: 18, color: PdfColors.black),
                ),
                pw.Container(
                  color: PdfColors.white,
                  child: pw.Column(
                    children: [
                      pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.black),
                        children: [
                          tableRow([
                            "Date",
                            "Category",
                            "Reason",
                            "Amount",
                          ], textStyle1(), 90),
                        ],
                      ),
                      pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.black),
                        children: pwFilteredExpenses.map((item) {
                          return pw.TableRow(
                            children: [
                              item["date"],
                              item['category'],
                              item['reason'],
                              item['amount'].toStringAsFixed(2),
                            ]
                                .map((e) => pw.Container(
                                      width: 90,
                                      child: pw.Text(
                                        " " + e,
                                        style: textStyle2(),
                                      ),
                                    ))
                                .toList(),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                // pw.Row(
                //   mainAxisAlignment: pw.MainAxisAlignment.end,
                //   children: [
                //     pw.Container(
                //       width: 250,
                //       child: pw.Column(
                //         mainAxisAlignment: pw.MainAxisAlignment.end,
                //         children: [
                //           textRow(["Total Labor", "{totalLabor.text}"],
                //               textStyle2()),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                // pw.Row(
                //   mainAxisAlignment: pw.MainAxisAlignment.end,
                //   children: [
                //     pw.Container(
                //       width: 250,
                //       child: pw.Column(
                //         mainAxisAlignment: pw.MainAxisAlignment.end,
                //         children: [
                //           textRow(
                //               ["Sub Total", "{subTotal.text}"], textStyle2()),
                //           textRow(
                //               ["Sales Tax", "{salesTax.text}"], textStyle2()),
                //           divider(500),
                //           textRow(["Grand Total", "{grandTotal.text}"],
                //               textStyle2()),
                //           divider(500),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      width: 75,
                      child: textRow([
                        "Total",
                      ], textStyle1()),
                    ),
                    pw.Container(
                      width: 120,
                      child: textRow([
                        totalExpenses.toStringAsFixed(2),
                      ], textStyle2()),
                    ),
                  ],
                ),
                spaceDivider(20),
                pw.Text(
                  'Comments:',
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
                ),
                spaceDivider(30),
                spaceDivider(30),
                divider(500),
              ],
            ),
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/example.pdf");
      await file.writeAsBytes(await pdf.save());
      PDFDocument doc = await PDFDocument.fromFile(file);
      // await Printing.layoutPdf(
      //     onLayout: (PdfPageFormat format) async => pdf.save());
      // await Printing.sharePdf(
      //     bytes: await pdf.save(), filename: 'my-document.pdf');
      Navigator.pushNamed(
        context,
        '/viewPDF',
        arguments: ViewPDFArgs(doc: doc),
      );
    }
    // }

    return StreamBuilder<UserDetails>(
        stream: DatabaseServices(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;

            return Scaffold(
              backgroundColor: white,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextBox(
                            textValue: 'Downloads',
                            textSize: 10,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                        ],
                      ),
                      SizedBox(height: height * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextBox(
                            textValue: 'Starting date:',
                            textSize: 5,
                            textWeight: FontWeight.normal,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          SizedBox(
                            width: width * 40,
                            child: DateTimePicker(
                              icon: Icon(Icons.calendar_month),
                              initialValue: DateTime.now()
                                  .subtract(Duration(days: 30))
                                  .toString(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              onChanged: (val) {
                                setState(() {
                                  startDate = val;
                                });
                              },
                              validator: (val) {
                                print(val);

                                return null;
                              },
                              onSaved: (val) {
                                setState(() {
                                  startDate = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextBox(
                            textValue: 'Ending date:',
                            textSize: 5,
                            textWeight: FontWeight.normal,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          SizedBox(
                            width: width * 40,
                            child: DateTimePicker(
                              icon: Icon(Icons.calendar_month),
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              onChanged: (val) {
                                setState(() {
                                  endDate = val;
                                });
                              },
                              validator: (val) {
                                print(val);
                                return null;
                              },
                              onSaved: (val) {
                                setState(() {
                                  endDate = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 5),
                      CustomTextBox(
                        textValue: 'Collection:',
                        textSize: 6.5,
                        textWeight: FontWeight.bold,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SingleCollection(
                        height: height,
                        user: user,
                        userDetails: userDetails,
                        startDate: startDate == '' ? formattedDate : startDate,
                        endDate: endDate == '' ? formattedDate : endDate,
                      ),
                      CustomTextBox(
                        textValue: 'Expenses:',
                        textSize: 6.5,
                        textWeight: FontWeight.bold,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SingleExpense(
                        height: height,
                        user: user,
                        userDetails: userDetails,
                        startDate: startDate == '' ? formattedDate : startDate,
                        endDate: endDate == '' ? formattedDate : endDate,
                      ),
                      SizedBox(height: height * 15),
                      Consumer<SingleCollectionModel>(
                        builder: (context, model, child) {
                          return PositiveElevatedButton(
                            label: 'Save',
                            onPressed: () {
                              downloadPDF(
                                userDetails!,
                                startDate!,
                                endDate!,
                                user,
                                model.totalCollection,
                                model.totalProfit,
                                model.totalExpenses,
                              );
                            },
                          );
                        },
                      ),
                      // PositiveElevatedButton(
                      //   label: 'Save',
                      //   onPressed: () {
                      //     downloadPDF(userDetails!, startDate!, endDate!, user);
                      //   },
                      // ),
                      SizedBox(height: height * 15),
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

class SingleCollection extends StatefulWidget {
  const SingleCollection({
    Key? key,
    required this.height,
    required this.user,
    required this.userDetails,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);
  final height;
  final user;
  final userDetails;
  final startDate;
  final endDate;

  @override
  State<SingleCollection> createState() => _SingleCollectionState();
}

class _SingleCollectionState extends State<SingleCollection> {
  double profit = 0.0;

  @override
  Widget build(BuildContext context) {
    gettingSum() {
      Provider.of<SingleCollectionModel>(context, listen: false)
          .changeSum(0.0, 0.0);
      transactionsCollection.doc(widget.user.uid).get().then((value) {
        List expenses = (value.data() as dynamic)['collection'].toList();
        List filteredCollections = [];
        double totalProfit = 0.0;
        double totalCollection = 0.0;
        filteredCollections.addAll(expenses.where((element) {
          return DateTime(
                      int.parse(widget.endDate.split('-').first),
                      int.parse(widget.endDate.split('-')[1]),
                      int.parse(widget.endDate.split('-').last))
                  .isAfter(DateTime(
                      int.parse(element['date'].split('-').first),
                      int.parse(element['date'].split('-')[1]),
                      int.parse(element['date'].split('-').last))) &&
              DateTime(
                      int.parse(widget.startDate.split('-').first),
                      int.parse(widget.startDate.split('-')[1]),
                      int.parse(widget.startDate.split('-').last))
                  .isBefore(DateTime(
                      int.parse(element['date'].split('-').first),
                      int.parse(element['date'].split('-')[1]),
                      int.parse(element['date'].split('-').last)));
        }).toList());
        // print(filteredCollections);

        for (var item in filteredCollections) {
          totalProfit = item['profit'] + totalProfit;
          totalCollection = item['amount'] + totalCollection;
        }
        Provider.of<SingleCollectionModel>(context, listen: false).changeSum(
          totalProfit,
          totalCollection,
        );
      });
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 700,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: CustomTextBox(
                    textValue: "Date",
                    textSize: 4.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: black,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: CustomTextBox(
                    textValue: "Customer",
                    textSize: 4.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: black,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: CustomTextBox(
                    textValue: "Collected by",
                    textSize: 4.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: black,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: CustomTextBox(
                    textValue: "Amount",
                    textSize: 4.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topRight,
                    captionAlign: TextAlign.right,
                    textColor: black,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: CustomTextBox(
                    textValue: "Profit",
                    textSize: 4.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topRight,
                    captionAlign: TextAlign.right,
                    textColor: black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: widget.height * 40,
              child: FutureBuilder(
                future: transactionsCollection.doc(widget.user.uid).get(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List expenses = snapshot.data!['collection'].toList();
                    List filteredCollections = [];
                    filteredCollections.addAll(expenses.where((element) {
                      return DateTime(
                                  int.parse(widget.endDate.split('-').first),
                                  int.parse(widget.endDate.split('-')[1]),
                                  int.parse(widget.endDate.split('-').last))
                              .isAfter(DateTime(
                                  int.parse(element['date'].split('-').first),
                                  int.parse(element['date'].split('-')[1]),
                                  int.parse(
                                      element['date'].split('-').last))) &&
                          DateTime(
                                  int.parse(widget.startDate.split('-').first),
                                  int.parse(widget.startDate.split('-')[1]),
                                  int.parse(widget.startDate.split('-').last))
                              .isBefore(DateTime(
                                  int.parse(element['date'].split('-').first),
                                  int.parse(element['date'].split('-')[1]),
                                  int.parse(element['date'].split('-').last)));
                    }).toList());

                    // for (var item in filteredCollections) {
                    //   Provider.of<SingleExpenseModel>(context, listen: false)
                    //       .changeSum(item['profit']);
                    // }

                    return SizedBox(
                      width: 700,
                      child: ListView.builder(
                        itemCount: filteredCollections.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomTextBox(
                                  textValue: filteredCollections[index]['date'],
                                  textSize: 4.0,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topLeft,
                                  captionAlign: TextAlign.left,
                                  textColor: black,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: CustomTextBox(
                                  textValue: filteredCollections[index]
                                      ['loanUser'],
                                  textSize: 4.0,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topLeft,
                                  captionAlign: TextAlign.left,
                                  textColor: black,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: CustomTextBox(
                                  textValue: filteredCollections[index]
                                      ['collector'],
                                  textSize: 4.0,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topLeft,
                                  captionAlign: TextAlign.left,
                                  textColor: black,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: CustomTextBox(
                                  textValue: widget.userDetails!.currency! +
                                      " " +
                                      filteredCollections[index]['amount']
                                          .toStringAsFixed(2),
                                  textSize: 4.0,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topRight,
                                  captionAlign: TextAlign.right,
                                  textColor: black,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: CustomTextBox(
                                  textValue: widget.userDetails!.currency! +
                                      " " +
                                      filteredCollections[index]['profit']
                                          .toStringAsFixed(2),
                                  textSize: 4.0,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topRight,
                                  captionAlign: TextAlign.right,
                                  textColor: black,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return Loading();
                  }
                },
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 400.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<SingleCollectionModel>(
                        builder: (context, model, child) {
                          return CustomTextBox(
                            textValue: widget.userDetails!.currency! +
                                " " +
                                model.totalCollection.toStringAsFixed(2),
                            textSize: 4.0,
                            textWeight: FontWeight.normal,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<SingleCollectionModel>(
                        builder: (context, model, child) {
                          return CustomTextBox(
                            textValue: widget.userDetails!.currency! +
                                " " +
                                model.totalProfit.toStringAsFixed(2),
                            textSize: 4.0,
                            textWeight: FontWeight.normal,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    gettingSum();
                  },
                  child: Text("Get total"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SingleExpense extends StatelessWidget {
  const SingleExpense({
    Key? key,
    required this.height,
    required this.user,
    required this.userDetails,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);
  final height;
  final user;
  final userDetails;
  final startDate;
  final endDate;

  @override
  Widget build(BuildContext context) {
    gettingSum() {
      Provider.of<SingleCollectionModel>(context, listen: false)
          .changeExpensesSum(0.0);
      transactionsCollection.doc(userDetails.uid).get().then((value) {
        List expenses = (value.data() as dynamic)['expenses'].toList();
        double totalExpenses = 0.0;
        List filteredExpenses = [];
        filteredExpenses.addAll(expenses.where((element) {
          return DateTime(
                      int.parse(endDate.split('-').first),
                      int.parse(endDate.split('-')[1]),
                      int.parse(endDate.split('-').last))
                  .isAfter(DateTime(
                      int.parse(element['date'].split('-').first),
                      int.parse(element['date'].split('-')[1]),
                      int.parse(element['date'].split('-').last))) &&
              DateTime(
                      int.parse(startDate.split('-').first),
                      int.parse(startDate.split('-')[1]),
                      int.parse(startDate.split('-').last))
                  .isBefore(DateTime(
                      int.parse(element['date'].split('-').first),
                      int.parse(element['date'].split('-')[1]),
                      int.parse(element['date'].split('-').last)));
        }).toList());
        // print(filteredCollections);

        for (var item in filteredExpenses) {
          totalExpenses = item['amount'] + totalExpenses;
        }
        Provider.of<SingleCollectionModel>(context, listen: false)
            .changeExpensesSum(
          totalExpenses,
        );
      });
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 700,
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: CustomTextBox(
                    textValue: "Date",
                    textSize: 4.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: black,
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: CustomTextBox(
                    textValue: "Reason",
                    textSize: 4.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: black,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: CustomTextBox(
                    textValue: "Category",
                    textSize: 4.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: black,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: CustomTextBox(
                    textValue: 'Amount',
                    textSize: 4.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topRight,
                    captionAlign: TextAlign.right,
                    textColor: black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 40,
              child: FutureBuilder(
                future: transactionsCollection.doc(user.uid).get(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List expenses = snapshot.data!['expenses'].toList();
                    List filteredExpenses = [];
                    filteredExpenses.addAll(expenses.where((element) {
                      return DateTime(
                                  int.parse(endDate.split('-').first),
                                  int.parse(endDate.split('-')[1]),
                                  int.parse(endDate.split('-').last))
                              .isAfter(DateTime(
                                  int.parse(element['date'].split('-').first),
                                  int.parse(element['date'].split('-')[1]),
                                  int.parse(
                                      element['date'].split('-').last))) &&
                          DateTime(
                                  int.parse(startDate.split('-').first),
                                  int.parse(startDate.split('-')[1]),
                                  int.parse(startDate.split('-').last))
                              .isBefore(DateTime(
                                  int.parse(element['date'].split('-').first),
                                  int.parse(element['date'].split('-')[1]),
                                  int.parse(element['date'].split('-').last)));
                    }).toList());

                    return SizedBox(
                      width: 700,
                      child: ListView.builder(
                        itemCount: filteredExpenses.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomTextBox(
                                  textValue: filteredExpenses[index]['date'],
                                  textSize: 4.0,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topLeft,
                                  captionAlign: TextAlign.left,
                                  textColor: black,
                                ),
                              ),
                              SizedBox(
                                width: 180,
                                child: CustomTextBox(
                                  textValue: filteredExpenses[index]['reason'],
                                  textSize: 4.0,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topLeft,
                                  captionAlign: TextAlign.left,
                                  textColor: black,
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: CustomTextBox(
                                  textValue: filteredExpenses[index]
                                      ['category'],
                                  textSize: 4.0,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topLeft,
                                  captionAlign: TextAlign.left,
                                  textColor: black,
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: CustomTextBox(
                                  textValue: userDetails!.currency! +
                                      " " +
                                      filteredExpenses[index]['amount']
                                          .toStringAsFixed(2),
                                  textSize: 4.0,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topRight,
                                  captionAlign: TextAlign.right,
                                  textColor: black,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return Loading();
                  }
                },
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 600.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<SingleCollectionModel>(
                        builder: (context, model, child) {
                          return CustomTextBox(
                            textValue: userDetails!.currency! +
                                " " +
                                model.totalExpenses.toStringAsFixed(2),
                            textSize: 4.0,
                            textWeight: FontWeight.normal,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    gettingSum();
                  },
                  child: Text("Get total"),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     SizedBox(width: 510),

            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
