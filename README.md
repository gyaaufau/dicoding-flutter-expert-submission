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

Catatan:
- `coverage:merge` pakai script custom [tool/merge_coverage.dart](/Users/argyaauliafauzandika/Coding/dicoding/Flutter/a199-flutter-expert-project/tool/merge_coverage.dart)
- file seperti `main.dart`, `*.g.dart`, dan `*.freezed.dart` otomatis di-exclude saat merge
- test root `ditonton/test` sudah dihapus; test sekarang tinggal di package modular masing-masing
