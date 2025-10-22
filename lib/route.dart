import 'package:go_router/go_router.dart';
import 'package:jawara_pintar/screens/bottom_nav_menu.dart';
import 'package:jawara_pintar/screens/dashboard/dashboard_menu.dart';
import 'package:jawara_pintar/screens/dashboard/section/dashboard_kegiatan_section.dart';
import 'package:jawara_pintar/screens/dashboard/section/dashboard_kependudukan_section.dart';
import 'package:jawara_pintar/screens/dashboard/section/dashboard_keuangan_section.dart';
import 'package:jawara_pintar/screens/kegiatan/kegiatan_menu.dart';
import 'package:jawara_pintar/screens/kegiatan/section/broadcast_daftar_section.dart';
import 'package:jawara_pintar/screens/kegiatan/section/detail/broadcast_detail.dart';
import 'package:jawara_pintar/screens/kegiatan/section/detail/kegiatan_detail.dart';
import 'package:jawara_pintar/screens/kegiatan/section/kegiatan_daftar_section.dart';
import 'package:jawara_pintar/screens/kegiatan/section/pesan_warga_section.dart';
import 'package:jawara_pintar/screens/kegiatan/section/tambah/broadcast_tambah.dart';
import 'package:jawara_pintar/screens/kegiatan/section/tambah/kegiatan_tambah.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/laporan_section/cetak_laporan_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/laporan_section/laporan_pemasukan_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/laporan_section/laporan_pengeluaran_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/laporan_tab.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/kategori_iuran_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/pemasukan_lain_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/pemasukan_tagihan_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_section/tambah_pemasukan_lain_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pemasukan_tab.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pengeluaran_section/pengeluaran_daftar_section.dart';
import 'package:jawara_pintar/screens/keuangan/keuangan_tab/pengeluaran_tab.dart';
import 'package:jawara_pintar/screens/keuangan/tab_bar_keuangan.dart';
import 'package:jawara_pintar/screens/lainnya/lainnya_menu.dart';
import 'package:jawara_pintar/screens/lainnya/section/channel_transfer_section.dart';
import 'package:jawara_pintar/screens/lainnya/section/log_aktivitas_section.dart';
import 'package:jawara_pintar/screens/lainnya/section/manajemen_pengguna_section.dart';
import 'package:jawara_pintar/screens/lainnya/section/tambah_pengguna_section.dart';
import 'package:jawara_pintar/screens/login_screen.dart';
import 'package:jawara_pintar/screens/register_screen.dart';
import 'package:jawara_pintar/screens/warga/section/keluarga_section.dart';
import 'package:jawara_pintar/screens/warga/section/mutasi_keluarga_section.dart';
import 'package:jawara_pintar/screens/warga/section/penerimaan_warga_section.dart';
import 'package:jawara_pintar/screens/warga/section/rumah_section.dart';
import 'package:jawara_pintar/screens/warga/section/tambah/mutasi_keluarga_tambah.dart';
import 'package:jawara_pintar/screens/warga/section/tambah/rumah_tambah.dart';
import 'package:jawara_pintar/screens/warga/section/tambah/warga_tambah.dart';
import 'package:jawara_pintar/screens/warga/section/warga_section.dart';
import 'package:jawara_pintar/screens/warga/section/detail/keluarga_detail.dart';
import 'package:jawara_pintar/screens/warga/section/detail/mutasi_keluarga_detail.dart';
import 'package:jawara_pintar/screens/warga/section/detail/penerimaan_warga_detail.dart';
import 'package:jawara_pintar/screens/warga/section/detail/rumah_detail.dart';
import 'package:jawara_pintar/screens/warga/section/detail/warga_detail.dart';
import 'package:jawara_pintar/screens/warga/section/edit/rumah_edit.dart';
import 'package:jawara_pintar/screens/warga/section/edit/warga_edit.dart';
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
        return BottomNavMenu(state: state, child: child);
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
          builder: (context, state, child) =>
              TabBarKeuangan(state: state, child: child),
          routes: [
            GoRoute(
              name: 'pemasukan',
              path: '/keuangan/pemasukan',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const PemasukanTab(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) => child,
                transitionDuration: Duration.zero,
              ),
            ),
            GoRoute(
              name: 'pengeluaran',
              path: '/keuangan/pengeluaran',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const PengeluaranTab(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) => child,
                transitionDuration: Duration.zero,
              ),
            ),
            GoRoute(
              name: 'laporan',
              path: '/keuangan/laporan',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const LaporanTab(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) => child,
                transitionDuration: Duration.zero,
              ),
            ),
          ],
        ),
        GoRoute(
          name: 'kegiatan',
          path: '/kegiatan',
          builder: (context, state) => const KegiatanMenu(),
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
      routes: [
        GoRoute(
          path: 'keluarga_detail',
          name: 'keluarga_detail',
          builder: (context, state) {
            final keluargaIndex =
                int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
            return KeluargaDetail(keluargaIndex: keluargaIndex);
          },
        ),
      ],
    ),
    GoRoute(
      name: 'mutasi_keluarga',
      path: '/mutasi_keluarga',
      builder: (context, state) => const MutasiKeluargaSection(),
      routes: [
        GoRoute(
          name: 'mutasi_keluarga_tambah',
          path: 'mutasi_keluarga_tambah',
          builder: (context, state) => const MutasiKeluargaTambah(),
        ),
        GoRoute(
          path: 'mutasi_keluarga_detail',
          name: 'mutasi_keluarga_detail',
          builder: (context, state) {
            final mutasiIndex =
                int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
            return MutasiKeluargaDetail(mutasiIndex: mutasiIndex);
          },
        ),
      ],
    ),
    GoRoute(
      name: 'penerimaan_warga',
      path: '/penerimaan_warga',
      builder: (context, state) => const PenerimaanWargaSection(),
      routes: [
        GoRoute(
          path: 'penerimaan_warga_detail',
          name: 'penerimaan_warga_detail',
          builder: (context, state) {
            final penerimaanIndex =
                int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
            final name = state.uri.queryParameters['name'];
            return PenerimaanWargaDetail(
                penerimaanIndex: penerimaanIndex, name: name);
          },
        ),
      ],
    ),
    GoRoute(
      name: 'rumah',
      path: '/rumah',
      builder: (context, state) => const RumahSection(),
      routes: [
        GoRoute(
          name: 'rumah_tambah',
          path: 'rumah_tambah',
          builder: (context, state) => const RumahTambah(),
        ),
        GoRoute(
          path: 'rumah_detail',
          name: 'rumah_detail',
          builder: (context, state) {
            final rumahIndex =
                int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
            final address = state.uri.queryParameters['address'];
            return RumahDetail(rumahIndex: rumahIndex, address: address);
          },
        ),
        GoRoute(
          path: 'rumah_edit',
          name: 'rumah_edit',
          builder: (context, state) {
            final rumahIndex =
                int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
            final address = state.uri.queryParameters['address'];
            return RumahEdit(rumahIndex: rumahIndex, address: address);
          },
        ),
      ],
    ),
    GoRoute(
      name: 'warga_section',
      path: '/warga_section',
      builder: (context, state) => const WargaSection(),
      routes: [
        GoRoute(
          name: 'warga_tambah',
          path: 'warga_tambah',
          builder: (context, state) => const WargaTambah(),
        ),
        GoRoute(
          path: 'warga_detail',
          name: 'warga_detail',
          builder: (context, state) {
            final wargaIndex =
                int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
            final name = state.uri.queryParameters['name'];
            return WargaDetail(wargaIndex: wargaIndex, name: name);
          },
        ),
        GoRoute(
          path: 'warga_edit',
          name: 'warga_edit',
          builder: (context, state) {
            final wargaIndex =
                int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
            final name = state.uri.queryParameters['name'];
            return WargaEdit(wargaIndex: wargaIndex, name: name);
          },
        ),
      ],
    ),

    // Push dari Menu Keuangan
    //// Keuangan - Laporan
    GoRoute(
      name: 'cetak_laporan',
      path: '/keuangan/laporan/cetak_laporan',
      builder: (context, state) => const CetakLaporanSection(),
    ),
    GoRoute(
      name: 'laporan_Pemasukan',
      path: '/keuangan/laporan/laporan_Pemasukan',
      builder: (context, state) => const LaporanPemasukanSection(),
    ),
    GoRoute(
      name: 'laporan_pengeluaran',
      path: '/keuangan/laporan/laporan_pengeluaran',
      builder: (context, state) => const LaporanPengeluaranSection(),
    ),
    //// Keuangan - Pemasukan
    GoRoute(
      name: 'kategori_iuran',
      path: '/keuangan/pemasukan/kategori_iuran',
      builder: (context, state) => KategoriIuranSection(),
    ),
    GoRoute(
      name: 'pemasukan_tagihan',
      path: '/keuangan/pemasukan/pemasukan_tagihan',
      builder: (context, state) => PemasukanTagihanSection(),
    ),
    GoRoute(
      name: 'pemasukan_lain',
      path: '/keuangan/pemasukan/pemasukan_lain',
      builder: (context, state) => const PemasukanLainSection(),
      routes: [
        GoRoute(
          name: 'tambah_pemasukan_lain',
          path: '/keuangan/pemasukan/pemasukan_lain/tambah',
          builder: (context, state) {
            return TambahPemasukanLainSection();
          },
        ),
      ],
    ),
    //// Keuangan - Pengeluaran
    GoRoute(
      name: 'pengeluaran_daftar',
      path: '/keuangan/pengeluaran/pengeluaran_daftar',
      builder: (context, state) => PengeluaranDaftarSection(),
    ),

    // Push dari Menu Kegiatan
    GoRoute(
        name: 'broadcast_daftar',
        path: '/broadcast_daftar',
        builder: (context, state) => const BroadcastDaftarSection(),
        routes: [
          GoRoute(
            path: 'broadcast_detail',
            name: 'broadcast_detail',
            builder: (context, state) => const BroadcastDetail(),
          ),
          GoRoute(
            name: 'broadcast_tambah',
            path: 'broadcast_tambah',
            builder: (context, state) => const BroadcastTambah(),
          )
        ]),
    GoRoute(
        name: 'kegiatan_daftar',
        path: '/kegiatan_daftar',
        builder: (context, state) => const KegiatanDaftarSection(),
        routes: [
          GoRoute(
            path: 'kegiatan_detail_detail',
            name: 'kegiatan_detail',
            builder: (context, state) => const KegiatanDetail(),
          ),
          GoRoute(
            name: 'kegiatan_tambah',
            path: 'kegiatan_tambah',
            builder: (context, state) => const KegiatanTambah(),
          )
        ]),
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
    GoRoute(
      name: 'tambah_pengguna',
      path: '/tambah_pengguna',
      builder: (context, state) => const TambahPenggunaSection(),
    ),
  ],
);
