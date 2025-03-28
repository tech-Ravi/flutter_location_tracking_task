package com.example.flutter_app_task_enterslice

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.database.Cursor
import android.os.Build
import android.os.Bundle
import androidx.core.content.ContextCompat

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.flutter_app_task_enterslice/location"
    private lateinit var dbHelper: LocationDatabaseHelper
    
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        dbHelper = LocationDatabaseHelper(applicationContext)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startLocationService" -> {
                    startLocationService()
                    result.success(true)
                }
                "getLastLocation" -> {
                    val location = getLastLocationFromDb()
                    result.success(location)
                }
                "getLocationHistory" -> {
                    val locations = getLocationHistoryFromDb()
                    result.success(locations)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (checkLocationPermissions()) {
            startLocationService()
        }
    }


    //to check location permission
    private fun checkLocationPermissions(): Boolean {
        val fineLocationPermission = ContextCompat.checkSelfPermission(
            this,
            android.Manifest.permission.ACCESS_FINE_LOCATION
        )
        val coarseLocationPermission = ContextCompat.checkSelfPermission(
            this,
            android.Manifest.permission.ACCESS_COARSE_LOCATION
        )
        
        return fineLocationPermission == android.content.pm.PackageManager.PERMISSION_GRANTED || 
               coarseLocationPermission == android.content.pm.PackageManager.PERMISSION_GRANTED
    }


    //to start Location service
    private fun startLocationService() {
        val serviceIntent = Intent(this, LocationService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }


    //location databse
    private fun getLastLocationFromDb(): Map<String, Any?> {
        val db = dbHelper.readableDatabase
        val cursor: Cursor = db.query(
            "location_table",  //Table name
            arrayOf("id", "latitude", "longitude", "timestamp"),
            null, null, null, null,
            "timestamp DESC",
            "1"
        )
        
        val locationMap = mutableMapOf<String, Any?>()
        
        if (cursor.moveToFirst()) {
            val idIndex = cursor.getColumnIndex("id")
            val latIndex = cursor.getColumnIndex("latitude")
            val lngIndex = cursor.getColumnIndex("longitude")
            val timeIndex = cursor.getColumnIndex("timestamp")
            
            if (idIndex >= 0 && latIndex >= 0 && lngIndex >= 0 && timeIndex >= 0) {
                locationMap["id"] = cursor.getLong(idIndex)
                locationMap["latitude"] = cursor.getDouble(latIndex)
                locationMap["longitude"] = cursor.getDouble(lngIndex)
                locationMap["timestamp"] = cursor.getLong(timeIndex)
            }
        }
        
        cursor.close()
        return locationMap
    }



    //fetch all location history
    private fun getLocationHistoryFromDb(): List<Map<String, Any?>> {
        val db = dbHelper.readableDatabase
        val cursor: Cursor = db.query(
            "location_table", //Table name
            arrayOf("id", "latitude", "longitude", "timestamp"),
            null, null, null, null,
            "timestamp DESC",
            "100"
        )
        
        val locationsList = mutableListOf<Map<String, Any?>>()
        
        while (cursor.moveToNext()) {
            val locationMap = mutableMapOf<String, Any?>()
            
            val idIndex = cursor.getColumnIndex("id")
            val latIndex = cursor.getColumnIndex("latitude")
            val lngIndex = cursor.getColumnIndex("longitude")
            val timeIndex = cursor.getColumnIndex("timestamp")
            
            if (idIndex >= 0 && latIndex >= 0 && lngIndex >= 0 && timeIndex >= 0) {
                locationMap["id"] = cursor.getLong(idIndex)
                locationMap["latitude"] = cursor.getDouble(latIndex)
                locationMap["longitude"] = cursor.getDouble(lngIndex)
                locationMap["timestamp"] = cursor.getLong(timeIndex)
                locationsList.add(locationMap)
            }
        }
        
        cursor.close()
        return locationsList
    }
}
