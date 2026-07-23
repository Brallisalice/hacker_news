# Hacker News Client 📰
This is my first hobby app that I made to practice coding with dart and flutter

This app is a modern and fast Hacker News client built with Flutter. The app fetches the latest tech news in real-time via the official Hacker News API and presents it in a user-friendly interface.

## ✨ Features

* **Category Switching via Tabs:** Seamlessly switch between *Top*, *Best*, and *New* stories directly in the app's AppBar.
* **Shimmer Loading:** Modern skeleton loading (shimmer effect) displayed while data is being fetched in the background for a smoother user experience.
* **Search Functionality:** Find specific articles quickly and easily (via `SearchScreen`).
* **Bookmarks:** Save your favorite articles to read them later (via `BookmarkScreen`).
* **Pull-to-Refresh:** Pull down on the screen to easily refresh the list with the absolute latest news.

## 🛠 Technical Details & Architecture

This project is built with a strong focus on clean code and performance:
* **State Management:** Combines local `setState` for UI-specific logic with global **`Providers`** to efficiently manage app-wide state, such as saved bookmarks and search results.
* **Enums & Switch Statements:** Type-safe handling of news categories using Dart `enums` for maximum code clarity and scalability.
* **API Optimization:** A centralized `NewsService` that efficiently maps the app's categories to API requests.

## 📁 Project Structure

The app is structured into modules to keep the codebase clean and maintainable:

```text
lib/
├── models/         # Data models (e.g., Article, Comment)
├── providers/      # State Management (e.g., Bookmarks, Search)
├── screens/        # The app's different screens/views
├── service/        # API services and network requests
├── themes/         # App design system and colors
├── utils/          # Helper functions (e.g., formatting, debouncer)
└── widgets/        # Reusable UI components (e.g., tiles, shimmers)
