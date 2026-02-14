Perfecto. Te implemento lo necesario (mínimo pero completo) para el flujo ViewModel Observable + View SwiftUI, siguiendo exactamente lo conversado y alineado a la UI de tu imagen (con nombres ficticios).

Incluye:
	•	Phase (idle/loading/loaded/failed) como fuente de verdad
	•	DomainState + Event + Route + Modal
	•	Presenter + Factories (Factory Pattern) para construir ViewData
	•	ViewModel orquestador con batching (1 build por evento)
	•	View “tonta”: pinta ViewData, envía eventos, muestra modal
	•	Cards con imagen (SF Symbols) + selección que cambia la info

Esto es 100% Presentation (más un repo mock mínimo para que corra). Si quieres luego conectamos Data/Domain real.

⸻

1) Presentation/State

CardUpgradePhase.swift

import Foundation

enum CardUpgradePhase: Equatable {
  case idle
  case loading
  case loaded
  case failed
}

CardUpgradeEvent.swift

import Foundation

enum CardUpgradeEvent: Equatable {
  case onAppear
  case selectOffer(id: String)
  case tapCTA
  case retry
  case dismissModal
  case modalAccept
}

CardUpgradeRoute.swift

import Foundation

enum CardUpgradeRoute: Equatable {
  case goNext(stepId: String)
}

ModalState.swift

import Foundation

struct ModalState: Identifiable, Equatable {
  enum Kind: Equatable { case loadError, ctaFailed, cupoUpdateFailed }

  let id = UUID()
  let kind: Kind
  let title: String
  let message: String
  let acceptTitle: String
}

CardUpgradeDomainState.swift

import Foundation

struct CardUpgradeDomainState: Equatable {
  var phase: CardUpgradePhase = .idle
  var payload: CardUpgradePayload? = nil
  var selectedOfferId: String? = nil
  var modal: ModalState? = nil
}

// Payload “normalizado” (en real vendría de Domain/UseCase)
struct CardUpgradePayload: Equatable {
  let headerTitle: String
  let offers: [CardOffer]
  let flowType: FlowType
  let hasCupo: Bool
  let infoBoxText: String
}

enum FlowType: Equatable { case digital, fisico }

struct CardOffer: Identifiable, Equatable {
  let id: String
  let name: String
  let monthlyFeeText: String        // ej: "Comisión mensual UF 0,40"
  let imageSystemName: String       // SF Symbol
  let tipoTarjetaText: String
  let cupoText: String
  let beneficios: [String]
  let tarifas: [KeyValue]
}

struct KeyValue: Equatable, Identifiable {
  let id: String
  let key: String
  let value: String
}


⸻

2) Presentation/ViewData

CardUpgradeViewData.swift

import Foundation

struct CardUpgradeViewData: Equatable {
  let phase: CardUpgradePhase
  let navTitle: String
  let headerTitle: String
  let sections: [SectionVM]
  let cta: CTAVM
  let modal: ModalState?
}

struct CTAVM: Equatable {
  let title: String
  let isEnabled: Bool
}

enum SectionVM: Equatable, Identifiable {
  case offerCarousel(OfferCarouselVM)
  case textBlock(TextBlockVM)           // Tipo de tarjeta / Cupo
  case bulletList(BulletListVM)         // Beneficios
  case keyValueList(KeyValueListVM)     // Tarifas
  case infoBox(InfoBoxVM)

  var id: String {
    switch self {
    case .offerCarousel: return "offerCarousel"
    case .textBlock(let vm): return "textBlock-\(vm.title)"
    case .bulletList: return "bulletList"
    case .keyValueList: return "keyValueList"
    case .infoBox: return "infoBox"
    }
  }
}

struct OfferCarouselVM: Equatable {
  let items: [OfferCardVM]
  let selectedId: String?
}

struct OfferCardVM: Equatable, Identifiable {
  let id: String
  let imageSystemName: String
  let title: String
  let subtitle: String
}

struct TextBlockVM: Equatable {
  let title: String
  let body: String
}

struct BulletListVM: Equatable {
  let title: String
  let items: [String]
}

