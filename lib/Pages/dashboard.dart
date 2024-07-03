// ignore_for_file: unused_local_variable, unused_field, library_private_types_in_public_api

import 'package:beepney/Pages/loginpage.dart';
import 'package:beepney/Pages/shared_data.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/* Authored by: Kryslone Dave D. Perez
Company: MITechnoverse
Project: Beepney
Feature: [BPNY-004] Beepney's Dashboard
 */

// DashBoard

class DashBoard extends StatefulWidget {
  final int initialIndex;

  const DashBoard({super.key, this.initialIndex = 0});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late PersistentTabController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: PersistentTabView(
          controller: _controller,
          navBarHeight: 80,
          tabs: [
            PersistentTabConfig(
              screen: const HomePage(),
              item: ItemConfig(
                  activeForegroundColor: const Color.fromRGBO(07, 30, 51, 1),
                  inactiveForegroundColor: Colors.grey,
                  icon: const Icon(FontAwesomeIcons.house, size: 30),
                  title: "Home",
                  textStyle: const TextStyle(
                    fontFamily: 'IstokWeb',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  )),
            ),
            PersistentTabConfig(
              item: ItemConfig(
                activeForegroundColor: const Color.fromRGBO(07, 30, 51, 1),
                inactiveForegroundColor: Colors.grey,
                icon: const Icon(FontAwesomeIcons.idCard, size: 30),
                title: "Driver",
                textStyle: const TextStyle(
                  fontFamily: 'IstokWeb',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              screen: Provider.of<SharedData>(context).isVerified
                  ? DriverPage(
                      key: const ValueKey('DriverPage'),
                      licensePlate:
                          Provider.of<SharedData>(context).licensePlate,
                      firstRoute: Provider.of<SharedData>(context).firstroute,
                      secondRoute: Provider.of<SharedData>(context).secondroute,
                    )
                  : const Splash(
                      child: null,
                    ),
            ),
            PersistentTabConfig.noScreen(
              item: ItemConfig(
                activeForegroundColor: const Color.fromRGBO(07, 30, 51, 1),
                icon: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      )),
                  child: const Icon(
                    FontAwesomeIcons.qrcode,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                title: " ",
              ),
              onPressed: (context) {
                pushScreen(context,
                    screen: const PaymentPage(), withNavBar: false);
              },
            ),
            PersistentTabConfig(
              screen: const TransactionPage(),
              item: ItemConfig(
                  activeForegroundColor: const Color.fromRGBO(07, 30, 51, 1),
                  inactiveForegroundColor: Colors.grey,
                  icon: const Icon(FontAwesomeIcons.receipt, size: 30),
                  title: "Transaction",
                  textStyle: const TextStyle(
                    fontFamily: 'IstokWeb',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  )),
            ),
            PersistentTabConfig(
              screen: const ProfilePage(),
              item: ItemConfig(
                  activeForegroundColor: const Color.fromRGBO(07, 30, 51, 1),
                  inactiveForegroundColor: Colors.grey,
                  icon: const Icon(
                    Icons.person,
                    size: 30,
                  ),
                  title: "Profile",
                  textStyle: const TextStyle(
                    fontFamily: 'IstokWeb',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  )),
            ),
          ],
          navBarBuilder: (navBarConfig) => Style13BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: const NavBarDecoration(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
        ),
      ),
    );
  }
}

