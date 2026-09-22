import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

//Singleton Class
class HiveService {
  static final HiveService _instance = HiveService._();
  bool _initialized = false;

  factory HiveService() => _instance;

  HiveService._();

  Future<void> init() async {
    if (_initialized) return;
    final appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    await Hive.openBox(HiveKeys.boxName);
    _initialized = true;
  }

  Future<Box> _getBox() async {
    if (!_initialized) await init();
    return Hive.box(HiveKeys.boxName);
  }

  Future<void> write(String key, dynamic value) async {
    final box = await _getBox();
    await box.put(key, value);
  }

  Future<T?> read<T>(String key) async {
    final box = await _getBox();
    return box.get(key) as T?;
  }

  Future<List<T>> readList<T>(String key) async {
    final box = await _getBox();
    return box.get(key)?.cast<T>() ?? [];
  }

  Future<void> delete(String key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  Future<void> clear() async {
    final box = await _getBox();
    box.clear();
  }

  Future<bool> contains(String key) async {
    final box = await _getBox();
    return box.containsKey(key);
  }

  // Version update dialog management
  Future<void> saveDismissedVersion(String platform, String version) async {
    final key = '${HiveKeys.dismissedVersionPrefix}${platform}_$version';
    await write(key, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> isVersionDismissed(String platform, String version) async {
    final key = '${HiveKeys.dismissedVersionPrefix}${platform}_$version';
    return await contains(key);
  }

  Future<void> clearDismissedVersions() async {
    final box = await _getBox();
    final keys = box.keys.where(
      (key) => key.toString().startsWith(HiveKeys.dismissedVersionPrefix),
    );
    for (final key in keys) {
      await box.delete(key);
    }
  }
}

mixin HiveKeys {
  static const String boxName = 'appBox';
  static const String fcmToken = 'fcmToken';
  static const String user = 'user';
  static const String inviteCode = 'inviteCode';
  static const String postId = 'postId';
  static const String token = 'token';
  static const String register = 'register';
  static const String appSettings = 'appSettings';
  static String activeCampaign = 'activeCampaign';
  static String activeSession = 'activeSession';
  static const String dismissedVersionPrefix = 'dismissed_version_';
  static const String isDetailScreenOpened = 'isDetailScreenOpened';
  static const String joinToken = 'joinToken';
  // Order tracking: lets a relaunched app resume mid-order instead of
  // restarting the timeline from the first status.
  static const String activeOrderId = 'activeOrderId';
  static const String activeOrderStartedAt = 'activeOrderStartedAt';
  static const String hasShownJoinOverlay = 'hasShownJoinOverlay';
}
