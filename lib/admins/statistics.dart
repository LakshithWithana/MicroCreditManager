import 'package:date_time_picker/date_time_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/database_services.dart';
import '../shared/colors.dart';
import '../shared/text.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<PricePoint> points = [
    PricePoint(x: 0, y: 0),
    PricePoint(x: 1, y: 0),
    PricePoint(x: 2, y: 0),
    PricePoint(x: 3, y: 0),
    PricePoint(x: 4, y: 0),
    PricePoint(x: 5, y: 0),
    PricePoint(x: 6, y: 0),
    PricePoint(x: 7, y: 0),
    PricePoint(x: 8, y: 0),
  ];
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  Object? startDate;
  Object? endDate;

  double? totalExpenses = 0.00;
  int touchedIndex = -1;
  int touchedIndexSpending = -1;

  double? dayToDayexpenses = 0.00;
  double? foods = 0.00;
  double? transport = 0.00;
  double? family = 0.00;
  double? telecomunication = 0.00;
  double? vehicles = 0.00;
  double? electronics = 0.00;
  double? furnitures = 0.00;
  double? presents = 0.00;
  double? totalExpensesSum = 0.00;
  double? totalLoansSum = 0.00;
  double? totalMoneyCollectionSum = 0.00;
  double? totalDepositsSum = 0.00;

  List<BarChartRodData> barChartExpenses() {
    return List.generate(2, (index) {
      switch (index) {
        case 0:
          return BarChartRodData(toY: 1.0);
        case 1:
          return BarChartRodData(toY: 3.0);
        default:
          throw Error();
      }
    });
  }

  List<PieChartSectionData> showingSections({totalDeposits, collectionTotal}) {
    return List.generate(
      2,
      (i) {
        final isTouched = i == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        const color0 = Color(0xff0293ee);
        const color1 = Color(0xfff8b250);
        const color2 = Color(0xff845bef);
        // const color3 = Color(0xff13d38e);

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0.withOpacity(opacity),
              value: totalDeposits,
              title: 'Desposits',
              radius: 80,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: color0, width: 6)
                  : BorderSide(color: color0.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1.withOpacity(opacity),
              value: collectionTotal,
              title: 'Collection',
              radius: 65,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: color1, width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          // case 2:
          //   return PieChartSectionData(
          //     color: color2.withOpacity(opacity),
          //     value: collectionTotal,
          //     title: 'Collections',
          //     radius: 60,
          //     titleStyle: const TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //         color: Color(0xff4c3788)),
          //     titlePositionPercentageOffset: 0.6,
          //     borderSide: isTouched
          //         ? const BorderSide(color: color2, width: 6)
          //         : BorderSide(color: color2.withOpacity(0)),
          //   );
          // case 3:
          //   return PieChartSectionData(
          //     color: color3.withOpacity(opacity),
          //     value: 20,
          //     title: '',
          //     radius: 70,
          //     titleStyle: const TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //         color: Color(0xff0c7f55)),
          //     titlePositionPercentageOffset: 0.55,
          //     borderSide: isTouched
          //         ? const BorderSide(color: color3, width: 6)
          //         : BorderSide(color: color2.withOpacity(0)),
          //   );
          default:
            throw Error();
        }
      },
    );
  }

  List<PieChartSectionData> showingSectionsSpending(
      {totalLoans, totalExpenses}) {
    return List.generate(
      2,
      (i) {
        final isTouched = i == touchedIndexSpending;
        final opacity = isTouched ? 1.0 : 0.6;

        const color0 = Color(0xFFF350C0);
        const color1 = Color(0xFF87F255);
        // const color2 = Color(0xff845bef);
        // const color3 = Color(0xff13d38e);

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0.withOpacity(opacity),
              value: totalLoans,
              title: 'Loans',
              radius: 80,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: color0, width: 6)
                  : BorderSide(color: color0.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1.withOpacity(opacity),
              value: totalExpenses,
              title: 'Expenses',
              radius: 65,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: color1, width: 6)
                  : BorderSide(color: color1.withOpacity(0)),
            );
          // case 2:
          //   return PieChartSectionData(
          //     color: color2.withOpacity(opacity),
          //     value: collectionTotal,
          //     title: 'Collections',
          //     radius: 60,
          //     titleStyle: const TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //         color: Color(0xff4c3788)),
          //     titlePositionPercentageOffset: 0.6,
          //     borderSide: isTouched
          //         ? const BorderSide(color: color2, width: 6)
          //         : BorderSide(color: color2.withOpacity(0)),
          //   );
          // case 3:
          //   return PieChartSectionData(
          //     color: color3.withOpacity(opacity),
          //     value: 20,
          //     title: '',
          //     radius: 70,
          //     titleStyle: const TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //         color: Color(0xff0c7f55)),
          //     titlePositionPercentageOffset: 0.55,
          //     borderSide: isTouched
          //         ? const BorderSide(color: color3, width: 6)
          //         : BorderSide(color: color2.withOpacity(0)),
          //   );
          default:
            throw Error();
        }
      },
    );
  }

  // List<PieChartSectionData> showingExpensesSections({
  //   dayToDayValue,
  //   foodsValue,
  //   transportValue,
  //   familyValue,
  //   telecomunicationValue,
  //   vehiclesValue,
  //   electronicsValue,
  //   furnitureValue,
  //   presentsValue,
  // }) {
  //   return List.generate(
  //     9,
  //     (i) {
  //       final isTouched = i == touchedIndex;
  //       final opacity = isTouched ? 1.0 : 0.6;

  //       const color0 = Color(0xff0293ee);
  //       const color1 = Color(0xfff8b250);
  //       const color2 = Color(0xff845bef);
  //       const color3 = Color(0xff13d38e);
  //       const color4 = Color(0xffff55a3);
  //       const color5 = Color(0xffb000b5);
  //       const color6 = Color(0xff9281b2);
  //       const color7 = Color(0xffa1b281);
  //       const color8 = Color(0xff89cff0);
  //       const color9 = Color(0xffffe135);

  //       switch (i) {
  //         case 0:
  //           return PieChartSectionData(
  //             color: color0.withOpacity(opacity),
  //             value: dayToDayValue,
  //             title: 'Day-to-day',
  //             radius: 100,
  //             titleStyle: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xff044d7c)),
  //             titlePositionPercentageOffset: 0.55,
  //             borderSide: isTouched
  //                 ? const BorderSide(color: color0, width: 6)
  //                 : BorderSide(color: color0.withOpacity(0)),
  //           );
  //         case 1:
  //           return PieChartSectionData(
  //             color: color1.withOpacity(opacity),
  //             value: foodsValue,
  //             title: 'Foods',
  //             radius: 90,
  //             titleStyle: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xff90672d)),
  //             titlePositionPercentageOffset: 0.55,
  //             borderSide: isTouched
  //                 ? const BorderSide(color: color1, width: 6)
  //                 : BorderSide(color: color2.withOpacity(0)),
  //           );
  //         case 2:
  //           return PieChartSectionData(
  //             color: color2.withOpacity(opacity),
  //             value: transportValue,
  //             title: 'Transport',
  //             radius: 80,
  //             titleStyle: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xff4c3788)),
  //             titlePositionPercentageOffset: 0.6,
  //             borderSide: isTouched
  //                 ? const BorderSide(color: color2, width: 6)
  //                 : BorderSide(color: color2.withOpacity(0)),
  //           );
  //         case 3:
  //           return PieChartSectionData(
  //             color: color3.withOpacity(opacity),
  //             value: familyValue,
  //             title: 'Family',
  //             radius: 70,
  //             titleStyle: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xff0c7f55)),
  //             titlePositionPercentageOffset: 0.55,
  //             borderSide: isTouched
  //                 ? const BorderSide(color: color3, width: 6)
  //                 : BorderSide(color: color2.withOpacity(0)),
  //           );
  //         case 4:
  //           return PieChartSectionData(
  //             color: color4.withOpacity(opacity),
  //             value: telecomunicationValue,
  //             title: 'Telecomunication',
  //             radius: 60,
  //             titleStyle: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xff0c7f55)),
  //             titlePositionPercentageOffset: 0.55,
  //             borderSide: isTouched
  //                 ? const BorderSide(color: color3, width: 6)
  //                 : BorderSide(color: color2.withOpacity(0)),
  //           );
  //         case 5:
  //           return PieChartSectionData(
  //             color: color5.withOpacity(opacity),
  //             value: vehiclesValue,
  //             title: 'Vehicles',
  //             radius: 50,
  //             titleStyle: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xff0c7f55)),
  //             titlePositionPercentageOffset: 0.55,
  //             borderSide: isTouched
  //                 ? const BorderSide(color: color3, width: 6)
  //                 : BorderSide(color: color2.withOpacity(0)),
  //           );
  //         case 6:
  //           return PieChartSectionData(
  //             color: color6.withOpacity(opacity),
  //             value: electronicsValue,
  //             title: 'Electronics',
  //             radius: 40,
  //             titleStyle: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xff0c7f55)),
  //             titlePositionPercentageOffset: 0.55,
  //             borderSide: isTouched
  //                 ? const BorderSide(color: color3, width: 6)
  //                 : BorderSide(color: color2.withOpacity(0)),
  //           );
  //         case 7:
  //           return PieChartSectionData(
  //             color: color7.withOpacity(opacity),
  //             value: furnitureValue,
  //             title: 'Furnitures',
  //             radius: 30,
  //             titleStyle: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xff0c7f55)),
  //             titlePositionPercentageOffset: 0.55,
  //             borderSide: isTouched
  //                 ? const BorderSide(color: color3, width: 6)
  //                 : BorderSide(color: color2.withOpacity(0)),
  //           );
  //         case 8:
  //           return PieChartSectionData(
  //             color: color8.withOpacity(opacity),
  //             value: presentsValue,
  //             title: 'Presents',
  //             radius: 20,
  //             titleStyle: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xff0c7f55)),
  //             titlePositionPercentageOffset: 0.55,
  //             borderSide: isTouched
  //                 ? const BorderSide(color: color3, width: 6)
  //                 : BorderSide(color: color2.withOpacity(0)),
  //           );

  //         default:
  //           throw Error();
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);

    // startDate = formatter.format(now);
    // endDate = formatter.format(now);

    return StreamBuilder<UserDetails>(
        stream: DatabaseServices(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;

            transactionsCollection
                .where('companyName', isEqualTo: userDetails!.companyName)
                .get()
                .then((value) {
              if (mounted) {
                setState(() {
                  totalExpenses =
                      (value.docs.first.data() as dynamic)['totalExpenses']
                          .toDouble();
                });
              }
            });

            getTotalDeposits({Object? startingDate, Object? endingDate}) async {
              double depositsSum = 0.00;
              await depositsCollection
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  depositsSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  totalDepositsSum = depositsSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });
            }

            getTotalMoneyCollection(
                {Object? startingDate, Object? endingDate}) async {
              double moneyCollectionSum = 0.00;
              await loansCollection
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  moneyCollectionSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  totalMoneyCollectionSum = moneyCollectionSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });
            }

            getTotalLoans({Object? startingDate, Object? endingDate}) async {
              double loanSum = 0.00;
              await loansCollection
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  loanSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  totalLoansSum = loanSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });
            }

            getTotalExpenses({Object? startingDate, Object? endingDate}) async {
              double expensesSum = 0.00;
              await expensesCollection
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  expensesSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  totalExpensesSum = expensesSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });
            }

            getExpenses({Object? startingDate, Object? endingDate}) async {
              double dayToDayexpensesSum = 0.00;
              double foodsSum = 0.00;
              double transportSum = 0.00;
              double familySum = 0.00;
              double telecomunicationSum = 0.00;
              double vehiclesSum = 0.00;
              double electronicsSum = 0.00;
              double furnituresSum = 0.00;
              double presentsSum = 0.00;
              await expensesCollection
                  .where('category', isEqualTo: 'Day-to-day expenses')
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  dayToDayexpensesSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  dayToDayexpenses = dayToDayexpensesSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });

              await expensesCollection
                  .where('category', isEqualTo: 'Foods')
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  foodsSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  foods = foodsSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });

              await expensesCollection
                  .where('category', isEqualTo: 'Transport')
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  transportSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  transport = transportSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });

              await expensesCollection
                  .where('category', isEqualTo: 'Family')
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  familySum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  family = familySum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });

              await expensesCollection
                  .where('category', isEqualTo: 'Telecomunication')
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  telecomunicationSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  telecomunication = telecomunicationSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });

              await expensesCollection
                  .where('category', isEqualTo: 'Vehicles')
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  vehiclesSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  vehicles = vehiclesSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });

              await expensesCollection
                  .where('category', isEqualTo: 'Electronics')
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  electronicsSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  electronics = electronicsSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });

              await expensesCollection
                  .where('category', isEqualTo: 'Furnitures')
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  furnituresSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  furnitures = furnituresSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });

              await expensesCollection
                  .where('category', isEqualTo: 'Presents')
                  .where('date', isGreaterThanOrEqualTo: startingDate)
                  .where('date', isLessThanOrEqualTo: endingDate)
                  .where('companyName', isEqualTo: userDetails.companyName)
                  .get()
                  .then((value) {
                for (var doc in value.docs) {
                  presentsSum += (doc.data() as dynamic)['amount'];
                }
                setState(() {
                  presents = presentsSum;
                });
              }).onError((error, stackTrace) {
                print(error);
              });

              setState(() {
                points = [
                  PricePoint(x: 0, y: dayToDayexpenses!),
                  PricePoint(x: 1, y: foods!),
                  PricePoint(x: 2, y: transport!),
                  PricePoint(x: 3, y: family!),
                  PricePoint(x: 4, y: telecomunication!),
                  PricePoint(x: 5, y: vehicles!),
                  PricePoint(x: 6, y: electronics!),
                  PricePoint(x: 7, y: furnitures!),
                  PricePoint(x: 8, y: presents!)
                ];
              });
            }

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
                            textValue: 'Statistics',
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
                          SizedBox(
                              width: width * 40,
                              child: const Text("Start date")),
                          SizedBox(
                              width: width * 40, child: const Text("End date")),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 40,
                            child: DateTimePicker(
                              icon: const Icon(Icons.calendar_month),
                              initialValue: DateTime.now()
                                  // .subtract(
                                  //     const Duration(
                                  //         days: 30))
                                  .toString(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2100),
                              onChanged: (val) {
                                setState(() {
                                  startDate = val;
                                });
                                getExpenses(
                                    startingDate: startDate,
                                    endingDate: endDate);

                                getTotalExpenses(
                                    startingDate: startDate,
                                    endingDate: endDate);

                                getTotalLoans(
                                    startingDate: startDate,
                                    endingDate: endDate);

                                getTotalMoneyCollection(
                                    startingDate: startDate,
                                    endingDate: endDate);

                                getTotalDeposits(
                                    startingDate: startDate,
                                    endingDate: endDate);
                              },
                              validator: (val) {
                                return null;
                              },
                              onSaved: (val) {
                                setState(() {
                                  startDate = val;
                                });
                                getExpenses(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalExpenses(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalLoans(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalMoneyCollection(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalDeposits(
                                    startingDate: startDate,
                                    endingDate: endDate);
                              },
                            ),
                          ),
                          SizedBox(
                            width: width * 40,
                            child: DateTimePicker(
                              icon: const Icon(Icons.calendar_month),
                              initialValue: DateTime.now()
                                  // .subtract(
                                  //     const Duration(
                                  //         days: 30))
                                  .toString(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2100),
                              onChanged: (val) {
                                setState(() {
                                  endDate = val;
                                });
                                getExpenses(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalExpenses(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalLoans(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalMoneyCollection(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalDeposits(
                                    startingDate: startDate,
                                    endingDate: endDate);
                              },
                              validator: (val) {
                                return null;
                              },
                              onSaved: (val) {
                                setState(() {
                                  endDate = val;
                                });
                                getExpenses(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalLoans(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalExpenses(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalMoneyCollection(
                                    startingDate: startDate,
                                    endingDate: endDate);
                                getTotalDeposits(
                                    startingDate: startDate,
                                    endingDate: endDate);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 2),
                      CustomTextBox(
                        textValue: 'Total of gaining money',
                        textSize: 5,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: PieChart(
                          PieChartData(
                            // pieTouchData: PieTouchData(touchCallback:
                            //     (FlTouchEvent event, pieTouchResponse) {
                            //   setState(() {
                            //     if (!event.isInterestedForInteractions ||
                            //         pieTouchResponse == null ||
                            //         pieTouchResponse.touchedSection == null) {
                            //       touchedIndex = -1;
                            //       return;
                            //     }
                            //     touchedIndex = pieTouchResponse
                            //         .touchedSection!.touchedSectionIndex;
                            //   });
                            // }),
                            startDegreeOffset: 180,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 1,
                            centerSpaceRadius: 0,
                            sections: showingSections(
                              collectionTotal: totalMoneyCollectionSum,
                              totalDeposits: totalDepositsSum,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 2),
                      CustomTextBox(
                        textValue: 'Total of spending money',
                        textSize: 5,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: PieChart(
                          PieChartData(
                            // pieTouchData: PieTouchData(touchCallback:
                            //     (FlTouchEvent event, pieTouchResponse) {
                            //   setState(() {
                            //     if (!event.isInterestedForInteractions ||
                            //         pieTouchResponse == null ||
                            //         pieTouchResponse.touchedSection == null) {
                            //       touchedIndex = -1;
                            //       return;
                            //     }
                            //     touchedIndex = pieTouchResponse
                            //         .touchedSection!.touchedSectionIndex;
                            //   });
                            // }),
                            startDegreeOffset: 180,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 1,
                            centerSpaceRadius: 0,
                            sections: showingSectionsSpending(
                              totalLoans: totalLoansSum,
                              totalExpenses: totalExpensesSum,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 2),
                      CustomTextBox(
                        textValue: 'Expenses categories',
                        textSize: 5,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SizedBox(height: height * 3),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 300,
                              width: 700,
                              child:
                                  // PieChart(
                                  //   PieChartData(
                                  //       startDegreeOffset: 180,
                                  //       borderData: FlBorderData(
                                  //         show: false,
                                  //       ),
                                  //       sectionsSpace: 1,
                                  //       centerSpaceRadius: 0,
                                  //       sections: showingExpensesSections(
                                  //         dayToDayValue: 0.2,
                                  //         electronicsValue: 0.1,
                                  //         familyValue: 0.1,
                                  //         foodsValue: 0.2,
                                  //         furnitureValue: 0.3,
                                  //         presentsValue: 0.1,
                                  //         telecomunicationValue: 0.13,
                                  //         transportValue: 0.3,
                                  //         vehiclesValue: 0.12,
                                  //       )),
                                  // ),
                                  BarChart(
                                BarChartData(
                                  barGroups: _chartGroups(),
                                  borderData: FlBorderData(
                                      border: const Border(
                                          bottom: BorderSide(),
                                          left: BorderSide())),
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    bottomTitles:
                                        AxisTitles(sideTitles: _bottomTitles),
                                    leftTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: true)),
                                    topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 2),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  List<BarChartGroupData> _chartGroups() {
    return points
        .map((point) => BarChartGroupData(
            x: point.x.toInt(), barRods: [BarChartRodData(toY: point.y)]))
        .toList();
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = 'Categories';
          switch (value.toInt()) {
            case 0:
              text = 'Day-to-day';
              break;
            case 1:
              text = 'Foods';
              break;
            case 2:
              text = 'Transport';
              break;
            case 3:
              text = 'Family';
              break;
            case 4:
              text = 'Telecom.';
              break;
            case 5:
              text = 'Vehicles';
              break;
            case 6:
              text = 'Electro.';
              break;
            case 7:
              text = 'Furnit.';
              break;
            case 8:
              text = 'Presents';
              break;
          }

          return Text(text);
        },
      );
}

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}
