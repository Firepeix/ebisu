package br.dev.arthurfernandes.piper.card

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.grid.LazyHorizontalGrid
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import br.dev.arthurfernandes.piper.theme.tutu.TutuTheme

typealias InnerCard = @Composable () -> Unit

class HighlightCardsScope(val cards: MutableList<InnerCard> = mutableListOf()) {
    fun card(item: InnerCard) = cards.add(item)
}

@Composable
fun Cards(block: HighlightCardsScope.() -> Unit) {
    val scope = HighlightCardsScope().apply(block)

    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
        scope.cards.forEachIndexed() { index, card ->
            val gutter = if(index == 0) 0.01F else 0.05F
            Column(Modifier.fillMaxWidth((index.plus(1).toFloat() / scope.cards.size) - gutter)) {
                card.invoke()
            }
        }
    }
}

@Preview(backgroundColor = 0xFFF8F8F8, showBackground = true)
@Composable
private fun HighLightCardPreviewSideBySide() {
    TutuTheme {
        Column(Modifier.fillMaxWidth()) {
            Cards {
                card {
                    HighlightCard(title = "Trem", subject = "R$ 3.250,00")
                }

                card {
                    HighlightCard(title = "Gasto", subject = "R$ 3.250,00", HighlightCardVariant.INVERTED)
                }
            }
        }
    }
}