struct KeyValueListVM: Equatable {
  let title: String
  let rows: [KeyValueRowVM]
}

struct KeyValueRowVM: Equatable, Identifiable {
  let id: String
  let key: String
  let value: String
}

struct InfoBoxVM: Equatable {
  let text: String
}


⸻

3) Presentation/L10n (textos constantes fuera del state)

CardUpgradeL10n.swift

import Foundation

enum CardUpgradeL10n {
  static let navTitle = "Mejora de Tarjeta"
  static let ctaContinue = "Continuar"
  static let ctaRetry = "Reintentar"

  static let sectionTipo = "TIPO DE TARJETA"
  static let sectionCupo = "CUPO"
  static let sectionBeneficios = "BENEFICIOS"
  static let sectionTarifas = "TARIFAS"

  static let modalLoadTitle = "Error"
  static let modalLoadMsg = "No se pudo cargar la información."

  static let modalCtaFailTitle = "No se pudo continuar"
  static let modalCtaFailMsg = "Al aceptar, actualizaremos tu cupo y la vista se actualizará."

  static let modalAccept = "Aceptar"
}


⸻

4) Presenter + Factories (Factory Pattern)

Factories (mínimo funcional)

import Foundation

protocol HeaderFactory {
  func makeHeaderTitle(payload: CardUpgradePayload?) -> String
}

final class DefaultHeaderFactory: HeaderFactory {
  func makeHeaderTitle(payload: CardUpgradePayload?) -> String {
    payload?.headerTitle ?? "Cargando…"
  }
}

protocol OfferCarouselFactory {
  func make(payload: CardUpgradePayload?, selectedId: String?) -> SectionVM?
}

final class DefaultOfferCarouselFactory: OfferCarouselFactory {
  func make(payload: CardUpgradePayload?, selectedId: String?) -> SectionVM? {
    guard let payload else { return nil }
    let items = payload.offers.map {
      OfferCardVM(id: $0.id, imageSystemName: $0.imageSystemName, title: $0.name, subtitle: $0.monthlyFeeText)
    }
    return .offerCarousel(.init(items: items, selectedId: selectedId))
  }
}

protocol OfferDetailsFactories {
  func makeTipoSection(offer: CardOffer) -> SectionVM
  func makeCupoSection(offer: CardOffer) -> SectionVM
  func makeBeneficiosSection(offer: CardOffer) -> SectionVM
  func makeTarifasSection(offer: CardOffer) -> SectionVM
}

final class DefaultOfferDetailsFactories: OfferDetailsFactories {
  func makeTipoSection(offer: CardOffer) -> SectionVM {
    .textBlock(.init(title: CardUpgradeL10n.sectionTipo, body: offer.tipoTarjetaText))
  }
  func makeCupoSection(offer: CardOffer) -> SectionVM {
    .textBlock(.init(title: CardUpgradeL10n.sectionCupo, body: offer.cupoText))
  }
  func makeBeneficiosSection(offer: CardOffer) -> SectionVM {
    .bulletList(.init(title: CardUpgradeL10n.sectionBeneficios, items: offer.beneficios))
  }
  func makeTarifasSection(offer: CardOffer) -> SectionVM {
    let rows = offer.tarifas.map { KeyValueRowVM(id: $0.id, key: $0.key, value: $0.value) }
    return .keyValueList(.init(title: CardUpgradeL10n.sectionTarifas, rows: rows))
  }
}

protocol InfoBoxFactory {
  func make(payload: CardUpgradePayload?) -> SectionVM?
}

final class DefaultInfoBoxFactory: InfoBoxFactory {
  func make(payload: CardUpgradePayload?) -> SectionVM? {
    guard let payload else { return nil }
    return .infoBox(.init(text: payload.infoBoxText))
  }
}

protocol CTAFactory {
  func make(phase: CardUpgradePhase, selectedOfferId: String?) -> CTAVM
}

final class DefaultCTAFactory: CTAFactory {
  func make(phase: CardUpgradePhase, selectedOfferId: String?) -> CTAVM {
    let enabled = (phase == .loaded) && (selectedOfferId != nil)
    return .init(title: CardUpgradeL10n.ctaContinue, isEnabled: enabled)
  }
}

