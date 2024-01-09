// import 'package:flutter/material.dart';
// import 'package:flutter_application_lengua/my_flutter_app_icons.dart';
// import 'package:flutter_application_lengua/ui/chat2.dart';
// import 'package:sizer/sizer.dart';
// import 'package:toggle_switch/toggle_switch.dart';

// class call extends StatelessWidget {
//   const call({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, deviceType) {
//       return SafeArea(
//         child: Scaffold(
//           body: Column(
//             children: [
//               Container(
//                 height: 8.h,
//                 decoration: BoxDecoration(
//                     color: Colors.green,
//                     image: DecorationImage(
//                         image: AssetImage("assets/images/ad.jpeg"),
//                         fit: BoxFit.fill)),
//               ),
//               Expanded(
//                 child: Scaffold(
//                   appBar: AppBar(
//                     automaticallyImplyLeading: false,
//                     backgroundColor: Color(0xffF6F6F6),
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: 45,
//                         ),
//                         Center(
//                           child: SizedBox(
//                             height: 30,
//                             width: 150,
//                             child: ToggleSwitch(
//                               inactiveBgColor: Colors.white,
//                               activeBgColor: [
//                                 Color(0xff007AFF),
//                                 Color(0xff007AFF)
//                               ],
//                               initialLabelIndex: 0,
//                               totalSwitches: 2,
//                               labels: ['All', 'Missed'],
//                               onToggle: (index) {
//                                 print('switched to: $index');
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     actions: [
//                       IconButton(
//                         onPressed: () {
//                           // Handle call icon press
//                         },
//                         icon: Icon(
//                           MyFlutterApp.callplus,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ],
//                   ),
//                   body: ListView.builder(
//                     itemCount: 20,
//                     padding: const EdgeInsets.symmetric(vertical: 0),
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           // Navigator.of(context).push(MaterialPageRoute(
//                           //     builder: (context) => ChatPage()));
//                         },
//                         child: Container(
//                           color: Colors.white,
//                           child: Column(
//                             children: [
//                               ListTile(
//                                 title: Text("Doreamon",
//                                     maxLines: 1,
//                                     style: TextStyle(
//                                         fontSize: 14.sp,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold)),
//                                 subtitle: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text("outgoing",
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                                 fontSize: 12.sp,
//                                                 color: Colors.grey)),
//                                         Text("2:23 pm",
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.grey)),
//                                       ],
//                                     ),
//                                     Divider(
//                                       thickness: 1,
//                                       color: Colors.grey,
//                                     )
//                                   ],
//                                 ),
//                                 leading: CircleAvatar(
//                                   radius: 20,
//                                   backgroundImage: AssetImage(
//                                     "assets/images/Oval.png",
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/my_flutter_app_icons.dart';
import 'package:flutter_application_lengua/ui/chat2.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';

class call extends StatefulWidget {
  const call({super.key});

  @override
  State<call> createState() => _callState();
}

class _callState extends State<call> {
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnit = "ca-app-pub-3940256099942544/6300978111";
  initBannerAd() {
    bannerAd = BannerAd(
      adUnitId: adUnit,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        },
      ),
    );
    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              isAdLoaded
                  ? SizedBox(
                      height: bannerAd.size.height.toDouble(),
                      width: bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd),
                    )
                  : const SizedBox(),
              Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Color(0xffF6F6F6),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 45,
                        ),
                        Center(
                          child: SizedBox(
                            height: 30,
                            width: 150,
                            child: ToggleSwitch(
                              inactiveBgColor: Colors.white,
                              activeBgColor: [
                                Color(0xff007AFF),
                                Color(0xff007AFF)
                              ],
                              initialLabelIndex: 0,
                              totalSwitches: 2,
                              labels: ['All', 'Missed'],
                              onToggle: (index) {
                                print('switched to: $index');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          // Handle call icon press
                        },
                        icon: Icon(
                          MyFlutterApp.callplus,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  body: ListView.builder(
                    itemCount: 20,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => ChatPage()));
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Doreamon",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("outgoing",
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey)),
                                        Text("2:23 pm",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    "assets/images/Oval.png",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          // bottomNavigationBar: isAdLoaded
          //     ? Container(
          //         height: bannerAd.size.height.toDouble(),
          //         width: bannerAd.size.width.toDouble(),
          //         child: AdWidget(ad: bannerAd),
          //       )
          //     : null,
        ),
      );
    });
  }
}
