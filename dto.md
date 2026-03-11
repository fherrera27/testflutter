Perfecto. Vamos a implementarlo bien, enfocados en:
	•	DTO como reflejo del JSON
	•	Mapper escalable y profesional
	•	Domain limpio, estable y sin sobreinterpretar de más
	•	lenguaje Swift avanzado, pero con criterio
	•	sin meternos todavía en ViewModel, Presenter, Policy, Sections

La idea será esta:

DTO -> Mapper -> Domain

Y el mapper hará:
	•	normalización de strings
	•	limpieza de vacíos
	•	conversión de tipos básicos
	•	traducción de claves técnicas a tipos internos
	•	desacople del contrato backend

⸻

1. Diseño objetivo

DTO

Refleja el JSON.

Domain

Representa el caso de uso con lenguaje interno.

Mapper

Centraliza toda la traducción.

⸻

2. Propuesta de estructura

CardDetailFeature/
├─ Data/
│  ├─ DTO/
│  │  └─ CardDetailDTO.swift
│  └─ Mappers/
│     └─ CardDetailMapper.swift
│
└─ Domain/
   └─ Models/
      ├─ CardDetail.swift
      ├─ CardBenefit.swift
      └─ CardRate.swift


⸻

3. Domain Models

Parto por el dominio, porque eso define hacia dónde mapeamos.

CardDetail.swift

import Foundation

public struct CardDetail: Equatable, Sendable {
    public let rewardsProgram: String?
    public let benefits: [CardBenefit]
    public let rates: [CardRate]
    public let cardArtBase64: String?

    public init(
        rewardsProgram: String?,
        benefits: [CardBenefit],
        rates: [CardRate],
        cardArtBase64: String?
    ) {
        self.rewardsProgram = rewardsProgram
        self.benefits = benefits
        self.rates = rates
        self.cardArtBase64 = cardArtBase64
    }
}


⸻

CardBenefit.swift

import Foundation

public struct CardBenefit: Equatable, Sendable, Identifiable {
    public let id: String
    public let type: CardBenefitType
    public let title: String?
    public let value: String

    public init(
        id: String,
        type: CardBenefitType,
        title: String?,
        value: String
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.value = value
    }
}

public enum CardBenefitType: String, Equatable, Sendable, CaseIterable {
    case rewardsAccumulation
    case discountDiningBenefits
    case emergencyMedical
    case baggageLoss
    case accessVipPacificClub
    case accessVisaAirport
    case accessVipPacificPrimeclass
    case accumulationSalaryDeposit
}


⸻

CardRate.swift

Aquí mantenemos el dominio estructural y limpio, sin todavía convertir a Money, ni resolver semántica visual final.

import Foundation

public struct CardRate: Equatable, Sendable, Identifiable {
    public let id: String
    public let type: CardRateType
    public let title: String?

    public let amount: Decimal?
    public let currency: String?

    public let percentage: Decimal?
    public let valuePerTransaction: String?

    public init(
        id: String,
        type: CardRateType,
        title: String?,
        amount: Decimal?,
        currency: String?,
        percentage: Decimal?,
        valuePerTransaction: String?
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.amount = amount
        self.currency = currency
        self.percentage = percentage
        self.valuePerTransaction = valuePerTransaction
    }
}

public enum CardRateType: String, Equatable, Sendable, CaseIterable {
    case monthlyFee
    case semiannualPlanFee
    case internationalPurchaseFee
    case variableInternationalCashAdvanceFee
    case fixedInternationalCashAdvanceFee
}


⸻

4. DTOs

Ahora sí, el DTO como reflejo del JSON.

CardDetailDTO.swift

import Foundation

public struct CardDetailDTO: Decodable, Sendable {
    public let cardBenefits: CardBenefitsDTO?
    public let cardRates: CardRatesDTO?
    public let cardArt: String?

    enum CodingKeys: String, CodingKey {
        case cardBenefits = "card_benefits"
        case cardRates = "card_rates"
        case cardArt = "card_art"
    }
}

public struct CardBenefitsDTO: Decodable, Sendable {
    public let rewardsProgram: String?
    public let rewardsAccumulation: BenefitItemDTO?
    public let discountDiningBenefits: BenefitItemDTO?
    public let emergencyMedical: BenefitItemDTO?
    public let baggageLoss: BenefitItemDTO?
    public let accessVipPacificClub: BenefitItemDTO?
    public let accessVisaAirport: BenefitItemDTO?
    public let accessVipPacificPrimeclass: BenefitItemDTO?
    public let accumulationSalaryDeposit: BenefitItemDTO?

