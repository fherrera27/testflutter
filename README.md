Aquí va el ejemplo completo (punto de control) con todos los casos de uso que definimos, ya con el flujo final “senior”:
	•	phase como fuente de verdad (idle/loading/loaded/failed)
	•	batching de cambios (1 build por evento)
	•	Presenter + SectionFactories (Factory Pattern)
	•	cards con imagen + selección que cambia contenido
	•	flags flowType y hasCupo controlan secciones
	•	CTA elige use case según flowType
	•	CTA falla → modal
	•	aceptar modal → actualiza cupo (vía use case UpdateCupoUseCase, no hardcode local)
	•	analítica como side-effect (inyección por protocolo)

Pega esto tal cual en un proyecto SwiftUI (iOS 16+).
Todo usa SF Symbols para imágenes (no necesitas assets).

⸻

1) Domain.swift

import Foundation

// MARK: - Domain Models

enum FlowType: Equatable {
  case digital
  case fisico
}

enum Destination: Equatable {
  case digitalNext(stepId: String)
  case physicalBranchPicker
}

struct BackendCard: Equatable, Identifiable {
  let id: String
  let title: String
  let subtitle: String
  let imageKey: String  // SF Symbol name en este demo
}

struct ScreenPayload: Equatable {
  let flowType: FlowType
  let hasCupo: Bool

  let userName: String
  let availableAmount: Decimal
  let backendMessage: String?

  let cards: [BackendCard]
}

// MARK: - Repository

protocol ScreenRepository {
  func fetchScreen() async throws -> ScreenPayload

  func startDigitalFlow(payload: ScreenPayload, selectedCardId: String) async throws -> Destination
  func startPhysicalFlow(payload: ScreenPayload, selectedCardId: String) async throws -> Destination

  /// Caso de uso extra: al aceptar modal (CTA falló) se actualiza cupo en backend
  func updateCupoAfterFailure(payload: ScreenPayload) async throws -> ScreenPayload
}

// MARK: - UseCases

struct LoadScreenUseCase {
  let repo: ScreenRepository
  func execute() async throws -> ScreenPayload { try await repo.fetchScreen() }
}

struct StartDigitalFlowUseCase {
  let repo: ScreenRepository
  func execute(payload: ScreenPayload, selectedCardId: String) async throws -> Destination {
    try await repo.startDigitalFlow(payload: payload, selectedCardId: selectedCardId)
  }
}

struct StartPhysicalFlowUseCase {
  let repo: ScreenRepository
  func execute(payload: ScreenPayload, selectedCardId: String) async throws -> Destination {
    try await repo.startPhysicalFlow(payload: payload, selectedCardId: selectedCardId)
  }
}

struct UpdateCupoUseCase {
  let repo: ScreenRepository
  func execute(payload: ScreenPayload) async throws -> ScreenPayload {
    try await repo.updateCupoAfterFailure(payload: payload)
  }
}


⸻

2) Analytics.swift

import Foundation

protocol AnalyticsTracking {
  func track(_ event: AnalyticsEvent)
}

enum AnalyticsEvent: Equatable {
  case screenAppear
  case screenLoaded(flow: FlowType, hasCupo: Bool)
  case screenLoadFailed

  case cardSelected(id: String)
  case ctaTapped(flow: FlowType)
  case ctaSucceeded(destination: Destination)
  case ctaFailed(flow: FlowType)

  case modalShown(kind: String)
  case modalAccepted(kind: String)

  case cupoUpdateStarted
  case cupoUpdateSucceeded(hasCupo: Bool)
  case cupoUpdateFailed
}

final class ConsoleAnalytics: AnalyticsTracking {
  func track(_ event: AnalyticsEvent) {
    print("📊 Analytics:", event)
  }
}


⸻

3) Presentation.swift (State, Events, ViewData + Factories + Presenter)

import Foundation

// MARK: - Presentation State

struct ModalState: Equatable, Identifiable {
  enum Kind: Equatable { case loadError, ctaFailed }

  let id = UUID()
  let kind: Kind
  let title: String
  let message: String
  let acceptTitle: String
}

struct ScreenDomainState: Equatable {
  enum Phase: Equatable { case idle, loading, loaded, failed }

  var phase: Phase = .idle
  var payload: ScreenPayload? = nil
  var selectedCardId: String? = nil
  var modal: ModalState? = nil
}

