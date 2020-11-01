[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/archit-aggarwal/len-den">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Len Den</h3>

  <p align="center">
    Minimize Cash Flow Algorithm
    <br />
    <a href="https://github.com/archit-aggarwal/len-den"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/archit-aggarwal/len-den/issues">Report Bug</a>
    ·
    <a href="https://github.com/archit-aggarwal/len-den/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
## Table of Contents

- [Table of Contents](#table-of-contents)
- [About The Project](#about-the-project)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
- [Hide Generated Files](#hide-generated-files)
- [Roadmap for Usage](#roadmap-for-usage)
- [Contributing](#contributing)
- [License](#license)
- [Connect with Me](#connect-with-me)
- [Acknowledgements](#acknowledgements)



<!-- ABOUT THE PROJECT -->
## About The Project

A cross-platform application built using **Flutter** SDK and **Dart** Object Oriented Programming language, using **Firebase Authentication** and **Cloud Firestore**.


### Built With

* [Dart](https://dart.dev/)
* [Flutter](https://flutter.dev/)
* [FlutterFire](https://firebase.flutter.dev/docs/firestore/usage/)
  * [Firebase Authentication](https://firebase.google.com/products/auth)
  * [Cloud Firestore](https://firebase.google.com/products/firestore)
* [Dart Plugins](https://pub.dev/)



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/archit-aggarwal/Len-Den.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

Get Package Dependencies downloaded for you from 3rd party plugins by writing the command in your terminal:

```
flutter --no-color packages get
```


## Hide Generated Files

In-order to hide generated files, navigate to `Android Studio` -> `Preferences` -> `Editor` -> `File Types` and paste the below lines under `ignore files and folders` section:

```
*.inject.summary;*.inject.dart;*.g.dart;
```

In Visual Studio Code, navigate to `Preferences` -> `Settings` and search for `Files:Exclude`. Add the following patterns:
```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart
```



<!-- USAGE EXAMPLES -->
# Roadmap for Usage

Len Den is a payments transaction manager application built for Android, _iOS and Web_*. It uses Google's Firebase as back-end for models and user's dataset. Firebase is used for storing data on Cloud Firestore and Firebase Authentication. 

## Individual Payments
Manage your payment transactions with people among your phones contact list and save details on Cloud (Google Firestore) for future reference.

![Individual Payment Screen](https://raw.githubusercontent.com/archit-aggarwal/Len-Den/master/images/Individual%20Payments%20in%20Phone.jpg)

## Authentication & QR Code Scan
Login/SignUp using 100% trusted Google Firebase Authentication Service. Scan QR Code and open theURL directly from the app

![History Screen](https://raw.githubusercontent.com/archit-aggarwal/Len-Den/master/images/History%20Screeen%20in%20Phone.jpeg)

## Group Payments
Form and Manage Groups from your contacts and plan or resolve travel expenses or daily business expenses

![Group Payments Screen](https://raw.githubusercontent.com/archit-aggarwal/Len-Den/master/images/Group%20Payments%20in%20Phone.jpeg)

![Group Transactions Screen](https://raw.githubusercontent.com/archit-aggarwal/Len-Den/master/images/Group%20Transactions%20in%20Phone.jpeg)

## Minimize Cash Flow Algorithm
Don't worry if your group has lot of payment transactions in chains or loops. We will resolve them to minimum cash flow so that you get rid of unnecessary extra payments.

![Minimize Cash Flow](https://raw.githubusercontent.com/archit-aggarwal/Len-Den/master/images/Minimize%20Cash%20Flow.jpg)

If you want to know more about the Minimize Cash flow Algorithm, refer to the following link :
[Geeks for Geeks](https://www.geeksforgeeks.org/minimize-cash-flow-among-given-set-friends-borrowed-money/)


## Features Planned for Future
* ```//TODO: Add Overall Payments History Screen```
* ```//TODO: Add Payment Reminder + Link generation```
* ```//TODO: Add PDF Generation for Report```
* ```//TODO: Add Authentication using Google Account & SMS (Phone)```
* ```//TODO: Add Social Authentication using Facebook , Github & Twitter```
* ```//TODO: Add Use of Google People API for Google Contacts```
* ```//TODO: Add full-fledged Support for Web & iOS```
* ```//TODO: Add Animations for Loading & Navigation```
* ```//TODO: Deployment on Play Store & App Store```

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Connect with Me

Archit Aggarwal

_Delhi Technological University_

_Computer Science Sophomore_

<br />

* [<img align="left" alt="codeSTACKr | LinkedIn" width="22px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/linkedin.svg" />][linkedin]   
  
<br />

* [<img align="left" alt="codeSTACKr | Twitter" width="22px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/twitter.svg" />][twitter]

<br />

* [<img align="left" alt="codeSTACKr | Instagram" width="22px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/instagram.svg" />][instagram]

<br />

* [<img align="left" alt="codeSTACKr | Facebook" width="22px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/facebook.svg" />][facebook]

<br />

Project Link: [https://github.com/archit-aggarwal/len-den](https://github.com/archit-aggarwal/len-den)



<!-- ACKNOWLEDGEMENTS -->
# Acknowledgements
## Plugins/Packages Used
We have used some 3rd party plugins/packages on [pub.dev](https://pub.dev/) which have been mentioned below:

* [Shared Preferences](https://pub.dev/packages/shared_preferences)
* [Firebase Core](https://pub.dev/packages/firebase_core)
* [Firebase Authentication](https://pub.dev/packages/firebase_auth)
* [Cloud Firestore](https://pub.dev/packages/cloud_firestore)
* [Google Fonts](https://pub.dev/packages/google_fonts)
* [Font Awesome](https://pub.dev/packages/font_awesome)
* [Contacts Service](https://pub.dev/packages/contacts_service)
* [Permission Handler](https://pub.dev/packages/permission_handler)
* [Snake Navigation Bar](https://pub.dev/packages/flutter_snake_navigationbar)
* [Flutter Login UI](https://pub.dev/packages/flutter_login)
* [URL Launcher](https://pub.dev/packages/url_launcher)
* [QR Code Flutter](https://pub.dev/packages/qr_flutter)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/archit-aggarwal/len-den.svg?style=flat-square
[contributors-url]: https://github.com/archit-aggarwal/len-den/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/archit-aggarwal/len-den.svg?style=flat-square
[forks-url]: https://github.com/archit-aggarwal/len-den/network/members
[stars-shield]: https://img.shields.io/github/stars/archit-aggarwal/len-den.svg?style=flat-square
[stars-url]: https://github.com/archit-aggarwal/len-den/stargazers
[issues-shield]: https://img.shields.io/github/issues/archit-aggarwal/len-den.svg?style=flat-square
[issues-url]: https://github.com/archit-aggarwal/len-den/issues
[license-shield]: https://img.shields.io/github/license/archit-aggarwal/len-den.svg?style=flat-square
[license-url]: https://github.com/archit-aggarwal/len-den/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/archit-aggarwal
[product-screenshot]: images/screenshot.png

[twitter]: https://twitter.com/archit_023
[facebook]: https://www.facebook.com/architaggarwal023
[instagram]: https://www.instagram.com/architaggarwal023/
[linkedin]: https://www.linkedin.com/in/archit-aggarwal-6a7716189/
