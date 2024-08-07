package br.dev.arthurfernandes.module.travel.entry.component

import androidx.compose.foundation.layout.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import br.dev.arthurfernandes.module.travel.core.domain.TravelDay
import br.dev.arthurfernandes.module.travel.core.domain.TravelExpense
import br.dev.arthurfernandes.piper.card.Cards
import br.dev.arthurfernandes.piper.card.HighlightCard
import br.dev.arthurfernandes.piper.card.HighlightCardVariant
import br.dev.arthurfernandes.piper.card.ResultCard
import br.dev.arthurfernandes.piper.theme.tutu.TutuTheme
import br.dev.arthurfernandes.primitive.Money
import br.dev.arthurfernandes.primitive.Money.Companion.sumOf
import br.dev.arthurfernandes.primitive.Money.Companion.toMoney
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant

enum class TravelDaySummaryVariant(val cardVariant: HighlightCardVariant) {
    MULTIPLE(HighlightCardVariant.NORMAL),
    SINGLE(HighlightCardVariant.INVERTED)
}

@Composable
fun TravelDaySummary(days: List<TravelDay>, variant: TravelDaySummaryVariant = TravelDaySummaryVariant.MULTIPLE) {
    val budget = days.sumOf { it.budget }
    val spent = days.sumOf { it.expenses.sumOf { expense -> expense.amount } }
    val diff = budget - spent

    Column {
        Cards {
            card {
                HighlightCard(title = "Planejado", subject = budget.toReal(), variant.cardVariant)
            }

            card {
                HighlightCard(title = "Gasto", subject = spent.toReal(), variant.cardVariant)
            }
        }


        Row(Modifier.fillMaxWidth().padding(top = 10.dp)) {
            Column {
                ResultCard(title = "Saldo:  ", subject = diff.toReal(), diff.color)
            }
        }
    }
}

val PREVIEW_DAYS = listOf(
    TravelDay(
        id = "id 1",
        date = Clock.System.now(),
        budget = 1000.toMoney(),
        expenses = listOf(
            TravelExpense(id = "1", description = "Teste", amount = 500.toMoney()),
        )
    ),
    TravelDay(
        id = "id 2",
        date = Clock.System.now(),
        budget = 1000.toMoney(),
        expenses = listOf()
    )
)


@Preview
@Composable
fun TravelDaySummaryPreview() {
    TutuTheme {
        TravelDaySummary(PREVIEW_DAYS)
    }
}