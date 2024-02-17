package es.antonborri.home_widget_counter

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider

class CounterWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray,
            widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.counter_widget).apply {
                
                val title = widgetData.getString("author", null)
                setTextViewText(R.id.author, title ?: "No title set")

                val description = widgetData.getString("quote", null)
                setTextViewText(R.id.quote, description ?: "No description set")

                val incrementIntent = HomeWidgetBackgroundIntent.getBroadcast(
                        context,
                        Uri.parse("homeWidgetCounter://increment")
                )
                val clearIntent = HomeWidgetBackgroundIntent.getBroadcast(
                        context,
                        Uri.parse("homeWidgetCounter://clear")
                )

                setOnClickPendingIntent(R.id.button_increment, incrementIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}