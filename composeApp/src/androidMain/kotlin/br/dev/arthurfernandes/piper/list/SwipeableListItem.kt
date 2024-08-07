package br.dev.arthurfernandes.piper.list

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import br.dev.arthurfernandes.piper.divider.SimpleDivider
import br.dev.arthurfernandes.piper.theme.tutu.TutuTheme
import br.dev.arthurfernandes.piper.theme.tutu.greyBorder

private fun Modifier.row(onClick: (() -> Unit)?): Modifier {
    val base = this
        .fillMaxWidth()
        .padding(horizontal = 20.dp, vertical = 10.dp)
    if (onClick == null) {
        return base
    }

    return base.clickable { onClick.invoke() }
}

@Composable
fun SwipeableListItem(title: String, subject: String, value: String? = null, onClick: (() -> Unit)? = null, onSwipe: () -> Unit) {
    val dragState = rememberSwipeToDismissBoxState()

    Column(Modifier.background(color = Color.White).fillMaxWidth()) {
        SwipeToDismissBox(state = dragState,
            enableDismissFromStartToEnd = false,
            backgroundContent = { Box(Modifier.background(color = MaterialTheme.colorScheme.error).fillMaxSize()) {} },
            content = {
                Column(Modifier.background(color = Color.White).fillMaxWidth()) {
                    ListItem(title = title, subject = subject, value, onClick)
                }
            }
        )
    }
    
    if (dragState.currentValue == SwipeToDismissBoxValue.EndToStart) {
        LaunchedEffect(dragState) {
            onSwipe.invoke()
        }
    }
}


@Preview(backgroundColor = 0xFFF8F8F8, showBackground = true)
@Composable
private fun SwipeableListItemPreview() {
    TutuTheme {
       Column {
           Column {
               SwipeableListItem("Title 1", "lorem ipsum") {
                   println("Nada")
               }
           }
       }
    }
}