CardUpgradePresenter.swift

import Foundation

protocol CardUpgradeViewDataBuilding {
  func build(from state: CardUpgradeDomainState) -> CardUpgradeViewData
}

final class CardUpgradePresenter: CardUpgradeViewDataBuilding {
  private let headerFactory: HeaderFactory
  private let carouselFactory: OfferCarouselFactory
  private let detailsFactories: OfferDetailsFactories
  private let infoBoxFactory: InfoBoxFactory
  private let ctaFactory: CTAFactory

  init(headerFactory: HeaderFactory = DefaultHeaderFactory(),
       carouselFactory: OfferCarouselFactory = DefaultOfferCarouselFactory(),
       detailsFactories: OfferDetailsFactories = DefaultOfferDetailsFactories(),
       infoBoxFactory: InfoBoxFactory = DefaultInfoBoxFactory(),
       ctaFactory: CTAFactory = DefaultCTAFactory()) {
    self.headerFactory = headerFactory
    self.carouselFactory = carouselFactory
    self.detailsFactories = detailsFactories
    self.infoBoxFactory = infoBoxFactory
    self.ctaFactory = ctaFactory
  }

  func build(from state: CardUpgradeDomainState) -> CardUpgradeViewData {
    let headerTitle = headerFactory.makeHeaderTitle(payload: state.payload)

    switch state.phase {
    case .idle, .loading:
      return CardUpgradeViewData(
        phase: state.phase,
        navTitle: CardUpgradeL10n.navTitle,
        headerTitle: headerTitle,
        sections: [],
        cta: .init(title: CardUpgradeL10n.ctaContinue, isEnabled: false),
        modal: state.modal
      )

    case .failed:
      return CardUpgradeViewData(
        phase: .failed,
        navTitle: CardUpgradeL10n.navTitle,
        headerTitle: headerTitle,
        sections: [],
        cta: .init(title: CardUpgradeL10n.ctaRetry, isEnabled: true),
        modal: state.modal
      )

    case .loaded:
      var sections: [SectionVM] = []
      if let s = carouselFactory.make(payload: state.payload, selectedId: state.selectedOfferId) {
        sections.append(s)
      }

      if let payload = state.payload,
         let sel = state.selectedOfferId,
         let offer = payload.offers.first(where: { $0.id == sel }) {

        sections.append(detailsFactories.makeTipoSection(offer: offer))
        sections.append(detailsFactories.makeCupoSection(offer: offer))
        sections.append(detailsFactories.makeBeneficiosSection(offer: offer))
        sections.append(detailsFactories.makeTarifasSection(offer: offer))
      }

      if let s = infoBoxFactory.make(payload: state.payload) {
        sections.append(s)
      }

      let cta = ctaFactory.make(phase: state.phase, selectedOfferId: state.selectedOfferId)

      return CardUpgradeViewData(
        phase: .loaded,
        navTitle: CardUpgradeL10n.navTitle,
        headerTitle: headerTitle,
        sections: sections,
        cta: cta,
        modal: state.modal
      )
    }
  }
}


⸻

5) ViewModel Observable (orquestador + batching)

Mock use cases (mínimo para demo)

import Foundation

protocol CardUpgradeUseCases {
  func load() async throws -> CardUpgradePayload
  func validateAndContinue(payload: CardUpgradePayload, selectedOfferId: String) async throws -> String // nextStepId
  func refreshCupoAfterModal(payload: CardUpgradePayload) async throws -> CardUpgradePayload
}

CardUpgradeViewModel.swift

import Foundation

@MainActor
final class CardUpgradeViewModel: ObservableObject {
  @Published private(set) var viewData: CardUpgradeViewData
  @Published var route: CardUpgradeRoute? = nil

  private var state = CardUpgradeDomainState()
  private let presenter: CardUpgradeViewDataBuilding
  private let useCases: CardUpgradeUseCases

  private var task: Task<Void, Never>?

  init(presenter: CardUpgradeViewDataBuilding, useCases: CardUpgradeUseCases) {
    self.presenter = presenter
    self.useCases = useCases
    self.viewData = presenter.build(from: CardUpgradeDomainState())
  }

