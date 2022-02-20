# sortout_when
以下是本app開發的重點內容摘要,

## XCode設定
使用以下指令, 進行Xcode對flutter專案ios部分的設定
% open ios/Runner.xcworkspace

Note:
1). Runner.xcworkspace: xcode的工作區
2). Rnnner.xcodeproj: xcode的專案檔

## Flutter for Mac 指令
使用以下指令, 進行flutter對專案操作:
. 為ios進行建置
% flutter build ios

. 發佈程式到實體機(需將手機接到筆電, 並解鎖)
% flutter run --release


## 過場畫面採用套件: flutter_native_splash
Note:
flutter_native_splash要更換splash圖檔時有點麻煩, 它是generator的概念.
執行create時會變更android, ios的屬性檔, 會有cache, 有時移不乾淨.

. step1: 取得套件
將以下設定加入pubspec.yaml
dev_dependencies:
  flutter_native_splash: ^1.1.5+1 (版次依最新更新)

. step2: 設定 splash_screen
執行以下指令
% flutter pub run flutter_native_splash:create

. step2: 設定 splash_screen
執行以下指令

. 移除 splash_screen
執行以下指令
% flutter pub run flutter_native_splash:remove

## app icon製作與設定
. android: Icons 放在 android 資料夾裡的 mipmap 資料夾(包含各種螢幕的分辨率)
. ios: Icon 放在 /ios/Runner/Assets.xcassets 資料夾裡的 AppIcon.appiconset 資料夾(包含各種尺寸)

參考: https://ab20803.medium.com/flutter-%E5%85%A9%E5%80%8B%E5%B9%B3%E5%8F%B0app-icon%E7%9A%84%E8%A8%AD%E7%BD%AE%E6%96%B9%E5%BC%8F-647e7bc2e680
圖檔製作: https://makeappicon.com/

## 重要套件.
本專案使用了幾個重要的套件, 可從https://pub.dev 中找到.

  1. calendar_view
    行事曆顯示的套件, 原套件使用版本為0.0.3, 只有顯示0-24小時時間,
    所以, 下載開源修改, 並附加一些功能, 及修改一些bugs.

  2. device_calendar
    讀取手機行事曆的套件, 原套件使用版本為v.4.1.0.

  3. screenshot
    擷取畫面的套件, 原套件使用版本為v.1.2.3
    因為在pub.dev所發佈的版本, 限定了截圖大小, 所以下載開源修改, 擴充targetSize.
    

## app 儲存擷取畫面成為照片.
First, add gallery_saver as a dependency in your pubspec.yaml file.

. iOS
Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:

NSPhotoLibraryUsageDescription - describe why your app needs permission for the photo library. This is called Privacy - Photo Library Usage Description in the visual editor.

. Android
android.permission.WRITE_EXTERNAL_STORAGE - Permission for usage of external storage

參考: https://github.com/CarnegieTechnologies/gallery_saver
