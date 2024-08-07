package br.dev.arthurfernandes.module.travel.core.domain

import br.dev.arthurfernandes.primitive.Money
import kotlinx.datetime.Instant
import java.time.LocalDateTime

data class TravelExpense(
    val id: String,
    val description: String,
    val amount: Money,
)