  func send(_ event: CardUpgradeEvent) {
    switch event {
    case .onAppear:
      load()

    case .selectOffer(let id):
      update { s in s.selectedOfferId = id }

    case .tapCTA:
      if state.phase == .failed { load(); return }
      continueFlow()

    case .retry:
      load()

    case .dismissModal:
      update { $0.modal = nil }

    case .modalAccept:
      acceptModal()
    }
  }

  // MARK: - Batching update (1 build por evento)
  private func update(_ mutate: (inout CardUpgradeDomainState) -> Void) {
    var next = state
    mutate(&next)
    state = next
    viewData = presenter.build(from: state)
  }

  private func load() {
    task?.cancel()
    update { s in
      s.phase = .loading
      s.modal = nil
    }

    task = Task { [weak self] in
      guard let self else { return }
      do {
        let payload = try await useCases.load()
        update { s in
          s.payload = payload
          s.phase = .loaded
          if s.selectedOfferId == nil {
            s.selectedOfferId = payload.offers.first?.id
          }
        }
      } catch {
        update { s in
          s.phase = .failed
          s.modal = ModalState(kind: .loadError,
                               title: CardUpgradeL10n.modalLoadTitle,
                               message: CardUpgradeL10n.modalLoadMsg,
                               acceptTitle: CardUpgradeL10n.modalAccept)
        }
      }
    }
  }

  private func continueFlow() {
    guard let payload = state.payload,
          let selectedId = state.selectedOfferId,
          state.phase == .loaded else { return }

    task?.cancel()
    update { s in
      s.phase = .loading
      s.modal = nil
    }

    task = Task { [weak self] in
      guard let self else { return }
      do {
        let stepId = try await useCases.validateAndContinue(payload: payload, selectedOfferId: selectedId)
        update { s in s.phase = .loaded }
        route = .goNext(stepId: stepId)
      } catch {
        update { s in
          s.phase = .loaded
          s.modal = ModalState(kind: .ctaFailed,
                               title: CardUpgradeL10n.modalCtaFailTitle,
                               message: CardUpgradeL10n.modalCtaFailMsg,
                               acceptTitle: CardUpgradeL10n.modalAccept)
        }
      }
    }
  }

  private func acceptModal() {
    guard let modal = state.modal else { return }

    switch modal.kind {
    case .loadError:
      update { $0.modal = nil }

    case .ctaFailed, .cupoUpdateFailed:
      guard let payload = state.payload else {
        update { $0.modal = nil }
        return
      }

      task?.cancel()
      update { s in
        s.modal = nil
        s.phase = .loading
      }

      task = Task { [weak self] in
        guard let self else { return }
        do {
          let updated = try await useCases.refreshCupoAfterModal(payload: payload)
          update { s in
            s.payload = updated
            s.phase = .loaded
          }
        } catch {
          update { s in
            s.phase = .loaded
            s.modal = ModalState(kind: .cupoUpdateFailed,
                                 title: "No se pudo actualizar",
                                 message: "Intenta nuevamente.",
                                 acceptTitle: CardUpgradeL10n.modalAccept)
          }
        }
      }
    }
  }
}


⸻

6) SwiftUI View (tonta: pinta ViewData)

CardUpgradeView.swift

import SwiftUI

struct CardUpgradeView: View {
  @StateObject var vm: CardUpgradeViewModel

