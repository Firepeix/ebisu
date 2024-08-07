package br.dev.arthurfernandes.corroutine

import androidx.compose.runtime.MutableState
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

object CorroutineScopeExtension {
    fun CoroutineScope.launchLoading(state: MutableState<Boolean>, block: suspend () -> Unit) {
        state.value = true

        launch {
            block()
            state.value = false
        }
    }
}