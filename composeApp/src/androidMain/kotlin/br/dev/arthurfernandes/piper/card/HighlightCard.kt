package br.dev.arthurfernandes.piper.card

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import br.dev.arthurfernandes.piper.card.Style.columnCard
import br.dev.arthurfernandes.piper.theme.tutu.TutuTheme
import br.dev.arthurfernandes.piper.theme.tutu.greyBorder

enum class HighlightCardVariant() {
    NORMAL,
    INVERTED
}

private object Style {
    fun Modifier.columnCard() = this
        .padding(vertical = 5.dp, horizontal = 8.dp)
}

val HighlightCardVariant.color: Color @Composable get() = when(this) {
    HighlightCardVariant.NORMAL -> MaterialTheme.colorScheme.primary
    HighlightCardVariant.INVERTED -> Color.White
}

val HighlightCardVariant.border: BorderStroke? @Composable get() = when(this) {
    HighlightCardVariant.NORMAL -> null
    HighlightCardVariant.INVERTED -> BorderStroke(1.dp, greyBorder)
}

@Composable
fun HighlightCard(title: String, subject: String, variant: HighlightCardVariant = HighlightCardVariant.NORMAL) {
    Column(Modifier) {
        Card(Modifier, shape = RoundedCornerShape(2.dp), colors = CardDefaults.cardColors(containerColor = variant.color), border = variant.border) {
            Column(
                Modifier
                    .columnCard()
                    .fillMaxWidth(), horizontalAlignment = Alignment.CenterHorizontally) {
                Text(text = title, fontWeight = FontWeight.Bold, fontSize = 22.sp)
                Text(text = subject, Modifier.padding(top = 2.dp), fontWeight = FontWeight.Bold, fontSize = 22.sp)
            }
        }
    }
}



@Preview(backgroundColor = 0xFFF8F8F8, showBackground = true)
@Composable
private fun HighLightCardPreview() {
    TutuTheme {
        Column {
            Column {
                HighlightCard("Teste", "R$ 3.250,00")
            }

            Column(Modifier.padding(top = 15.dp)) {
                HighlightCard("Teste", "R$ 3.250,00", variant = HighlightCardVariant.INVERTED)
            }
        }
    }
}