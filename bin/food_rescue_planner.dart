import 'dart:io';

// Model item
class FoodItem {
  String name;
  String category; // Protein, Produce, Grain, Other
  int quantity;    // jumlah unit
  int daysLeft;    // sisa hari kadaluarsa (>=0)

  FoodItem(this.name, this.category, this.quantity, this.daysLeft);

  @override
  String toString() =>
      "$name [$category] | qty: $quantity | sisa hari: $daysLeft";
}

void main() {
  final inventory = <FoodItem>[
    FoodItem("Ayam Fillet", "Protein", 6, 2),
    FoodItem("Wortel", "Produce", 10, 4),
    FoodItem("Beras 5kg", "Grain", 3, 90),
    FoodItem("Roti Tawar", "Grain", 8, 1),
  ];

  print("=== FOOD RESCUE PLANNER ===");
  int choice;
  do {
    print("\nMenu:");
    print("1. Lihat inventori");
    print("2. Simulasikan hari berlalu");
    print("3. Rencanakan donasi");
    print("4. Tambah stok");
    print("0. Keluar");
    choice = _readInt("Pilih menu: ", min: 0, max: 4);

    switch (choice) {
      case 1:
        _showInventory(inventory);
        break;
      case 2:
        _simulateDays(inventory);
        break;
      case 3:
        _planDonation(inventory);
        break;
      case 4:
        _addItem(inventory);
        break;
      case 0:
        print("Terima kasih sudah menyelamatkan makanan hari ini!");
        break;
      default:
        print("Pilihan tidak valid.");
    }
  } while (choice != 0);
}

// Lihat inventori + flag kadaluarsa
void _showInventory(List<FoodItem> inv) {
  print("\n-- INVENTORI --");
  if (inv.isEmpty) {
    print("Belum ada stok.");
    return;
  }
  for (final item in inv) {
    String flag;
    if (item.daysLeft <= 0 && item.quantity > 0) {
      flag = " (EXPIRED!)";
    } else if (item.daysLeft <= 2 && item.quantity > 0) {
      flag = " (PERINGATAN: segera gunakan/donasikan)";
    } else {
      flag = "";
    }
    print("${item.toString()}$flag");
  }
  for (final item in inv) {
    if (item.quantity == 0) continue;
    if (item.daysLeft <= 0) {
      print("! Terdapat item kadaluarsa: ${item.name}");
      break;
    }
  }
}

// Kurangi daysLeft sesuai jumlah hari
void _simulateDays(List<FoodItem> inv) {
  final days = _readInt("Masukkan jumlah hari yang ingin disimulasikan: ", min: 1);
  for (int d = 1; d <= days; d++) {
    for (final item in inv) {
      if (item.quantity == 0) continue;
      if (item.daysLeft > 0) item.daysLeft -= 1;
    }
  }
  print("Simulasi $days hari selesai. Cek inventori untuk status terbaru.");
}

// Rencana donasi: alokasi stok prioritas yang segera kadaluarsa
void _planDonation(List<FoodItem> inv) {
  if (inv.where((e) => e.quantity > 0).isEmpty) {
    print("Tidak ada stok untuk didonasikan.");
    return;
  }
  final beneficiaries = _readInt("Jumlah penerima bantuan (orang): ", min: 1);
  final maxPerPerson = _readInt("Batas maksimal unit per orang: ", min: 1);

  int served = 0;
  int person = 1;

  // Prioritaskan yang daysLeft kecil (segera kadaluarsa)
  inv.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));

  // while: layani orang satu per satu
  while (person <= beneficiaries) {
    int remainingQuota = maxPerPerson;

    // for indeks agar bisa modifikasi qty
    for (int i = 0; i < inv.length; i++) {
      final item = inv[i];
      if (item.quantity == 0) continue;

      // habiskan kuota orang ini dari item tersedia
      while (item.quantity > 0 && remainingQuota > 0) {
        item.quantity -= 1;
        remainingQuota -= 1;
      }
      if (remainingQuota == 0) break;
    }

    if (maxPerPerson - remainingQuota > 0) {
      print("Orang #$person menerima ${maxPerPerson - remainingQuota} unit.");
      served++;
    } else {
      print("Stok habis sebelum orang #$person.");
      break;
    }
    person++;
  }

  print("Donasi selesai. Penerima terlayani: $served/${beneficiaries}.");
}

// Tambah item baru dengan switch-case kategori
void _addItem(List<FoodItem> inv) {
  stdout.write("Nama item: ");
  final name = stdin.readLineSync()?.trim();
  if (name == null || name.isEmpty) {
    print("Nama tidak boleh kosong.");
    return;
  }

  print("Kategori:");
  print("1. Protein");
  print("2. Produce");
  print("3. Grain");
  print("4. Other");
  final catChoice = _readInt("Pilih kategori [1-4]: ", min: 1, max: 4);

  String category;
  switch (catChoice) {
    case 1:
      category = "Protein";
      break;
    case 2:
      category = "Produce";
      break;
    case 3:
      category = "Grain";
      break;
    case 4:
    default:
      category = "Other";
  }

  final qty = _readInt("Jumlah unit: ", min: 1);
  final days = _readInt("Sisa hari kadaluarsa: ", min: 0);

  inv.add(FoodItem(name, category, qty, days));
  print("Item ditambahkan.");
}

// Helper input integer + validasi
int _readInt(String prompt, {int? min, int? max}) {
  int? value;
  do {
    stdout.write(prompt);
    final raw = stdin.readLineSync();
    value = int.tryParse(raw ?? "");
    if (value == null) {
      print("Masukan tidak valid. Harus angka.");
      continue;
    }
    if (min != null && value < min) {
      print("Nilai minimal $min.");
      value = null;
      continue;
    }
    if (max != null && value > max) {
      print("Nilai maksimal $max.");
      value = null;
      continue;
    }
  } while (value == null);
  return value!;
}