  var body: some View {
    VStack(spacing: 14) {
      Text(vm.viewData.headerTitle)
        .font(.title3)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)

      switch vm.viewData.phase {
      case .idle, .loading:
        ProgressView().frame(maxWidth: .infinity)

      case .failed:
        Button(vm.viewData.cta.title) { vm.send(.retry) }
          .frame(maxWidth: .infinity)

      case .loaded:
        ForEach(vm.viewData.sections) { section in
          render(section)
        }

        Spacer()

        Button(vm.viewData.cta.title) { vm.send(.tapCTA) }
          .disabled(!vm.viewData.cta.isEnabled)
          .frame(maxWidth: .infinity)
      }
    }
    .padding()
    .navigationTitle(vm.viewData.navTitle)
    .navigationBarTitleDisplayMode(.inline)
    .onAppear { vm.send(.onAppear) }
    .alert(item: Binding(
      get: { vm.viewData.modal },
      set: { _ in vm.send(.dismissModal) }
    )) { modal in
      Alert(
        title: Text(modal.title),
        message: Text(modal.message),
        dismissButton: .default(Text(modal.acceptTitle)) {
          vm.send(.modalAccept)
        }
      )
    }
    .onChange(of: vm.route) { _, newRoute in
      guard let newRoute else { return }
      // Aquí conectarías navegación real (NavigationStack / coordinator)
      // Limpieza:
      vm.route = nil
      print("Navigate ->", newRoute)
    }
  }

  @ViewBuilder
  private func render(_ section: SectionVM) -> some View {
    switch section {
    case .offerCarousel(let s):
      OfferCarouselSection(vm: s) { id in vm.send(.selectOffer(id: id)) }

    case .textBlock(let s):
      VStack(alignment: .leading, spacing: 6) {
        Text(s.title).font(.caption).foregroundStyle(.secondary)
        Text(s.body).font(.body)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 6)

    case .bulletList(let s):
      VStack(alignment: .leading, spacing: 6) {
        Text(s.title).font(.caption).foregroundStyle(.secondary)
        ForEach(s.items, id: \.self) { Text("• \( $0 )").font(.body) }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 6)

    case .keyValueList(let s):
      VStack(alignment: .leading, spacing: 8) {
        Text(s.title).font(.caption).foregroundStyle(.secondary)
        ForEach(s.rows) { row in
          HStack {
            Text(row.key)
            Spacer()
            Text(row.value).foregroundStyle(.secondary)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 6)

    case .infoBox(let s):
      InfoBoxView(vm: s)
    }
  }
}

struct OfferCarouselSection: View {
  let vm: OfferCarouselVM
  let onTap: (String) -> Void

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 12) {
        ForEach(vm.items) { item in
          OfferCardView(item: item, isSelected: item.id == vm.selectedId)
            .onTapGesture { onTap(item.id) }
        }
      }
      .padding(.vertical, 4)
    }
  }
}

struct OfferCardView: View {
  let item: OfferCardVM
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Image(systemName: item.imageSystemName)
        .resizable()
        .scaledToFit()
        .padding(12)
        .frame(height: 86)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.1))
        .cornerRadius(12)

      Text(item.title).font(.headline)
      Text(item.subtitle).font(.subheadline).foregroundStyle(.secondary)
    }
    .padding()
    .frame(width: 260, alignment: .leading)
    .background(isSelected ? .gray.opacity(0.12) : .clear)
    .overlay(
      RoundedRectangle(cornerRadius: 14)
        .stroke(isSelected ? .red : .gray.opacity(0.3), lineWidth: 1)
    )
    .cornerRadius(14)
  }
}

struct InfoBoxView: View {
  let vm: InfoBoxVM
  var body: some View {
    HStack(alignment: .top, spacing: 10) {
      Image(systemName: "info.circle").padding(.top, 2)
      Text(vm.text).font(.subheadline)
      Spacer()
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.blue.opacity(0.08))
    .cornerRadius(12)
    .padding(.top, 8)
  }
}


⸻

7) Demo UseCases (mock) para que lo veas funcionando

MockCardUpgradeUseCases.swift

import Foundation

final class MockCardUpgradeUseCases: CardUpgradeUseCases {
  var shouldFailCTA: Bool = true
  var hasCupoInitial: Bool = true