//Home Page Screen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselController _controller = CarouselController();
  final List<String> imgList = [
    'assets/images/img1.png',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
  ];
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<SharedData>(builder: (content, sharedData, child) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Material(
            elevation: 15,
            child: AppBar(
              toolbarHeight: 100,
              title: Text('Hello, ${sharedData.name}',
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'IstokWeb',
                      fontWeight: FontWeight.bold)),
              backgroundColor: const Color.fromRGBO(07, 30, 51, 1),
              leading: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset('assets/images/B.png'),
              ),
              elevation: 0,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 19.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'New Guidelines',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'IstokWeb',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Divider(),
                                  Text(
                                    'The city Government new implementation of Fare rates and regulation',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(07, 30, 51, 1),
                                      fontFamily: 'IstokWeb',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(07, 30, 51, 1),
                                          Colors.blue,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: TextButton(
                                      child: const Text('Not Now',
                                          style: TextStyle(
                                              fontFamily: 'IstokWeb',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(07, 30, 51, 1),
                                          Colors.blue,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: TextButton(
                                      child: const Text('View',
                                          style: TextStyle(
                                              fontFamily: 'IstokWeb',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                GuidelinesPage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(234, 234, 234, 1),
        body: SafeArea(
          child: LimitedBox(
            maxHeight: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: <Color>[
                            Color.fromRGBO(60, 186, 255, 1),
                            Color.fromRGBO(16, 71, 101, 1)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: const Text(
                          'Overview',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'IstokWeb',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 340,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/ContainerBG.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text('Available Balance',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'IstokWeb',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text('\u20B1 1000.00',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          pushScreen(context,
                              screen: const CashinPage(), withNavBar: false);
                        },
                        child: Container(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: <Color>[
                                    Color.fromRGBO(60, 186, 255, 1),
                                    Color.fromRGBO(16, 71, 101, 1)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                child: const Text(
                                  ' + Cash In ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'IstokWeb',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Dash(
                  direction: Axis.horizontal,
                  length: 320,
                  dashLength: 15,
                  dashThickness: 2,
                  dashGap: 7,
                  dashColor: Colors.grey,
                ),
                const SizedBox(
                  height: 30,
                ),
                CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  items: imgList
                      .map((item) => Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(item,
                                  fit: BoxFit.cover, width: 1000),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(
                  height: 15,
                ),
                SmoothPageIndicator(
                  controller: PageController(initialPage: _current),
                  count: imgList.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Color.fromRGBO(07, 30, 51, 1),
                    dotColor: Colors.grey,
                    dotHeight: 12,
                    dotWidth: 12,
                  ),
                  onDotClicked: (index) {
                    _controller.animateToPage(index);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

//Drivers Page

class DriverPage extends StatelessWidget {
  final String licensePlate;
  final String firstRoute;
  final String secondRoute;

  const DriverPage({
    required Key key,
    required this.licensePlate,
    required this.firstRoute,
    required this.secondRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sharedData = Provider.of<SharedData>(context);
    final licensePlate = sharedData.licensePlate;
    final firstRoute = sharedData.firstroute;
    final secondRoute = sharedData.secondroute;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Material(
          elevation: 15,
          child: AppBar(
            toolbarHeight: 100,
            title: const Text('Hello, Driver',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'IstokWeb',
                    fontWeight: FontWeight.bold)),
            backgroundColor: const Color.fromRGBO(07, 30, 51, 1),
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/images/B.png'),
            ),
            elevation: 0,
          ),
        ),
      ),
      body: SafeArea(
        child: LimitedBox(
          maxHeight: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(60, 186, 255, 1),
                          Color.fromRGBO(16, 71, 101, 1)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'IstokWeb',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 340,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/images/ContainerBG.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text('Beepney Balance',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'IstokWeb',
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('\u20B1 1000.00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: <Color>[
                                Color.fromRGBO(60, 186, 255, 1),
                                Color.fromRGBO(16, 71, 101, 1)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: const Text(
                              ' + Withdraw ',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'IstokWeb',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Dash(
                direction: Axis.horizontal,
                length: 320,
                dashLength: 15,
                dashThickness: 2,
                dashGap: 7,
                dashColor: Colors.grey,
              ),
              const SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 125.0,
                              enlargeFactor: 5,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.vertical,
                              onPageChanged: (index, reason) {},
                            ),
                            items: [
                              {
                                'title': 'License Plate',
                                'value': licensePlate,
                              },
                              {
                                'title': 'First Route',
                                'value': firstRoute,
                              },
                              {
                                'title': 'Second Route',
                                'value': secondRoute,
                              },
                            ].map((item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.blue,
                                          Color.fromRGBO(7, 48, 81, 1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item['title'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item['value'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.qr_code_2_rounded,
                                size: 45,
                                color: Color.fromRGBO(21, 91, 157, 1)),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              color: const Color.fromRGBO(
                                                  07, 30, 51, 1),
                                            ),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.6,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4 -
                                              100,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  QrImageView(
                                                    data: 'Driver Gabriel',
                                                    version: QrVersions.auto,
                                                    size: 200.0,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              WidgetStateProperty
                                                                  .all(Colors
                                                                      .transparent),
                                                          shadowColor:
                                                              WidgetStateProperty
                                                                  .all(Colors
                                                                      .transparent),
                                                          shape:
                                                              WidgetStateProperty
                                                                  .all(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            ),
                                                          ),
                                                          padding:
                                                              WidgetStateProperty
                                                                  .all(
                                                                      const EdgeInsets
                                                                          .all(
                                                                          0)),
                                                        ),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            gradient:
                                                                const LinearGradient(
                                                              colors: [
                                                                Colors.blue,
                                                                Color.fromRGBO(
                                                                    07,
                                                                    30,
                                                                    51,
                                                                    1),
                                                              ],
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: const Text(
                                                              'Print QR',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'IstokWeb',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      20)),
                                                        ),
                                                        onPressed: () {},
                                                      ),
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              WidgetStateProperty
                                                                  .all(Colors
                                                                      .transparent),
                                                          shadowColor:
                                                              WidgetStateProperty
                                                                  .all(Colors
                                                                      .transparent),
                                                          shape:
                                                              WidgetStateProperty
                                                                  .all(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            ),
                                                          ),
                                                          padding:
                                                              WidgetStateProperty
                                                                  .all(
                                                                      const EdgeInsets
                                                                          .all(
                                                                          0)),
                                                        ),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            gradient:
                                                                const LinearGradient(
                                                              colors: [
                                                                Colors.blue,
                                                                Color.fromRGBO(
                                                                    07,
                                                                    30,
                                                                    51,
                                                                    1),
                                                              ],
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: const Text(
                                                              'Share QR',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'IstokWeb',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                              )),
                                                        ),
                                                        onPressed: () {},
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 40,
                                          left: 20,
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons
                                                    .keyboard_arrow_left_rounded,
                                                size: 40,
                                                color: Colors.white),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const Text(
                            'Generate',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'IstokWeb',
                              color: Color.fromRGBO(21, 91, 157, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(234, 234, 234, 1),
    );
  }
}

//Payment Page

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    return _controller!.initialize();
  }

  @override
  void dispose() {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded,
              color: Colors.white, size: 40),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Pay',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'IstokWeb',
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(07, 30, 51, 1),
        toolbarHeight: 90,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (_controller != null && _controller!.value.isInitialized)
                  CameraPreview(_controller!)
                else
                  const Center(child: CircularProgressIndicator()),
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SuccessPayment(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: Color.fromRGBO(07, 30, 51, 1)),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

//SuccessPayment Page

class SuccessPayment extends StatelessWidget {
  const SuccessPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(07, 30, 51, 1),
                        Colors.blue,
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Successful!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Thank you for paying your fare',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Color.fromRGBO(07, 30, 51, 1)],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: () {
                          Navigator.popUntil(context,
                              ModalRoute.withName(Navigator.defaultRouteName));
                        },
                        child: const Text(
                          'FINISH',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IstokWeb'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Transaction Page Code

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Material(
          elevation: 15,
          child: AppBar(
            toolbarHeight: 100,
            centerTitle: true,
            title: const Text('Transaction History',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'IstokWeb',
                    fontWeight: FontWeight.bold)),
            backgroundColor: const Color.fromRGBO(07, 30, 51, 1),
            elevation: 0,
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(234, 234, 234, 1),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 10),
                const Text(
                  'Recent',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'IstokWeb',
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(07, 30, 51, 1),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Transaction Details',
                            style: TextStyle(
                              color: Color.fromRGBO(07, 30, 51, 1),
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'Send beepney to Driver Gabriel via QR',
                                      style: TextStyle(
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      '09096055789',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'April 06, 2024',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'PHP 12.00',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Reference Number',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          '1234567890',
                                          style: TextStyle(
                                            fontFamily: 'IstokWeb',
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(07, 30, 51, 1),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 15,
                                            color:
                                                Color.fromRGBO(07, 30, 51, 1),
                                          ),
                                          onPressed: () {
                                            Clipboard.setData(
                                                const ClipboardData(
                                                    text: '1234567890'));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            Center(
                              child: Container(
                                width: 200,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF3366FF),
                                      Color(0xFF00CCFF)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Okay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'IstokWeb',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.mark_email_unread_outlined,
                          color: Color.fromRGBO(07, 30, 51, 1)),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Send Beepney',
                              style: TextStyle(
                                  color: Color.fromRGBO(07, 30, 51, 1),
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold)),
                          Text('April 06, 2024',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              'You have paid PHP 12.00 via QR to Driver Gabriel',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'IstokWeb',
                                  color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Transaction Details',
                            style: TextStyle(
                              color: Color.fromRGBO(07, 30, 51, 1),
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'Send beepney to Driver Christian via QR',
                                      style: TextStyle(
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      '09096891289',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'April 05, 2024',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'PHP 50.00',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Reference Number',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          '0987654321',
                                          style: TextStyle(
                                            fontFamily: 'IstokWeb',
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(07, 30, 51, 1),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 15,
                                            color:
                                                Color.fromRGBO(07, 30, 51, 1),
                                          ),
                                          onPressed: () {
                                            Clipboard.setData(
                                                const ClipboardData(
                                                    text: '0987654321'));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            Center(
                              child: Container(
                                width: 200,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF3366FF),
                                      Color(0xFF00CCFF)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Okay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'IstokWeb',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.mark_email_unread_outlined,
                          color: Color.fromRGBO(07, 30, 51, 1)),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Send Beepney',
                              style: TextStyle(
                                  color: Color.fromRGBO(07, 30, 51, 1),
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold)),
                          Text('April 05, 2024',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              'You have paid PHP 50.00 via QR to Driver Christian',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'IstokWeb',
                                  color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Transaction Details',
                            style: TextStyle(
                              color: Color.fromRGBO(07, 30, 51, 1),
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'Send beepney to Driver Dave via QR',
                                      style: TextStyle(
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      '09096022755',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'April 05, 2024',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'PHP 30.00',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Reference Number',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          '1234567890',
                                          style: TextStyle(
                                            fontFamily: 'IstokWeb',
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(07, 30, 51, 1),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 15,
                                            color:
                                                Color.fromRGBO(07, 30, 51, 1),
                                          ),
                                          onPressed: () {
                                            Clipboard.setData(
                                                const ClipboardData(
                                                    text: '1234567890'));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            Center(
                              child: Container(
                                width: 200,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF3366FF),
                                      Color(0xFF00CCFF)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Okay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'IstokWeb',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.mark_email_unread_outlined,
                          color: Color.fromRGBO(07, 30, 51, 1)),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Send Beepney',
                              style: TextStyle(
                                  color: Color.fromRGBO(07, 30, 51, 1),
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold)),
                          Text('April 05, 2024',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              'You have paid PHP 30.00 via QR to Driver Dave',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'IstokWeb',
                                  color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Other Messages',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'IstokWeb',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Transaction Details',
                            style: TextStyle(
                              color: Color.fromRGBO(07, 30, 51, 1),
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Successfully Purchased Beepney',
                                      style: TextStyle(
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      '09098765452',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'April 01, 2024',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'PHP 1000.00',
                                      style: TextStyle(
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(07, 30, 51, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Reference Number',
                                      style: TextStyle(
                                          fontFamily: 'IstokWeb',
                                          color: Colors.grey),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          '1234567890',
                                          style: TextStyle(
                                            fontFamily: 'IstokWeb',
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(07, 30, 51, 1),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 15,
                                            color:
                                                Color.fromRGBO(07, 30, 51, 1),
                                          ),
                                          onPressed: () {
                                            Clipboard.setData(
                                                const ClipboardData(
                                                    text: '1234567890'));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            Center(
                              child: Container(
                                width: 200,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF3366FF),
                                      Color(0xFF00CCFF)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Okay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'IstokWeb',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.mark_email_unread_outlined,
                          color: Colors.grey),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recieved Beepney',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold)),
                          Text('April 01, 2024',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              'You have paid PHP 1000.00 for Beepney Balance Purchase',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'IstokWeb',
                                  color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Profile Page Code

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  bool isPhoneVisible = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: Provider.of<SharedData>(context, listen: false).name);
    addressController = TextEditingController(
        text: Provider.of<SharedData>(context, listen: false).address);
    emailController = TextEditingController(text: 'johndoe@example.com');
    phoneController = TextEditingController(text: '09096024579');
  }

  Future<void> showEditDialog(String title, TextEditingController controller) {
    TextEditingController dialogController =
        TextEditingController(text: controller.text);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: const TextStyle(
              color: Color.fromRGBO(07, 30, 51, 1),
              fontSize: 30,
              fontFamily: 'IstokWeb',
              fontWeight: FontWeight.bold),
          title: Text('Edit $title'),
          content: TextField(
            controller: dialogController,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFF3366FF), Color(0xFF00CCFF)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        ' Not Now ',
                        style: TextStyle(
                          fontFamily: 'IstokWeb',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFF3366FF), Color(0xFF00CCFF)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        ' Save ',
                        style: TextStyle(
                          fontFamily: 'IstokWeb',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    controller.text = dialogController.text;
                    if (title == 'Name') {
                      Provider.of<SharedData>(context, listen: false).name =
                          controller.text;
                    } else if (title == 'Address') {
                      Provider.of<SharedData>(context, listen: false).address =
                          controller.text;
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String idText = Provider.of<SharedData>(context).idText;
    String name = Provider.of<SharedData>(context).name;
    String address = Provider.of<SharedData>(context).address;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          centerTitle: true,
          title: const Text('Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'IstokWeb',
                  fontWeight: FontWeight.bold)),
          backgroundColor: const Color.fromRGBO(07, 30, 51, 1),
        ),
        backgroundColor: const Color.fromRGBO(234, 234, 234, 1),
        body: SingleChildScrollView(
          child: Flexible(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 150,
                  child: Container(
                    width: double.infinity,
                    color: const Color.fromRGBO(07, 30, 51, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 4, color: Colors.white),
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                    image:
                                        AssetImage('assets/images/profile.jpg'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Colors.white,
                                    ),
                                    color:
                                        const Color.fromARGB(255, 11, 85, 155),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(07, 30, 51, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Name',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold)),
                          Consumer<SharedData>(
                            builder: (context, sharedData, child) {
                              return Text(sharedData.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'IstokWeb'));
                            },
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          showEditDialog('Name', nameController);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(07, 30, 51, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Phone Number',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'IstokWeb',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              isPhoneVisible
                                  ? phoneController.text
                                  : phoneController.text.length > 4
                                      ? phoneController.text.substring(0, 2) +
                                          '*' *
                                              (phoneController.text.length -
                                                  4) +
                                          phoneController.text.substring(
                                              phoneController.text.length - 2)
                                      : phoneController.text,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'IstokWeb')),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color.fromRGBO(60, 186, 255, 1),
                                  Color.fromRGBO(16, 71, 101, 1)
                                ],
                                tileMode: TileMode.mirror,
                              ).createShader(bounds),
                              child: const Text(' Verified ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'IstokWeb',
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                            isPhoneVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white),
                        onPressed: () {
                          setState(() {
                            isPhoneVisible = !isPhoneVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(07, 30, 51, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Email',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold)),
                          Text(emailController.text,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'IstokWeb')),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color.fromRGBO(60, 186, 255, 1),
                                  Color.fromRGBO(16, 71, 101, 1)
                                ],
                                tileMode: TileMode.mirror,
                              ).createShader(bounds),
                              child: const Text(' Verified ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'IstokWeb',
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(07, 30, 51, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Address',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold)),
                          Text(addressController.text,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'IstokWeb')),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          showEditDialog('Address', addressController);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(07, 30, 51, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Valid ID',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold)),
                          Text(idText,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'IstokWeb')),
                          if (idText.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(60, 186, 255, 1),
                                    Color.fromRGBO(16, 71, 101, 1)
                                  ],
                                  tileMode: TileMode.mirror,
                                ).createShader(bounds),
                                child: const Text(' Verified ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'IstokWeb',
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          pushScreen(context,
                              screen: const ChooseId(), withNavBar: false);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20), // Adjust spacing as needed
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      pushScreen(context,
                          screen: const LoginPage(), withNavBar: false);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromRGBO(07, 30, 51, 1), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18.0), // Rounded corners
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 15.0), // Adjust padding as needed
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                            fontSize: 16), // Adjust text style as needed
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ));
  }
}

class CashinPage extends StatefulWidget {
  const CashinPage({super.key});

  @override
  State<CashinPage> createState() => _CashinPageState();
}

class _CashinPageState extends State<CashinPage> {
  int _selectedIndex = -1;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final SharedData sharedData = SharedData();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _selectedIndex = -1;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded,
              color: Colors.white, size: 40),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Cash In',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'IstokWeb',
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(07, 30, 51, 1),
        toolbarHeight: 90,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    margin: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 300.0,
                        width: 300.0,
                        child: Image.asset(
                          'assets/images/howto.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const Dash(
                    direction: Axis.horizontal,
                    length: 320,
                    dashLength: 15,
                    dashThickness: 2,
                    dashGap: 7,
                    dashColor: Colors.grey,
                  ),
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('Enter Phone Number',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IstokWeb',
                                color: Color.fromRGBO(07, 30, 51, 1))),
                        const SizedBox(height: 10),
                        TextField(
                          keyboardType: TextInputType.number,
                          maxLength: 11,
                          decoration: InputDecoration(
                            hintText: '09xxxxxxxxx',
                            hintStyle: TextStyle(color: Colors.grey[300]),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const Text('Beepney',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IstokWeb',
                                color: Color.fromRGBO(07, 30, 51, 1))),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter your desired amount ₱5-₱1000',
                            hintStyle: TextStyle(color: Colors.grey[300]),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 0;
                                  _controller.text = '50';
                                });
                              },
                              child: Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  border: _selectedIndex == 0
                                      ? Border.all(
                                          color: const Color.fromRGBO(
                                              07, 30, 51, 1),
                                          width: 2.0)
                                      : null,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ' 50 Beepney',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromRGBO(07, 30, 51, 1),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'IstokWeb'),
                                    ),
                                    Text(' ₱50.00',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 1;
                                  _controller.text = '100';
                                });
                              },
                              child: Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  border: _selectedIndex == 1
                                      ? Border.all(
                                          color: const Color.fromRGBO(
                                              07, 30, 51, 1),
                                          width: 2.0)
                                      : null,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ' 100 Beepney',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromRGBO(07, 30, 51, 1),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'IstokWeb'),
                                    ),
                                    Text(' ₱100.00',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 3;
                                  _controller.text = '250';
                                });
                              },
                              child: Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  border: _selectedIndex == 3
                                      ? Border.all(
                                          color: const Color.fromRGBO(
                                              07, 30, 51, 1),
                                          width: 2.0)
                                      : null,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ' 250 Beepney',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromRGBO(07, 30, 51, 1),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'IstokWeb'),
                                    ),
                                    Text(' ₱250.00',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 4;
                                  _controller.text = '500';
                                });
                              },
                              child: Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  border: _selectedIndex == 4
                                      ? Border.all(
                                          color: const Color.fromRGBO(
                                              07, 30, 51, 1),
                                          width: 2.0)
                                      : null,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ' 500 Beepney',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromRGBO(07, 30, 51, 1),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'IstokWeb'),
                                    ),
                                    Text(' ₱500.00',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 5;
                                  _controller.text = '750';
                                });
                              },
                              child: Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  border: _selectedIndex == 5
                                      ? Border.all(
                                          color: const Color.fromRGBO(
                                              07, 30, 51, 1),
                                          width: 2.0)
                                      : null,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ' 750 Beepney',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromRGBO(07, 30, 51, 1),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'IstokWeb'),
                                    ),
                                    Text(' ₱750.00',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 6;
                                  _controller.text = '1000';
                                });
                              },
                              child: Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  border: _selectedIndex == 6
                                      ? Border.all(
                                          color: const Color.fromRGBO(
                                              07, 30, 51, 1),
                                          width: 2.0)
                                      : null,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ' 1000 Beepney',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromRGBO(07, 30, 51, 1),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'IstokWeb'),
                                    ),
                                    Text(' ₱1000.00',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                sharedData.saveBeepneyAmount(_controller.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectPaymentMethod(
                          beepneyAmount: sharedData.beepneyAmount)),
                );
              },
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                      offset: Offset(0.0, 2.0),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 50.0,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue,
                          Color.fromRGBO(7, 48, 81, 1),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Select Payment Method',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'IstokWeb',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectPaymentMethod extends StatefulWidget {
  final String beepneyAmount;

  const SelectPaymentMethod({super.key, required this.beepneyAmount});

  @override
  State<SelectPaymentMethod> createState() => _SelectPaymentMethodState();
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod> {
  int _selectedButton = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded,
              color: Colors.white, size: 40),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Select Payment Method',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(07, 30, 51, 1),
        toolbarHeight: 90,
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.security_rounded, color: Colors.grey, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your Security is important to use. We do not store your e-wallet information.',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IstokWeb',
                          color: Colors.grey),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/gcash.png', width: 140),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        side: BorderSide(
                          width: 3,
                          color: _selectedButton == 1
                              ? const Color.fromRGBO(07, 30, 51, 1)
                              : Colors.grey,
                        ),
                      ),
                      child: _selectedButton == 1
                          ? const Icon(Icons.circle,
                              color: Color.fromRGBO(07, 30, 51, 1))
                          : const Icon(Icons.circle, color: Colors.transparent),
                      onPressed: () {
                        selectedPaymentMethod = 'Gcash';
                        setState(() {
                          _selectedButton = 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/maya.png',
                        width: 160.0, height: 80),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        side: BorderSide(
                          width: 3,
                          color: _selectedButton == 2
                              ? const Color.fromRGBO(07, 30, 51, 1)
                              : Colors.grey,
                        ),
                      ),
                      child: _selectedButton == 2
                          ? const Icon(Icons.circle,
                              color: Color.fromRGBO(07, 30, 51, 1))
                          : const Icon(Icons.circle, color: Colors.transparent),
                      onPressed: () {
                        selectedPaymentMethod = 'Maya';
                        setState(() {
                          _selectedButton = 2;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 2.0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Beepney',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IstokWeb',
                                color: Color.fromRGBO(07, 30, 51, 1))),
                        Text(widget.beepneyAmount.toString(),
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IstokWeb',
                                color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Dash(
                    direction: Axis.horizontal,
                    length: 330,
                    dashLength: 5,
                    dashThickness: 2,
                    dashGap: 5,
                    dashColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(''),
                            const Text('Amount to pay',
                                style: TextStyle(
                                  fontFamily: 'IstokWeb',
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text('₱${widget.beepneyAmount}.00',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Color.fromRGBO(07, 30, 51, 1),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Container(
                          height: 50.0,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue,
                                Color.fromRGBO(7, 48, 81, 1),
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(15)),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.transparent),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                              textStyle: WidgetStateProperty.all<TextStyle>(
                                  const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentSuccessful(
                                        beepneyAmount: double.parse(
                                            widget.beepneyAmount))),
                              );
                            },
                            child: const Text('Proceed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23.0,
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class PaymentSuccessful extends StatelessWidget {
  final double beepneyAmount;

  const PaymentSuccessful({super.key, required this.beepneyAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(07, 30, 51, 1),
                        Colors.blue,
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Successful Payment',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Thank you for paying through $selectedPaymentMethod',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '₱$beepneyAmount',
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Color.fromRGBO(07, 30, 51, 1)],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: () {
                          Navigator.popUntil(context,
                              ModalRoute.withName(Navigator.defaultRouteName));
                        },
                        child: const Text(
                          'FINISH',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IstokWeb'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String selectedPaymentMethod = '';

//Guidelines

class GuidelinesPage extends StatelessWidget {
  GuidelinesPage({super.key});

  final Uri _url = Uri.parse(
      'https://www2.naga.gov.ph/riding-public-hails-naga-citys-reduction-of-transport-fare/#:~:text=Its%20regular%20fare%20now%20rates,and%20P8%20for%20discounted%20passengers.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded,
              color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Guidelines',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'IstokWeb',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(07, 30, 51, 1),
        toolbarHeight: 65,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(07, 30, 51, 1),
                        Colors.blue,
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 300,
            left: MediaQuery.of(context).size.width / 2 - 149,
            child: Column(
              children: [
                Container(
                  width: 300,
                  height: 420,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/fare.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 150,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(07, 30, 51, 1),
                        Colors.blue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _launchUr1,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Read More',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'IstokWeb',
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUr1() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key, required child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/context1.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Align(
              alignment: const Alignment(0, 0.2),
              child: Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Simply hit \'Get Started\' below to kickstart the process. We\'ll guide you through the quick and hassle-free verification and jeepney information management.',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IstokWeb',
                          color: Color.fromRGBO(13, 58, 100, 1)),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                          colors: <Color>[
                            Color(0xFF208FCB),
                            Color(0xFF073051),
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          showGeneralDialog(
                            context: context,
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    DriverRegisterPage(),
                            barrierDismissible: false,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            transitionBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return ScaleTransition(
                                scale: CurvedAnimation(
                                    parent: animation, curve: Curves.easeOut),
                                child: child,
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IstokWeb',
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DriverRegisterPage extends StatelessWidget {
  final licensePlateController = TextEditingController();
  final firstrouteController = TextEditingController();
  final secondrouteController = TextEditingController();

  DriverRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/context2.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                      Positioned(
                        top: 40.0,
                        left: 10.0,
                        child: IconButton(
                          icon: const Icon(Icons.keyboard_arrow_left_rounded,
                              size: 50.0, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    color: Colors.grey[200],
                    child: Center(
                        child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Row(
                                    children: [
                                      Text('License Plate Number',
                                          style: TextStyle(
                                              fontFamily: 'IstokWeb',
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  13, 58, 100, 1))),
                                      Text('  *',
                                          style: TextStyle(color: Colors.blue)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: licensePlateController,
                                    decoration: InputDecoration(
                                      hintText: 'ABC-123',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[300]),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Row(
                                    children: [
                                      Text('Route',
                                          style: TextStyle(
                                              fontFamily: 'IstokWeb',
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  13, 58, 100, 1))),
                                      Text('  *',
                                          style: TextStyle(color: Colors.blue)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: firstrouteController,
                                          decoration: InputDecoration(
                                            hintText: 'Libmanan',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[300]),
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                          FontAwesomeIcons.arrowRightArrowLeft,
                                          color: Colors.blue),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: secondrouteController,
                                          decoration: InputDecoration(
                                            hintText: 'Naga',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[300]),
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Dash(
                              direction: Axis.horizontal,
                              length: 320,
                              dashLength: 15,
                              dashThickness: 2,
                              dashGap: 7,
                              dashColor: Colors.grey,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Please provide copies of the following documents to complete your registration',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'IstokWeb',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  const Row(
                                    children: [
                                      Text('Professional Driver\'s License',
                                          style: TextStyle(
                                              fontFamily: 'IstokWeb',
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  13, 58, 100, 1))),
                                      Text('  * Required',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.lightBlue)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 50,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          border: Border.all(
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: const Icon(
                                          Icons.attach_file,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Row(
                                    children: [
                                      Text('Certificate of Registration',
                                          style: TextStyle(
                                              fontFamily: 'IstokWeb',
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  13, 58, 100, 1))),
                                      Text('  * Required',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.lightBlue)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 50,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          border: Border.all(
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: const Icon(
                                          Icons.attach_file,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Center(
                                    child: SizedBox(
                                      width: 200,
                                      height: 40,
                                      child: Text(
                                        'These Documents are necessary to verify your identity and vehicle ownership.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: 'IstokWeb',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: const LinearGradient(
                                          colors: <Color>[
                                            Color(0xFF208FCB),
                                            Color(0xFF073051),
                                          ],
                                        ),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                        ),
                                        onPressed: () {
                                          final licensePlate =
                                              licensePlateController.text;
                                          final firstroute =
                                              firstrouteController.text;
                                          final secondroute =
                                              secondrouteController.text;

                                          final sharedData =
                                              Provider.of<SharedData>(context,
                                                  listen: false);

                                          sharedData.licensePlate =
                                              licensePlate;
                                          sharedData.firstroute = firstroute;
                                          sharedData.secondroute = secondroute;

                                          sharedData.verify();

                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Verify Me',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'IstokWeb',
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CaptureId extends StatefulWidget {
  const CaptureId({super.key});

  @override
  CaptureIdState createState() => CaptureIdState();
}

class CaptureIdState extends State<CaptureId> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    return _controller!.initialize();
  }

  @override
  void dispose() {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded,
              color: Colors.white, size: 40),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(' ',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'IstokWeb',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(07, 30, 51, 1),
        toolbarHeight: 90,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (_controller != null && _controller!.value.isInitialized)
                  CameraPreview(_controller!)
                else
                  const Center(child: CircularProgressIndicator()),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: 370,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 60,
                      child: FloatingActionButton(
                        child: const Icon(Icons.camera,
                            color: Color.fromRGBO(07, 30, 51, 1)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UploadId()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ChooseId extends StatelessWidget {
  const ChooseId({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded,
              color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Select IDs',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'IstokWeb',
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(07, 30, 51, 1),
        toolbarHeight: 90,
      ),
      backgroundColor: const Color.fromRGBO(234, 234, 234, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Choose available discount IDs to apply discounts!',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'IstokWeb',
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(07, 30, 51, 1),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: const Color.fromRGBO(07, 30, 51, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: ListTile(
                leading: SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset('assets/images/student.png'),
                ),
                title: const Text('Student',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IstokWeb',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  Provider.of<SharedData>(context, listen: false).idText =
                      'Student';
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CaptureId()),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color.fromRGBO(07, 30, 51, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: ListTile(
                leading: SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset('assets/images/senior.png'),
                ),
                title: const Text('Senior',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IstokWeb',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  Provider.of<SharedData>(context, listen: false).idText =
                      'Senior';
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CaptureId()),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color.fromRGBO(07, 30, 51, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: ListTile(
                leading: SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset('assets/images/pwd.png'),
                ),
                title: const Text('PWDs',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IstokWeb',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  Provider.of<SharedData>(context, listen: false).idText =
                      'PWD';
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CaptureId()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadId extends StatelessWidget {
  const UploadId({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[
                          Color(0xFF073051),
                          Color(0xFF2B6DA3),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Upload Successful!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IstokWeb',
                        color: Color.fromRGBO(07, 30, 51, 1)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Waiting for Verification\nThank you for choosing Beepney!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IstokWeb',
                        color: Color.fromRGBO(07, 30, 51, 1)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5)
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DashBoard(initialIndex: 4),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text(
                        'FINISH',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IstokWeb',
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
