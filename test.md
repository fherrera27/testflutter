Perfecto. Vamos a completar lo que falta para que la pantalla de la imagen sea implementable de forma “enterprise”: Presenter + ViewData + helpers/patterns para textos (incluyendo bold/segmentado), formateadores (money/UF), base64 image, y composición de secciones.

La idea: el ViewModel solo orquesta y mantiene ScreenState.
El Presenter toma ScreenState + OfferModel y construye ViewData lista para la View.

⸻

1) ViewData “lista para renderizar” (sin negocio, pero sí estructura UI)

// Presentation/ViewData/CardUpgradeViewData.swift

import Foundation

struct CardUpgradeViewData: Equatable {
  var navigationTitle: String
  var headerTitle: String

  var carousel: CardCarouselVM
  var sections: [SectionVM]

  var disclaimer: DisclaimerVM?
  var infoBox: InfoBoxVM?

  var cta: CTAVM

  var modal: ModalVM?
  var route: Route?
}

struct CardCarouselVM: Equatable {
  var selectedId: String?
  var items: [CardCarouselItemVM]
}

struct CardCarouselItemVM: Equatable, Identifiable {
  let id: String
  let badgeText: String?      // “NUEVA TARJETA”
  let artBase64: String?
  let name: String            // “Gold / Infinite”
  let monthlyFee: String      // “Comisión mensual UF 0,21”
  let isSelected: Bool
}

struct SectionVM: Equatable, Identifiable {
  enum Kind: Equatable {
    case textBlocks([TextBlockVM])  // “TIPO DE TARJETA”, “CUPO”
    case bullets([BulletVM])        // “BENEFICIOS”
    case keyValues([KeyValueVM])    // “TARIFAS”
  }

  let id: String      // min 3 chars
  let title: String   // “TIPO DE TARJETA”
  let kind: Kind
}

struct TextBlockVM: Equatable, Identifiable {
  let id: String
  let text: StyledTextVM
}

struct BulletVM: Equatable, Identifiable {
  let id: String
  let text: StyledTextVM
}

struct KeyValueVM: Equatable, Identifiable {
  let id: String
  let title: String
  let value: String
}

struct DisclaimerVM: Equatable {
  let iconName: String?
  let text: StyledTextVM
  let linkText: String?
  let linkURL: String?
}

struct InfoBoxVM: Equatable {
  let iconName: String?
  let text: StyledTextVM
}

struct CTAVM: Equatable {
  let title: String
  let isLoading: Bool
  let isEnabled: Bool
}

struct ModalVM: Equatable {
  enum Kind: Equatable { case switchToNoLimit, genericError }
  let kind: Kind
  let title: String
  let message: String
  let primaryTitle: String
  let secondaryTitle: String?
}


⸻

2) Pattern clave para textos: StyledTextVM + helpers

Esto resuelve:
	•	párrafos con bold en partes
	•	L10n con placeholders (%@, {{amount}})
	•	o strings backend con **bold**

// Presentation/Text/StyledTextVM.swift

import Foundation

struct StyledTextVM: Equatable {
  struct Segment: Equatable, Identifiable {
    let id: String
    let text: String
    let style: Style
  }
  enum Style: Equatable { case regular, bold }

  let segments: [Segment]

  static func plain(_ text: String) -> StyledTextVM {
    .init(segments: [.init(id: "seg_regular", text: text, style: .regular)])
  }
}

Helper 1: desde plantilla L10n con tokens {{}}

// Presentation/Text/TemplateText.swift

import Foundation

enum TemplateText {
  /// Ej: "Podrás solicitar tu {{offerName}} y mantener tu cupo de {{amount}}."
  static func fromTokens(
    _ template: String,
    tokens: [String: (String, StyledTextVM.Style)]
  ) -> StyledTextVM {
    // Split simple por {{key}} (determinístico, sin regex heavy)
    var result: [StyledTextVM.Segment] = []
    var buffer = template

    while let start = buffer.range(of: "{{"),
          let end = buffer.range(of: "}}", range: start.upperBound..<buffer.endIndex) {
      let before = String(buffer[..<start.lowerBound])
      if !before.isEmpty {
        result.append(.init(id: "seg_\(result.count)", text: before, style: .regular))
      }

      let key = String(buffer[start.upperBound..<end.lowerBound])
      if let (value, style) = tokens[key] {
        result.append(.init(id: "seg_\(result.count)", text: value, style: style))
      } else {
        // fallback: deja el token literal si falta
        result.append(.init(id: "seg_\(result.count)", text: "{{\(key)}}", style: .regular))
      }

      buffer = String(buffer[end.upperBound...])
    }

    if !buffer.isEmpty {
      result.append(.init(id: "seg_\(result.count)", text: buffer, style: .regular))
    }

    return .init(segments: result)
  }

