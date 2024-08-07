package br.dev.arthurfernandes.module.travel.entry.view

import androidx.annotation.MainThread
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.material3.pulltorefresh.PullToRefreshBox
import androidx.compose.material3.pulltorefresh.rememberPullToRefreshState
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.compose.LifecycleEventEffect
import androidx.lifecycle.viewModelScope
import br.dev.arthurfernandes.corroutine.CorroutineScopeExtension.launchLoading
import br.dev.arthurfernandes.module.travel.core.domain.TravelDay
import br.dev.arthurfernandes.module.travel.core.gateway.TravelGateway
import br.dev.arthurfernandes.module.travel.core.service.TravelService
import br.dev.arthurfernandes.module.travel.core.usecase.GetTravelDaysUseCase
import br.dev.arthurfernandes.module.travel.entry.component.PREVIEW_DAYS
import br.dev.arthurfernandes.module.travel.entry.component.TravelDaySummary
import br.dev.arthurfernandes.piper.divider.Divider
import br.dev.arthurfernandes.piper.layout.RefreshableView
import br.dev.arthurfernandes.piper.list.ListItem
import br.dev.arthurfernandes.piper.list.NaiveList
import br.dev.arthurfernandes.piper.list.SwipeableListItem
import br.dev.arthurfernandes.piper.theme.tutu.TutuTheme
import br.dev.arthurfernandes.primitive.DateExtension.toLongDescription
import br.dev.arthurfernandes.primitive.Money.Companion.sumOf
import fox.composeapp.generated.resources.Res
import fox.composeapp.generated.resources.compose_multiplatform
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.painterResource


@Composable
fun TravelView(title: MutableState<String>, service: TravelService, onDayClick: (id: String) -> Unit) {
    title.value = "Gastos de Viagens"
    val scope = rememberCoroutineScope()
    var days by rememberSaveable { mutableStateOf(emptyList<TravelDay>()) }
    val isLoading = remember { mutableStateOf(false) }
    val setDays = {
        scope.launchLoading(isLoading) {
            days = service.getTravelDays().fold(onSuccess = { it }, onFailure = { emptyList() })
        }
    }

    LifecycleEventEffect(event = Lifecycle.Event.ON_START, onEvent = setDays)

    Column {
        RefreshableView(isRefreshing = isLoading.value, onRefresh = setDays) {
            Column {
                TravelDaySummary(days)
                Divider()
            }
        }

        NaiveList(items = days) { day ->
            SwipeableListItem(
                title = day.date.toLongDescription(),
                subject = day.budget.toReal(),
                value = day.expenses.sumOf { it.amount }.toReal(),
                onClick = { onDayClick(day.id) },
                onSwipe = { println("Foi ${day.id}") }
            )
        }
    }
}

@Preview(backgroundColor = 0xFFF8F8F8, showBackground = true)
@Composable
fun TravelViewPreview() {
    val title = remember { mutableStateOf("") }
    val gateway = object : TravelGateway {
        override suspend fun getTravelDays() = Result.success(PREVIEW_DAYS)
    }


    TutuTheme {
        TravelView(title, TravelService(GetTravelDaysUseCase(gateway))) {

        }
    }
}