package br.dev.arthurfernandes.module.travel.core.usecase

import br.dev.arthurfernandes.module.travel.core.domain.TravelDay
import br.dev.arthurfernandes.module.travel.core.gateway.TravelGateway

class GetTravelDaysUseCase(private val gateway: TravelGateway) {
    suspend fun getDays(): Result<List<TravelDay>> = gateway.getTravelDays()
}