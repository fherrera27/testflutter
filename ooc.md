Sí, entonces vayamos a lo simple: solo la vista.

Necesitas:
	•	mostrar tarjetas como imagen
	•	un badge fijo por ahora
	•	poder deslizar
	•	poder tocar una tarjeta
	•	ejecutar una acción como onTap

La solución más simple y eficiente en SwiftUI para salir rápido es:
	•	TabView con estilo paging
	•	una CardCarouselView
	•	una CardItemView
	•	callback onCardTap

⸻

Modelo simple

import Foundation

struct CardCarouselItem: Identifiable, Equatable {
    let id: String
    let imageName: String
    let title: String
    let subtitle: String?
    let isCurrent: Bool
}

Si la imagen por ahora es constante/local, imageName te sirve perfecto.

⸻

Vista de la tarjeta

import SwiftUI

struct CardItemView: View {
    let item: CardCarouselItem
    let onTap: (CardCarouselItem) -> Void

    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .topLeading) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                if item.isCurrent {
                    Text("ACTUAL TARJETA")
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(12)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onTap(item)
            }

            VStack(spacing: 4) {
                Text(item.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)

                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 24)
    }
}


⸻

Carrusel con deslizamiento

import SwiftUI

struct CardCarouselView: View {
    let items: [CardCarouselItem]
    let onCardTap: (CardCarouselItem) -> Void

    @State private var selection: String = ""

    var body: some View {
        VStack(spacing: 16) {
            TabView(selection: $selection) {
                ForEach(items) { item in
                    CardItemView(item: item, onTap: onCardTap)
                        .tag(item.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 320)
            .onAppear {
                if let firstId = items.first?.id {
                    selection = firstId
                }
            }
        }
    }
}


⸻

Uso

import SwiftUI

struct ContentView: View {
    let cards: [CardCarouselItem] = [
        .init(
            id: "1",
            imageName: "card_gold",
            title: "Gold",
            subtitle: "Comisión mensual UF 0,21",
            isCurrent: true
        ),
        .init(
            id: "2",
            imageName: "card_black",
            title: "Black",
            subtitle: "Comisión mensual UF 0,35",
            isCurrent: false
        )
    ]

    var body: some View {
        CardCarouselView(items: cards) { selectedCard in
            print("Tap en tarjeta: \(selectedCard.id)")
        }
    }
}


⸻

Por qué esta solución te sirve ahora

Porque es:
	•	simple
	•	nativa
	•	rápida de implementar
	•	soporta swipe
	•	soporta tap
	•	fácil de escalar después

⸻

Si la imagen no viene de Assets sino de UIImage

Puedes cambiar esto:

let imageName: String

por esto:

let image: UIImage

y en la vista usar:

Image(uiImage: item.image)
    .resizable()
    .scaledToFit()


⸻

Si quieres una versión todavía más reusable

Puedes dejar la vista así:

struct CardCarouselView<Item: Identifiable>: View where Item.ID == String

pero para salir rápido no lo haría ahora.
La versión concreta de arriba es la correcta para urgente.

⸻

Punto fino importante

El onTapGesture está puesto sobre la tarjeta, no sobre todo el carrusel.
Así:
	•	puedes deslizar normalmente
	•	y también tocar una tarjeta para disparar acción

Eso responde justo a lo que pediste.

Si quieres, te doy la versión siguiente con efecto de tarjeta vecina visible como en tu screenshot, porque TabView paging puro normalmente la muestra a ancho completo.