  /// Ej: backend: "texto **bold** texto"
  static func fromMarkdownBold(_ text: String) -> StyledTextVM {
    // Parse minimal: **...**
    var segments: [StyledTextVM.Segment] = []
    var i = text.startIndex

    func append(_ s: String, _ style: StyledTextVM.Style) {
      guard !s.isEmpty else { return }
      segments.append(.init(id: "seg_\(segments.count)", text: s, style: style))
    }

    while i < text.endIndex {
      if text[i...].hasPrefix("**"),
         let end = text[text.index(i, offsetBy: 2)...].range(of: "**") {
        // regular before
        let before = String(text[text.startIndex..<i])
        // OJO: para mantener simple, reconstruimos incremental:
        // mejor: usamos un "cursorStart". Mantengo simple con buffer.
        break
      }
      i = text.index(after: i)
    }

    // Versión robusta sin complicar: split por "**"
    let parts = text.components(separatedBy: "**")
    for (idx, p) in parts.enumerated() {
      append(p, (idx % 2 == 1) ? .bold : .regular)
    }
    return .init(segments: segments)
  }
}


⸻

3) Formateadores (money / porcentaje / UF) como helpers “presentation utilities”

Dominio entrega RateValueModel tipado. Presenter decide string.

// Presentation/Formatters/RateValueFormatter.swift

import Foundation

struct RateValueFormatter {
  func format(_ value: RateValueModel) -> String {
    switch value {
    case .perTransaction(let s):
      return s
    case .percentage(let p):
      return formatPercent(p)
    case .amount(let a, let currency):
      return "\(currency) \(formatDecimal(a))"
    case .unknown:
      return "—"
    }
  }

  private func formatPercent(_ d: Decimal) -> String {
    // 2.5 -> "2,5%" según locale; aquí simple (ajusta NumberFormatter si quieres)
    return "\(formatDecimal(d))%"
  }

  private func formatDecimal(_ d: Decimal) -> String {
    let nf = NumberFormatter()
    nf.numberStyle = .decimal
    nf.maximumFractionDigits = 2
    nf.minimumFractionDigits = 0
    nf.decimalSeparator = ","
    nf.groupingSeparator = "."
    return nf.string(from: d as NSDecimalNumber) ?? "\(d)"
  }
}


⸻

4) Presenter: UI Policy (aquí se arma TODO lo de la pantalla)

El Presenter:
	•	elige tarjeta seleccionada
	•	arma carrusel
	•	arma secciones (Tipo/Cupo/Beneficios/Tarifas)
	•	arma disclaimer + infobox
	•	arma CTA
	•	arma modal texts (esto es presentación, no negocio)

// Presentation/Presenter/CardUpgradePresenter.swift

import Foundation

struct CardUpgradePresenter {

  private let rateFormatter: RateValueFormatter
  private let copy: CardUpgradeCopy // textos constantes

  init(rateFormatter: RateValueFormatter, copy: CardUpgradeCopy) {
    self.rateFormatter = rateFormatter
    self.copy = copy
  }

