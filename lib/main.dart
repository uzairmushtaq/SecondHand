import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/bindings/bindings.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/splash/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  //print("Handling a background message: ${message.messageId}");
}

void main() async {
  timeago.setLocaleMessages('de', MyCustomMessages());

  Dio dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Stripe.publishableKey =
      "pk_test_51KmjD2JvwIBAKlBVwupZzW24QmmBQlNUnqTEIWEYzEYVxrYblzmBbn4ikqySMUnepVZPKhoqr5qUq7IvEHvBFHGz00NrIbuPeW";
  Stripe.merchantIdentifier = 'abrar';
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  //print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //print('Got a message whilst in the foreground!');
    //print('Message data: ${message.data}');

    if (message.notification != null) {
      //print('Message also contained a notification: ${message.notification}');
    }
  });

  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

  Locale locale;
  // await Stripe.instance.applySettings();
  runApp(MainApp(initialLink: initialLink));
}

// my_custom_messages.dart
class MyCustomMessages implements timeago.LookupMessages {
  @override String prefixAgo() => 'vor';
  @override String prefixFromNow() => '';
  @override String suffixAgo() => '';
  @override String suffixFromNow() => '';
  @override String lessThanOneMinute(int seconds) => 'jetzt';
  @override String aboutAMinute(int minutes) => '${minutes} Minute';
  @override String minutes(int minutes) => '${minutes} Minuten';
  @override String aboutAnHour(int minutes) => '${minutes} Minuten';
  @override String hours(int hours) => '${hours} Stunden';
  @override String aDay(int hours) => '${hours} Stunden';
  @override String days(int days) => '${days} Tagen';
  @override String aboutAMonth(int days) => '${days} Tagen';
  @override String months(int months) => '${months} Monaten';
  @override String aboutAYear(int year) => '${year} Jahr';
  @override String years(int years) => '${years} Jahren';
  @override String wordSeparator() => ' ';
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key, this.initialLink}) : super(key: key);
  final initialLink;

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    fetchLocale();
    if (widget.initialLink != null) {
      final Uri deepLink = widget.initialLink.link;
      //print(deepLink);
      //Navigator.pushNamed(context, deepLink.path);
    }
    super.initState();
  }

   fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('languageCode') ?? "";

    if (languageCode != "") {
      Get.updateLocale(Locale(languageCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return GetMaterialApp(
              theme: ThemeData(fontFamily: "Inter"),
              initialBinding: AuthBindings(),
              debugShowCheckedModeBanner: false,
              home: SplashPage(),
              title: "Second hand",
              locale: Get.deviceLocale,
              fallbackLocale: const Locale('en', 'US'),
              localizationsDelegates: [
                AppLocalizations.delegate, // Add this line
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('de', ''),
                Locale('en', ''),
                Locale('es', ''),
                Locale('fa', ''),
                Locale('pl', ''),
                Locale('pt', ''),
                Locale('ru', ''),
                Locale('uk', ''),
                Locale('th', ''),
                Locale('fr', ''),
                Locale('it', ''),
                Locale('he', ''),
              ],
            );
          },
        );
      },
    );
  }
}