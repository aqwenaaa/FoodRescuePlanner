import 'dart:io';

// Model item
class FoodItem {
  String name;
  String category;
  int quantity;
  int daysLeft;

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

  print("===================================================");
  print("|              FOOD RESCUE PLANNER                |");
  print("===================================================");
  int choice;

  do {
    print("\nMenu:");
    print("1. Lihat inventori");
    print("2. Simulasikan hari berlalu"); // AKTIF di branch ini
    print("3. (Akan ada) Rencanakan donasi");
    print("4. (Akan ada) Tambah stok");
    print("0. Keluar");
    choice = _readInt("Pilih menu: ", min: 0, max: 4);

    switch (choice) {
      case 1:
        _showInventory(inventory);
        break;
      case 2:
        _simulateDays(inventory); // fitur baru
        break;
      case 3:
      case 4:
        print("Fitur belum tersedia di branch ini.");
        break;
      case 0:
        print("Terima kasih sudah menyelamatkan makanan hari ini!");
        break;
      default:
        print("Pilihan tidak valid.");
    }
  } while (choice != 0);
}

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

// Simulasi berjalannya hari: kurangi daysLeft jika >0
void _simulateDays(List<FoodItem> inv) {
  final days = _readInt("Masukkan jumlah hari yang ingin disimulasikan: ", min: 1);

  // nested for: hari -> item
  for (int d = 1; d <= days; d++) {
    for (final item in inv) {
      if (item.quantity == 0) continue;
      if (item.daysLeft > 0) item.daysLeft -= 1;
    }
  }
  print("Simulasi $days hari selesai. Cek inventori untuk status terbaru.");
}

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
