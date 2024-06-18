class JadwalMatkulData {
  final String namaMatkul;
  final String jamMulai;
  final String jamSelesai;
  final String namaDosen;

  JadwalMatkulData({
    required this.namaMatkul,
    required this.jamMulai,
    required this.jamSelesai,
    required this.namaDosen,
  });
}

Map<DateTime, List<JadwalMatkulData>> jadwalMatkul = {
  DateTime(2024, 6, 18): [
    JadwalMatkulData(
      namaMatkul: 'Pemrograman Berorientasi Objek',
      jamMulai: '07:00',
      jamSelesai: '09:30',
      namaDosen: 'Wahyu',
    ),
    JadwalMatkulData(
      namaMatkul: 'Desain Antarmuka',
      jamMulai: '09:31',
      jamSelesai: '12:00',
      namaDosen: 'Kartini',
    ),
  ],
  DateTime(2024, 6, 19): [
    JadwalMatkulData(
      namaMatkul: 'Rekayasa Perangkat Lunak',
      jamMulai: '07:00',
      jamSelesai: '09:30',
      namaDosen: 'Agung',
    ),
    JadwalMatkulData(
      namaMatkul: 'Analisis & Desain Sistem',
      jamMulai: '09:31',
      jamSelesai: '12:00',
      namaDosen: 'Gede',
    ),
  ],
  DateTime(2024, 6, 20): [
    JadwalMatkulData(
      namaMatkul: 'Jaringan Komputer',
      jamMulai: '07:00',
      jamSelesai: '09:30',
      namaDosen: 'Henny',
    ),
    JadwalMatkulData(
      namaMatkul: 'Kepemimpinan',
      jamMulai: '09:31',
      jamSelesai: '12:00',
      namaDosen: 'Rizki',
    ),
  ],
  DateTime(2024, 6, 21): [
    JadwalMatkulData(
      namaMatkul: 'Pemrograman Web',
      jamMulai: '07:00',
      jamSelesai: '09:30',
      namaDosen: 'Ayom',
    ),
    JadwalMatkulData(
      namaMatkul: 'Kecerdasan Buatan',
      jamMulai: '09:31',
      jamSelesai: '12:00',
      namaDosen: 'Adira',
    ),
  ],
};