  func build(from state: CardUpgradeScreenState) -> CardUpgradeViewData {
    // Loading / error sin snapshot
    guard let snapshot = state.snapshot else {
      return CardUpgradeViewData(
        navigationTitle: copy.navTitle,
        headerTitle: copy.headerTitle,
        carousel: .init(selectedId: nil, items: []),
        sections: [],
        disclaimer: nil,
        infoBox: nil,
        cta: CTAVM(title: copy.ctaTitle, isLoading: state.actionPhase == .loading, isEnabled: false),
        modal: modalVM(from: state.modal),
        route: state.route
      )
    }

    let selected = selectedCard(from: snapshot, selectedId: state.selectedCardId)

    let carousel = buildCarousel(snapshot: snapshot, selectedId: selected.id)
    let sections = buildSections(snapshot: snapshot, selected: selected, flowMode: state.flowMode)

    return CardUpgradeViewData(
      navigationTitle: copy.navTitle,
      headerTitle: copy.headerTitle,
      carousel: carousel,
      sections: sections,
      disclaimer: buildDisclaimer(),
      infoBox: buildInfoBox(flowMode: state.flowMode),
      cta: CTAVM(
        title: copy.ctaTitle,
        isLoading: state.actionPhase == .loading,
        isEnabled: state.phase == .loaded && state.actionPhase != .loading
      ),
      modal: modalVM(from: state.modal),
      route: state.route
    )
  }

  private func selectedCard(from snapshot: OfferModel, selectedId: String?) -> CardModel {
    if let id = selectedId, let found = snapshot.details.offered.first(where: { $0.id == id }) {
      return found
    }
    return snapshot.details.offered.first ?? snapshot.details.current
  }

  private func buildCarousel(snapshot: OfferModel, selectedId: String) -> CardCarouselVM {
    let items = snapshot.details.offered.map { card in
      CardCarouselItemVM(
        id: card.id,
        badgeText: copy.badgeNewCard,
        artBase64: card.cardArtBase64,
        name: copy.cardDisplayName(for: card.id),              // o desde Domain si existe
        monthlyFee: copy.monthlyFeePrefix + " " + copy.monthlyFeeValue(for: card),
        isSelected: card.id == selectedId
      )
    }
    return .init(selectedId: selectedId, items: items)
  }

  private func buildSections(
    snapshot: OfferModel,
    selected: CardModel,
    flowMode: UpgradeFlowMode
  ) -> [SectionVM] {

    var result: [SectionVM] = []

    // 1) TIPO DE TARJETA
    let cardTypeText = copy.cardTypeParagraph(flowMode: flowMode)
    result.append(
      SectionVM(
        id: "sec_card_type",
        title: copy.sectionCardType,
        kind: .textBlocks([
          TextBlockVM(id: "tb_card_type", text: cardTypeText)
        ])
      )
    )

    // 2) CUPO
    let cupoText = copy.creditLimitParagraph(flowMode: flowMode)
    result.append(
      SectionVM(
        id: "sec_credit_limit",
        title: copy.sectionCreditLimit,
        kind: .textBlocks([
          TextBlockVM(id: "tb_credit", text: cupoText)
        ])
      )
    )

    // 3) BENEFICIOS (bullets)
    let bullets: [BulletVM] = selected.benefits.map { b in
      BulletVM(
        id: "ben_\(b.id)",
        text: StyledTextVM.plain([b.title, b.value].compactMap { $0 }.joined(separator: " "))
      )
    }
    if !bullets.isEmpty {
      result.append(
        SectionVM(
          id: "sec_benefits",
          title: copy.sectionBenefits,
          kind: .bullets(bullets)
        )
      )
    }

    // 4) TARIFAS (key-values)
    let kv: [KeyValueVM] = selected.rates.map { r in
      KeyValueVM(
        id: "fee_\(r.id)",
        title: r.title ?? "",
        value: rateFormatter.format(r.value)
      )
    }
    if !kv.isEmpty {
      result.append(
        SectionVM(
          id: "sec_fees",
          title: copy.sectionFees,
          kind: .keyValues(kv)
        )
      )
    }

    return result
  }

  private func buildDisclaimer() -> DisclaimerVM {
    DisclaimerVM(
      iconName: "speaker", // placeholder
      text: StyledTextVM.plain(copy.disclaimerText),
      linkText: copy.disclaimerLinkText,
      linkURL: copy.disclaimerLinkURL
    )
  }

  private func buildInfoBox(flowMode: UpgradeFlowMode) -> InfoBoxVM? {
    InfoBoxVM(
      iconName: "info",
      text: copy.infoBoxText(flowMode: flowMode)
    )
  }

