import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.rememberNavController
import br.dev.arthurfernandes.infrastructure.di.Dependencies
import br.dev.arthurfernandes.module.travel.entry.Travel
import br.dev.arthurfernandes.module.travel.entry.travelRoutes
import br.dev.arthurfernandes.module.travel.entry.view.TravelView
import br.dev.arthurfernandes.piper.layout.Header
import br.dev.arthurfernandes.piper.route.NAME
import br.dev.arthurfernandes.piper.route.Route
import br.dev.arthurfernandes.piper.theme.tutu.TutuTheme
import br.dev.arthurfernandes.piper.theme.wewe.WeweTheme
import org.jetbrains.compose.resources.painterResource

@Composable
fun App(homePage: String = Travel.Routes.Home.NAME) {
    val title = rememberSaveable { mutableStateOf("Ebisu") }
    val controller = rememberNavController()

    TutuTheme {
        Scaffold(topBar = { Header(title.value) }, containerColor = MaterialTheme.colorScheme.surface) { padding ->
            Column(Modifier.padding(padding)) {
                NavHost(controller, startDestination = homePage) {
                    travelRoutes(title, controller)
                }
            }
        }
    }
}

@Preview
@Composable
private fun AppPreview() {
    App()
}