    enum CodingKeys: String, CodingKey {
        case rewardsProgram = "rewards_program"
        case rewardsAccumulation = "rewards_accumulation"
        case discountDiningBenefits = "discount_dining_benefits"
        case emergencyMedical = "emergency_medical"
        case baggageLoss = "baggage_loss"
        case accessVipPacificClub = "access_vip_pacific_club"
        case accessVisaAirport = "access_visa_airport"
        case accessVipPacificPrimeclass = "access_vip_pacific_primeclass"
        case accumulationSalaryDeposit = "accumulation_salary_deposit"
    }
}

public struct BenefitItemDTO: Decodable, Sendable {
    public let title: String?
    public let value: String?
}

public struct CardRatesDTO: Decodable, Sendable {
    public let monthlyFee: AmountRateDTO?
    public let semiannualPlanFee: AmountRateDTO?
    public let internationalPurchaseFee: PercentageRateDTO?
    public let variableInternationalCashAdvanceFee: VariableRateDTO?
    public let fixedInternationalCashAdvanceFee: AmountRateDTO?

    enum CodingKeys: String, CodingKey {
        case monthlyFee = "monthly_fee"
        case semiannualPlanFee = "semiannual_plan_fee"
        case internationalPurchaseFee = "international_purchase_fee"
        case variableInternationalCashAdvanceFee = "variable_international_cash_advance_fee"
        case fixedInternationalCashAdvanceFee = "fixed_international_cash_advance_fee"
    }
}

public struct AmountRateDTO: Decodable, Sendable {
    public let title: String?
    public let amount: Decimal?
    public let currency: String?
}

public struct PercentageRateDTO: Decodable, Sendable {
    public let title: String?
    public let percentage: Decimal?
}

public struct VariableRateDTO: Decodable, Sendable {
    public let title: String?
    public let percentage: Decimal?
    public let valuePerTransaction: String?

    enum CodingKeys: String, CodingKey {
        case title
        case percentage
        case valuePerTransaction = "value_per_transaction"
    }
}


⸻

5. Protocolo del mapper

Esto ayuda a testear y desacoplar implementación.

CardDetailMapping.swift

import Foundation

public protocol CardDetailMapping: Sendable {
    func map(_ dto: CardDetailDTO) -> CardDetail
}


⸻

6. Mapper avanzado y escalable

Ahora sí, lo importante.

CardDetailMapper.swift

import Foundation

public struct CardDetailMapper: CardDetailMapping, Sendable {

    public init() {}

    public func map(_ dto: CardDetailDTO) -> CardDetail {
        CardDetail(
            rewardsProgram: normalize(dto.cardBenefits?.rewardsProgram),
            benefits: mapBenefits(from: dto.cardBenefits),
            rates: mapRates(from: dto.cardRates),
            cardArtBase64: normalize(dto.cardArt)
        )
    }
}


⸻

7. Extensión privada del mapper

Aquí metemos toda la lógica interna, separada por responsabilidad.

private extension CardDetailMapper {

    // MARK: - Benefits

    func mapBenefits(from dto: CardBenefitsDTO?) -> [CardBenefit] {
        guard let dto else { return [] }

        return [
            mapBenefit(dto.rewardsAccumulation, as: .rewardsAccumulation),
            mapBenefit(dto.discountDiningBenefits, as: .discountDiningBenefits),
            mapBenefit(dto.emergencyMedical, as: .emergencyMedical),
            mapBenefit(dto.baggageLoss, as: .baggageLoss),
            mapBenefit(dto.accessVipPacificClub, as: .accessVipPacificClub),
            mapBenefit(dto.accessVisaAirport, as: .accessVisaAirport),
            mapBenefit(dto.accessVipPacificPrimeclass, as: .accessVipPacificPrimeclass),
            mapBenefit(dto.accumulationSalaryDeposit, as: .accumulationSalaryDeposit)
        ]
        .compactMap { $0 }
    }

