package br.dev.arthurfernandes.piper.list

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import br.dev.arthurfernandes.piper.divider.SimpleDivider
import br.dev.arthurfernandes.piper.theme.tutu.TutuTheme
import br.dev.arthurfernandes.piper.theme.tutu.greyBorder

private fun Modifier.click(onClick: (() -> Unit)?): Modifier {
    if (onClick == null) {
        return this
    }

    return this.clickable { onClick.invoke() }
}

@Composable
fun ListItem(title: String, subject: String, value: String? = null, onClick: (() -> Unit)? = null) {
    Column(Modifier.click(onClick)) {
        SimpleDivider()

        Row(
            modifier = Modifier.fillMaxWidth().padding(horizontal = 20.dp, vertical = 10.dp),
            horizontalArrangement = Arrangement.SpaceBetween) {
            Column {
                Text(text = title, fontSize = 14.sp)
                Text(text = subject, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.tertiary)
            }

            if (value != null) {
                Column(Modifier.padding(top = 12.dp)) {
                    Text(text = value, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                }
            }
        }
    }
}


@Preview(backgroundColor = 0xFFF8F8F8, showBackground = true)
@Composable
fun ListItemPreview() {
    TutuTheme {
        Column {
            Column {
                ListItem("Title 1", "lorem ipsum")
            }

            Column {
                ListItem("Title 2", "R$ 3.022,00")
            }

            Column {
                ListItem("Title 3", "lorem ipsum damn", "R$ 3.022,00") {
                    println("tere")
                }
            }

            Column {
                ListItem("Title 4", "lorem ipsum damn", "Damn")
            }
        }
    }
}