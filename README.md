# Palast

> Your mind palast.

Palast is a personal, AI-native knowledge organizer. Share anything from your phone — a link, an article, a screenshot, a fleeting thought, a voice memo — and Palast quietly files it into a living mind palace: an AI-managed tree of folders and tags, with summaries and key points distilled from the source.

Palast is built by **Palast AI**.

---

## Stack

| Layer            | Technology                                                                 |
|------------------|----------------------------------------------------------------------------|
| Client           | Flutter (stable), Riverpod (codegen), go_router, freezed, drift            |
| Backend          | Supabase (Postgres, Auth, Storage, Realtime, Edge Functions)               |
| Auth             | Google Sign-In, Apple Sign-In                                              |
| AI               | OpenRouter (server-side only, called from Edge Functions)                  |
| Capture          | receive_sharing_intent (OS share sheet), record (voice memos)              |
| Analytics        | PostHog (behind an `AnalyticsService` abstraction)                         |
| Crash reporting  | Sentry                                                                     |
| Localization     | English + German (German is first-class)                                   |

Mobile only. iOS 16+, Android 24+.

---

## Folder overview

```
lib/
  app.dart, main.dart, bootstrap.dart
  core/        theme, env, router, network, analytics, ai, error, extensions
  features/    auth, capture, inbox, library, item_detail, search, settings
  shared/      widgets, models
  l10n/        app_en.arb, app_de.arb
supabase/
  config.toml
  migrations/  00001_initial_schema.sql
  functions/   process-item, transcribe-audio
```

Each feature is split into `presentation/{pages,widgets,providers}`, `domain/`, `data/`.

---

## Setup

### 1. Prerequisites

- Flutter stable (>= 3.22)
- Dart >= 3.4
- Xcode 15+ / Android Studio
- Supabase CLI
- A Supabase project
- An OpenRouter account
- A PostHog project (optional)
- A Sentry project (optional)

### 2. Install dependencies

```sh
flutter pub get
make gen        # runs build_runner for freezed, riverpod, envied
```

### 3. Configure environment

```sh
cp .env.example .env
# Fill in SUPABASE_URL, SUPABASE_ANON_KEY, POSTHOG_API_KEY, SENTRY_DSN
make gen        # regenerate envied bindings
```

### 4. Supabase

```sh
supabase link --project-ref <your-ref>
supabase db push                 # applies migrations
supabase functions deploy process-item
supabase functions deploy transcribe-audio
supabase secrets set OPENROUTER_API_KEY=sk-or-...
supabase secrets set OPENROUTER_MODEL=anthropic/claude-sonnet-4
```

In the Supabase dashboard:
- Enable **Google** and **Apple** providers under Authentication.
- Create a Storage bucket called `items` (private).

### 5. OAuth

- **Google:** create OAuth client IDs (iOS, Android, Web). Drop `GoogleService-Info.plist` into `ios/Runner/` and `google-services.json` into `android/app/`.
- **Apple:** enable Sign In with Apple capability in Xcode. Configure Service ID and key in Supabase.

### 6. Run

```sh
flutter run
```

---

## Build commands

| Command            | What                                     |
|--------------------|------------------------------------------|
| `make gen`         | Run build_runner once                    |
| `make watch`       | Run build_runner in watch mode           |
| `make test`        | Run Flutter tests                        |
| `make analyze`     | Static analysis                          |
| `make format`      | Format `lib/` and `test/`                |
| `make run`         | `flutter run`                            |
| `make clean`       | Clean and re-fetch deps                  |
| `make supa-deploy` | Deploy edge functions                    |
| `make supa-migrate`| Push DB migrations                       |

---

## Next features

- [ ] Full-text + semantic search
- [ ] Offline capture queue with retry
- [ ] Drag-and-drop reorganization in Library
- [ ] Manual reprocess of an item
- [ ] Sharing of items / folders with others
- [ ] Export (Markdown, Notion, Obsidian)
- [ ] Home-screen widgets (iOS/Android)
- [ ] Onboarding flow
- [ ] Push notifications when an item finishes processing

---

## A note on voice

Palast is a quiet place. Copy is warm, literary, and unhurried.
