//
//  AppDelegate.swift
//  Swacoun-2018
//
//  Created by Marcel Weiher on 9/14/18.
//  Copyright © 2018 metaobject. All rights reserved.
//

import Cocoa
import MPWFoundation
import ObjectiveXML

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var objects:[TestClass]=[]
    
    func createObjects() {
        for i:Int32 in 1...1000000 {
            objects.append(TestClass(hi: i, there: i*2, comment: "comment"))
        }
    }
    
    func writeJSONViaStream() -> Data {
        NSLog("Stream Encode")
        let data=NSMutableData()
        let writer = MPWJSONWriter(target: data)!
        writer.write( objects )
        writer.close()
        return data as Data
    }
    
    func writeBPListViaStream() -> Data {
        NSLog("BPList Stream Encode")
        let data=NSMutableData()
        let writer = MPWBinaryPListWriter(target: data)!
        writer.write( objects )
        writer.close()
        return data as Data
    }
    

    
    func writeJSONCoder() -> Data {
        NSLog("Swift Coding")
        let coder=JSONEncoder()
        let data=try! coder.encode(objects)
        return data
    }
    func writeJSONSerialization() -> Data {
        NSLog("NSJSONSerialization, create plist")
        let plist=self.objects.map { $0.asDictionary() }
        NSLog("NSJSONSerialization, encode the plist")
        return try! JSONSerialization.data(withJSONObject: plist, options: [])
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSLog("will create")
        createObjects()
        let start =  Date.timeIntervalSinceReferenceDate;
        let data = writeJSONViaStream()
//      let data = writeJSONCoder()
//        let data = writeBPListViaStream()
//      let data = writeJSONSerialization()
        let encodeTime = Date.timeIntervalSinceReferenceDate - start
        NSLog("did encode in %g seconds, write",encodeTime)
        let writStart = Date.timeIntervalSinceReferenceDate
        try! data.write(to: URL(fileURLWithPath: "/tmp/swlist.json"), options: [])
        let writeTime = Date.timeIntervalSinceReferenceDate - writStart
        NSLog("did write in %g seconds",writeTime)
        NSLog("total: %g seconds",encodeTime+writeTime)
        NSLog("I/O: %g %%",writeTime/encodeTime * 100.0)
        NSLog("CPU: %g %%",100 - (writeTime/encodeTime * 100.0))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

