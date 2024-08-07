package br.dev.arthurfernandes.module.travel.entry

import androidx.compose.runtime.MutableState
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.composable
import br.dev.arthurfernandes.infrastructure.di.Dependencies
import br.dev.arthurfernandes.module.travel.entry.view.TravelDayViewModel
import br.dev.arthurfernandes.module.travel.entry.view.TravelView
import br.dev.arthurfernandes.piper.route.NAME
import br.dev.arthurfernandes.piper.route.Route


object Travel {
    object Routes {
        object Home : Route
        object TravelDay : Route {
            const val NAME = "TravelDay/{id}"
            fun create(id: String) = "TravelDay/$id"
        }
    }
}

fun NavGraphBuilder.travelRoutes(title: MutableState<String>, controller: NavController) {
    composable(Travel.Routes.Home.NAME) { TravelView(title = title, service = Dependencies.travelService) {  controller.navigate(Travel.Routes.TravelDay.create(it)) } }

    composable(Travel.Routes.TravelDay.NAME) { nav ->
        TravelDayViewModel.View(title = title, id = nav.arguments?.getString("id") ?: "0", view = TravelDayViewModel(Dependencies.travelService))
    }
}
