import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryConfig {
  // TODO: Ganti dengan credentials Anda dari Cloudinary Dashboard
  // https://console.cloudinary.com/
  //
  // Cara setup:
  // 1. Daftar di https://cloudinary.com/users/register_free (GRATIS, tanpa kartu kredit)
  // 2. Login ke https://console.cloudinary.com/
  // 3. Catat "Cloud name" dari Dashboard (contoh: dxyz123abc)
  // 4. Buat Upload Preset:
  //    - Settings > Upload > Add upload preset
  //    - Preset name: jawara_mobile (atau nama lain)
  //    - Signing Mode: Unsigned (PENTING!)
  //    - Folder: penerimaan_warga (opsional)
  //    - Save
  // 5. Ganti nilai di bawah dengan Cloud name dan Upload preset Anda

  static const String cloudName = 'dpoffkpkg'; // Ganti dengan Cloud name Anda
  static const String uploadPreset =
      'jawara_mobile'; // Ganti dengan Upload preset Anda

  static CloudinaryPublic getCloudinary() {
    return CloudinaryPublic(cloudName, uploadPreset, cache: false);
  }
}
