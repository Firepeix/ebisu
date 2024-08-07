package br.dev.arthurfernandes.piper.route

interface Route
inline val <reified T: Route> T.NAME: String get() = T::class.simpleName!!
