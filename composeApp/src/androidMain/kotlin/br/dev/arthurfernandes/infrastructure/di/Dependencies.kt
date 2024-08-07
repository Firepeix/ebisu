package br.dev.arthurfernandes.infrastructure.di

import br.dev.arthurfernandes.module.travel.core.domain.TravelDay
import br.dev.arthurfernandes.module.travel.core.gateway.TravelGateway
import br.dev.arthurfernandes.module.travel.core.service.TravelService
import br.dev.arthurfernandes.module.travel.core.usecase.GetTravelDaysUseCase
import br.dev.arthurfernandes.module.travel.entry.component.PREVIEW_DAYS
import kotlinx.coroutines.delay

object Dependencies {
    val travelService = TravelService(GetTravelDaysUseCase(object :TravelGateway {
        override suspend fun getTravelDays(): Result<List<TravelDay>> {
            return Result.success(PREVIEW_DAYS)
        }
    }))
}