//
//  AppDelegate.swift
//  Swacoun-2018
//
//  Created by Marcel Weiher on 9/14/18.
//  Copyright © 2018 metaobject. All rights reserved.
//

import Cocoa
import MPWFoundation
import JASON
import ZippyJSON


@NSApplicationMain
class SwacounAppDelegate: NSObject, NSApplicationDelegate {

    var objects:[TestClass]=[]
    
    func createObjects() {
        for i:Int in 1...1000000 {
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


    func messagePack() -> Data {
        NSLog("Swift Coding / Message Pack")
        let coder=MessagePackEncoder()
        let data=try! coder.encode(objects)
        return data
    }

    func readMessagePack(data:Data) -> [TestClass] {
        NSLog("Message Pack (Swift) Decoding")
        let coder=MessagePackDecoder( )
        let array=try! coder.decode([TestClass].self, from: data)
        return array
    }

    func readJASON(data:Data )  -> [Any] {
        NSLog("JASON Coding")
        let objects=JSON( data )
        return objects.array!
    }
    
    func writeJSONCoder() -> Data {
        NSLog("Swift Coding")
        let coder=JSONEncoder()
        let data=try! coder.encode(objects)
        return data
    }
//    func writePureJSONCoder() -> Data {
//        NSLog("PureJSONCoder() -> Data {")
//        let coder=PureJSONEncoder()
//        let data=try! coder.encode(objects)
//        return Data(bytes:data, count:data.count )
//    }
    func readJSONCoder(data:Data) -> [TestClass] {
        NSLog("Swift Decoding")
        let coder=JSONDecoder( )
        let array=try! coder.decode([TestClass].self, from: data)
        return array
    }

    func readPureJSONCoder(data:Data) -> [TestClass] {
        NSLog("PurerSwift Decoding")
        let coder=PureJSONDecoder( )
        let array=try! coder.decode([TestClass].self, from: data)
        return array
    }

    func readPureJSONParser(data:Data) -> [Any] {
        NSLog("PurerSwift Parsing")
        let value=try! JSONParser().parse(bytes: data )
        guard case .array(let array) = value else {
            return ["Parse error"]
        }

        return array
    }

    func readZippyCoder(data:Data) -> [TestClass] {
        NSLog("Zippy Decoding")
        let coder=ZippyJSONDecoder( )
        let array=try! coder.decode([TestClass].self, from: data)
        return array
    }

    func readSTJSON(data:Data) -> [Any] {
        var p = STJSONParser(data: data)
        let o = try! p.parse()
        return o as! [Any]
    }

    func writeJSONSerialization() -> Data {
        NSLog("NSJSONSerialization, create plist")
        let plist=self.objects.map { $0.asDictionary() }
        NSLog("NSJSONSerialization, encode the plist")
        return try! JSONSerialization.data(withJSONObject: plist, options: [])
    }
    func readJSONSerialization(data:Data) -> [Any]  {
        NSLog("NSJSONSerialization, decode data to plist")
        let array = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [Any]
        return array
    }

    func readMPWDirect(data:Data) -> [Any]  {
        let parser=MPWMASONParser(with: TestClass.self)
        let result=parser?.parsedData(data)
        return result as! [Any]
    }


    func fileurl() -> URL {
        URL(fileURLWithPath: "/tmp/swlist.json")
    }

    func encodeTest() {
        NSLog("will create")
        createObjects()
        let start =  Date.timeIntervalSinceReferenceDate;
        //        let data = writeJSONViaStream()
//        let data = messagePack()
        let data = writeJSONCoder()
//        let data = writePureJSONCoder()
     //        let data = writeBPListViaStream()
        //      let data = writeJSONSerialization()
        let encodeTime = Date.timeIntervalSinceReferenceDate - start
        NSLog("did encode in %g seconds, write",encodeTime)
        let writStart = Date.timeIntervalSinceReferenceDate
        try! data.write(to:fileurl() , options: [])
        let writeTime = Date.timeIntervalSinceReferenceDate - writStart
        NSLog("did write in %g seconds",writeTime)
        NSLog("total: %g seconds",encodeTime+writeTime)
        NSLog("I/O: %g %%",writeTime/encodeTime * 100.0)
        NSLog("CPU: %g %%",100 - (writeTime/encodeTime * 100.0))
    }

    func decodeTest() {
        NSLog("decodeTest")
        let data = try! Data(contentsOf: fileurl())
        let start =  Date.timeIntervalSinceReferenceDate
        let array = readJSONCoder( data:data )
//        let array = readZippyCoder( data:data )
//        let array = readPureJSONCoder(data: data)
//        let array = readPureJSONParser(data: data)

//        let array = readMessagePack( data:data )
//        let array = readSTJSON( data:data )
//        let array = readJASON(data: data)
//        let array = readJSONSerialization(data:data)
//        let array=readMPWDirect(data:data)
        let decodeTime = Date.timeIntervalSinceReferenceDate - start
        NSLog("array with %ld elements",array.count)
        print("elements[0]=\(array[0])")
        NSLog("did decode in %g seconds",decodeTime)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
       encodeTest()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

