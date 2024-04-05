object casaDePepeYJulian {

	var property porcentajeDeViveres = 50
	var montoParaReparaciones = 0
	var property cuentaAsignada = cuentaCombinada
	var property estrategiaDeAhorro = minimoEIndispesable

	method hayQueHacerReparaciones() {
		return montoParaReparaciones > 0
	}

	method montoParaReparaciones() {
		return montoParaReparaciones
	}

	method hayViveresSuficientes() {
		return porcentajeDeViveres > 40
	}

	method porcentajeDeViveres() {
		return porcentajeDeViveres
	}

	method laCasaEstaEnOrden() {
		return self.hayViveresSuficientes() && !self.hayQueHacerReparaciones()
	}

	method romperAlgo(valor) {
		montoParaReparaciones += valor
	}

	method depositar(cantidad) {
		cuentaAsignada.depositar(cantidad)
	}

	method extraer(cantidad) {
		cuentaAsignada.extraer(cantidad)
	}

	method saldo() {
		return cuentaAsignada.saldo()
	}

	method generarGasto(cantidad) {
		self.extraer(cantidad)
	}

	method hacerMantenimiento() {
		estrategiaDeAhorro.hacerMantenimiento(self)
	}

	method alcanzaParaReparar() {
		return self.hayQueHacerReparaciones() && self.saldo() > (self.montoParaReparaciones() + 1000)
	}

	method reparar() {
		if (self.alcanzaParaReparar()) {
			self.generarGasto(montoParaReparaciones)
			montoParaReparaciones = 0
		}
	}

}

object cuentaCorriente {

	var saldo = 500

	method saldo() {
		return saldo
	}

	method depositar(cantidad) {
		saldo += cantidad
	}

	method extraer(cantidad) {
		saldo -= cantidad
	}

}

object cuentaDeGastos {

	var saldo = 0
	var property costoPorOperacion = 0

	method saldo() {
		return saldo
	}

	method depositar(cantidad) {
		saldo = saldo + cantidad - costoPorOperacion
	}

	method extraer(cantidad) {
		saldo -= cantidad
	}

}

object cuentaCombinada {

	const cuentaPrimaria = cuentaDeGastos
	const cuentaSecundaria = cuentaCorriente

	method saldo() {
		return cuentaPrimaria.saldo() + cuentaSecundaria.saldo()
	}

	method depositar(cantidad) {
		cuentaPrimaria.depositar(cantidad)
	}

	method extraer(cantidad) {
		if (cuentaPrimaria.saldo() > cantidad) {
			cuentaPrimaria.extraer(cantidad)
		} else {
			cuentaSecundaria.extraer(cantidad)
		}
	}

}

object minimoEIndispesable {

	var property calidad = 1

	method gastoDeViveres(porcentajeAComprar) {
		return porcentajeAComprar * calidad
	}

	method hacerMantenimiento(casa) {
		if (!casa.hayViveresSuficientes()) {
			const valor = (40 - casa.porcentajeDeViveres()).max(0)
			casa.generarGasto(self.gastoDeViveres(valor))
			casa.porcentajeDeViveres(40)
		}
	}

}

object full {

	const calidad = 5

	method gastoDeViveres(porcentajeAComprar) {
		return porcentajeAComprar * calidad
	}

	method hacerMantenimiento(casa) {
		if (casa.laCasaEstaEnOrden()) {
			const valor = 100 - casa.porcentajeDeViveres()
			casa.generarGasto(self.gastoDeViveres(valor))
			casa.porcentajeDeViveres(100)
		} else {
			casa.generarGasto(self.gastoDeViveres(40))
			casa.porcentajeDeViveres(casa.porcentajeDeViveres() + 40)
		}
		casa.reparar()
	}

}

