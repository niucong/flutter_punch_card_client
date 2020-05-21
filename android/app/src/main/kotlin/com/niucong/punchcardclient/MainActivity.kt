package com.niucong.punchcardclient

import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL = "punchcardclient.niucong.com/native"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { methodCall, result ->
            when (methodCall.method) {
                "toScheduleActivity" -> {
//                    val listData: String? = methodCall.argument("listData");
//                    Log.d("MainActivity", listData)
                    // 跳转到原生Activity界面
                    val intent = Intent(this@MainActivity, ScheduleActivity::class.java)
                    startActivity(intent)//.putExtra("listData", listData)
                }
                "toCalendarActivity" -> {
                    startActivity(Intent(this@MainActivity, CalendarActivity::class.java))
                }
                else -> result.notImplemented()
            }
        }
    }
}
