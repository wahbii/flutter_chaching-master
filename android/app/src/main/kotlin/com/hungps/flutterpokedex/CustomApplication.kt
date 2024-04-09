package com.hungps.flutterpokedex

import android.app.Application
import androidx.multidex.MultiDex



class CustomApplication :  Application() {
    override fun onCreate() {
        super.onCreate()
        MultiDex.install(this)
    }
}