    func mapBenefit(_ dto: BenefitItemDTO?, as type: CardBenefitType) -> CardBenefit? {
        guard let dto else { return nil }

        let normalizedTitle = normalize(dto.title)
        guard let normalizedValue = normalize(dto.value) else { return nil }

        return CardBenefit(
            id: type.rawValue,
            type: type,
            title: normalizedTitle,
            value: normalizedValue
        )
    }
}


⸻

8. Mapeo de rates

Aquí resolvemos la heterogeneidad de tasas, pero sin sobresemantizar todavía.

private extension CardDetailMapper {

    // MARK: - Rates

    func mapRates(from dto: CardRatesDTO?) -> [CardRate] {
        guard let dto else { return [] }

        return [
            mapAmountRate(dto.monthlyFee, as: .monthlyFee),
            mapAmountRate(dto.semiannualPlanFee, as: .semiannualPlanFee),
            mapPercentageRate(dto.internationalPurchaseFee, as: .internationalPurchaseFee),
            mapVariableRate(dto.variableInternationalCashAdvanceFee, as: .variableInternationalCashAdvanceFee),
            mapAmountRate(dto.fixedInternationalCashAdvanceFee, as: .fixedInternationalCashAdvanceFee)
        ]
        .compactMap { $0 }
    }

    func mapAmountRate(_ dto: AmountRateDTO?, as type: CardRateType) -> CardRate? {
        guard let dto else { return nil }

        return CardRate(
            id: type.rawValue,
            type: type,
            title: normalize(dto.title),
            amount: dto.amount,
            currency: normalize(dto.currency),
            percentage: nil,
            valuePerTransaction: nil
        )
    }

    func mapPercentageRate(_ dto: PercentageRateDTO?, as type: CardRateType) -> CardRate? {
        guard let dto else { return nil }

        return CardRate(
            id: type.rawValue,
            type: type,
            title: normalize(dto.title),
            amount: nil,
            currency: nil,
            percentage: dto.percentage,
            valuePerTransaction: nil
        )
    }

    func mapVariableRate(_ dto: VariableRateDTO?, as type: CardRateType) -> CardRate? {
        guard let dto else { return nil }

        return CardRate(
            id: type.rawValue,
            type: type,
            title: normalize(dto.title),
            amount: nil,
            currency: nil,
            percentage: dto.percentage,
            valuePerTransaction: normalize(dto.valuePerTransaction)
        )
    }
}


⸻

9. Helpers privados del mapper

Aquí está la parte fina: los helpers no son genéricos “por toda la app”, sino helpers de normalización acotados al mapper.

private extension CardDetailMapper {

    // MARK: - Normalization

    func normalize(_ value: String?) -> String? {
        guard let trimmed = value?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty else {
            return nil
        }

        return trimmed
    }
}


⸻

10. ¿Por qué este mapper está bien escalado?

Porque hace exactamente lo que debe hacer un mapper serio:

a) Aísla el backend

La app deja de depender de claves como:
	•	access_vip_pacific_club
	•	value_per_transaction
	•	semiannual_plan_fee

Eso queda encapsulado en DTO + mapper.

⸻

b) Normaliza sin sobreinterpretar

Hace:
	•	"" -> nil
	•	whitespaces -> nil
	•	limpia currency string
	•	limpia title/value

Pero no hace todavía:
	•	formato de moneda
	•	view state
	•	UI text final
	•	secciones
	•	badges
	•	layout

⸻

c) Define lenguaje del feature

Tu sistema ahora habla de:
	•	CardDetail
	•	CardBenefit
	•	CardRate
	•	CardBenefitType
	•	CardRateType

No de nombres crudos del backend.

⸻

d) Escala

Si mañana backend agrega un nuevo beneficio:

"travel_insurance": {
  "title": "...",
  "value": "..."
}

solo haces tres cambios:
	1.	lo agregas al DTO
	2.	agregas un nuevo CardBenefitType
	3.	lo sumas en mapBenefits

Nada más.

⸻

11. Punto importante: por qué no metimos Currency, Money, RateValue

Porque siguiendo lo que conversamos, todavía no queremos sobreenriquecer el dominio.

Entonces el mapper queda sano y estable, pero sin adelantarse a presentation.

Eso es correcto para este punto de control.

⸻

12. Variante aún más profesional: usar descriptores internos

Si quieres escalar aún más el mapper y evitar repetición, puedes usar una estrategia con descriptores.

