package be.rmdy.calendar_manager

import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import be.rmdy.calendar_manager.exceptions.CalendarManagerException
import be.rmdy.calendar_manager.exceptions.NotImplementedMethodException
import be.rmdy.calendar_manager.models.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.json.Json

class CalendarManagerPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    private val delegate: CalendarManagerDelegate = CalendarManagerDelegate()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this.init(flutterPluginBinding))
    }

    private fun init(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) = apply {
        delegate.context = flutterPluginBinding.applicationContext
    }

    companion object {
        const val TAG = "CalendarManagerPlugin"
        const val CHANNEL_NAME = "rmdy.be/calendar_manager"
    }

    private fun assertMainThread() {
        check(Looper.myLooper() == Looper.getMainLooper())
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        GlobalScope.launch(context = Dispatchers.Main) {
            assertMainThread()
            sendBackResult(result, call)
        }

    }


    private suspend fun sendBackResult(result: Result, call: MethodCall) {
        try {
            var success = handleMethod(call.method, requireNotNull(call.arguments()) { "arguments = null" })
            if (success == Unit) {
                success = null
            }
            result.success(success)
        } catch (ex: CalendarManagerException) {
            result.error(ex)
        } catch (ex: NotImplementedMethodException) {
            result.notImplemented()
        } catch (ex: Exception) {
            Log.e(TAG, ex.message, ex)
            result.error(ex.toCalendarManagerException())
        }
    }

    private fun Result.error(error: CalendarManagerException) {
        error(error.code.name, error.message, error.details)
    }

    private fun Exception.toCalendarManagerException(): CalendarManagerException {
        return CalendarManagerException(ErrorCode.UNKNOWN, message, this::class)
    }

    @Suppress("UnnecessaryVariable")
    private suspend fun handleMethod(method: String, jsonArgs: Map<String, Any?>): Any? {
        println("handleMethod: $method")
        return when (method) {
            "createCalendar" -> {
                val calendar = Json.decodeFromString(CreateCalendar.serializer(), jsonArgs["calendar"] as String)
                val createdCalender = delegate.createCalendar(calendar)
                Json.encodeToString(CalendarResult.serializer(), createdCalender)
            }
            "createEvent" -> {
                val event = Json.decodeFromString(Event.serializer(), jsonArgs["event"] as String)
               val eventResult= delegate.createEvent(event)
                Json.encodeToString(EventResult.serializer(), eventResult)
            }
            "deleteAllEventsByCalendarId" -> {
                val calendarId = jsonArgs["calendarId"] as String
               val deletedEvents= delegate.deleteAllEventsByCalendarId(calendarId)
                Json.encodeToString(ListSerializer(EventResult.serializer()), deletedEvents)
            }
            "requestPermissions" -> {
                val granted: Boolean = delegate.requestPermissions()
                granted
            }
            "findAllCalendars" -> {
                val calendars = delegate.findAllCalendars()
                Json.encodeToString(ListSerializer(CalendarResult.serializer()), calendars)
            }
            "deleteCalendar" -> {
                val calendarId = jsonArgs["calendarId"] as String
                delegate.deleteCalendar(calendarId)
                null
            }
            else -> {
                throw NotImplementedMethodException()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        delegate.activity = null
    }

    override fun onDetachedFromActivity() {
        delegate.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onNewBindingDelegate(BindingDelegate.activityPluginBinding(binding))
    }

    private fun onNewBindingDelegate(binding: BindingDelegate) {
        delegate.activity = binding.activity
        binding.removeRequestPermissionsResultListener(delegate)
        binding.addRequestPermissionsResultListener(delegate)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        onNewBindingDelegate(BindingDelegate.activityPluginBinding(binding))
    }

    override fun onDetachedFromActivityForConfigChanges() {
        delegate.activity = null
    }
}
