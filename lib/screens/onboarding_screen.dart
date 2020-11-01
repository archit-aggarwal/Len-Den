import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'homepage_screen.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset(
        'images/$assetName',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fitWidth,
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      pageColor: Colors.black87,
      imagePadding: EdgeInsets.only(top: 40),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Individual Payments",
          body:
              "Manage your payment transactions with people among your phones' "
              "contact list and save details on Cloud (Google Firestore)",
          image: _buildImage('Individual Payments in Phone.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Authentication & QR Code Scan",
          body: "Login/SignUp using 100% trusted Google Firebase Authentication"
              " Service. Scan QR Code and open theURL directly from the app",
          image: _buildImage('History Screeen in Phone.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Group Payments",
          body: "Form and Manage Groups from your contacts and plan or resolve "
              "Travel expenses or daily business expenses",
          image: _buildImage('Group Payments in Phone.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Minimize Cash Flow",
          body: "Don't worry if your group has lot of payment transactions in"
              " chains or loops. We will resolve them to minimum cash flow "
              "so that you get rid of unnecessary extra payments.",
          image: _buildImage('Minimize Cash Flow.jpg'),
          footer: RaisedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'Read Again',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Get Started Now",
          body: "Len Den made Simple Now from your Phone. Manage your "
              "business from your pocket. Press Done to Len - Den",
          image: _buildImage('Group Transactions in Phone.jpeg'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
