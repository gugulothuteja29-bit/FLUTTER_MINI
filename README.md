# TaskFlow — PDF-reference Flutter app

This Flutter project recreates the five TaskFlow screens shown in `Flutter_Mini_Project_Documentation_updated.pdf`: Dashboard, Task List, Kanban Board, Calendar, and Analytics. The wide-screen layout uses a fixed left sidebar and a compact top bar, with purple accents, metric cards, project colors, and sample tasks based on the reference screenshots.

## Run in VS Code

1. Install Flutter and the Flutter extension in VS Code.
2. Open this project folder.
3. In the VS Code terminal run:

   ```powershell
   flutter pub get
   flutter run -d chrome
   ```

4. Use the left navigation to open all five pages. You can add, edit, complete, move, search, filter, and delete tasks.

## Build for web / Vercel

```powershell
flutter build web
```

Deploy the generated `build/web` directory as a prebuilt static site. The included `vercel.json` points to `build/web`; make sure that folder is available to Vercel at deployment time.

## Storage note

This web-compatible version uses `shared_preferences` in the browser, so changes persist in that browser profile. It does not use SQLite in the browser and does not sync between devices. The original PDF describes SQLite on mobile; standard `sqflite` does not support Flutter Web directly.

## Fidelity note

The layout and sample content are based on the screenshots and descriptions in the PDF, but this is a code recreation rather than a pixel-perfect screenshot clone. Run and compare in Chrome at a similar desktop width to the PDF screenshots.
