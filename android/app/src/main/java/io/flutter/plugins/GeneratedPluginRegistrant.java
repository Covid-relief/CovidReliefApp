package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
    flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin());
    flutterEngine.getPlugins().add(new com.mr.flutter.plugin.filepicker.FilePickerPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.firebaseanalytics.FirebaseAnalyticsPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.firebaseauth.FirebaseAuthPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.core.FirebaseCorePlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.database.FirebaseDatabasePlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.storage.FirebaseStoragePlugin());
    flutterEngine.getPlugins().add(new com.sidlatau.flutterdocumentpicker.FlutterDocumentPickerPlugin());
    flutterEngine.getPlugins().add(new vn.hunghd.flutterdownloader.FlutterDownloaderPlugin());
      com.roughike.facebooklogin.facebooklogin.FacebookLoginPlugin.registerWith(shimPluginRegistry.registrarFor("com.roughike.facebooklogin.facebooklogin.FacebookLoginPlugin"));
      infozenplus.com.flutter_open_whatsapp.FlutterOpenWhatsappPlugin.registerWith(shimPluginRegistry.registrarFor("infozenplus.com.flutter_open_whatsapp.FlutterOpenWhatsappPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin());
      pt.tribeiro.flutter_plugin_pdf_viewer.FlutterPluginPdfViewerPlugin.registerWith(shimPluginRegistry.registrarFor("pt.tribeiro.flutter_plugin_pdf_viewer.FlutterPluginPdfViewerPlugin"));
    flutterEngine.getPlugins().add(new com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.googlesignin.GoogleSignInPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.imagepicker.ImagePickerPlugin());
    flutterEngine.getPlugins().add(new com.lyokone.location.LocationPlugin());
      com.pkmnapps.nearby_connections.NearbyConnectionsPlugin.registerWith(shimPluginRegistry.registrarFor("com.pkmnapps.nearby_connections.NearbyConnectionsPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
    flutterEngine.getPlugins().add(new com.baseflow.permissionhandler.PermissionHandlerPlugin());
    flutterEngine.getPlugins().add(new com.tekartik.sqflite.SqflitePlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.urllauncher.UrlLauncherPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.videoplayer.VideoPlayerPlugin());
    flutterEngine.getPlugins().add(new creativecreatorormaybenot.wakelock.WakelockPlugin());
  }
}
