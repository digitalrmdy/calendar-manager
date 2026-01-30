package be.rmdy.calendar_manager

import android.app.Activity
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener

interface BindingDelegate {
    fun removeRequestPermissionsResultListener(listener: RequestPermissionsResultListener)
    fun addRequestPermissionsResultListener(listener: RequestPermissionsResultListener)
    val activity: Activity?

    companion object {
        fun activityPluginBinding(activityPluginBinding: ActivityPluginBinding): BindingDelegate = ActivityBindingDelegate(activityPluginBinding)
    }
}

class ActivityBindingDelegate(private val activityPluginBinding: ActivityPluginBinding) : BindingDelegate {
    override val activity: Activity
        get() = activityPluginBinding.activity

    override fun removeRequestPermissionsResultListener(listener: RequestPermissionsResultListener) {
        activityPluginBinding.removeRequestPermissionsResultListener(listener)
    }

    override fun addRequestPermissionsResultListener(listener: RequestPermissionsResultListener) {
        activityPluginBinding.addRequestPermissionsResultListener(listener)
    }

}