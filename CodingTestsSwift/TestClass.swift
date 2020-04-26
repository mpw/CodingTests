//
//  TestClass.swift
//  Swacoun-2018
//
//  Created by Marcel Weiher on 9/14/18.
//  Copyright © 2018 metaobject. All rights reserved.
//

import Foundation
import MPWFoundation

@objc class TestClass: MPWObject, Codable {
    var hi:Int
    var there:Int
    var comment:String


    init( hi:Int , there:Int, comment:String ) {
        self.hi=hi
        self.there=there
        self.comment=comment
    }
    override init() {
        self.hi=0
        self.there=0
        self.comment=""
        super.init()
    }
    
    public func asDictionary() -> [String:Any] {
        return ["hi": hi,
                "there": there,
                "comment": comment]
    }
    override var description: String {
        return "<\(type(of: self)): hi = \(hi) there = \(there) comment = '\(comment)'>"
    }

    @objc override public func write(onJSONStream aStream: MPWJSONWriter!) {
        aStream.writeDictionaryLike( "") { (writer) in
            if let writer=writer {
                writer.writeInteger(self.hi as! Int32, forKey: "hi")
                writer.writeInteger(self.there as! Int32 , forKey: "there")
                writer.write(self.comment, forKey: "comment")
            }
        }
    }

}
