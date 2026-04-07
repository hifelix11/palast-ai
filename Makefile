.PHONY: gen watch test analyze format run clean supa-deploy supa-migrate

gen:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

test:
	flutter test

analyze:
	flutter analyze

format:
	dart format lib test

run:
	flutter run

clean:
	flutter clean && flutter pub get

supa-deploy:
	supabase functions deploy process-item
	supabase functions deploy transcribe-audio

supa-migrate:
	supabase db push
