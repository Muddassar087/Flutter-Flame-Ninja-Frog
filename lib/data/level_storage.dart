import 'package:flutter_game_2/data/levels.dart' as level_data;
import 'package:flutter_game_2/model/level_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelsData {
  static SharedPreferences? sharedPreferences;
  static String key = "secretKey";

  static Future<void> deleteLevels() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    await sharedPreferences!.remove(key);
  }

  static Future<void> unlockAndActivate(int level) async {
    for (int i = 0; i < level_data.levels.length; i++) {
      if (i == level) {
        level_data.levels[i].isActive = true;
        level_data.levels[i].isLocked = false;
      } else {
        level_data.levels[i].isActive = false;
      }
    }

    await saveLevelProgress();
  }

  static Future<void> updateActiveStatus(int level) async {
    for (int i = 0; i < level_data.levels.length; i++) {
      if (i == level) {
        level_data.levels[i].isActive = true;
      } else {
        level_data.levels[i].isActive = false;
      }
    }

    await saveLevelProgress();
  }

  static Future<void> saveLevelProgress() async {
    List<String> decodedLevels = [];
    for (var level in level_data.levels) {
      decodedLevels.add(level.toJsonString());
    }

    sharedPreferences ??= await SharedPreferences.getInstance();
    await sharedPreferences!.setStringList(key, decodedLevels);
  }

  static Future<void> getSavedLevelProgress() async {
    await Future.delayed(const Duration(seconds: 1));
    sharedPreferences ??= await SharedPreferences.getInstance();

    List<String>? levelsEncoded = sharedPreferences!.getStringList(key);

    /// WHEN NOT LEVEL SAVE FOUND;
    if (levelsEncoded == null) {
      await saveLevelProgress();
      return;
    }

    List<LevelModel> temp = [];
    for (var levels in levelsEncoded) {
      temp.add(LevelModel.fromJsonEncodedString(levels));
    }

    level_data.levels = temp;
  }
}