  func load() async throws -> CardUpgradePayload {
    try await Task.sleep(nanoseconds: 200_000_000)

    let offers: [CardOffer] = [
      CardOffer(
        id: "offer_infinite",
        name: "Aurora Infinite",
        monthlyFeeText: "Comisión mensual UF 0,40",
        imageSystemName: "creditcard",
        tipoTarjetaText: "La nueva tarjeta será de tipo Digital.\nUna vez contratada podrás solicitar la versión física.",
        cupoText: hasCupoInitial ? "Mantendrás el mismo cupo que tienes actualmente." : "No tienes cupo disponible para esta oferta.",
        beneficios: [
          "Acumula 0,7% del monto de la compra",
          "20% dcto. en Ruta Gourmet",
          "Ingresos gratuitos mensuales a salas VIP"
        ],
        tarifas: [
          KeyValue(id: "t1", key: "Costo mensual", value: "UF 0,40"),
          KeyValue(id: "t2", key: "Compras internacionales", value: "2,0%"),
          KeyValue(id: "t3", key: "Avances internacionales", value: "2,5% + US$3,0")
        ]
      ),
      CardOffer(
        id: "offer_gold",
        name: "Aurora Gold",
        monthlyFeeText: "Comisión mensual UF 0,21",
        imageSystemName: "wallet.pass",
        tipoTarjetaText: "La nueva tarjeta será de tipo Digital.\nPodrás solicitar la versión física luego.",
        cupoText: "Mantendrás el mismo cupo que tienes actualmente.",
        beneficios: [
          "Acumula 0,3% del monto de la compra",
          "10% dcto. en Ruta Gourmet"
        ],
        tarifas: [
          KeyValue(id: "g1", key: "Costo mensual", value: "UF 0,21"),
          KeyValue(id: "g2", key: "Compras internacionales", value: "2,0%")
        ]
      )
    ]

    return CardUpgradePayload(
      headerTitle: "¡Mejora tu Tarjeta!",
      offers: offers,
      flowType: .digital,
      hasCupo: hasCupoInitial,
      infoBoxText: "La entrega de la tarjeta se realizará en 24 horas. El plástico puede demorar más."
    )
  }

  func validateAndContinue(payload: CardUpgradePayload, selectedOfferId: String) async throws -> String {
    try await Task.sleep(nanoseconds: 200_000_000)
    if shouldFailCTA { throw NSError(domain: "cta", code: 1) }
    return "next-\(selectedOfferId)"
  }

  func refreshCupoAfterModal(payload: CardUpgradePayload) async throws -> CardUpgradePayload {
    try await Task.sleep(nanoseconds: 200_000_000)
    // Simula que “aceptar modal” actualiza cupo a false
    let updatedOffers = payload.offers.map { offer in
      if offer.id == "offer_infinite" {
        return CardOffer(
          id: offer.id,
          name: offer.name,
          monthlyFeeText: offer.monthlyFeeText,
          imageSystemName: offer.imageSystemName,
          tipoTarjetaText: offer.tipoTarjetaText,
          cupoText: "No tienes cupo disponible para esta oferta (actualizado).",
          beneficios: offer.beneficios,
          tarifas: offer.tarifas
        )
      }
      return offer
    }

    return CardUpgradePayload(
      headerTitle: payload.headerTitle,
      offers: updatedOffers,
      flowType: payload.flowType,
      hasCupo: false,
      infoBoxText: payload.infoBoxText
    )
  }
}


⸻

8) Host para probar

import SwiftUI

struct CardUpgradeHostView: View {
  var body: some View {
    NavigationStack {
      let useCases = MockCardUpgradeUseCases()
      useCases.shouldFailCTA = true

      let vm = CardUpgradeViewModel(
        presenter: CardUpgradePresenter(),
        useCases: useCases
      )

      CardUpgradeView(vm: vm)
    }
  }
}


⸻

Qué se logra con esta implementación (según tu conversación)
	•	La View no decide negocio: no hace switch de flujo ni visibilidad por flags.
	•	phase gobierna loading/error/loaded.
	•	Presenter + factories construyen toda la pantalla con secciones como tu imagen.
	•	Selección de tarjeta cambia el contenido mostrado.
	•	CTA ejecuta flujo (en mock falla → muestra modal).
	•	Aceptar modal ejecuta use case para refrescar cupo y se actualiza la UI.
	•	Preparado para meter analítica en el ViewModel en los send() (sin tocar View).

⸻

Si me dices si quieres que el CTA quede como botón fijo abajo (como en tu imagen) sobre un ScrollView, te ajusto el layout con ScrollView + safeAreaInset(edge: .bottom) para un footer fijo, sin romper el patrón “View tonta”.