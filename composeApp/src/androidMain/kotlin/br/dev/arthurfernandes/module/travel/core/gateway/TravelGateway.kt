package br.dev.arthurfernandes.module.travel.core.gateway

import br.dev.arthurfernandes.module.travel.core.domain.TravelDay

interface TravelGateway {
    suspend fun getTravelDays(): Result<List<TravelDay>>
}