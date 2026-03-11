Perfecto. Ahora sí pasamos a la siguiente traducción:

Domain → View

Aquí ya no hablamos del backend.
Ya no nos importa:
	•	snake_case
	•	claves del JSON
	•	payload heterogéneo
	•	DTO

Ahora trabajamos sobre nuestro modelo interno y lo transformamos en algo que la vista pueda consumir fácil.

La idea es esta:

DTO -> Domain -> ViewModel

Y ahora implementaremos solo:

Domain -> ViewModel

Sin meter todavía:
	•	presenter completo
	•	policies complejas no conversadas
	•	UIKit table sections
	•	cellType
	•	navegación

Solo el mapper de dominio a vista.

⸻

1. Qué debe hacer este mapper

Este mapper sí puede empezar a resolver:
	•	textos visibles
	•	formato de montos
	•	formato de porcentajes
	•	composición de un string visible
	•	omisiones de campos vacíos
	•	títulos que la UI necesita
	•	imagen base64 si la vista la necesita como Data o UIImage

Pero con criterio.

⸻

2. Qué no debería hacer todavía

Todavía evitaría meter:
	•	lógica de secciones dinámicas
	•	reglas de visibilidad de pantalla complejas
	•	orden global de bloques por policy
	•	navegación
	•	side effects

Porque aquí estamos enfocados en:

dado un CardDetail de dominio, ¿cómo lo convierto en un modelo listo para render?

⸻

3. Propuesta de View Models

Voy a proponer una salida pensada para una vista UIKit o SwiftUI, pero todavía neutral.

CardDetailViewModel

import Foundation

public struct CardDetailViewModel: Equatable, Sendable {
    public let rewardsProgram: String?
    public let benefitItems: [CardBenefitItemViewModel]
    public let rateItems: [CardRateItemViewModel]
    public let cardArtBase64: String?

    public init(
        rewardsProgram: String?,
        benefitItems: [CardBenefitItemViewModel],
        rateItems: [CardRateItemViewModel],
        cardArtBase64: String?
    ) {
        self.rewardsProgram = rewardsProgram
        self.benefitItems = benefitItems
        self.rateItems = rateItems
        self.cardArtBase64 = cardArtBase64
    }
}


⸻

CardBenefitItemViewModel

import Foundation

public struct CardBenefitItemViewModel: Equatable, Sendable, Identifiable {
    public let id: String
    public let title: String?
    public let description: String

    public init(
        id: String,
        title: String?,
        description: String
    ) {
        self.id = id
        self.title = title
        self.description = description
    }
}


⸻

CardRateItemViewModel

Aquí sí resolvemos el string visible final.

import Foundation

public struct CardRateItemViewModel: Equatable, Sendable, Identifiable {
    public let id: String
    public let title: String?
    public let valueText: String

    public init(
        id: String,
        title: String?,
        valueText: String
    ) {
        self.id = id
        self.title = title
        self.valueText = valueText
    }
}


⸻

4. Protocolo del mapper

import Foundation

public protocol CardDetailViewModelMapping: Sendable {
    func map(_ domain: CardDetail) -> CardDetailViewModel
}


⸻

5. Implementación del mapper

import Foundation

public struct CardDetailViewModelMapper: CardDetailViewModelMapping, Sendable {

    public init() {}

    public func map(_ domain: CardDetail) -> CardDetailViewModel {
        CardDetailViewModel(
            rewardsProgram: domain.rewardsProgram,
            benefitItems: domain.benefits.map(mapBenefit),
            rateItems: domain.rates.compactMap(mapRate),
            cardArtBase64: domain.cardArtBase64
        )
    }
}


⸻

6. Mapeo de beneficios

Aquí es muy directo porque el dominio ya viene limpio.

private extension CardDetailViewModelMapper {

    func mapBenefit(_ benefit: CardBenefit) -> CardBenefitItemViewModel {
        CardBenefitItemViewModel(
            id: benefit.id,
            title: benefit.title,
            description: benefit.value
        )
    }
}


⸻

7. Mapeo de rates

Aquí está la parte interesante.

Como decidimos que el dominio todavía no sobreinterpreta demasiado, ahora sí la capa de presentación resuelve el texto visible.

private extension CardDetailViewModelMapper {

    func mapRate(_ rate: CardRate) -> CardRateItemViewModel? {
        guard let valueText = makeRateValueText(from: rate) else {
            return nil
        }

        return CardRateItemViewModel(
            id: rate.id,
            title: rate.title,
            valueText: valueText
        )
    }
}


⸻

8. Construcción del valueText

Aquí centralizamos la semántica visual del rate.

private extension CardDetailViewModelMapper {

    func makeRateValueText(from rate: CardRate) -> String? {
        if let amount = rate.amount {
            return formatAmount(amount, currency: rate.currency)
        }

        if let percentage = rate.percentage,
           let valuePerTransaction = normalize(rate.valuePerTransaction) {
            let formattedPercentage = formatPercentage(percentage)
            return "\(formattedPercentage) del monto + \(valuePerTransaction)"
        }

        if let percentage = rate.percentage {
            return formatPercentage(percentage)
        }

        if let valuePerTransaction = normalize(rate.valuePerTransaction) {
            return valuePerTransaction
        }

        return nil
    }
}


⸻

9. Formateadores privados del mapper

Aquí sí tiene sentido resolver:
	•	monto + currency
	•	porcentaje
	•	strings visibles

pero aún encapsulado dentro del mapper de presentación.

private extension CardDetailViewModelMapper {

