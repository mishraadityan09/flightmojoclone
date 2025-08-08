# FlightsMojo Flutter App - Folder Structure

## 📁 Project Structure Overview

```
lib/
├── main.dart                           # App entry point
├── core/                               # Core utilities and shared code
│   ├── constants/
│   │   ├── app_constants.dart          # App-wide constants
│   │   ├── api_constants.dart          # API endpoints
│   │   └── asset_constants.dart        # Asset paths
│   ├── theme/
│   │   ├── app_theme.dart              # Light & dark themes
│   │   ├── app_colors.dart             # Color palette
│   │   └── text_styles.dart            # Typography
│   ├── router/
│   │   ├── app_router.dart             # GoRouter configuration
│   │   └── app_routes.dart             # Route definitions
│   ├── utils/
│   │   ├── validators.dart             # Form validators
│   │   ├── formatters.dart             # Text formatters
│   │   ├── date_utils.dart             # Date utilities
│   │   └── extensions.dart             # Dart extensions
│   ├── network/
│   │   ├── dio_client.dart             # HTTP client setup
│   │   ├── api_client.dart             # API client
│   │   ├── interceptors.dart           # Request/Response interceptors
│   │   └── network_info.dart           # Network connectivity
│   ├── storage/
│   │   ├── local_storage.dart          # SharedPreferences wrapper
│   │   └── storage_keys.dart           # Storage key constants
│   ├── error/
│   │   ├── exceptions.dart             # Custom exceptions
│   │   ├── failures.dart               # Error handling
│   │   └── error_handler.dart          # Global error handler
│   └── widgets/                        # Reusable UI components
│       ├── buttons/
│       │   ├── primary_button.dart
│       │   ├── secondary_button.dart
│       │   └── loading_button.dart
│       ├── inputs/
│       │   ├── custom_text_field.dart
│       │   ├── date_picker_field.dart
│       │   └── dropdown_field.dart
│       ├── cards/
│       │   ├── flight_card.dart
│       │   ├── offer_card.dart
│       │   └── booking_card.dart
│       ├── loading/
│       │   ├── shimmer_loading.dart
│       │   ├── loading_indicator.dart
│       │   └── skeleton_loader.dart
│       └── dialogs/
│           ├── confirmation_dialog.dart
│           ├── error_dialog.dart
│           └── loading_dialog.dart
├── features/                           # Feature modules
│   ├── splash/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── splash_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── splash_model.dart
│   │   │   └── repositories/
│   │   │       └── splash_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── splash_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── splash_repository.dart
│   │   │   └── usecases/
│   │   │       └── check_app_version.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── splash_page.dart
│   │       ├── providers/
│   │       │   └── splash_provider.dart
│   │       └── widgets/
│   │           └── splash_logo.dart
│   ├── main/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── main_page.dart
│   │       ├── providers/
│   │       │   └── main_provider.dart
│   │       └── widgets/
│   │           └── bottom_nav_bar.dart
│   ├── home/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── home_remote_datasource.dart
│   │   │   │   └── home_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── offer_model.dart
│   │   │   │   └── popular_route_model.dart
│   │   │   └── repositories/
│   │   │       └── home_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── offer_entity.dart
│   │   │   │   └── popular_route_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── home_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_offers.dart
│   │   │       └── get_popular_routes.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── home_page.dart
│   │       ├── providers/
│   │       │   └── home_provider.dart
│   │       └── widgets/
│   │           ├── search_form.dart
│   │           ├── offers_section.dart
│   │           ├── popular_routes_section.dart
│   │           └── hero_banner.dart
│   ├── search/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── search_remote_datasource.dart
│   │   │   │   └── search_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── flight_model.dart
│   │   │   │   ├── airport_model.dart
│   │   │   │   └── search_request_model.dart
│   │   │   └── repositories/
│   │   │       └── search_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── flight_entity.dart
│   │   │   │   ├── airport_entity.dart
│   │   │   │   └── search_request_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── search_repository.dart
│   │   │   └── usecases/
│   │   │       ├── search_flights.dart
│   │   │       ├── get_airports.dart
│   │   │       └── save_search_history.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── search_page.dart
│   │       │   └── flight_results_page.dart
│   │       ├── providers/
│   │       │   └── search_provider.dart
│   │       └── widgets/
│   │           ├── search_form.dart
│   │           ├── flight_list.dart
│   │           ├── filter_bottom_sheet.dart
│   │           └── airport_selector.dart
│   ├── bookings/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── bookings_remote_datasource.dart
│   │   │   │   └── bookings_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── booking_model.dart
│   │   │   │   └── passenger_model.dart
│   │   │   └── repositories/
│   │   │       └── bookings_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── booking_entity.dart
│   │   │   │   └── passenger_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── bookings_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_bookings.dart
│   │   │       ├── create_booking.dart
│   │   │       └── cancel_booking.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── bookings_page.dart
│   │       │   ├── booking_details_page.dart
│   │       │   └── passenger_details_page.dart
│   │       ├── providers/
│   │       │   └── bookings_provider.dart
│   │       └── widgets/
│   │           ├── booking_card.dart
│   │           ├── booking_status_chip.dart
│   │           └── passenger_form.dart
│   ├── profile/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── profile_remote_datasource.dart
│   │   │   │   └── profile_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── profile_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── profile_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_user_profile.dart
│   │   │       ├── update_profile.dart
│   │   │       └── logout_user.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── profile_page.dart
│   │       │   ├── edit_profile_page.dart
│   │       │   └── settings_page.dart
│   │       ├── providers/
│   │       │   └── profile_provider.dart
│   │       └── widgets/
│   │           ├── profile_header.dart
│   │           ├── profile_menu_item.dart
│   │           └── profile_form.dart
│   └── flight_details/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── flight_details_remote_datasource.dart
│       │   ├── models/
│       │   │   └── flight_details_model.dart
│       │   └── repositories/
│       │       └── flight_details_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── flight_details_entity.dart
│       │   ├── repositories/
│       │   │   └── flight_details_repository.dart
│       │   └── usecases/
│       │       └── get_flight_details.dart
│       └── presentation/
│           ├── pages/
│           │   └── flight_details_page.dart
│           ├── providers/
│           │   └── flight_details_provider.dart
│           └── widgets/
│               ├── flight_info_card.dart
│               ├── fare_breakdown.dart
│               └── booking_button.dart
├── providers/                          # Global providers
│   └── app_providers.dart              # Provider configuration
└── generated/                          # Auto-generated files
    ├── assets.gen.dart                 # Asset references
    └── l10n.dart                       # Localization
```

