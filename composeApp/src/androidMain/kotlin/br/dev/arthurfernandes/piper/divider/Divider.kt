package br.dev.arthurfernandes.piper.divider

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import br.dev.arthurfernandes.piper.theme.tutu.greyBorder

@Preview
@Composable
fun Divider() {
    HorizontalDivider(Modifier.padding(vertical = 20.dp), color = MaterialTheme.colorScheme.primary)
}

@Preview
@Composable
fun SimpleDivider() {
    HorizontalDivider(color = greyBorder)
}