Te dejo una versión avanzada solo para beneficios.

Beneficios con descriptors

private extension CardDetailMapper {

    typealias BenefitExtractor = (CardBenefitsDTO) -> BenefitItemDTO?

    struct BenefitDescriptor {
        let type: CardBenefitType
        let extractor: BenefitExtractor
    }

    var benefitDescriptors: [BenefitDescriptor] {
        [
            .init(type: .rewardsAccumulation, extractor: { $0.rewardsAccumulation }),
            .init(type: .discountDiningBenefits, extractor: { $0.discountDiningBenefits }),
            .init(type: .emergencyMedical, extractor: { $0.emergencyMedical }),
            .init(type: .baggageLoss, extractor: { $0.baggageLoss }),
            .init(type: .accessVipPacificClub, extractor: { $0.accessVipPacificClub }),
            .init(type: .accessVisaAirport, extractor: { $0.accessVisaAirport }),
            .init(type: .accessVipPacificPrimeclass, extractor: { $0.accessVipPacificPrimeclass }),
            .init(type: .accumulationSalaryDeposit, extractor: { $0.accumulationSalaryDeposit })
        ]
    }

    func mapBenefitsDescriptorBased(from dto: CardBenefitsDTO?) -> [CardBenefit] {
        guard let dto else { return [] }

        return benefitDescriptors.compactMap { descriptor in
            mapBenefit(descriptor.extractor(dto), as: descriptor.type)
        }
    }
}

Esto se justifica cuando:
	•	habrá muchos beneficios
	•	cambiarán con frecuencia
	•	quieres mantener el mapper más declarativo

Por ahora, ambas versiones son correctas.

⸻

13. Cómo testear este mapper

Casos que sí deberías cubrir:

Benefits
	•	si value == nil, no crea beneficio
	•	si value == "", no crea beneficio
	•	si title == "", crea beneficio con title = nil
	•	si vienen varios beneficios, preserva todos los válidos

Rates
	•	mapea correctamente amount
	•	mapea correctamente percentage
	•	mapea correctamente value_per_transaction
	•	limpia currency == "" a nil

Root
	•	si card_benefits == nil, benefits = []
	•	si card_rates == nil, rates = []
	•	si card_art == "", cardArtBase64 = nil

⸻

14. Ejemplo de test unitario

import XCTest

final class CardDetailMapperTests: XCTestCase {

    func test_map_shouldNormalizeEmptyBenefitTitleToNil() {
        let dto = CardDetailDTO(
            cardBenefits: CardBenefitsDTO(
                rewardsProgram: "Scotia Rewards",
                rewardsAccumulation: BenefitItemDTO(
                    title: "   ",
                    value: "Acumulas 0,7%"
                ),
                discountDiningBenefits: nil,
                emergencyMedical: nil,
                baggageLoss: nil,
                accessVipPacificClub: nil,
                accessVisaAirport: nil,
                accessVipPacificPrimeclass: nil,
                accumulationSalaryDeposit: nil
            ),
            cardRates: nil,
            cardArt: nil
        )

        let mapper = CardDetailMapper()
        let domain = mapper.map(dto)

        XCTAssertEqual(domain.rewardsProgram, "Scotia Rewards")
        XCTAssertEqual(domain.benefits.count, 1)
        XCTAssertNil(domain.benefits.first?.title)
        XCTAssertEqual(domain.benefits.first?.value, "Acumulas 0,7%")
    }
}

Si tus DTO no tienen init público, puedes agregarlos o testear vía decoding.

⸻

15. Conclusión arquitectónica

Lo que acabamos de implementar ya deja una base senior y escalable:
	•	el backend puede seguir desordenado
	•	el DTO lo refleja fielmente
	•	el mapper absorbe el caos
	•	el dominio queda limpio y estable
	•	el resto del sistema deja de depender del payload

La idea clave aquí fue:

el mapper no maquilla la UI; el mapper estabiliza el significado interno del feature.

⸻

16. Mi recomendación siguiente

El siguiente paso natural, sin salirnos todavía del enfoque correcto, sería revisar juntos una de estas dos cosas:
	1.	refinar el domain model antes de presentation
	2.	armar tests del mapper como punto de control de arquitectura

Porque ya con este mapper, el siguiente nivel serio es blindar el contrato interno con pruebas.