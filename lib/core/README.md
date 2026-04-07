# core

App-wide infrastructure and configuration. Nothing in this folder is specific to
any feature.

## Rules

- No business logic here, only wiring and configuration.
- No feature-specific imports, `core` must not depend on anything inside
  `features/`.
- Every new singleton service or repository gets registered in
  `service_locator.dart`, not instantiated ad-hoc.
