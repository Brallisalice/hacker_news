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
```

## Screenshots

### Light Mode

<p float="left">
  <img src="https://github.com/user-attachments/assets/347e5d31-1505-4a43-90a9-267f5412d1dc" width="220" />
  <img src="https://github.com/user-attachments/assets/b03cf59f-dd7a-406d-8c05-e0d2de6c650b" width="220" />
  <img src="https://github.com/user-attachments/assets/10a38bba-f647-49d5-a2c3-611c29ecd879" width="220" />
  <img src="https://github.com/user-attachments/assets/e93081ba-bc30-4e05-91c9-f6d87f7a0e4b" width="220" />
  <img src="https://github.com/user-attachments/assets/fc1afb16-8da2-4040-a5de-8d39906376d2" width="220" />
  <img src="https://github.com/user-attachments/assets/f56388a6-7e8c-4916-8b57-1aa47ef9d7ae" width="220" />
</p>

<p float="left">
  <img src="https://github.com/user-attachments/assets/6c54b4a4-f547-46d7-bc5d-2299fded120a" width="220" />
  <img src="https://github.com/user-attachments/assets/2d2f395d-7ab1-4757-b120-9377f501803c" width="220" />
  <img src="https://github.com/user-attachments/assets/20405fee-75f0-43de-ae3f-e426b3c35c6d" width="220" />
 
</p>

---

### Dark Mode

<p float="left">
  <img src="https://github.com/user-attachments/assets/69d3e7e1-8963-4cbe-89ff-2117a0139401" width="220" />
  <img src="https://github.com/user-attachments/assets/3eac7d3d-758d-4e9d-88fa-34f96eb7d24d" width="220" />
  <img src="https://github.com/user-attachments/assets/d217ed1d-8fba-41fb-b6a7-3b021d9b7144" width="220" />
  <img src="https://github.com/user-attachments/assets/bdba6992-9af1-4d68-b85f-d24a3aac2606" width="220" />
</p>










