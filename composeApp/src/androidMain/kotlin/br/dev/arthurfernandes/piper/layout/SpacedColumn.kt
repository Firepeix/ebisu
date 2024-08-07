package br.dev.arthurfernandes.piper.layout

import android.annotation.SuppressLint
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun SpacedColumn(@SuppressLint("ModifierParameter") modifier: Modifier = Modifier.padding(20.dp), block: @Composable ColumnScope.() -> Unit) {
    Column(modifier) {
        block()
    }
}