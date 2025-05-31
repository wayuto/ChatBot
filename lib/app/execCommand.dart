import 'package:shizuku_api/shizuku_api.dart';

class ExecCommand {
  final ShizukuApi _shizukuApi = ShizukuApi();

  Future<void> init() async {
    final hasPermission = await _shizukuApi.checkPermission();
    if (hasPermission == false) {
      await _shizukuApi.requestPermission();
    }
  }

  Future<String> execCommand(String command) async {
    try {
      await init(); // 确保有权限
      final result = await _shizukuApi.runCommand(command);
      return result ?? "命令执行成功但无输出";
    } catch (e) {
      return "Error executing command: $e";
    }
  }
}