enum ScreenEvent {
  case onAppear
  case tapCard(id: String)
  case tapCTA
  case retry
  case dismissModal
  case modalAccept
}

enum ScreenRoute: Equatable {
  case goDigital(stepId: String)
  case goPhysicalBranchPicker
}

// MARK: - ViewData

struct ScreenViewData: Equatable {
  let phase: ScreenDomainState.Phase
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
  case cards(CardsSectionVM)
  case banner(BannerSectionVM)
  case cupo(CupoSectionVM)
  case info(InfoSectionVM)

  var id: String {
    switch self {
    case .cards: return "cards"
    case .banner: return "banner"
    case .cupo: return "cupo"
    case .info: return "info"
    }
  }
}

struct CardsSectionVM: Equatable {
  let items: [CardItemVM]
  let selectedId: String?
}

struct CardItemVM: Equatable, Identifiable {
  let id: String
  let title: String
  let subtitle: String
  let imageSystemName: String
}

struct BannerSectionVM: Equatable { let text: String }
struct CupoSectionVM: Equatable { let title: String; let amountText: String }
struct InfoSectionVM: Equatable { let title: String; let body: String }

// MARK: - L10n (catálogo)

enum L10n {
  static let titleDigital = "Flujo Digital"
  static let titleFisico  = "Flujo Físico"

  static let noCupoBanner = "Sin cupo disponible"
  static let cupoTitle    = "Cupo disponible"
  static let infoTitle    = "Información"

  static let ctaContinue  = "Continuar"
  static let ctaGoBranch  = "Ir a sucursal"

  static let loadErrorTitle = "Error"
  static let loadErrorMsg   = "No se pudo cargar la información."

  static let ctaFailTitle = "No se pudo continuar"
  static let ctaFailMsg   = "Al aceptar, se actualizará el cupo (vía use case) y la vista se actualizará."

  static let accept = "Aceptar"
  static let retry  = "Reintentar"

  static let loading = "Cargando…"
}

// MARK: - Factories (Factory Pattern)

protocol HeaderFactory {
  func makeHeaderTitle(phase: ScreenDomainState.Phase, payload: ScreenPayload?) -> String
}

final class DefaultHeaderFactory: HeaderFactory {
  func makeHeaderTitle(phase: ScreenDomainState.Phase, payload: ScreenPayload?) -> String {
    guard let payload else { return L10n.loading }
    switch payload.flowType {
    case .digital: return L10n.titleDigital
    case .fisico:  return L10n.titleFisico
    }
  }
}

protocol CardsSectionFactory {
  func make(payload: ScreenPayload?, selectedId: String?) -> SectionVM?
}

final class DefaultCardsSectionFactory: CardsSectionFactory {
  func make(payload: ScreenPayload?, selectedId: String?) -> SectionVM? {
    guard let payload else { return nil }
    let items = payload.cards.map {
      CardItemVM(id: $0.id, title: $0.title, subtitle: $0.subtitle, imageSystemName: $0.imageKey)
    }
    return .cards(.init(items: items, selectedId: selectedId))
  }
}

protocol CupoSectionFactory {
  func make(payload: ScreenPayload?) -> SectionVM?
}

final class DefaultCupoSectionFactory: CupoSectionFactory {
  func make(payload: ScreenPayload?) -> SectionVM? {
    guard let payload else { return nil }
    if payload.hasCupo {
      return .cupo(.init(title: L10n.cupoTitle, amountText: formatCLP(payload.availableAmount)))
    } else {
      return .banner(.init(text: L10n.noCupoBanner))
    }
  }

  private func formatCLP(_ amount: Decimal) -> String {
    // demo simple
    return "$\(amount)"
  }
}

protocol InfoSectionFactory {
  func make(payload: ScreenPayload?, selectedId: String?) -> SectionVM?
}

final class DefaultInfoSectionFactory: InfoSectionFactory {
  func make(payload: ScreenPayload?, selectedId: String?) -> SectionVM? {
    guard let payload, let selectedId else { return nil }
    let selected = payload.cards.first { $0.id == selectedId }
    let body =
"""
Seleccionado: \(selected?.title ?? selectedId)
Usuario: \(payload.userName)
\(payload.backendMessage ?? "")
Flow: \(payload.flowType == .digital ? "Digital" : "Físico")
Cupo: \(payload.hasCupo ? "Sí" : "No")
"""
    return .info(.init(title: L10n.infoTitle, body: body))
  }
}

