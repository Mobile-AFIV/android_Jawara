import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/bottom_nav_menu.dart';
import 'package:jawara_pintar/screens/dashboard/dashboard_menu.dart';
import 'package:jawara_pintar/screens/dashboard/section/dashboard_kegiatan_section.dart';
import 'package:jawara_pintar/screens/dashboard/section/dashboard_kependudukan_section.dart';
import 'package:jawara_pintar/screens/dashboard/section/dashboard_keuangan_section.dart';
import 'package:jawara_pintar/screens/kegiatan/kegiatan_menu.dart';
import 'package:jawara_pintar/screens/kegiatan/section/broadcast_daftar_section.dart';
import 'package:jawara_pintar/screens/kegiatan/section/kegiatan_daftar_section.dart';
import 'package:jawara_pintar/screens/kegiatan/section/pesan_warga_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/laporan_section/cetak_laporan_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/laporan_section/laporan_pemasukan_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/laporan_section/laporan_pengeluaran_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/laporan_tab.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/kategori_iuran_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/pemasukan_tagihan_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_tab.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pengeluaran_section/pengeluaran_daftar_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pengeluaran_tab.dart';
import 'package:jawara_pintar/screens/keuangan/tab_bar_keuangan.dart';
import 'package:jawara_pintar/screens/lainnya/lainnya_menu.dart';
import 'package:jawara_pintar/screens/lainnya/section/channel_transfer_section.dart';
import 'package:jawara_pintar/screens/lainnya/section/log_aktivitas_section.dart';
import 'package:jawara_pintar/screens/lainnya/section/manajemen_pengguna_section.dart';
import 'package:jawara_pintar/screens/login_screen.dart';
import 'package:jawara_pintar/screens/register_screen.dart';
import 'package:jawara_pintar/screens/warga/section/keluarga_section.dart';
import 'package:jawara_pintar/screens/warga/section/mutasi_keluarga_section.dart';
import 'package:jawara_pintar/screens/warga/section/penerimaan_warga_section.dart';
import 'package:jawara_pintar/screens/warga/section/rumah_section.dart';
import 'package:jawara_pintar/screens/warga/section/warga_section.dart';
import 'package:jawara_pintar/screens/warga/warga_menu.dart';

final GoRouter mainRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: 'register',
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return BottomNavMenu(child: child);
      },
      routes: [
        GoRoute(
          name: 'dashboard',
          path: '/dashboard',
          builder: (context, state) => const DashboardMenu(),
        ),
        GoRoute(
          name: 'warga',
          path: '/warga',
          builder: (context, state) => const WargaMenu(),
        ),
        ShellRoute(
          builder: (context, state, child) => TabBarKeuangan(child: child),
          routes: [
            GoRoute(
              name: 'pemasukan',
              path: '/keuangan/pemasukan',
              builder: (context, state) => const PemasukanTab(),
            ),
            GoRoute(
              name: 'pengeluaran',
              path: '/keuangan/pengeluaran',
              builder: (context, state) => const PengeluaranTab(),
            ),
            GoRoute(
              name: 'laporan',
              path: '/keuangan/laporan',
              builder: (context, state) => const LaporanTab(),
            ),
          ],
        ),
        GoRoute(
          name: 'kegiatan',
          path: '/kegiatan',
          builder: (context, state) => const KegiatanMain(),
        ),
        GoRoute(
          name: 'lainnya',
          path: '/lainnya',
          builder: (context, state) => const LainnyaMenu(),
        ),
      ],
    ),

    // --------------- PUSH TERPISAH DARI SHELL ROUTE ---------------
    // Push dari Menu Dashboard
    GoRoute(
      name: 'dashboard_kegiatan',
      path: '/dashboard_kegiatan',
      builder: (context, state) => const DashboardKegiatanSection(),
    ),
    GoRoute(
      name: 'dashboard_kependudukan',
      path: '/dashboard_kependudukan',
      builder: (context, state) => const DashboardKependudukanSection(),
    ),
    GoRoute(
      name: 'dashboard_keuangan',
      path: '/dashboard_keuangan',
      builder: (context, state) => const DashboardKeuanganSection(),
    ),

    // Push dari Menu Warga
    GoRoute(
      name: 'keluarga',
      path: '/keluarga',
      builder: (context, state) => const KeluargaSection(),
    ),
    GoRoute(
      name: 'mutasi_keluarga',
      path: '/mutasi_keluarga',
      builder: (context, state) => const MutasiKeluargaSection(),
    ),
    GoRoute(
      name: 'penerimaan_warga',
      path: '/penerimaan_warga',
      builder: (context, state) => const PenerimaanWargaSection(),
    ),
    GoRoute(
      name: 'rumah',
      path: '/rumah',
      builder: (context, state) => const RumahSection(),
    ),
    GoRoute(
      name: 'warga_section',
      path: '/warga_section',
      builder: (context, state) => const WargaSection(),
    ),

    // Push dari Menu Keuangan
    //// Keuangan - Laporan
    GoRoute(
      name: 'cetak_laporan',
      path: '/cetak_laporan',
      builder: (context, state) => const CetakLaporanSection(),
    ),
    GoRoute(
      name: 'laporan_Pemasukan',
      path: '/laporan_Pemasukan',
      builder: (context, state) => const LaporanPemasukanSection(),
    ),
    GoRoute(
      name: 'laporan_pengeluaran',
      path: '/laporan_pengeluaran',
      builder: (context, state) => const LaporanPengeluaranSection(),
    ),
    //// Keuangan - Pemasukan
    GoRoute(
      name: 'kategori_iuran',
      path: '/kategori_iuran',
      builder: (context, state) => const KategoriIuranSection(),
    ),
    GoRoute(
      name: 'pemasukan_tagihan',
      path: '/pemasukan_tagihan',
      builder: (context, state) => const PemasukanTagihanSection(),
    ),
    //// Keuangan - Pengeluaran
    GoRoute(
      name: 'pengeluaran_daftar',
      path: '/pengeluaran_daftar',
      builder: (context, state) => const PengeluaranDaftarSection(),
    ),

    // Push dari Menu Kegiatan
    GoRoute(
      name: 'broadcast_daftar',
      path: '/broadcast_daftar',
      builder: (context, state) => const BroadcastDaftarSection(),
    ),
    GoRoute(
      name: 'kegiatan_daftar',
      path: '/kegiatan_daftar',
      builder: (context, state) => const KegiatanDaftarSection(),
    ),
    GoRoute(
      name: 'pesan_warga',
      path: '/pesan_warga',
      builder: (context, state) => const PesanWargaSection(),
    ),

    // Push dari Menu Lainnya
    GoRoute(
      name: 'channel_transfer',
      path: '/channel_transfer',
      builder: (context, state) => const ChannelTransferSection(),
    ),
    GoRoute(
      name: 'log_aktivitas',
      path: '/log_aktivitas',
      builder: (context, state) => const LogAktivitasSection(),
    ),
    GoRoute(
      name: 'manajemen_pengguna',
      path: '/manajemen_pengguna',
      builder: (context, state) => const ManajemenPenggunaSection(),
    ),
  ],
);
