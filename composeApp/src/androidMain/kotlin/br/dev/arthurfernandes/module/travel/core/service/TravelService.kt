package br.dev.arthurfernandes.module.travel.core.service

import br.dev.arthurfernandes.module.travel.core.domain.TravelDay
import br.dev.arthurfernandes.module.travel.core.domain.TravelExpense
import br.dev.arthurfernandes.module.travel.core.usecase.GetTravelDaysUseCase
import fox.composeapp.generated.resources.Res

class TravelService(private val useCase: GetTravelDaysUseCase) {
    suspend fun getTravelDays() = useCase.getDays()

    suspend fun getTravelDay(id: String): Result<TravelDay?> {
        return useCase.getDays().map { it.first() }
    }

    suspend fun onDeleteExpense(id: String): Result<Unit> {
        TODO()
    }
}