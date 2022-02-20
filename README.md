# Schedule When
This is an app can help user to edit a timeline schedule to others. The app's name on AppStore is "Schedule When".

## 1. Important packages

### 1.1 flutter_native_splash
I use flutter_native_splash package to create my splash page. It's easy to use, but not good enough in my opinion.

. step1: get packages.
add the following code to pubspec.yaml
`
dev_dependencies:
  flutter_native_splash: ^1.1.5+1 
`

. step2: set splash_screen
`
% flutter pub run flutter_native_splash:create
`

you can remove splash_screen by following command, but sometimes it not work.
`
% flutter pub run flutter_native_splash:remove
`

### 1.2 calendar_view
You can find this package from pub.dev website. I made some change, becase I want to display my timeduration from 8 clock to 20 clock. (Source version display from 00-24)

source: https://pub.dev/packages/calendar_view

### 1.3 device_calendar
This package help you can access your device calendar. You can read all device calendar account which you setting for your iphone.

source: https://pub.dev/packages/device_calendar

### 1.4 screenshot
I use screenshot to capture calendar, then save as an photo image. So, user can attach the image to share with people. 
I change it to extend targetSize, because the capture size was limited in the source version.

source: https://pub.dev/packages/screenshot
    
## 2. Config
### For iOS
Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:

NSPhotoLibraryUsageDescription - describe why your app needs permission for the photo library. This is called Privacy - Photo Library Usage Description in the visual editor.

### 2.2 For Android
android.permission.WRITE_EXTERNAL_STORAGE - Permission for usage of external storage

source: https://github.com/CarnegieTechnologies/gallery_saver
