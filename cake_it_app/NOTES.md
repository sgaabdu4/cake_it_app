# Tech Notes

## My Thoughts
It's been a while since I used ChangeNotifier and did state management without the packages I normally reach for, so it took me a bit of time to think from a different perspective. Actually quite exciting working within these constraints, made me appreciate how the flutter ecosystem has evolved!

## What I Built

### Architecture
- Clean architecture approach to keep things organised
- Feature first folder structure (features/cakes, features/settings) instead of layer first
- Core folder for shared utilities like network service, routing, config
- Repository pattern to keep data logic separate from UI
- Cache first strategy so the app feels responsive
- ChangeNotifier for simple state management

### Project Structure Decisions
- **AppRoutes class**: Centralised route constants instead of scattered string literals
- **Route Generator**: Type safe routing with proper parameter passing
- **AppNavigator**: Helper methods for type-safe navigation
- **Context extensions**: Clean route argument access with `context.routeArguments<T>()`
- **Feature folders**: Each feature is self contained with its own data/domain/presentation
- **Core utilities**: Shared components like NetworkService, Failure classes, config
- **No more hardcoded navigation**: Proper Cake entity passing instead of fake JSON

### Key Features
- Pull to refresh as requested
- Offline support so you can browse cakes without internet
- Image caching with proper loading states
- Error handling that actually helps users
- Proper cake details page (not just a placeholder)
- Type safe navigation to avoid runtime crashes
- Theme persistence for better user experience
- Separated UI states into private widget classes for better performance with const constructors

### From Prototype to Production
- **Original**: Everything in single files, hardcoded fake cake in details
- **Now**: Feature first structure, real data flow, proper error states

- **Original**: Direct HTTP calls in UI widgets
- **Now**: NetworkService → Repository → Controller → UI layers

- **Original**: No caching, no offline support
- **Now**: Cache first strategy with SharedPreferences

### Testing
- 26 tests because I believe in testing things properly
- Good test coverage for confidence in changes
- All green with zero warnings

### Performance
- Smart caching so it doesn't overload the API
- Background image loading for smooth scrolling
- Proper memory management
- Const optimization linting rules to catch performance improvements automatically

## What I'd Use In Real Projects

### State Management
- **riverpod**: Much better than ChangeNotifier, handles dependencies properly
- **flutter_hooks**: For simple widget state, prevents forgetting to dispose controllers

### Data Modelling
- **freezed**: Makes immutable classes with union types, saves loads of boilerplate
- **json_serializable**: Works brilliantly with freezed, no more manual JSON parsing

### Error Handling
- **fpdart**: Love the Either pattern, forces you to think about errors properly

### Local Storage
- **vault_storage**: My own package for secure storage with encryption
- Much better than SharedPreferences when you care about security

### Navigation
- **go_router**: Declarative routing, shell routes, deep linking works well
- Type safe navigation that catches mistakes at compile time

### Testing
- **mocktail**: Simple mocking without code generation faff
- Clean syntax, straightforward to use

## Why I Like These Better

### Upgrades I'd Make
- **ChangeNotifier → Riverpod**: Better DI, automatic cleanup, way more testable
- **SharedPreferences → Vault Storage**: Security matters for more complex apps or use **hive_ce**, personally
- **AppRoutes + RouteGenerator → go_router**: Less boilerplate, better web support
- **Manual JSON → freezed + json_serializable**: Less bugs, more type safety
- **Try catch → fpdart Either**: You can't ignore errors anymore (which is helpful!)

### The Real Benefits
- Type safety everywhere prevents runtime crashes
- Better testing means fewer bugs in production
- Less boilerplate means more time for actual features
- Functional patterns make code more predictable
