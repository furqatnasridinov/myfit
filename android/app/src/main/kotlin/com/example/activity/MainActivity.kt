package com.example.activity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
      try{
          MapKitFactory.setApiKey("523fed12-dd4d-4253-91a7-2585ae0b8b27") 
      }catch(e: AssertionError){}
      GeneratedPluginRegistrant.registerWith(flutterEngine)
  }
}