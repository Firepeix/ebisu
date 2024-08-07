package br.dev.arthurfernandes.piper.layout

import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.pulltorefresh.PullToRefreshBox
import androidx.compose.ui.tooling.preview.Preview


import androidx.compose.runtime.Composable
import br.dev.arthurfernandes.module.travel.entry.component.TravelDaySummary

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RefreshableView(isRefreshing: Boolean, onRefresh: () -> Unit, block: @Composable () -> Unit) {
    PullToRefreshBox(isRefreshing, onRefresh) {
        LazyColumn {
            item {
                View {
                    block()
                }
            }
        }
    }
}
