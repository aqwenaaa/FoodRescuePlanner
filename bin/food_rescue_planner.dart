import 'dart:io';

void main() {
  // Banner sederhana biar keliatan cakep pas jalan
  print("===================================================");
  print("|              FOOD RESCUE PLANNER                |");
  print("===================================================");
  print("Versi awal. Fitur akan ditambahkan lewat branch fitur.");

  int choice; // variabel buat nampung pilihan menu user

  // do-while dipakai supaya menu MUNCUL minimal sekali
  do {
    print("\nMenu:");
    print("1. (Akan ada) Lihat inventori");
    print("0. Keluar");

    // minta input angka dengan helper _readInt (ada validasi min/max)
    choice = _readInt("Pilih menu: ", min: 0, max: 1);

    // logika sederhana: sekarang baru ada dua opsi
    if (choice == 1) {
      print("Fitur belum tersedia di main. Checkout branch fitur ya.");
    } else if (choice == 0) {
      print("Sampai jumpa!");
    }
  } while (choice != 0); // ulangi terus sampai user pilih 0 (keluar)
}

// Helper untuk baca input INT dari terminal, lengkap sama validasi
int _readInt(String prompt, {int? min, int? max}) {
  int? value; // kita pakai tipe nullable biar bisa diisi null saat invalid

  do {
    stdout.write(prompt);          // tampilkan prompt tanpa newline
    final raw = stdin.readLineSync(); // baca satu baris dari keyboard
    value = int.tryParse(raw ?? "");  // coba parse ke int, gagal -> null

    if (value == null) {
      print("Masukan tidak valid. Harus angka.");
      continue; // balik ke atas loop minta input lagi
    }

    // cek batas bawah kalau diset
    if (min != null && value < min) {
      print("Nilai minimal $min.");
      value = null; // set null biar loop lanjut minta input lagi
      continue;
    }

    // cek batas atas kalau diset
    if (max != null && value > max) {
      print("Nilai maksimal $max.");
      value = null; // set null biar loop lanjut minta input lagi
      continue;
    }
  } while (value == null); // selama value belum valid, ulangi

  // NOTE penting:
  // Fungsi ini bertipe 'int' (non-null), sedangkan 'value' itu 'int?' (nullable).
  // Supaya aman secara null-safety, pakai 'value!' atau ubah tipe return jadi 'int?'.
  // Di project kita, lebih pas pakai 'value!' karena kita udah pastikan tidak null.
  return value!; // pakai tanda '!' karena value dijamin tidak null di titik ini
}