  private func modalVM(from modal: ModalState?) -> ModalVM? {
    guard let modal else { return nil }
    switch modal.kind {
    case .switchToNoLimit:
      return ModalVM(
        kind: .switchToNoLimit,
        title: copy.modalSwitchTitle,
        message: copy.modalSwitchMessage,
        primaryTitle: copy.modalSwitchPrimary,
        secondaryTitle: copy.modalSwitchSecondary
      )
    case .genericError:
      return ModalVM(
        kind: .genericError,
        title: copy.modalErrorTitle,
        message: copy.modalErrorMessage,
        primaryTitle: copy.modalErrorPrimary,
        secondaryTitle: nil
      )
    }
  }
}


⸻

5) Copy/Texts: un “copy provider” para no contaminar Presenter

Esto te permite:
	•	centralizar textos
	•	soportar L10n (sin meter NSLocalizedString directo por todas partes)
	•	soportar templates con bold

// Presentation/Copy/CardUpgradeCopy.swift

import Foundation

struct CardUpgradeCopy {

  // Nav/header
  let navTitle = "Upgrade Tarjeta de Crédito"
  let headerTitle = "¡Mejora tu Tarjeta de Crédito!"

  // Carousel
  let badgeNewCard = "NUEVA TARJETA"
  let monthlyFeePrefix = "Comisión mensual"

  // Sections
  let sectionCardType = "TIPO DE TARJETA"
  let sectionCreditLimit = "CUPO"
  let sectionBenefits = "BENEFICIOS"
  let sectionFees = "TARIFAS"

  // CTA
  let ctaTitle = "Continuar"

  // Disclaimer
  let disclaimerText = "Conoce el detalle de todos estos beneficios, antes de la contratación de cualquier producto o servicio."
  let disclaimerLinkText = "www.aurorabank.cl"
  let disclaimerLinkURL = "https://www.aurorabank.cl"

  // Infobox
  func infoBoxText(flowMode: UpgradeFlowMode) -> StyledTextVM {
    // Ejemplo con bold parcial usando TemplateText
    let template = "La deuda de tu **tarjeta actual** se traspasará a la nueva. Tu tarjeta actual se eliminará dentro de **24 horas**."
    return TemplateText.fromMarkdownBold(template)
  }

  // Modals
  let modalSwitchTitle = "Atención"
  let modalSwitchMessage = "Para continuar sin aumento de cupo, confirma."
  let modalSwitchPrimary = "Aceptar"
  let modalSwitchSecondary = "Cancelar"

  let modalErrorTitle = "Error"
  let modalErrorMessage = "No pudimos continuar. Intenta nuevamente."
  let modalErrorPrimary = "Aceptar"

  // Paragraphs: Tipo tarjeta / cupo (sin negocio duro, solo copy según flowMode)
  func cardTypeParagraph(flowMode: UpgradeFlowMode) -> StyledTextVM {
    switch flowMode {
    case .withLimit:
      return StyledTextVM.plain("La nueva tarjeta será de tipo Digital. Una vez contratada podrás solicitar tu tarjeta física.")
    case .noLimit:
      return StyledTextVM.plain("La nueva tarjeta será de tipo Digital. Una vez contratada podrás solicitar tu tarjeta física.")
    }
  }

  func creditLimitParagraph(flowMode: UpgradeFlowMode) -> StyledTextVM {
    switch flowMode {
    case .withLimit:
      return StyledTextVM.plain("Tendrás el mismo cupo que tienes actualmente en tu tarjeta de crédito.")
    case .noLimit:
      return StyledTextVM.plain("Tendrás el mismo cupo que tienes actualmente en tu tarjeta de crédito.")
    }
  }

  // Placeholder: si Domain no trae nombre/fee, aquí los defines.
  func cardDisplayName(for cardId: String) -> String {
    // ideal: si Domain trae productName, no uses esto.
    return cardId.isEmpty ? "Oferta" : "Gold"
  }

  func monthlyFeeValue(for card: CardModel) -> String {
    // si tienes la fee monthly_fee en rates, la puedes buscar aquí y formatear.
    return "UF 0,21"
  }
}

Si mañana Product decide cambiar copy, se toca este archivo, no el Presenter ni la View.

