//
//  Protocols.swift
//  POPWWDC
//
//  Created by Admin on 20/11/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

protocol NamedImageData {
    var name: String { get }
    var data: Data { get }
    init(name: String, data: Data)
}

protocol ImageDataPersisting: NamedImageData {
    init(name: String, contentsOf url: URL) throws
    func save(to url: URL) throws
}

extension ImageDataPersisting {
    init(name: String, contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        self.init(name: name, data: data)
    }
    
    func save(to url: URL) throws {
        try self.data.write(to: url)
    }
}

protocol ImageDataCompressing: NamedImageData {
    func compress(withQuality compressionQuality: Double) -> Self?
}

extension ImageDataCompressing {
    func compress(withQuality compressionQuality: Double) -> Self? {
        guard let uiImage = UIImage.init(data: self.data) else {
            return nil
        }
        guard let jpegData = uiImage.jpegData(compressionQuality: CGFloat(compressionQuality)) else {
            return nil
        }
        return Self(name: self.name, data: jpegData)
    }
}

protocol ImageDataEncoding: NamedImageData {
    var base64Encoded: String { get }
}


extension ImageDataEncoding {
    var base64Encoded: String {
        return self.data.base64EncodedString()
    }
}

struct MyImage: ImageDataPersisting, ImageDataCompressing, ImageDataEncoding {
    var name: String
    var data: Data
}

struct InMemoryImage: NamedImageData, ImageDataCompressing, ImageDataEncoding {
    var name: String
    var data: Data
}
