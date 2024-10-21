import 'dart:io';
import 'package:path/path.dart' as f_path;
import 'package:path_provider/path_provider.dart';

enum CacheType {
  search("search"),
  cluster("cluster"),
  article("article"),;

  final String folderName;
  const CacheType(this.folderName);
}

class NetCache {
  static const int _zero = 0;
  static const int _invalidPage = 0;
  static const int _3hourToMilliseconds = 1000 * 60 * 60 * 3;

  static Future<String> read(CacheType cacheType, String fileName,
      {int page = _invalidPage, int totalCount = _zero}) async {
    if (false == await _createDir(cacheType, page == _invalidPage ? "" : fileName)) {
      print('NetCache read _createDir fail');
      return '';
    }
    return _check(cacheType, fileName, page, totalCount);
  }

  static Future<void> write(String data, CacheType cacheType, String fileName,
      {int page = _invalidPage, int totalCount = _zero}) async {
    if (false == await _createDir(cacheType, page == _invalidPage ? "" : fileName)) {
      print('NetCache write _createDir fail');
      return;
    }
    return _flush(data, cacheType, fileName, page, totalCount);
  }

  static Future<void> openCacheDir() async {
    final Directory cacheDir = await getApplicationCacheDirectory();
    await Process.run('explorer', [cacheDir.absolute.path]);
  }

  static Future<void> clearCacheDir() async {
    final Directory cacheDir = await getApplicationCacheDirectory();
    cacheDir.list().forEach((fs) async {
      print('clearCacheDir ${fs.absolute.path}');
      fs.delete(recursive: true);
    });
  }

  static Future<String> _check(CacheType cacheType, String fileName,
      int page, int totalCount) async {
    var dumpPath = await _generateDumpPath(cacheType, fileName, page);
    var metaPath = await _generateMetaPath(cacheType, fileName);

    var metaFile = File(metaPath);
    if (false == await metaFile.exists()) {
      print('NetCache metaFile is not exist : $metaPath');
      return '';
    }

    var timeCheck = page < 2;
    var files = await _getAllDump(File(dumpPath));
    if (page == 1 && files.length != totalCount) {
      print('NetCache length != totalCount');
      await _deleteFiles(files);
      timeCheck = false;
    }

    if (timeCheck) {
      var saveTs = int.parse(await metaFile.readAsString());
      var currentTs = DateTime.now().millisecondsSinceEpoch;
      //after 3 hour
      if (currentTs - saveTs > _3hourToMilliseconds) {
        print('NetCache metaFile saved after 3 hour');
        if (page == 1) {
          await _deleteFiles(files);
        }
        return '';
      }
    }

    var dumpFile = File(dumpPath);
    if (false == await dumpFile.exists()) {
      print('NetCache dumpFile is not exist : $dumpFile');
      return '';
    }

    return await dumpFile.readAsString();
  }

  static Future<void> _flush(String data, CacheType cacheType, String fileName,
      int page, int totalCount) async {
    var dumpPath = await _generateDumpPath(cacheType, fileName, page);
    var metaPath = await _generateMetaPath(cacheType, fileName);

    var dumpFile = File(dumpPath);
    if (page < 2) {
      var metaFile = File(metaPath);
      var currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      await metaFile.writeAsString(currentTimestamp.toString(), flush: true);
    }

    await dumpFile.writeAsString(data, flush: true);
    print('NetCache _flush ${dumpFile.absolute.path}');
  }

  static Future<bool> _createDir(CacheType cacheType, String subName) async {
    final Directory cacheDir = await getApplicationCacheDirectory();
    var path = subName.isEmpty
        ? f_path.join(cacheDir.absolute.path, cacheType.folderName)
        : f_path.join(cacheDir.absolute.path, cacheType.folderName, subName);
    var dir = await Directory(path).create(recursive: true);
    print('NetCache _createDir $path');
    return await dir.exists();
  }

  static Future<String> _generateDumpPath(CacheType cacheType, String fileName, int page) async {
    final Directory cacheDir = await getApplicationCacheDirectory();
    return page == _invalidPage
        ? f_path.join(cacheDir.absolute.path, cacheType.folderName, '$fileName.dump')
        : f_path.join(cacheDir.absolute.path, cacheType.folderName, fileName, '${page.toString()}.dump');
  }

  static Future<String> _generateMetaPath(CacheType cacheType, String fileName) async {
    final Directory cacheDir = await getApplicationCacheDirectory();
    return f_path.join(cacheDir.absolute.path, cacheType.folderName, '$fileName.meta');
  }

  static Future<List<File>> _getAllDump(File dumpFile) async {
    List<File> files = [];
    await dumpFile.parent.list().forEach((fs) {
      files.add(File(fs.path));
    });
    return files;
  }

  static Future<void> _deleteFiles(List<File> files) async {
    for (var file in files) {
      await file.delete();
    }
  }
}