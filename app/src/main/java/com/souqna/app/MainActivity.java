package com.souqna.app;

import android.Manifest;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebChromeClient;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.firebase.messaging.FirebaseMessaging;

public class MainActivity extends AppCompatActivity {
    private static final String CHANNEL_ID = "souqna_orders";
    private WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        createNotificationChannel();

        webView = new WebView(this);
        setContentView(webView);

        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setAllowFileAccess(true);
        settings.setAllowContentAccess(true);

        // Enable JavaScript alert(), confirm(), and prompt() dialogs used by the
        // product edit/delete buttons in the Souqna WebView UI.
        webView.setWebChromeClient(new WebChromeClient());
        webView.addJavascriptInterface(new SouqnaBridge(this), "SouqnaAndroid");
        webView.loadUrl("file:///android_asset/index.html");

        if (Build.VERSION.SDK_INT >= 33 &&
                ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS)
                        != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                    this,
                    new String[]{Manifest.permission.POST_NOTIFICATIONS},
                    1001
            );
        }

        FirebaseMessaging.getInstance().getToken()
                .addOnSuccessListener(token ->
                        getSharedPreferences("souqna", MODE_PRIVATE)
                                .edit().putString("fcm_token", token).apply());
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    CHANNEL_ID,
                    "إشعارات طلبات سوقنا",
                    NotificationManager.IMPORTANCE_HIGH
            );
            channel.setDescription("إشعارات الطلبات الجديدة");
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(channel);
        }
    }

    public static class SouqnaBridge {
        private final Context context;

        SouqnaBridge(Context context) {
            this.context = context;
        }

        @JavascriptInterface
        public String getFcmToken() {
            return context.getSharedPreferences("souqna", Context.MODE_PRIVATE)
                    .getString("fcm_token", "");
        }
    }
}