    func formatAmount(_ amount: Decimal, currency: String?) -> String {
        let amountText = decimalString(from: amount)

        guard let normalizedCurrency = normalize(currency) else {
            return amountText
        }

        return "\(amountText) \(normalizedCurrency)"
    }

    func formatPercentage(_ percentage: Decimal) -> String {
        "\(decimalString(from: percentage))%"
    }

    func decimalString(from value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."

        return formatter.string(from: value as NSDecimalNumber)
            ?? "\(value)"
    }

    func normalize(_ value: String?) -> String? {
        guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty else {
            return nil
        }

        return trimmed
    }
}


⸻

10. Observación importante sobre valuePerTransaction

Aquí hay un punto fino.

En tu payload original, algunas tasas traían algo como:

"2,5% del monto + US$2,50"

Si ese texto ya viene completo desde backend, y además tú concatenas el porcentaje, podrías duplicarlo.

Por eso hay dos caminos válidos:

Camino A — valuePerTransaction ya es complemento

Entonces:

"\(formattedPercentage) del monto + \(valuePerTransaction)"

Camino B — valuePerTransaction ya es el texto final

Entonces solo haces:

return valuePerTransaction

Dado lo que vimos en tu ejemplo, yo sería más conservador y dejaría esta versión:

private extension CardDetailViewModelMapper {

    func makeRateValueText(from rate: CardRate) -> String? {
        if let amount = rate.amount {
            return formatAmount(amount, currency: rate.currency)
        }

        if let valuePerTransaction = normalize(rate.valuePerTransaction) {
            return valuePerTransaction
        }

        if let percentage = rate.percentage {
            return formatPercentage(percentage)
        }

        return nil
    }
}

Y esta me parece más correcta para tu caso actual, porque no asume semántica que no confirmamos.

⸻

11. Entonces, versión final recomendada

Te dejo la versión que yo usaría ahora, respetando tu criterio de no incorporar lógica que no hayamos conversado.

CardDetailViewModelMapper.swift

import Foundation

public struct CardDetailViewModelMapper: CardDetailViewModelMapping, Sendable {

    public init() {}

    public func map(_ domain: CardDetail) -> CardDetailViewModel {
        CardDetailViewModel(
            rewardsProgram: domain.rewardsProgram,
            benefitItems: domain.benefits.map(mapBenefit),
            rateItems: domain.rates.compactMap(mapRate),
            cardArtBase64: domain.cardArtBase64
        )
    }
}

private extension CardDetailViewModelMapper {

    func mapBenefit(_ benefit: CardBenefit) -> CardBenefitItemViewModel {
        CardBenefitItemViewModel(
            id: benefit.id,
            title: benefit.title,
            description: benefit.value
        )
    }

    func mapRate(_ rate: CardRate) -> CardRateItemViewModel? {
        guard let valueText = makeRateValueText(from: rate) else {
            return nil
        }

        return CardRateItemViewModel(
            id: rate.id,
            title: rate.title,
            valueText: valueText
        )
    }

    func makeRateValueText(from rate: CardRate) -> String? {
        if let amount = rate.amount {
            return formatAmount(amount, currency: rate.currency)
        }

        if let valuePerTransaction = normalize(rate.valuePerTransaction) {
            return valuePerTransaction
        }

        if let percentage = rate.percentage {
            return formatPercentage(percentage)
        }

        return nil
    }

    func formatAmount(_ amount: Decimal, currency: String?) -> String {
        let amountText = decimalString(from: amount)

        guard let normalizedCurrency = normalize(currency) else {
            return amountText
        }

        return "\(amountText) \(normalizedCurrency)"
    }

    func formatPercentage(_ percentage: Decimal) -> String {
        "\(decimalString(from: percentage))%"
    }

    func decimalString(from value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."

        return formatter.string(from: value as NSDecimalNumber)
            ?? "\(value)"
    }

    func normalize(_ value: String?) -> String? {
        guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty else {
            return nil
        }

        return trimmed
    }
}


⸻

12. Qué logramos con este mapper

Este mapper ya deja la vista libre de pensar en:
	•	amount
	•	percentage
	•	currency
	•	valuePerTransaction
	•	combinaciones posibles de un rate

La vista solo recibe:

CardRateItemViewModel(
    title: "...",
    valueText: "0,3 CLF"
)

o

CardRateItemViewModel(
    title: "...",
    valueText: "2,5%"
)

o

CardRateItemViewModel(
    title: "...",
    valueText: "2,5% del monto + US$2,50"
)

según cómo venga el dominio.

⸻

13. Qué todavía no hicimos

A propósito, todavía no metimos:
	•	sections
	•	screen state
	•	presenter
	•	cellType
	•	variants de UI
	•	attributed strings / markdown bold
	•	UIImage desde base64

Eso está bien.
Vamos paso a paso y limpio.

⸻

14. Decisión arquitectónica importante

Fíjate en esto:
	•	En DTO -> Domain evitamos sobreinterpretar
	•	En Domain -> View sí empezamos a componer la representación visual

Eso es exactamente coherente con lo que me marcaste antes.

O sea:

el dominio conserva estructura útil;
la presentación interpreta para la vista.

Muy buen criterio.

⸻

15. Próximo paso natural

El siguiente paso lógico ya sería uno de estos dos:

opción A

definir un ScreenViewModel más completo con bloques como:
	•	header
	•	benefits list
	•	rates list
	•	card art

opción B

llevar esto a UIKit clásico:
	•	Presenter
	•	ViewModel
	•	CellType

opción C

llevarlo a SwiftUI:
	•	ObservableObject
	•	ViewState
	•	render

Aquí el punto de control ya quedó muy bien armado.