protocol CtaFactory {
  func make(phase: ScreenDomainState.Phase, payload: ScreenPayload?, selectedId: String?) -> CTAVM
}

final class DefaultCtaFactory: CtaFactory {
  func make(phase: ScreenDomainState.Phase, payload: ScreenPayload?, selectedId: String?) -> CTAVM {
    guard let payload else { return .init(title: L10n.ctaContinue, isEnabled: false) }

    let title: String = {
      switch payload.flowType {
      case .digital: return L10n.ctaContinue
      case .fisico:  return L10n.ctaGoBranch
      }
    }()

    let enabled = (phase == .loaded) && (selectedId != nil)
    return .init(title: title, isEnabled: enabled)
  }
}

// MARK: - Presenter (orquesta factories)

protocol ScreenViewDataBuilding {
  func build(from domain: ScreenDomainState) -> ScreenViewData
}

final class ScreenPresenter: ScreenViewDataBuilding {
  private let headerFactory: HeaderFactory
  private let cardsFactory: CardsSectionFactory
  private let cupoFactory: CupoSectionFactory
  private let infoFactory: InfoSectionFactory
  private let ctaFactory: CtaFactory

  init(headerFactory: HeaderFactory = DefaultHeaderFactory(),
       cardsFactory: CardsSectionFactory = DefaultCardsSectionFactory(),
       cupoFactory: CupoSectionFactory = DefaultCupoSectionFactory(),
       infoFactory: InfoSectionFactory = DefaultInfoSectionFactory(),
       ctaFactory: CtaFactory = DefaultCtaFactory()) {
    self.headerFactory = headerFactory
    self.cardsFactory = cardsFactory
    self.cupoFactory = cupoFactory
    self.infoFactory = infoFactory
    self.ctaFactory = ctaFactory
  }

  func build(from domain: ScreenDomainState) -> ScreenViewData {
    let header = headerFactory.makeHeaderTitle(phase: domain.phase, payload: domain.payload)

    // phase-first: decide secciones base por estado
    switch domain.phase {
    case .idle, .loading:
      return ScreenViewData(
        phase: domain.phase,
        headerTitle: header,
        sections: [],
        cta: CTAVM(title: L10n.ctaContinue, isEnabled: false),
        modal: domain.modal
      )

    case .failed:
      // puedes modelar una sección error en vez de modal; aquí mantenemos modal
      return ScreenViewData(
        phase: .failed,
        headerTitle: header,
        sections: [],
        cta: CTAVM(title: L10n.retry, isEnabled: true),
        modal: domain.modal
      )

    case .loaded:
      var sections: [SectionVM] = []
      if let s = cardsFactory.make(payload: domain.payload, selectedId: domain.selectedCardId) { sections.append(s) }
      if let s = cupoFactory.make(payload: domain.payload) { sections.append(s) }
      if let s = infoFactory.make(payload: domain.payload, selectedId: domain.selectedCardId) { sections.append(s) }

      let cta = ctaFactory.make(phase: domain.phase, payload: domain.payload, selectedId: domain.selectedCardId)

      return ScreenViewData(
        phase: .loaded,
        headerTitle: header,
        sections: sections,
        cta: cta,
        modal: domain.modal
      )
    }
  }
}


⸻

4) ScreenViewModel.swift (orquestador con batching + analítica)

import Foundation

@MainActor
final class ScreenViewModel: ObservableObject {
  @Published private(set) var viewData: ScreenViewData
  @Published var route: ScreenRoute? = nil

  private var domain = ScreenDomainState()
  private let presenter: ScreenViewDataBuilding

  private let load: LoadScreenUseCase
  private let startDigital: StartDigitalFlowUseCase
  private let startPhysical: StartPhysicalFlowUseCase
  private let updateCupo: UpdateCupoUseCase

  private let analytics: AnalyticsTracking

  private var loadTask: Task<Void, Never>?
  private var actionTask: Task<Void, Never>?

  init(presenter: ScreenViewDataBuilding,
       load: LoadScreenUseCase,
       startDigital: StartDigitalFlowUseCase,
       startPhysical: StartPhysicalFlowUseCase,
       updateCupo: UpdateCupoUseCase,
       analytics: AnalyticsTracking) {
    self.presenter = presenter
    self.load = load
    self.startDigital = startDigital
    self.startPhysical = startPhysical
    self.updateCupo = updateCupo
    self.analytics = analytics

    self.viewData = presenter.build(from: ScreenDomainState())
  }

