class Tanaman {
  final Map<String, String> estimasiPanen;
  final Map<String, bool> namaTanaman;
  final Map<String, PertumbuhanStatus> statusPertumbuhan;
  final Map<String, String> tanggalPanen;
  final Map<String, String> tanggalTanam;
  final Map<String, String> usiaTanaman;

  Tanaman({
    required this.estimasiPanen,
    required this.namaTanaman,
    required this.statusPertumbuhan,
    required this.tanggalPanen,
    required this.tanggalTanam,
    required this.usiaTanaman,
  });

  factory Tanaman.fromMap(Map<dynamic, dynamic> map) {
    Map<String, PertumbuhanStatus> statusPertumbuhan = {};
    map['status_pertumbuhan'].forEach((key, value) {
      statusPertumbuhan[key] = PertumbuhanStatus.fromMap(value);
    });

    return Tanaman(
      estimasiPanen: Map<String, String>.from(map['estimasi_panen']),
      namaTanaman: Map<String, bool>.from(map['nama_tanaman']),
      statusPertumbuhan: statusPertumbuhan,
      tanggalPanen: Map<String, String>.from(map['tanggal_panen']),
      tanggalTanam: Map<String, String>.from(map['tanggal_tanam']),
      usiaTanaman: Map<String, String>.from(map['usia_tanaman']),
    );
  }
}

class PertumbuhanStatus {
  final bool panen;
  final bool semai;
  final String tanggalPanen;
  final String tanggalTanam;
  final bool tumbuh;

  PertumbuhanStatus({
    required this.panen,
    required this.semai,
    required this.tanggalPanen,
    required this.tanggalTanam,
    required this.tumbuh,
  });

  factory PertumbuhanStatus.fromMap(Map<dynamic, dynamic> map) {
    return PertumbuhanStatus(
      panen: map['panen'],
      semai: map['semai'],
      tanggalPanen: map['tanggal_panen'],
      tanggalTanam: map['tanggal_tanam'],
      tumbuh: map['tumbuh'],
    );
  }
}
