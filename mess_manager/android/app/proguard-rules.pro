# Play Core / Play Billing (in_app_purchase) — reflection-based deferred component APIs.
-keep class com.android.billingclient.** { *; }
-keep class com.google.android.play.core.** { *; }

# Google Sign-In / Play Services Auth (google_sign_in, Drive OAuth).
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }

# flutter_local_notifications — official rule, uses reflection for scheduled receivers.
-keep class com.dexterous.** { *; }

# workmanager — background task dispatch relies on reflection to reach the
# registered Dart callback handle.
-keep class be.tramckrijte.workmanager.** { *; }
-keep class androidx.work.** { *; }

# sqlite3_flutter_libs / drift — native JNI bindings.
-keep class io.requery.android.database.sqlite.** { *; }

# local_auth — biometric prompt callbacks.
-keep class androidx.biometric.** { *; }

# googleapis (Drive API) parses JSON via dart:convert only; no native reflection.