  func send(_ event: ScreenEvent) {
    switch event {
    case .onAppear:
      analytics.track(.screenAppear)
      loadScreen()

    case .tapCard(let id):
      update { s in
        s.selectedCardId = id
      }
      analytics.track(.cardSelected(id: id))

    case .tapCTA:
      runCTA()

    case .retry:
      loadScreen()

    case .dismissModal:
      update { $0.modal = nil }

    case .modalAccept:
      modalAcceptFlow()
    }
  }

  // MARK: - Batching update

  private func update(_ mutate: (inout ScreenDomainState) -> Void) {
    var next = domain
    mutate(&next)
    domain = next
    viewData = presenter.build(from: domain)
  }

  // MARK: - Load

  private func loadScreen() {
    loadTask?.cancel()

    update { s in
      s.phase = .loading
      s.modal = nil
    }

    loadTask = Task { [weak self] in
      guard let self else { return }
      do {
        let payload = try await load.execute()
        update { s in
          s.payload = payload
          s.phase = .loaded
          if s.selectedCardId == nil {
            s.selectedCardId = payload.cards.first?.id
          }
        }
        analytics.track(.screenLoaded(flow: payload.flowType, hasCupo: payload.hasCupo))
      } catch {
        update { s in
          s.phase = .failed
          s.modal = ModalState(kind: .loadError,
                               title: L10n.loadErrorTitle,
                               message: L10n.loadErrorMsg,
                               acceptTitle: L10n.accept)
        }
        analytics.track(.screenLoadFailed)
        analytics.track(.modalShown(kind: "loadError"))
      }
    }
  }

  // MARK: - CTA

  private func runCTA() {
    guard let payload = domain.payload, let selectedId = domain.selectedCardId else { return }
    guard domain.phase == .loaded else { return }

    analytics.track(.ctaTapped(flow: payload.flowType))

    actionTask?.cancel()
    update { s in
      s.phase = .loading
      s.modal = nil
    }

    actionTask = Task { [weak self] in
      guard let self else { return }
      do {
        let dest: Destination
        switch payload.flowType {
        case .digital:
          dest = try await startDigital.execute(payload: payload, selectedCardId: selectedId)
        case .fisico:
          dest = try await startPhysical.execute(payload: payload, selectedCardId: selectedId)
        }

        update { s in
          s.phase = .loaded
        }

        analytics.track(.ctaSucceeded(destination: dest))

        switch dest {
        case .digitalNext(let stepId):
          route = .goDigital(stepId: stepId)
        case .physicalBranchPicker:
          route = .goPhysicalBranchPicker
        }
      } catch {
        // CTA failed -> show modal. accept triggers UpdateCupoUseCase
        update { s in
          s.phase = .loaded
          s.modal = ModalState(kind: .ctaFailed,
                               title: L10n.ctaFailTitle,
                               message: L10n.ctaFailMsg,
                               acceptTitle: L10n.accept)
        }
        analytics.track(.ctaFailed(flow: payload.flowType))
        analytics.track(.modalShown(kind: "ctaFailed"))
      }
    }
  }

  // MARK: - Modal accept (Update cupo use case)

  private func modalAcceptFlow() {
    guard let modal = domain.modal else { return }

    analytics.track(.modalAccepted(kind: "\(modal.kind)"))

    switch modal.kind {
    case .loadError:
      // en loadError, aceptar simplemente cierra
      update { $0.modal = nil }

    case .ctaFailed:
      // en ctaFailed, aceptar => update cupo via UC (y refresca UI)
      update { s in
        s.modal = nil
        s.phase = .loading
      }

      analytics.track(.cupoUpdateStarted)

      actionTask?.cancel()
      actionTask = Task { [weak self] in
        guard let self else { return }
        do {
          guard let payload = domain.payload else {
            update { s in s.phase = .loaded }
            return
          }
          let updatedPayload = try await updateCupo.execute(payload: payload)
          update { s in
            s.payload = updatedPayload
            s.phase = .loaded
          }
          analytics.track(.cupoUpdateSucceeded(hasCupo: updatedPayload.hasCupo))
        } catch {
          update { s in
            s.phase = .loaded
            s.modal = ModalState(kind: .ctaFailed,
                                 title: "No se pudo actualizar cupo",
                                 message: "Intenta nuevamente.",
                                 acceptTitle: L10n.accept)
          }
          analytics.track(.cupoUpdateFailed)
          analytics.track(.modalShown(kind: "cupoUpdateFailed"))
        }
      }
    }
  }
}


