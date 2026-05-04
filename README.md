# Summary

This PR introduces the initial implementation of the BioCatch module as a dedicated Swift Package, providing a clear separation between SDK integration concerns and the public contracts consumed by feature modules.

The module was designed to encapsulate the vendor SDK behind our own abstractions, keeping the integration isolated, testable, and easier to evolve without leaking vendor-specific details into consumers.

# What was added

- Initial BioCatch module structure
- Separation of responsibilities between configuration and tracking flows
- Public contracts for module consumption
- Internal SDK integration layer
- Main-thread-safe access for SDK interaction
- Swift Package setup and target organization
- Initial unit tests for module-owned behavior

# Design goals

- Encapsulate the BioCatch SDK behind module-owned abstractions
- Avoid direct vendor dependency usage from feature modules
- Keep configuration concerns separate from runtime tracking concerns
- Centralize SDK access through a controlled integration layer
- Improve maintainability and future SDK replacement/upgrade flexibility
- Provide a clean foundation for future extensions

# Architecture notes

The implementation follows a wrapper/facade approach:

- **Public API** exposes only module-owned contracts
- **Internal integration layer** adapts the vendor SDK
- **Configuration** and **tracking** are separated by responsibility
- SDK access is centralized to avoid duplication and vendor leakage
- Unit tests focus on behavior owned by the module, using dependency injection and test doubles where applicable

# Testing

Included tests validate the behavior of the module-owned wrapper/adaptation layer.

Note: vendor singleton wiring is intentionally not the focus of behavioral unit tests, since it represents infrastructure composition rather than deterministic module logic.

# Why this matters

This PR establishes the baseline architecture for BioCatch integration and provides a scalable entry point for future consumers, while keeping the SDK isolated from the rest of the codebase.

# Follow-ups

- Expand coverage for additional tracking scenarios
- Add integration-level validation where needed
- Refine public API ergonomics based on first consumers
- Extend documentation/examples for consuming modules