package com.tutufernandes.ebisu;

import android.os.Bundle;

import com.newrelic.agent.android.NewRelic;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    protected void onCreate(Bundle savedInstanceState) {
        NewRelic.withApplicationToken("AA7ae7e54106b9b036d6effc0ec5a6a45956c59d32-NRMA")
                .start(this.getApplication());
        super.onCreate(savedInstanceState);
    }
}
