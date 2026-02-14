Perfecto 👌
Te voy a generar un script .sh profesional y limpio que crea exactamente el árbol que definimos para el feature CardUpgrade, siguiendo Clean Architecture + Feature-First.

Este script:
	•	Crea carpetas
	•	Crea archivos .swift
	•	No sobreescribe si ya existen
	•	Es idempotente (puedes ejecutarlo más de una vez sin romper nada)

⸻

📜 create_card_upgrade_feature.sh

#!/bin/bash

FEATURE_NAME="CardUpgrade"
BASE_DIR="./Features/$FEATURE_NAME"

echo "📁 Creando estructura para feature: $FEATURE_NAME"

# ---------- Helper ----------
create_file() {
  FILE_PATH="$1"
  if [ ! -f "$FILE_PATH" ]; then
    touch "$FILE_PATH"
    echo "  📝 Created: $FILE_PATH"
  else
    echo "  ⚠️  Exists: $FILE_PATH"
  fi
}

create_dir() {
  DIR_PATH="$1"
  mkdir -p "$DIR_PATH"
  echo "  📂 Dir: $DIR_PATH"
}

# ---------- DI ----------
create_dir "$BASE_DIR/DI"
create_file "$BASE_DIR/DI/CardUpgradeAssembly.swift"

# ---------- DOMAIN ----------
create_dir "$BASE_DIR/Domain/Entities"
create_dir "$BASE_DIR/Domain/Contracts"
create_dir "$BASE_DIR/Domain/UseCases"
create_dir "$BASE_DIR/Domain/Policies"
create_dir "$BASE_DIR/Domain/Errors"

create_file "$BASE_DIR/Domain/Entities/CardUpgradeOffer.swift"
create_file "$BASE_DIR/Domain/Entities/CardTier.swift"
create_file "$BASE_DIR/Domain/Entities/CardFlowType.swift"
create_file "$BASE_DIR/Domain/Entities/CupoStatus.swift"
create_file "$BASE_DIR/Domain/Entities/UpgradeDestination.swift"

create_file "$BASE_DIR/Domain/Contracts/CardUpgradeRepository.swift"

create_file "$BASE_DIR/Domain/UseCases/LoadUpgradeOffersUseCase.swift"
create_file "$BASE_DIR/Domain/UseCases/ValidateUpgradeUseCase.swift"
create_file "$BASE_DIR/Domain/UseCases/ConfirmUpgradeUseCase.swift"
create_file "$BASE_DIR/Domain/UseCases/RefreshCupoAfterModalUseCase.swift"

create_file "$BASE_DIR/Domain/Policies/UpgradeEligibilityPolicy.swift"
create_file "$BASE_DIR/Domain/Policies/VisibleSectionsPolicy.swift"

create_file "$BASE_DIR/Domain/Errors/CardUpgradeError.swift"

# ---------- DATA ----------
create_dir "$BASE_DIR/Data/DTO"
create_dir "$BASE_DIR/Data/Mappers"
create_dir "$BASE_DIR/Data/Remote"
create_dir "$BASE_DIR/Data/Repositories"
create_dir "$BASE_DIR/Data/Mock"

create_file "$BASE_DIR/Data/DTO/UpgradeOffersResponseDTO.swift"
create_file "$BASE_DIR/Data/DTO/OfferDTO.swift"
create_file "$BASE_DIR/Data/DTO/BenefitDTO.swift"
create_file "$BASE_DIR/Data/DTO/FeeDTO.swift"

create_file "$BASE_DIR/Data/Mappers/UpgradeOffersMapper.swift"

create_file "$BASE_DIR/Data/Remote/CardUpgradeAPI.swift"

create_file "$BASE_DIR/Data/Repositories/DefaultCardUpgradeRepository.swift"

create_file "$BASE_DIR/Data/Mock/MockCardUpgradeRepository.swift"

# ---------- PRESENTATION ----------
create_dir "$BASE_DIR/Presentation/Analytics"
create_dir "$BASE_DIR/Presentation/State"
create_dir "$BASE_DIR/Presentation/ViewData/Sections"
create_dir "$BASE_DIR/Presentation/L10n"
create_dir "$BASE_DIR/Presentation/Presenter/Factories"
create_dir "$BASE_DIR/Presentation/Presenter/Policies"
create_dir "$BASE_DIR/Presentation/ViewModel"
create_dir "$BASE_DIR/Presentation/View/Sections"
create_dir "$BASE_DIR/Presentation/View/Components"

# Analytics
create_file "$BASE_DIR/Presentation/Analytics/AnalyticsTracking.swift"
create_file "$BASE_DIR/Presentation/Analytics/AnalyticsEvent.swift"
create_file "$BASE_DIR/Presentation/Analytics/ConsoleAnalytics.swift"

