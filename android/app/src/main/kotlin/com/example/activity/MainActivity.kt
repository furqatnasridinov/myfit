package com.example.activity

import io.flutter.embedding.android.FlutterActivity
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MapKitFactory.setApiKey("e00661b4-ef69-4150-8589-8c8a600941f6") 
    super.configureFlutterEngine(flutterEngine)
  }
}