⸻

5) MockRepository.swift (escenarios + CTA success/fail + update cupo)

import Foundation

enum MockError: Error { case forced }

final class MockScreenRepository: ScreenRepository {
  enum Scenario {
    case digitalHasCupo
    case digitalNoCupo
    case fisicoHasCupo
    case fisicoNoCupo
  }

  var scenario: Scenario = .digitalHasCupo

  /// Fuerza fallo del CTA para probar modal -> accept -> update cupo
  var shouldFailCTA: Bool = true

  /// simula que el backend al “aceptar” actualiza cupo a false
  var updateCupoSetsFalse: Bool = true

  func fetchScreen() async throws -> ScreenPayload {
    try await Task.sleep(nanoseconds: 200_000_000)

    let (flow, cupo): (FlowType, Bool) = {
      switch scenario {
      case .digitalHasCupo: return (.digital, true)
      case .digitalNoCupo:  return (.digital, false)
      case .fisicoHasCupo:  return (.fisico, true)
      case .fisicoNoCupo:   return (.fisico, false)
      }
    }()

    return ScreenPayload(
      flowType: flow,
      hasCupo: cupo,
      userName: "Felipe",
      availableAmount: 1_250_000,
      backendMessage: "Mensaje backend: reglas activas.",
      cards: [
        BackendCard(id: "cardA", title: "Tarjeta A", subtitle: "Beneficio A", imageKey: "creditcard"),
        BackendCard(id: "cardB", title: "Tarjeta B", subtitle: "Beneficio B", imageKey: "wallet.pass"),
        BackendCard(id: "cardC", title: "Tarjeta C", subtitle: "Beneficio C", imageKey: "qrcode")
      ]
    )
  }

  func startDigitalFlow(payload: ScreenPayload, selectedCardId: String) async throws -> Destination {
    try await Task.sleep(nanoseconds: 200_000_000)
    if shouldFailCTA { throw MockError.forced }
    return .digitalNext(stepId: "digital-\(selectedCardId)")
  }

  func startPhysicalFlow(payload: ScreenPayload, selectedCardId: String) async throws -> Destination {
    try await Task.sleep(nanoseconds: 200_000_000)
    if shouldFailCTA { throw MockError.forced }
    return .physicalBranchPicker
  }

  func updateCupoAfterFailure(payload: ScreenPayload) async throws -> ScreenPayload {
    try await Task.sleep(nanoseconds: 200_000_000)
    // Aquí simulas el backend: “al aceptar, cupo cambia”
    let newCupo = updateCupoSetsFalse ? false : payload.hasCupo

    return ScreenPayload(
      flowType: payload.flowType,
      hasCupo: newCupo,
      userName: payload.userName,
      availableAmount: payload.availableAmount,
      backendMessage: payload.backendMessage,
      cards: payload.cards
    )
  }
}


⸻

6) ScreenView.swift (tonta: solo pinta ViewData)

import SwiftUI

struct ScreenView: View {
  @StateObject var vm: ScreenViewModel

  var body: some View {
    VStack(spacing: 16) {
      Text(vm.viewData.headerTitle)
        .font(.title2)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)

      switch vm.viewData.phase {
      case .idle, .loading:
        ProgressView().frame(maxWidth: .infinity)

      case .failed:
        Button(L10n.retry) { vm.send(.retry) }
          .frame(maxWidth: .infinity)

      case .loaded:
        ForEach(vm.viewData.sections) { section in
          render(section)
        }

        Button(vm.viewData.cta.title) { vm.send(.tapCTA) }
          .disabled(!vm.viewData.cta.isEnabled)
          .frame(maxWidth: .infinity)
      }

      Spacer()
    }
    .padding()
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
      guard newRoute != nil else { return }
      // Aquí integrarías navegación real.
      // Limpieza:
      vm.route = nil
    }
  }

  @ViewBuilder
  private func render(_ section: SectionVM) -> some View {
    switch section {
    case .cards(let s):
      CardsSection(vm: s) { id in vm.send(.tapCard(id: id)) }

    case .banner(let s):
      Text(s.text)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(12)

    case .cupo(let s):
      VStack(alignment: .leading, spacing: 6) {
        Text(s.title).font(.headline)
        Text(s.amountText)
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.gray.opacity(0.12))
      .cornerRadius(12)

    case .info(let s):
      VStack(alignment: .leading, spacing: 6) {
        Text(s.title).font(.headline)
        Text(s.body).font(.subheadline)
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.blue.opacity(0.08))
      .cornerRadius(12)
    }
  }
}

