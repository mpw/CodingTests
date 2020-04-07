//
//  TestClass.swift
//  Swacoun-2018
//
//  Created by Marcel Weiher on 9/14/18.
//  Copyright © 2018 metaobject. All rights reserved.
//

import Foundation
import MPWFoundation

@objc class TestClass: NSObject, Codable {
    let hi:Int32
    let there:Int32
    let comment:String


    init( hi:Int32 , there:Int32, comment:String ) {
        self.hi=hi
        self.there=there
        self.comment=comment
    }
    
    
    public func asDictionary() -> [String:Any] {
        return ["hi": hi,
                "there": there,
                "comment": comment]
    }
    
    @objc override public func write(onJSONStream aStream: MPWJSONWriter!) {
        aStream.writeDictionaryLike( "") { (writer) in
            if let writer=writer {
                writer.writeInteger(self.hi, forKey: "hi")
                writer.writeInteger(self.there, forKey: "there")
                writer.write(self.comment, forKey: "comment")
            }
        }
    }

}
