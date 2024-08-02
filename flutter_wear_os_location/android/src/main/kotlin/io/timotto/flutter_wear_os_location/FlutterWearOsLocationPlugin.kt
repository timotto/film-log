package io.timotto.flutter_wear_os_location

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.location.Location
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterWearOsLocationPlugin */
class FlutterWearOsLocationPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private val PERMISSION_REQUEST_CODE = 123

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var fusedLocationClient: FusedLocationProviderClient? = null
    private var activityBinding: ActivityPluginBinding? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_wear_os_location")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "getLocation" -> {
                if (ActivityCompat.checkSelfPermission(
                        activityBinding!!.activity,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                        activityBinding!!.activity,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    result.error("permission", null, null)
                    return
                }

                fusedLocationClient!!.getCurrentLocation(
                    Priority.PRIORITY_BALANCED_POWER_ACCURACY,
                    null
                ).addOnSuccessListener { location: Location? ->
                    if (location == null) {
                        result.error("null", null, null)
                    } else {
                        result.success(
                            mapOf(
                                "latitude" to location.latitude,
                                "longitude" to location.longitude,
                                "altitude" to location.altitude,
                                "accuracy" to location.accuracy,
                            )
                        )
                    }
                }.addOnFailureListener { err ->
                    result.error("failed", err.message, null)
                }
            }

            "hasGps" -> {
                val hasGps = activityBinding!!.activity
                    .packageManager
                    .hasSystemFeature(PackageManager.FEATURE_LOCATION_GPS)
                result.success(hasGps)
            }

            "ensurePermission" -> {
                ensureLocationPermission()
                result.success(true)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        setupFusedLocationClient(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding = null
        clearFusedLocationClient()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
        setupFusedLocationClient(binding.activity)
    }

    override fun onDetachedFromActivity() {
        activityBinding = null
        clearFusedLocationClient()
    }

    private fun setupFusedLocationClient(activity: Activity) {
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(activity)
    }

    private fun clearFusedLocationClient() {
        fusedLocationClient = null
    }

    private fun ensureLocationPermission() {
        if (ActivityCompat.checkSelfPermission(
                activityBinding!!.activity,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                activityBinding!!.activity,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                activityBinding!!.activity,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                PERMISSION_REQUEST_CODE
            )
        }
    }
}
