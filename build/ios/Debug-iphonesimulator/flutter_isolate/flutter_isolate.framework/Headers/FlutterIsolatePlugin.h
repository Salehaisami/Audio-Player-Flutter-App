#import <Flutter/Flutter.h>

#define FLUTTER_ISOLATE_NAMESPACE @"com.rmawatson.flutterisolate"

@interface FlutterIsolatePlugin : NSObject<FlutterPlugin,FlutterStreamHandler>
@end