# State
create_file "$BASE_DIR/Presentation/State/CardUpgradeDomainState.swift"
create_file "$BASE_DIR/Presentation/State/CardUpgradePhase.swift"
create_file "$BASE_DIR/Presentation/State/CardUpgradeEvent.swift"
create_file "$BASE_DIR/Presentation/State/CardUpgradeRoute.swift"
create_file "$BASE_DIR/Presentation/State/ModalState.swift"

# ViewData
create_file "$BASE_DIR/Presentation/ViewData/CardUpgradeViewData.swift"
create_file "$BASE_DIR/Presentation/ViewData/Sections/SectionVM.swift"
create_file "$BASE_DIR/Presentation/ViewData/Sections/OfferCarouselVM.swift"
create_file "$BASE_DIR/Presentation/ViewData/Sections/KeyValueSectionVM.swift"
create_file "$BASE_DIR/Presentation/ViewData/Sections/InfoBoxVM.swift"
create_file "$BASE_DIR/Presentation/ViewData/Sections/CTAViewModel.swift"

# L10n
create_file "$BASE_DIR/Presentation/L10n/CardUpgradeL10n.swift"

# Presenter
create_file "$BASE_DIR/Presentation/Presenter/CardUpgradePresenter.swift"
create_file "$BASE_DIR/Presentation/Presenter/Factories/HeaderFactory.swift"
create_file "$BASE_DIR/Presentation/Presenter/Factories/OfferCarouselFactory.swift"
create_file "$BASE_DIR/Presentation/Presenter/Factories/TipoTarjetaSectionFactory.swift"
create_file "$BASE_DIR/Presentation/Presenter/Factories/CupoSectionFactory.swift"
create_file "$BASE_DIR/Presentation/Presenter/Factories/BeneficiosSectionFactory.swift"
create_file "$BASE_DIR/Presentation/Presenter/Factories/TarifasSectionFactory.swift"
create_file "$BASE_DIR/Presentation/Presenter/Factories/InfoBoxFactory.swift"
create_file "$BASE_DIR/Presentation/Presenter/Factories/CTAFactory.swift"

create_file "$BASE_DIR/Presentation/Presenter/Policies/OfferSelectionPolicy.swift"

# ViewModel
create_file "$BASE_DIR/Presentation/ViewModel/CardUpgradeViewModel.swift"

# View
create_file "$BASE_DIR/Presentation/View/CardUpgradeView.swift"
create_file "$BASE_DIR/Presentation/View/Sections/OfferCarouselSection.swift"
create_file "$BASE_DIR/Presentation/View/Sections/KeyValueSectionView.swift"
create_file "$BASE_DIR/Presentation/View/Sections/InfoBoxView.swift"
create_file "$BASE_DIR/Presentation/View/Sections/BottomCTAView.swift"
create_file "$BASE_DIR/Presentation/View/Components/OfferCardView.swift"
create_file "$BASE_DIR/Presentation/View/Components/LoadingView.swift"
create_file "$BASE_DIR/Presentation/View/Components/ErrorView.swift"

# ---------- TESTS ----------
create_dir "$BASE_DIR/Tests/Domain"
create_dir "$BASE_DIR/Tests/Presentation"

create_file "$BASE_DIR/Tests/Domain/UpgradeEligibilityPolicyTests.swift"
create_file "$BASE_DIR/Tests/Presentation/CardUpgradePresenterTests.swift"
create_file "$BASE_DIR/Tests/Presentation/CardUpgradeViewModelTests.swift"

echo ""
echo "✅ Estructura del feature $FEATURE_NAME creada correctamente."


⸻

🧠 Cómo usarlo
	1.	Guarda el archivo como:

create_card_upgrade_feature.sh

	2.	Dale permisos:

chmod +x create_card_upgrade_feature.sh

	3.	Ejecútalo desde la raíz del proyecto:

./create_card_upgrade_feature.sh


⸻

🎯 Resultado

Te genera:

Features/CardUpgrade/
   DI/
   Domain/
   Data/
   Presentation/
   Tests/

Con toda la separación Clean Architecture lista para empezar a codificar.

⸻

Si quieres, puedo generarte ahora una versión del script que:
	•	Agregue automáticamente encabezados base dentro de cada archivo Swift
	•	O agregue plantillas mínimas de código para ViewModel / Presenter / UseCases
	•	O lo adapte para tu estructura real de repo (por ejemplo si usas Modules/ en vez de Features/)

Dime cómo está estructurado tu repo actual y lo dejamos 100% alineado a tu estándar.