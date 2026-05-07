## Context
The application needs a dedicated integration layer for BioCatch in order to avoid direct dependencies on the vendor SDK from the app host or feature modules.

This PR introduces the initial module-level integration required to centralize SDK setup, runtime usage, and backend validation support while keeping vendor-specific constraints encapsulated.

## Objective
Establish the foundational BioCatch integration layer by:
- encapsulating the vendor SDK,
- enabling configuration and initialization from the host,
- exposing operational capabilities through the module,
- and supporting the backend validation flow required by the integration.

## Scope
- Add BioCatch SDK wrapper and integration entry points
- Add configuration/bootstrap support
- Add runtime support for operational SDK usage
- Connect backend validation calls related to BioCatch
- Update affected contracts and internal flow where needed
- Add and update related unit tests

## Design notes
The integration is implemented at module level rather than inside a feature-specific flow, since BioCatch responsibilities go beyond a single login use case.

The module keeps vendor-specific details isolated and provides a cleaner separation between:
- configuration/bootstrap,
- runtime execution,
- and feature-level consumption.

This helps prevent direct imports of the vendor SDK outside the module boundary.

## Testing
- Added/updated unit tests for the BioCatch integration flow
- Verified SDK setup and initialization path
- Verified backend validation integration path
- Verified affected contracts for the new flow

## Out of scope
- Business rules for login, antifraud, or authorization
- Environment selection logic inside the module
- Exposing the vendor SDK as a public dependency
- Broader feature-level adoption beyond the integration points included in this PR

## Reviewer focus
Please review mainly:
- module boundary and encapsulation of vendor-specific concerns,
- separation between configuration, runtime, and operational usage,
- backend validation integration points,
- and test coverage for the new flow.