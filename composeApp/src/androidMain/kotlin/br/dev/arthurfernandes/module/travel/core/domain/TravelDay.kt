package br.dev.arthurfernandes.module.travel.core.domain

import br.dev.arthurfernandes.primitive.Money
import kotlinx.datetime.Instant
import java.time.LocalDateTime

data class TravelDay(
    val id: String,
    val date: Instant,
    val budget: Money,
    val expenses: List<TravelExpense>
)
