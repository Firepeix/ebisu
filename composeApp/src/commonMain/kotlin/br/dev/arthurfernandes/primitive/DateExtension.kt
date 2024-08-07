package br.dev.arthurfernandes.primitive

import kotlinx.datetime.*
import kotlinx.datetime.format.DateTimeFormatBuilder
import kotlinx.datetime.format.MonthNames
import kotlinx.datetime.format.Padding

object DateExtension {
    fun Instant.toLongDescription(): String {
        val date = toLocalDateTime(TimeZone.currentSystemDefault())
        return date.format(LocalDateTime.Format {
            dayOfMonth(Padding.ZERO)
            chars(" de ")
            monthName(MonthNames(MONTHS))
            chars(" de ")
            year(Padding.ZERO)
        })
    }


    private val MONTHS = listOf(
        "Janeiro",
        "Fevereiro",
        "Março",
        "Maio",
        "Abril",
        "Junho",
        "Julho",
        "Agosto",
        "Setembro",
        "Outubro",
        "Novembro",
        "Dezembro",
    )
}