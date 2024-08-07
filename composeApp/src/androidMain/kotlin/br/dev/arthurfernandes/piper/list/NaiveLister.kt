package br.dev.arthurfernandes.piper.list

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.HorizontalDivider
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import br.dev.arthurfernandes.piper.divider.SimpleDivider

@Composable
fun <T> NaiveList(items: List<T>, template: @Composable (T) -> Unit) {
    Column(Modifier.verticalScroll(rememberScrollState())) {
        items.forEach { template(it) }
        SimpleDivider()
    }
}


@Preview(backgroundColor = 0xFFF8F8F8, showBackground = true)
@Composable
private fun NaiveListPreview() {
    NaiveList(listOf("Teste 1", "Teste 2", "Teste 3", "Teste 4", "Teste 5", "Teste 6")) {
        ListItem(it.split(" ")[0], subject = it.split(" ")[1], "Oia")
    }
}