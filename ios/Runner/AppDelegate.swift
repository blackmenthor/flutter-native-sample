import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let EVENT_CHANNEL = "com.anggach.flutternativesample/event_channel"
    private let METHOD_CHANGE_INTERNET: String = "CHANGE_INTERNET"
    
    private let CHANNEL: String = "com.anggach.flutternativesample/channel"
    private let METHOD_HELLO: String = "HELLO"
    
    private var streamHandler: NativeStreamHandler?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        setUpMethodChannel()
        setUpEventChannel()
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func setUpEventChannel() {
        guard let controller: FlutterViewController = window?.rootViewController as? FlutterViewController else {
            fatalError("Invalid root view controller")
        }
        
        let eventChannel = FlutterEventChannel(name: EVENT_CHANNEL, binaryMessenger: controller)
        
        if (self.streamHandler == nil) {
            self.streamHandler = NativeStreamHandler()
        }
        
        eventChannel.setStreamHandler((self.streamHandler as! FlutterStreamHandler & NSObjectProtocol))
    }
    
    func setUpMethodChannel() {
        guard let controller: FlutterViewController = window?.rootViewController as? FlutterViewController else {
            fatalError("Invalid root view controller")
        }
        
        let methodChannel = FlutterMethodChannel(name: CHANNEL,
                                                 binaryMessenger: controller)
        
        methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch call.method {
            case self.METHOD_HELLO:
                self.hello(call: call, result: result)
                break
            case self.METHOD_CHANGE_INTERNET:
                self.sendMessageToStream(call: call, result: result)
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    func sendMessageToStream(call: FlutterMethodCall, result: FlutterResult) {
        let args = call.arguments as? [String: Any?]
        let message = args?["connectivity"] as? Bool?
        
        if (self.streamHandler != nil && message != nil) {
            self.streamHandler?.eventSink?(message)
        }
    }
    
    func hello(call: FlutterMethodCall, result: FlutterResult) {
        result("HELLO WORLD")
    }
    
}
