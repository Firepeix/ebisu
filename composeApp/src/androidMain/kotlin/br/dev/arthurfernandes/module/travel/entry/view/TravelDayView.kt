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
import br.dev.arthurfernandes.module.travel.core.domain.TravelExpense
import br.dev.arthurfernandes.module.travel.core.gateway.TravelGateway
import br.dev.arthurfernandes.module.travel.core.service.TravelService
import br.dev.arthurfernandes.module.travel.core.usecase.GetTravelDaysUseCase
import br.dev.arthurfernandes.module.travel.entry.component.PREVIEW_DAYS
import br.dev.arthurfernandes.module.travel.entry.component.TravelDaySummary
import br.dev.arthurfernandes.module.travel.entry.component.TravelDaySummaryVariant
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

class TravelDayViewModel(private val service: TravelService) {
    var day by mutableStateOf<TravelDay?>(null)
    val isLoading = mutableStateOf(false)

    fun setDay(scope: CoroutineScope) {
        scope.launchLoading(isLoading) {
            day = service.getTravelDay("id").fold(onSuccess = { it }, onFailure = { null })
        }
    }

    companion object {
        @Composable
        fun View(title: MutableState<String>, id: String, view: TravelDayViewModel) {
            val scope = rememberCoroutineScope()
            val model = remember { view }

            title.value = id

            LifecycleEventEffect(event = Lifecycle.Event.ON_START, onEvent = { model.setDay(scope) })

            Column {
                RefreshableView(isRefreshing = model.isLoading.value, onRefresh = { model.setDay(scope) }) {
                    Column {
                        TravelDaySummary(model.day?.let { listOf(it) } ?: emptyList(), TravelDaySummaryVariant.SINGLE)
                        Divider()
                    }
                }

                NaiveList(items = model.day?.expenses ?: emptyList()) { expense ->
                    SwipeableListItem(
                        title = expense.description,
                        subject = expense.amount.toReal(),
                        onSwipe = { println("Foi ${expense.id}") }
                    )
                }
            }
        }
    }
}




@Preview(backgroundColor = 0xFFF8F8F8, showBackground = true)
@Composable
private fun TravelDayViewPreview() {
    val title = remember { mutableStateOf("") }
    val gateway = object : TravelGateway {
        override suspend fun getTravelDays() = Result.success(PREVIEW_DAYS)
    }


    TutuTheme {
        TravelDayViewModel.View(title, "1", TravelDayViewModel(TravelService(GetTravelDaysUseCase(gateway))))
    }
}