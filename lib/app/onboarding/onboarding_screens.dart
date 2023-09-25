// ignore_for_file: prefer_const_constructors

import '../../src/repo/models/others/onboarding_screen.dart';
import '../../theme/colors.dart';

List<OnboardModel> screens = <OnboardModel>[
  OnboardModel(
    img: 'assets/images/onboarding_screen/frame-1.png',
    text: "Order from your favorite Stores",
    subtext: "and have it delivered to any address \nof your choice",
    bg: kSecondaryColor,
    button: kAccentColor,
  ),
  OnboardModel(
    img: 'assets/images/onboarding_screen/frame-2.png',
    text: "Quick and Safe \nDelivery",
    subtext: "Get your packages safely and timely \ndelivered to your location",
    bg: kSecondaryColor,
    button: kAccentColor,
  ),
  OnboardModel(
    img: 'assets/images/onboarding_screen/frame-3.png',
    text: "Explore Variety of \nProducts",
    subtext: "search for your preferred product \nbrand and specification",
    bg: kSecondaryColor,
    button: kAccentColor,
  ),
];
