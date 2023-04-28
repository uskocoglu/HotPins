import "package:firebase_analytics/firebase_analytics.dart";

FirebaseAnalytics analytics = FirebaseAnalytics.instance ;

setCurrentScreen(FirebaseAnalytics analytics, String screenName, String screenClass)  {
    analytics.setCurrentScreen(
    screenName: screenName,
    screenClassOverride: screenClass,
  );
}

