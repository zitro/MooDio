//
//  RecordedAudio.swift
//  MooDio Recorder
//
//  Created by Bryan Ortiz on 6/25/15.
//  Copyright (c) 2015 NerdyCow. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathURL: NSURL, title: String) {
        self.filePathUrl = filePathURL
        self.title = title
    }
}