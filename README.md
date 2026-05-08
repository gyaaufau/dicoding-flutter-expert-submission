# a199-flutter-expert-project

Repository ini merupakan starter project submission kelas Flutter Expert Dicoding Indonesia.

---

## Workspace Modular

Project ini sekarang pakai `melos` untuk kelola monorepo, test, dan coverage antar package.

### Setup

Jalankan dari root project:

```bash
flutter pub get
dart pub global activate melos
melos bootstrap
```

### Command Harian

Jalankan semua test workspace:

```bash
melos run test
```

Jalankan coverage per package lalu gabungkan ke root:

```bash
melos run coverage:collect
melos run coverage:merge
```

Atau langsung sekali jalan:

```bash
melos run coverage
```

Hasil gabungan coverage ada di:

```bash
coverage/lcov.info
```

## Struktur Folder Singkat

- `lib/` entry point aplikasi utama, bootstrap, router, dan wiring dependency root
- `features/` package fitur level presentasi per domain seperti `movie`, `tv`, `watchlist`, dan `profile`
- `domains/` package business logic per domain seperti `movie_domain`, `tv_domain`, dan `watchlist_domain`
- `shared_libraries/` library bersama untuk kebutuhan umum:
  - `common` utility/helper umum
  - `core` komponen inti, base class, dan shared service
  - `dependencies` registrasi dependency lintas package
- `resources/` aset bersama dan resource package yang dipakai banyak module
- `tool/` script bantu workspace, termasuk merge coverage
- `android/` dan `ios/` target platform Flutter
- `coverage/` output laporan coverage gabungan workspace

Catatan:
- `coverage:merge` pakai script custom [tool/merge_coverage.dart](/Users/argyaauliafauzandika/Coding/dicoding/Flutter/a199-flutter-expert-project/tool/merge_coverage.dart)
- file seperti `main.dart`, `*.g.dart`, dan `*.freezed.dart` otomatis di-exclude saat merge
- test root `ditonton/test` sudah dihapus; test sekarang tinggal di package modular masing-masing
