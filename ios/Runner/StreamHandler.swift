//
//  StreamHandler.swift
//  Runner
//
//  Created by Angga Dwi Arifandi on 18/03/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

public class NativeStreamHandler: FlutterStreamHandler {
    
    var eventSink: FlutterEventSink?
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
}
