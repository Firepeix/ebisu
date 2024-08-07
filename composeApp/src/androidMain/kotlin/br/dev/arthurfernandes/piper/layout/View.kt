package br.dev.arthurfernandes.piper.layout

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.ui.tooling.preview.Preview


import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import br.dev.arthurfernandes.infrastructure.di.Dependencies
import br.dev.arthurfernandes.module.travel.core.gateway.TravelGateway
import br.dev.arthurfernandes.module.travel.core.service.TravelService
import br.dev.arthurfernandes.module.travel.core.usecase.GetTravelDaysUseCase
import br.dev.arthurfernandes.module.travel.entry.component.PREVIEW_DAYS
import br.dev.arthurfernandes.module.travel.entry.view.TravelView
import br.dev.arthurfernandes.piper.theme.tutu.TutuTheme

@Composable
fun View(block: @Composable () -> Unit) {
    Column(Modifier.padding(vertical = 10.dp, horizontal = 15.dp)) {
        block()
    }
}


@Preview
@Composable
fun ViewPreview() {
    val title = rememberSaveable { mutableStateOf("Ebisu") }
    val gateway = object : TravelGateway {
        override suspend fun getTravelDays() = Result.success(PREVIEW_DAYS)
    }

    TutuTheme {
        Scaffold(topBar = { Header(title.value) }, containerColor = MaterialTheme.colorScheme.surface) { padding ->
            Column(Modifier.padding(padding)) {
                TravelView(title, TravelService(GetTravelDaysUseCase(gateway))) {}
            }
        }
    }
}