## 🏗️ Architecture Benefits

### 1. **Feature-First Organization**
- Each feature is self-contained
- Easy to locate and maintain code
- Supports team collaboration
- Enables feature-based development

### 2. **Clean Architecture Layers**
- **Data Layer**: API calls, models, repositories
- **Domain Layer**: Business logic, entities, use cases
- **Presentation Layer**: UI, providers, widgets

### 3. **Separation of Concerns**
- Each layer has a single responsibility
- Easy to test individual components
- Maintainable and scalable codebase

### 4. **Scalability**
- Easy to add new features
- Minimal impact when modifying existing features
- Supports large development teams

## 📦 Key Directories Explanation

### **Core Directory**
Contains shared utilities and configurations used across the entire app:
- Theme configuration
- Navigation setup
- Network configuration
- Reusable widgets
- Common utilities

### **Features Directory**
Each feature follows the same structure:
- **Data**: External data sources and models
- **Domain**: Business logic and entities
- **Presentation**: UI components and state management

### **Providers Directory**
Contains global state management configuration.

## 🎯 Best Practices Implemented

1. **Dependency Injection**: Using Provider for state management
2. **Error Handling**: Centralized error management
3. **Type Safety**: Strong typing throughout the app
4. **Code Reusability**: Shared widgets and utilities
5. **Maintainability**: Clear separation of concerns
6. **Testability**: Easy to mock and test individual components

This structure is industry-standard and used by major Flutter applications for its scalability, maintainability, and developer experience.


lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart             // All API URLs, keys, headers, timeouts
│   ├── di/
│   │   └── service_locator.dart           // GetIt registrations and setup
│   ├── network/
│   │   ├── dio_client.dart                 // Dio singleton setup with interceptors
│   │   ├── interceptors.dart               // Dio interceptors (auth, error handling)
│   ├── error/
│   │   └── exceptions.dart                 // Custom exceptions for error handling
│   └── utils/                             // Optional utils if needed (formatters, validators)
│
├── features/
│   ├── search/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── search_remote_datasource.dart    // API calls related to Search feature
│   │   │   ├── models/
│   │   │   │   ├── city_airport_model.dart          // Models for Search API responses
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── search_provider.dart             // Provider using SearchRemoteDataSource
│   │       └── pages/
│   │           ├── search_page.dart                  // Widget using SearchProvider
│
│   ├── bookings/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── booking_remote_datasource.dart    // Booking-related API calls
│   │   │   ├── models/
│   │   │   │   ├── booking_model.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── booking_provider.dart
│   │       └── pages/
│   │           ├── booking_page.dart
│
│   └── profile/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── profile_remote_datasource.dart    // Profile-related APIs
│       │   ├── models/
│       │   │   ├── user_model.dart
│       └── presentation/
│           ├── providers/
│           │   ├── profile_provider.dart
│           └── pages/
│               ├── profile_page.dart
│
└── main.dart
