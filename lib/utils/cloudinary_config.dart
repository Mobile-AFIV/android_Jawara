import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryConfig {
  static const String cloudName = 'dpoffkpkg';
  static const String uploadPreset = 'jawara_mobile';

  static CloudinaryPublic getCloudinary() {
    return CloudinaryPublic(cloudName, uploadPreset, cache: false);
  }
}
