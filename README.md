from pathlib import Path

readme = """# BioCatchModule

Módulo iOS para encapsular la integración con el SDK externo de **BioCatch**.

Este repositorio centraliza la configuración y el uso operativo del SDK, evitando que la app host y los módulos funcionales dependan directamente del vendor SDK o de sus restricciones técnicas.

---

## Estado del proyecto

- Estado: Nuevo repositorio / Base inicial

- Plataforma mínima: iOS 14+

- Swift: 5.9

- Distribución soportada:

  - Swift Package Manager

  - CocoaPods

- Alcance:

  - Configuración del SDK

  - Tracking operativo

  - Encapsulación de `MainActor` / main thread

  - Wrapper del SDK vendor

---

## Propósito

Este módulo existe para resolver estos problemas:

- Evitar imports directos del SDK de BioCatch desde la app host o features.

- Separar la configuración inicial del uso operativo del tracker.

- Centralizar la restricción técnica del SDK que exige uso en main thread.

- Entregar una API pública simple y estable para módulos funcionales.

- Reducir acoplamiento entre features y detalles de integración del vendor.

---

## Objetivos

- Encapsular completamente el SDK vendor de BioCatch.

- Permitir que la app host configure BioCatch una sola vez.

- Permitir que features o módulos consuman solo la API pública de tracking.

- Separar claramente:

  - configuración

  - tracking

  - runtime interno

- Facilitar testing del módulo sin depender del SDK real.

- Preparar el repositorio para evolución futura por productos separados.

## No objetivos

- No resolver la lógica de negocio de login, antifraude o autorización.

- No decidir ambientes (`dev`, `qa`, `cert`, `prod`) dentro de la librería.

- No exponer el SDK vendor como dependencia pública.

- No convertir el módulo en fuente de verdad del estado funcional de la app.

---

## Arquitectura general

La solución se organiza en tres áreas:

### 1. Configuration

API pública usada por la **app host** para construir y enviar la configuración inicial del SDK.

### 2. Tracking

API pública usada por **features o módulos funcionales** para ejecutar tracking operativo.

### 3. Runtime

Implementación interna responsable de:

- encapsular el SDK vendor

- ejecutar operaciones en main thread

- centralizar engine, adapter y dispatcher

- aislar detalles técnicos del vendor

---

## Estructura del repositorio

```text

BioCatchModule/

├── Package.swift

├── Vendor/

│   └── BioCatchSDK.xcframework

└── Sources/

    ├── BioCatchRuntime/

    │   ├── BioCatchDispatcher.swift

    │   ├── BioCatchEngine.swift

    │   ├── BioCatchLogger.swift

    │   ├── BioCatchSDKAdapter.swift

    │   └── VendorBioCatchAdapter.swift

    ├── BioCatchConfiguration/

    │   ├── BioCatchConfiguration.swift

    │   └── BioCatchBootstrap.swift

    └── BioCatchTracking/

        ├── BioCatchTracking.swift

        └── BioCatchTracker.swift

```

---

## Productos y responsabilidades

### `BioCatchConfiguration`

Producto público orientado a la app host.

Responsabilidad:

- recibir una configuración ya construida por la app host

- disparar el proceso de bootstrap del runtime

Expone:

- `BioCatchConfiguration`

- `BioCatchBootstrap`

### `BioCatchTracking`

Producto público orientado a módulos y features.

Responsabilidad:

- permitir ejecutar tracking sin conocer detalles del SDK

- exponer una fachada simple e inyectable

Expone:

- `BioCatchTracking`

- `BioCatchTracker`

### `BioCatchRuntime`

Target interno compartido.

Responsabilidad:

- encapsular el SDK vendor

- absorber la restricción de main thread

- implementar engine, adapter y dispatcher

- centralizar la lógica técnica del wrapper

---

## Flujo de dependencias

```text

AppHost

 ├── BioCatchConfiguration

 └── BioCatchTracking

Feature / Module

 └── BioCatchTracking

BioCatchConfiguration

 └── BioCatchRuntime

      └── BioCatchSDK

BioCatchTracking

 └── BioCatchRuntime

      └── BioCatchSDK

```

Dirección correcta:

```text

BioCatchConfiguration ──► BioCatchRuntime

BioCatchTracking      ──► BioCatchRuntime

BioCatchRuntime       ──► BioCatchSDK

```

Dirección no permitida:

```text

BioCatchRuntime ──► BioCatchConfiguration

BioCatchRuntime ──► BioCatchTracking

```

---

## API pública

### Configuración

```swift

public struct BioCatchConfiguration: Sendable

public enum BioCatchBootstrap

```

Uso esperado:

```swift

let configuration = BioCatchConfiguration(

    projectURL: URL(string: "https://qa-biocatch.example.com")!,

    customerID: "customer-qa",

    customerSessionID: nil,

    hybridSolution: false

)

BioCatchBootstrap.configure(configuration)

```

### Tracking

```swift

public protocol BioCatchTracking: AnyObject, Sendable

public final class BioCatchTracker: BioCatchTracking, Sendable

```

Uso esperado:

```swift

BioCatchTracker.shared.changeContext("transfer")

BioCatchTracker.shared.flush()

```

O por inyección:

```swift

final class TransferPresenter {

    private let tracker: BioCatchTracking

    init(tracker: BioCatchTracking = BioCatchTracker.shared) {

        self.tracker = tracker

    }

}

```

---

## Encapsulación de concurrencia y main thread

El SDK vendor de BioCatch exige ejecución en el hilo principal.

Este módulo encapsula esa restricción dentro de `BioCatchRuntime`, de forma que los consumidores **no** tengan que hacer esto:

```swift

Task { @MainActor in ... }

DispatchQueue.main.async { ... }

await MainActor.run { ... }

```

La librería absorbe esa responsabilidad mediante:

- `BioCatchDispatcher`

- `BioCatchEngine`

- `VendorBioCatchAdapter`

### Regla arquitectónica

La restricción de main thread es una restricción del **SDK vendor**, no una responsabilidad de los módulos funcionales.

Por eso debe quedar encapsulada en la librería.

---

## Patrones de diseño aplicados

### Bootstrap Pattern

`BioCatchBootstrap` separa la configuración inicial del uso operativo.

```swift

BioCatchBootstrap.configure(configuration)

```

La app host es responsable de ejecutar el bootstrap.

### Facade Pattern

`BioCatchTracker.shared` actúa como fachada pública para features y módulos.

```swift

BioCatchTracker.shared.changeContext("transfer")

```

Esto oculta:

- `BioCatchEngine`

- `VendorBioCatchAdapter`

- `BioCatchDispatcher`

- el SDK vendor

- la lógica de `MainActor`

### Adapter Pattern

`VendorBioCatchAdapter` adapta la API real del SDK externo a un contrato interno controlado por el módulo.

```swift

protocol BioCatchSDKAdapter

final class VendorBioCatchAdapter: BioCatchSDKAdapter

```

Si cambia el SDK vendor, el impacto queda concentrado en esta capa.

### Dispatcher interno

`BioCatchDispatcher` encapsula el salto al `MainActor` y desacopla la API pública de la restricción de main thread.

### Singleton técnico interno

`BioCatchEngine.shared` centraliza:

- la configuración

- el control de uso antes y después de configurar

- el acceso real al SDK

- la coordinación interna del wrapper

No se expone públicamente.

### Dependency Inversion

Los módulos pueden depender de `BioCatchTracking` y no directamente de `BioCatchTracker`.

Esto permite:

- inyección limpia

- tests con mocks y spies

- menor acoplamiento a implementación concreta

---

## Instalación por Swift Package Manager

### App host

La app host debe agregar los productos:

- `BioCatchConfiguration`

- `BioCatchTracking`

Ejemplo:

```swift

.product(name: "BioCatchConfiguration", package: "BioCatchModule"),

.product(name: "BioCatchTracking", package: "BioCatchModule")

```

### Módulo / Feature

Un módulo funcional debe agregar solo:

```swift

.product(name: "BioCatchTracking", package: "BioCatchModule")

```

---

## Instalación por CocoaPods

### App host

```ruby

target 'AppHost' do

  use_frameworks!

  pod 'BioCatchConfiguration'

  pod 'BioCatchTracking'

end

```

### Feature module

```ruby

s.dependency 'BioCatchTracking'

```

---

## Ejemplo de uso desde la app host

```swift

import Foundation

import BioCatchConfiguration

enum CloudEnvironment {

    case dev

    case qa

    case certification

    case production

}

extension CloudEnvironment {

    var bioCatchConfiguration: BioCatchConfiguration {

        switch self {

        case .dev:

            return .init(

                projectURL: URL(string: "https://dev-biocatch.example.com")!,

                customerID: "customer-dev"

            )

        case .qa:

            return .init(

                projectURL: URL(string: "https://qa-biocatch.example.com")!,

                customerID: "customer-qa"

            )

        case .certification:

            return .init(

                projectURL: URL(string: "https://cert-biocatch.example.com")!,

                customerID: "customer-cert"

            )

        case .production:

            return .init(

                projectURL: URL(string: "https://prod-biocatch.example.com")!,

                customerID: "customer-prod"

            )

        }

    }

}

final class AppStartup {

    private let environment: CloudEnvironment

    init(environment: CloudEnvironment) {

        self.environment = environment

    }

    func configureBioCatch() {

        BioCatchBootstrap.configure(environment.bioCatchConfiguration)

    }

}

```

---

## Ejemplo de uso desde un feature o módulo

```swift

import BioCatchTracking

final class TransferPresenter {

    private let tracker: BioCatchTracking

    init(tracker: BioCatchTracking = BioCatchTracker.shared) {

        self.tracker = tracker

    }

    func onViewDidAppear() {

        tracker.changeContext("transfer")

    }

    func onViewDidDisappear() {

        tracker.flush()

    }

}

```

---

## Ejemplo de uso en login con casos async

El módulo BioCatch no almacena `currentSessionID`.

El valor que llega desde backend se usa directamente por la feature.

```swift

import Foundation

import BioCatchTracking

protocol FetchBioCatchSessionUseCase {

    func execute() async throws -> String

}

protocol ValidateLoginContinuationUseCase {

    func execute(sessionID: String) async throws -> Bool

}

final class LoginPresenter {

    private let tracker: BioCatchTracking

    private let fetchBioCatchSessionUseCase: FetchBioCatchSessionUseCase

    private let validateLoginContinuationUseCase: ValidateLoginContinuationUseCase

    init(

        tracker: BioCatchTracking = BioCatchTracker.shared,

        fetchBioCatchSessionUseCase: FetchBioCatchSessionUseCase,

        validateLoginContinuationUseCase: ValidateLoginContinuationUseCase

    ) {

        self.tracker = tracker

        self.fetchBioCatchSessionUseCase = fetchBioCatchSessionUseCase

        self.validateLoginContinuationUseCase = validateLoginContinuationUseCase

    }

    func onLoginStarted() {

        Task {

            do {

                let freshSessionID = try await fetchBioCatchSessionUseCase.execute()

                tracker.updateCustomerSessionID(freshSessionID)

                let canContinue = try await validateLoginContinuationUseCase.execute(

                    sessionID: freshSessionID

                )

                if canContinue {

                    print("Continuar login")

                } else {

                    print("Bloquear login")

                }

            } catch {

                print("Mostrar error: \\(error)")

            }

        }

    }

}

```

---

## Testing

El módulo se testea en tres niveles.

### `BioCatchConfigurationTests`

Cubre:

- inicialización de `BioCatchConfiguration`

- valores por defecto

- persistencia de propiedades públicas

### `BioCatchRuntimeTests`

Cubre:

- `configure` llama `start`

- `configure` no se ejecuta dos veces

- `changeContext`

- `updateCustomerSessionID`

- `setCustomerBrand`

- `startNewSession`

- `pause`

- `resume`

- `stop`

- `flush`

- validación de que no se reenvían acciones antes de configurar

### `BioCatchTrackingTests`

Cubre:

- disponibilidad de `BioCatchTracker.shared`

- conformidad con `BioCatchTracking`

- conformidad con `Sendable`

### Ejecutar tests

```bash

swift test

```

---

## Versionado

Se recomienda seguir versionado semántico:

- `MAJOR`: cambios incompatibles

- `MINOR`: nuevas capacidades compatibles

- `PATCH`: fixes internos

Ejemplos:

```text

1.0.0

1.1.0

1.1.1

2.0.0

```

---

## Estrategia de release

Flujo sugerido:

1. implementar cambios en branch feature

2. abrir Pull Request

3. correr tests

4. revisar arquitectura y API

5. hacer merge a rama principal

6. crear tag

7. publicar nueva versión para SPM y CocoaPods

---

## Decisiones técnicas relevantes

### ¿Por qué la app host construye `BioCatchConfiguration`?

Porque la app host conoce:

- el ambiente real

- URLs

- customer IDs

- políticas de configuración

La librería no debe depender del enum de ambiente del host.

### ¿Por qué existe `BioCatchEngine`?

Para centralizar:

- ciclo de vida

- configuración

- acceso al adapter

- uso correcto del SDK

### ¿Por qué existe `BioCatchDispatcher`?

Para encapsular la restricción técnica de main thread del vendor SDK.

### ¿Por qué `BioCatchTracker.shared`?

Porque permite:

- una API pública simple

- consumo directo

- inyección opcional por protocolo

- testabilidad sin exponer el runtime

### ¿Por qué `VendorBioCatchAdapter` no es singleton?

Porque no gestiona ciclo de vida ni estado. Solo traduce llamadas del engine al SDK vendor.

### ¿Por qué `BioCatchTracker` es `Sendable`?

Porque expone una instancia compartida (`shared`) y no guarda estado mutable. Solo delega al dispatcher.

---

## Troubleshooting

### Error: uso antes de configurar

Asegurar que la app host llame `BioCatchBootstrap.configure(...)` durante el arranque.

### Error: warnings de concurrencia con `shared`

Verificar que `BioCatchTracker` conforme a `Sendable` y que no tenga estado mutable propio.

### Error: el SDK no responde en runtime

Verificar:

- URL correcta

- `customerID` correcto

- orden de inicialización

- integración correcta del `.xcframework`

### Error: módulo feature depende de configuración

Revisar dependencias del product target. Un feature debe depender solo de `BioCatchTracking`.

---

## Roadmap

- Completar cobertura de tests del módulo

- Documentar flujo de publicación de tags y releases

- Agregar ejemplo oficial de integración en app host

- Agregar ejemplo oficial de integración en feature module

- Evaluar evolución futura a una estructura aún más desacoplada si aparecen nuevos casos de uso

- Revisar observabilidad y logging interno del runtime

---

## Mantenedores

- Equipo iOS / Plataforma

- Contacto: ios@empresa.com

"""

path = Path("/mnt/data/README_BioCatchModule.md")

path.write_text(readme, encoding="utf-8")

print(f"Saved to {path}")