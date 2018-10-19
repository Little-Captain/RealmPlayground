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
    
    deinit { print("\(type(of: self).description()) 被释放") }
    
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
    // Bool
    @objc dynamic var isVIP: Bool = false
//    let allowPublication = RealmOptional<Bool>()
    
    // Int
    @objc dynamic var id = 0
    @objc dynamic var hairCount: Int64 = 0
    
    // Float
    @objc dynamic var height: Float = 0.0
    @objc dynamic var weight = 0.0
    
    // Custom types
    // Wrapping CLLocation
//    private let lat = RealmOptional<Double>()
//    private let lng = RealmOptional<Double>()
//
//    var lastLocation: CLLocation? {
//        get {
//            guard let lat = lat.value, let lng = lng.value else {
//                return nil
//            }
//            return CLLocation(latitude: lat, longitude: lng)
//        }
//        set {
//            lat.value = newValue?.coordinate.latitude
//            lng.value = newValue?.coordinate.longitude
//        }
//    }
    // 为了在 Playground 中运行通过, 注释掉所有的 RealmOptional 类型代码
    // 但是在 非 Playground 环境中, RealmOptional 类型能够正常使用!!!
    
    // Enumerations
    enum Department: String {
        case technology
        case politics
        case business
        case health
        case science
        case sports
        case travel
    }
    @objc dynamic private var _department = Department.technology.rawValue
    var department: Department {
        get { return Department(rawValue: _department)! }
        set { _department = newValue.rawValue }
    }
    
    // Computed properties (Realm 不会管理它们)
    var isDeceased: Bool {
        return deceased != nil
    }
    
    var fullName: String {
        guard let last = lastName else { return firstName }
        return "\(firstName) \(last)"
    }
    
    // Convenience initializers
    convenience init(firstName: String, born: Date, id: Int) {
        self.init()
        self.firstName = firstName
        self.born = born
        self.id = id
    }
    
    // Default object description
//    override var description: String {
//        return fullName
//    }
    
    // Meta information
    // Primary key
    @objc dynamic var key = UUID().uuidString
    override static func primaryKey() -> String? {
        return "key"
    }
    
    // Indexed properties
    override static func indexedProperties() -> [String] {
        return ["firstName", "lastName"]
    }
    
    // Ignored properties
    // Properties with inaccessible setters
    let idPropertyName = "id"
    var temporaryId = 0
    
    // Custom ignored properties
    @objc dynamic var temporaryUploadId = 0
    override static func ignoredProperties() -> [String] {
        return ["temporaryUploadId"]
    }
    
}

Example.of("Complex Model") {
    let person = Person(firstName: "Marin",
                        born: Date(timeIntervalSince1970: 0),
                        id: 1035)
    person.hairCount = 1284639265974
    person.isVIP = true
    
    print(type(of: person))
    print(type(of: person).primaryKey() ?? "no primary key")
    print(type(of: person).className())
    print(Person.className())
    print(Person.primaryKey() ?? "no primary key")
    
    print(person)
}

@objcMembers class Article: Object {
    
    deinit { print("\(type(of: self).description()) 被释放") }
    
    dynamic var id = 0
    dynamic var title: String?
    
}

Example.of("Using @objcMembers") {
    let article = Article()
    article.title = "New article about a famous person"
    print(article)
}

@objcMembers class Book: Object {
    
    dynamic var ISBN = ""
    dynamic var title = ""
    dynamic var author = ""
    dynamic var bestseller = false
    dynamic var firstPublishDate = Date.distantPast
    dynamic var lastPublishDate: Date?
    
    convenience init(ISBN: String, title: String, author: String, firstPublishDate: Date) {
        self.init()
        self.ISBN = ISBN
        self.title = title
        self.author = author
        self.firstPublishDate = firstPublishDate
    }
    
    enum Property: String {
        case ISBN, bestseller
    }
    
    override static func primaryKey() -> String? {
        return Property.ISBN.rawValue
    }
    
    override static func indexedProperties() -> [String] {
        return [Property.bestseller.rawValue]
    }
    
    enum Classification: String {
        case fiction
        case nonFiction
        case selfHelp
    }
    // @objcMembers, 不会为私有属性添加 @objc 标识符
    @objc dynamic private var _type = Classification.fiction.rawValue
    var type: Classification {
        set { _type = newValue.rawValue }
        get { return Classification(rawValue: _type)! }
    }
    
}

Example.of("Challenge 1") {
    let book = Book(ISBN: "1234567890",
                    title: "Realm by Tutorials",
                    author: "Marin Todorov",
                    firstPublishDate: Date())
    book.bestseller = true
    book.type = .nonFiction
    
    print(book)
}












