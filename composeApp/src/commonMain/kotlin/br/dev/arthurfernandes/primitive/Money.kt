package br.dev.arthurfernandes.primitive

import androidx.compose.ui.graphics.Color

data class Money(private val value: Int = 0) {
        private val string = value.toString().replace("-", "")

    enum class Strata {
        POSITIVE, NEUTRAL, NEGATIVE
    }

    val strata = when {
        value == 0 -> Strata.NEUTRAL
        value < 0 -> Strata.NEGATIVE
        else -> Strata.POSITIVE
    }

    val color = when(strata) {
        Strata.NEUTRAL -> Color(0xFF1976D2)
        Strata.NEGATIVE -> Color(0xFFC10015)
        Strata.POSITIVE -> Color(0xFF21BA45)
    }

    operator fun plus(money: Money) = Money(value + money.value)
    operator fun minus(money: Money) = Money(value - money.value)

    fun toReal(showSign: Boolean = true): String {
        if (value == 0) return "R$ 0,00"
        val offset = string.length - 2
        val inCents = value > -100 && value < 100
        val prefix = if(showSign && strata == Strata.NEGATIVE) "-" else ""
        val suffix = if (inCents) "0" else ""
        return "${prefix}R$ ${whole()}$suffix,${string.slice(offset..<string.length)}"
    }

    private fun whole(): String {
        val unit = mutableListOf<String>()
        val offset = string.length - 2
        string.slice(0..<offset).split("").reversed().filter { it != "" }.forEachIndexed { index: Int, number: String ->
            if (index % 3 == 0 && index != 0) {
                unit.add(".")
            }
            unit.add(number)
        }

        return unit.reversed().joinToString("")
    }

    companion object {
        fun Int.toMoney() = Money(this)

        inline fun <T> Iterable<T>.sumOf(selector: (T) -> Money): Money {
            var sum = Money()
            for (element in this) {
                sum += selector(element)
            }
            return sum
        }
    }
}