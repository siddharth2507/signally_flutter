import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'package:signalbyt/pages/group_chat/chat_provider.dart';
import 'package:signalbyt/utils/ironsourceutils.dart';
import 'package:signalbyt/utils/unityadsmediation.dart';
import 'package:signalbyt/utils/unityadsutils.dart';

import 'constants/app_constants.dart';
import 'models_providers/app_provider.dart';
import 'models_providers/app_controls_provider.dart';
import 'models_providers/auth_provider.dart';
import 'models_providers/navbar_provider.dart';
import 'models_providers/theme_provider.dart';
import 'models_services/firebase_notification_service.dart';
import 'models_services/revenuecat_service.dart';
import 'pages/_app/splash_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await dotenv.load(fileName: ".env");

  HttpOverrides.global = new MyHttpOverrides();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF141518),
      systemNavigationBarIconBrightness: Brightness.light));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  ThemeMode themeMode = await Themes.getThemeModeHive();

  await Firebase.initializeApp();

  FirebaseNotificationService.init();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await RevenueCatSevice.init();
  await initTrackingTransparency();
  // UnityAdsUtils.initUnityMediation();
  UnityAdsServices.initUnityads();
  // IronsourceUtils.initIronsource();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('es'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: Locale('en'),
      useOnlyLangCode: true,
      child: ChangeNotifierProvider(
          create: (_) => ThemeProvider(themeMode), child: const MyApp()),
    ),
  );
}

Future<void> initTrackingTransparency() async {
  try {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      var _authStatus =
          await AppTrackingTransparency.requestTrackingAuthorization();
    }
  } on PlatformException {}

  final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  print("UUID:" + uuid);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    Themes.setStatusNavigationBarColor();
    super.didChangeDependencies();
  }

  @override
  void didChangePlatformBrightness() {
    Themes.setStatusNavigationBarColor();
    super.didChangePlatformBrightness();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    Themes.setStatusNavigationBarColor();
    super.didChangeAppLifecycleState(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavbarProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(
            create: (context) => ChatProvider(
                  firebaseFirestore: this.firebaseFirestore,
                  firebaseStorage: this.firebaseStorage,
                )),
        ChangeNotifierProxyProvider<AuthProvider, AppProvider>(
            create: (context) => AppProvider(),
            update: (_, authProvider, prev) =>
                prev!..authProvider = authProvider),
        ChangeNotifierProxyProvider<AuthProvider, AppControlsProvider>(
            create: (context) => AppControlsProvider(),
            update: (_, authProvider, prev) =>
                prev!..authProvider = authProvider),
        /*Provider<ChatProvider>(
          create: (_) => ChatProvider(
            firebaseFirestore: this.firebaseFirestore,
            firebaseStorage: this.firebaseStorage,
          ),
        ),*/
      ],
      child: GetMaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: AppConstants.APP_NAME,
        theme: Themes.light(),
        darkTheme: Themes.dark(),
        themeMode: themeProvider.themeMode,
        home: SplashPage(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