struct CardsSection: View {
  let vm: CardsSectionVM
  let onTap: (String) -> Void

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 12) {
        ForEach(vm.items) { item in
          CardCell(item: item, isSelected: item.id == vm.selectedId)
            .onTapGesture { onTap(item.id) }
        }
      }
      .padding(.vertical, 4)
    }
  }
}

struct CardCell: View {
  let item: CardItemVM
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Image(systemName: item.imageSystemName)
        .resizable()
        .scaledToFit()
        .padding(12)
        .frame(height: 72)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)

      Text(item.title).font(.headline)
      Text(item.subtitle).font(.subheadline)
    }
    .padding()
    .frame(width: 220, alignment: .leading)
    .background(isSelected ? Color.gray.opacity(0.15) : Color.clear)
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3))
    )
    .cornerRadius(12)
  }
}


⸻

7) AppHost.swift (para probar escenarios y comportamiento)

import SwiftUI

struct AppHostView: View {
  @State private var scenario: MockScreenRepository.Scenario = .digitalHasCupo
  @State private var failCTA: Bool = true

  var body: some View {
    NavigationStack {
      VStack(spacing: 12) {
        controls
        ScreenView(vm: makeVM())
          .navigationTitle("Demo")
          .navigationBarTitleDisplayMode(.inline)
      }
      .padding(.horizontal)
    }
  }

  private var controls: some View {
    VStack(alignment: .leading, spacing: 8) {
      Picker("Escenario", selection: $scenario) {
        Text("Digital + Cupo").tag(MockScreenRepository.Scenario.digitalHasCupo)
        Text("Digital + No Cupo").tag(MockScreenRepository.Scenario.digitalNoCupo)
        Text("Físico + Cupo").tag(MockScreenRepository.Scenario.fisicoHasCupo)
        Text("Físico + No Cupo").tag(MockScreenRepository.Scenario.fisicoNoCupo)
      }
      .pickerStyle(.menu)

      Toggle("Forzar fallo CTA (modal)", isOn: $failCTA)
    }
    .padding(.vertical, 8)
  }

  private func makeVM() -> ScreenViewModel {
    let repo = MockScreenRepository()
    repo.scenario = scenario
    repo.shouldFailCTA = failCTA

    let presenter = ScreenPresenter()
    let analytics = ConsoleAnalytics()

    return ScreenViewModel(
      presenter: presenter,
      load: LoadScreenUseCase(repo: repo),
      startDigital: StartDigitalFlowUseCase(repo: repo),
      startPhysical: StartPhysicalFlowUseCase(repo: repo),
      updateCupo: UpdateCupoUseCase(repo: repo),
      analytics: analytics
    )
  }
}

@main
struct DemoApp: App {
  var body: some Scene {
    WindowGroup {
      AppHostView()
    }
  }
}


⸻

Qué casos de uso cubre (exactamente lo que pediste)
	1.	Obtener info del backend → LoadScreenUseCase
	2.	Flags flowType y hasCupo → secciones condicionales por Presenter + factories
	3.	Textos constantes → L10n (no en state)
	4.	Cards con imagen + selección → cambia sección Info y habilita CTA
	5.	CTA valida flujo → VM elige use case según flowType
	6.	Success → route para navegar
	7.	Fail → modal
	8.	Aceptar modal → UpdateCupoUseCase → cambia hasCupo → Presenter cambia UI
	9.	Analítica en acciones clave (screenLoaded, cardSelected, ctaFailed, modalAccepted, cupoUpdateSucceeded, etc.)

⸻

Si quieres el siguiente “punto de control” (muy útil), lo que haría ahora es agregar tests (sin SwiftUI) para validar:
	•	Presenter.build() con payload cupo/no cupo
	•	VM.tapCTA falla → modal → accept → cupo false (por UC) → sections cambian

Dime si prefieres tests con XCTest (iOS) o si lo dejamos solo en la app demo.