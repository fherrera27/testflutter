## Context
This PR integrates BioCatch support into the application through the BioCatchModule dependency.

The goal is to allow the app to configure, initialize, and use BioCatch capabilities through the module, while also wiring the backend validation calls required by the current flow.

## What this PR adds
- Integrates BioCatchModule into the application flow
- Adds BioCatch setup and initialization from the app side
- Connects backend validation calls related to BioCatch
- Updates the affected data, repository, and use case flow where needed
- Adds and updates related unit tests

## Testing
- Added/updated unit tests for the integration flow
- Verified BioCatch initialization path from the app
- Verified backend validation integration path
- Verified affected flow behavior after integration

## Out of scope
- Internal implementation details of BioCatchModule
- Vendor SDK internal behavior
- Broader feature adoption outside the flow covered by this PR

## Reviewer focus
Please review mainly:
- app-level integration points with BioCatchModule
- initialization/configuration flow from the app side
- backend validation wiring
- affected flow behavior and related test coverage