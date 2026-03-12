En simple: lo implementamos como un pager custom con DragGesture.

Para tu caso es la opción más limpia porque necesitas:
	•	iOS 14 / 15+
	•	2 tarjetas
	•	vecina visible
	•	selección clara
	•	tap
	•	diseño controlado

No necesitas meterte ahora en PreferenceKey ni en UICollectionView.

Qué piezas quedan

1. Modelo de item

import UIKit

struct CardCarouselItemViewModel: Identifiable, Equatable {
    let id: String
    let image: UIImage?
    let badgeText: String?
    let title: String
    let subtitle: String?
}

2. ViewModel del carrusel

import Combine

final class CardCarouselViewModel: ObservableObject {
    @Published var cards: [CardCarouselItemViewModel] = []
    @Published var selectedIndex: Int = 0

    var selectedCard: CardCarouselItemViewModel? {
        guard cards.indices.contains(selectedIndex) else { return nil }
        return cards[selectedIndex]
    }

    func applyCards(_ cards: [CardCarouselItemViewModel]) {
        self.cards = cards
        selectedIndex = min(selectedIndex, max(cards.count - 1, 0))
    }

    func select(index: Int) {
        guard cards.indices.contains(index) else { return }
        selectedIndex = index
    }
}

3. Vista de la tarjeta

import SwiftUI

struct CardItemView: View {
    let card: CardCarouselItemViewModel
    let isActive: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            Group {
                if let image = card.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.15))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))

            if let badgeText = card.badgeText {
                Text(badgeText)
                    .font(.caption.weight(.bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black.opacity(0.15), lineWidth: 1)
                    )
                    .padding(10)
            }
        }
        .scaleEffect(isActive ? 1.0 : 0.94)
        .opacity(isActive ? 1.0 : 0.92)
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

4. Indicador

import SwiftUI

struct PageIndicator: View {
    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? Color.primary : Color.secondary.opacity(0.25))
                    .frame(width: index == currentIndex ? 14 : 6, height: 6)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: currentIndex)
    }
}

5. Carrusel final

import SwiftUI

struct CardCarouselView: View {
    @ObservedObject var viewModel: CardCarouselViewModel
    let onTapCard: (CardCarouselItemViewModel) -> Void

    @GestureState private var dragTranslation: CGFloat = 0

    private let cardWidthRatio: CGFloat = 0.78
    private let cardAspectRatio: CGFloat = 1.586
    private let spacing: CGFloat = 16

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let cardWidth = width * cardWidthRatio
            let cardHeight = cardWidth / cardAspectRatio
            let step = cardWidth + spacing
            let sideInset = (width - cardWidth) / 2

            VStack(spacing: 16) {
                HStack(spacing: spacing) {
                    ForEach(Array(viewModel.cards.enumerated()), id: \.1.id) { index, item in
                        CardItemView(
                            card: item,
                            isActive: index == activeIndex(step: step)
                        )
                        .frame(width: cardWidth, height: cardHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.select(index: index)
                            onTapCard(item)
                        }
                    }
                }
                .padding(.horizontal, sideInset)
                .offset(x: currentOffset(step: step))
                .animation(.spring(response: 0.32, dampingFraction: 0.82), value: viewModel.selectedIndex)
                .gesture(
                    DragGesture()
                        .updating($dragTranslation) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            let finalIndex = activeIndex(
                                translation: value.translation.width,
                                step: step
                            )
                            viewModel.select(index: finalIndex)
                        }
                )
                .frame(height: cardHeight)

                if let current = currentCard(step: step) {
                    VStack(spacing: 4) {
                        Text(current.title)
                            .font(.title3.weight(.semibold))

                        if let subtitle = current.subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                PageIndicator(
                    count: viewModel.cards.count,
                    currentIndex: activeIndex(step: step)
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 320)
    }

    private func currentOffset(step: CGFloat) -> CGFloat {
        -CGFloat(viewModel.selectedIndex) * step + dragTranslation
    }

    private func activeIndex(step: CGFloat) -> Int {
        activeIndex(translation: dragTranslation, step: step)
    }

    private func activeIndex(translation: CGFloat, step: CGFloat) -> Int {
        guard !viewModel.cards.isEmpty else { return 0 }

        let rawIndex = (CGFloat(viewModel.selectedIndex) * step - translation) / step
        let rounded = Int(round(rawIndex))

        return min(max(rounded, 0), viewModel.cards.count - 1)
    }

    private func currentCard(step: CGFloat) -> CardCarouselItemViewModel? {
        let index = activeIndex(step: step)
        guard viewModel.cards.indices.contains(index) else { return nil }
        return viewModel.cards[index]
    }
}

6. Uso

struct DemoScreen: View {
    @StateObject private var viewModel = CardCarouselViewModel()

    var body: some View {
        CardCarouselView(viewModel: viewModel) { selectedCard in
            print("tap:", selectedCard.id)
        }
        .onAppear {
            viewModel.applyCards([
                .init(
                    id: "gold",
                    image: UIImage(named: "card_gold"),
                    badgeText: "ACTUAL TARJETA",
                    title: "Gold",
                    subtitle: "Comisión mensual UF 0,21"
                ),
                .init(
                    id: "platinum",
                    image: UIImage(named: "card_platinum"),
                    badgeText: nil,
                    title: "Platinum",
                    subtitle: "Comisión mensual UF 0,35"
                )
            ])
        }
    }
}

Con esto qué obtienes
	•	carrusel horizontal
	•	tarjeta vecina visible
	•	selección en tiempo real mientras arrastras
	•	snap al soltar
	•	tap
	•	título/subtítulo reactivo
	•	iOS 14 / 15+

Decisión final

Así lo implementaría hoy para tu requerimiento.

Si después quieres que la imagen venga desde base64 del backend, el único cambio es mapear antes:

func makeImage(from base64: String?) -> UIImage? {
    guard
        let base64,
        let data = Data(base64Encoded: base64)
    else { return nil }

    return UIImage(data: data)
}

y llenar CardCarouselItemViewModel.image con eso.

Si quieres, el siguiente paso te lo dejo ya con nombres reales de tu proyecto y con el mapper Domain -> CardCarouselItemViewModel.