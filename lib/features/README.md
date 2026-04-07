# features

Each subdirectory is a self-contained feature module.

## Structure

Every feature follows the same internal layout:

```
feature_name/
├── data/          # Repository implementations, API calls
├── domain/        # Abstract interfaces, models
└── presentation/  # Screens, widgets, Riverpod providers
```

## Rules

- Features must not depend on each other's implementation details.
- Features may only import from other features:
    - **Models** from `domain/`
    - **Providers** from `presentation/providers/`
    - **Reusable widgets** from `presentation/widgets/`
- Shared or reusable logic should go in `shared/`.
- Always depend on abstract interfaces in `domain/`, never concrete
  implementations in `data/`.
- Riverpod providers live in `presentation/providers/` and resolve dependencies
  via GetIt.
