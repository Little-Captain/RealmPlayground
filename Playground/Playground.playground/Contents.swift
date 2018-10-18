/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Realm
import RealmSwift
import CoreLocation

// Setup
let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TemporaryRealm"))

print("Ready to play...")

// Playground

/// Object basics
class Car: Object {
    
    @objc dynamic var brand = ""
    @objc dynamic var year = 0
    
    convenience init(brand: String, year: Int) {
        self.init()
        self.brand = brand
        self.year = year
    }
    
    override var description: String {
        return "🚗 {\(brand), \(year)}"
    }
    
    deinit { print("\(type(of: self).description()) 被释放") }
    
}

Example.of("Basic Model") {
    let car1 = Car(brand: "BMW", year: 1980)
    print(car1)
}

/// Storage data types
class Person: Object {
    
    // Object-type properties
    // String
    @objc dynamic var firstName = ""
    @objc dynamic var lastName: String?
    
    // Date
    @objc dynamic var born = Date.distantPast
    @objc dynamic var deceased: Date?
    
    // Data (应尽量避开存储 Data)
    @objc dynamic var photo: Data?
    
    // Primitive-type properties
    
    
}