⸻

6) Helpers para View: base64 → Image (iOS14)

// Presentation/View/Helpers/Base64Image.swift

import SwiftUI
import UIKit

struct Base64Image: View {
  let base64: String?

  var body: some View {
    if let uiImage = decode() {
      Image(uiImage: uiImage).resizable().scaledToFit()
    } else {
      Rectangle().opacity(0.1)
    }
  }

  private func decode() -> UIImage? {
    guard let base64, let data = Data(base64Encoded: base64) else { return nil }
    return UIImage(data: data)
  }
}


⸻

7) Helper para render de StyledTextVM (bold/regular)

// Presentation/View/Components/StyledTextView.swift

import SwiftUI

struct StyledTextView: View {
  let model: StyledTextVM

  var body: some View {
    // iOS14: Text + concatenation
    model.segments.reduce(Text("")) { partial, seg in
      let t = Text(seg.text)
      switch seg.style {
      case .regular:
        return partial + t
      case .bold:
        return partial + t.bold()
      }
    }
  }
}


⸻

8) Cómo quedaría la View (solo para mostrar el “shape”)

(No la detallo completa ahora, pero esto es la composición correcta.)

// Presentation/View/CardUpgradeView.swift

import SwiftUI

struct CardUpgradeView: View {
  @ObservedObject var vm: CardUpgradeViewModel

  var body: some View {
    VStack(spacing: 0) {

      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          Text(vm.viewData.headerTitle).font(.headline)

          OfferCarouselSection_iOS14(
            model: vm.viewData.carousel,
            onSelect: { vm.selectCard(id: $0) }
          )

          ForEach(vm.viewData.sections) { section in
            SectionView(section: section)
          }

          if let disclaimer = vm.viewData.disclaimer {
            DisclaimerView(model: disclaimer)
          }

          if let info = vm.viewData.infoBox {
            InfoBoxView(model: info)
          }
        }
        .padding(16)
      }

      CTAButton(
        title: vm.viewData.cta.title,
        isLoading: vm.viewData.cta.isLoading,
        isEnabled: vm.viewData.cta.isEnabled,
        onTap: { vm.tapContinue() }
      )
      .padding(16)
    }
    .navigationTitle(vm.viewData.navigationTitle)
    .onAppear { vm.onAppear() }
    .alert(item: modalBinding) { modal in
      // iOS14: 1 o 2 botones
      if let secondary = modal.secondaryTitle {
        return Alert(
          title: Text(modal.title),
          message: Text(modal.message),
          primaryButton: .default(Text(modal.primaryTitle), action: { vm.modalPrimaryAction() }),
          secondaryButton: .cancel(Text(secondary), action: { vm.modalSecondaryAction() })
        )
      } else {
        return Alert(
          title: Text(modal.title),
          message: Text(modal.message),
          dismissButton: .default(Text(modal.primaryTitle), action: { vm.modalPrimaryAction() })
        )
      }
    }
  }

  private var modalBinding: Binding<ModalVM?> {
    Binding(get: { vm.viewData.modal }, set: { _ in /* no-op */ })
  }
}


⸻

9) Carrusel iOS14: pattern (resumen, no full code)

Tu pregunta anterior era: “selected según lo que se ve”.
El patrón correcto en iOS14 es:
	•	cada item reporta su midX en coordenadas globales mediante PreferenceKey
	•	el container calcula cuál está más cerca del centro del viewport
	•	dispara onSelect(id) con debounce

Si quieres, te dejo el OfferCarouselSection_iOS14 completo en el siguiente mensaje.

⸻

Qué logramos con estos “helpers/patterns”
	•	Textos segmentados (bold/regular) sin ensuciar ViewModel.
	•	Presenter arma la pantalla desde modelos tipados (benefits/rates).
	•	Data no crea strings.
	•	Domain no conoce UI.
	•	View es “tonta” y renderiza ViewData.

⸻

Si seguimos, dime qué prefieres como próximo paso (sin fricción):
	1.	Te entrego el OfferCarouselSection_iOS14 completo (auto-select por scroll).
	2.	O te entrego la vista completa con secciones (bullets + key-values) como en la imagen.