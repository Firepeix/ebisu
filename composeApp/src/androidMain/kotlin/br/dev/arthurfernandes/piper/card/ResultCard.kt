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
import br.dev.arthurfernandes.piper.layout.SpacedColumn
import br.dev.arthurfernandes.piper.theme.tutu.TutuTheme
import br.dev.arthurfernandes.piper.theme.tutu.greyBorder
import br.dev.arthurfernandes.primitive.Money.Companion.toMoney


@Composable
fun ResultCard(title: String, subject: String, subjectColor: Color = Color.Unspecified) {
    Card(Modifier.fillMaxWidth(), shape = RoundedCornerShape(2.dp), colors = CardDefaults.cardColors(containerColor = Color.White), border = BorderStroke(1.dp, greyBorder)
    ) {
        Row(Modifier.fillMaxWidth().padding(vertical = 8.dp), horizontalArrangement = Arrangement.Center) {
            Text(text = title, fontWeight = FontWeight.Bold, fontSize = 22.sp)
            Text(text = subject, fontWeight = FontWeight.Bold, fontSize = 22.sp, color = subjectColor)
        }
    }
}

@Preview
@Composable
fun ResultCardPreview() {
    TutuTheme {
        Column {
            SpacedColumn { ResultCard("Saldo:  ", 325000.toMoney().toReal(), 325000.toMoney().color) }
            SpacedColumn { ResultCard("Saldo:  ", 0.toMoney().toReal(), 0.toMoney().color)}
            SpacedColumn { ResultCard("Saldo:  ", 325000.toMoney().toReal(), (-325000).toMoney().color)}
        }
    }
}