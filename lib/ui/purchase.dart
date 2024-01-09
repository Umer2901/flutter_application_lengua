import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/ui/otp1.dart';
import 'package:sizer/sizer.dart';

class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  String selectedPlan = '';
  bool isButtonEnabled = false;

  List<SubscriptionPlan> plans = [
    SubscriptionPlan('Monthly', '\$9.99/month'),
    SubscriptionPlan('6 Months', '\$49.99/6 months'),
    SubscriptionPlan('Yearly', '\$89.99/year'),
  ];

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Subscription Plans'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Remove Ads",
                  style: TextStyle(fontSize: 13.sp),
                ),
                // Text(
                //   "Get all Featured",
                //   style: TextStyle(fontSize: 13.sp),
                // ),
                // Text(
                //   "Change language according to need",
                //   style: TextStyle(fontSize: 13.sp),
                // ),
                SizedBox(height: 10),
                buildSubscriptionList(),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => otp1()));
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 25.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    primary: Color(0XFF007AFF),
                  ),
                  child: Center(
                    child: Text(
                      'Purchase Plan',
                      style: TextStyle(fontSize: 15.sp, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildSubscriptionList() {
    return Column(
      children: plans.map((plan) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPlan = plan.title;
              isButtonEnabled = true;
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedPlan == plan.title ? Colors.blue : Colors.grey,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Text(
                plan.title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                plan.price,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SubscriptionPlan {
  final String title;
  final String price;

  SubscriptionPlan(this.title, this.price);
}

void main() {
  runApp(MaterialApp(
    home: PurchasePage(),
  ));
}
