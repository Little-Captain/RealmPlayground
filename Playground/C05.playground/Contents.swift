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

// setup
let realm = try! Realm(configuration:
  Realm.Configuration(inMemoryIdentifier: "TemporaryRealm"))
try! TestDataSet.create(in: realm)

// Fetching all objects of a type
Example.of("Getting All Objects") {
    let people = realm.objects(Person.self)
    let articles = realm.objects(Article.self)
    
    print("\(people.count) people and \(articles.count) articles")
}

// Fetching an object by its primary key
Example.of("Getting an Object by Primary Key") {
    let person = realm.object(ofType: Person.self, forPrimaryKey: "test-key")
    
    if let person = person {
        print("Person with Primary Key 'test-kye': \(person.firstName)")
    } else {
        print("Not found")
    }
}

// Accessing objects in a result set
Example.of("Accessing Results") {
    let people = realm.objects(Person.self)
    print("Realm contains \(people.count) people")
    print("First person is: \(people.first!.fullName)")
    print("Second person is: \(people[1].fullName)")
    print("Last person is: \(people.last!.fullName)")
    
    let firstNames = people
        .map { $0.firstName }
        .joined(separator: ", ")
    print("First names of all people are: \(firstNames)")
    
    let namesAndIds = people
        .enumerated()
        .map { "\($0.offset): \($0.element.firstName)" }
        .joined(separator: ", ")
    print("People and indexes: \(namesAndIds)")
}

Example.of("Results Indexes") {
    let people = realm.objects(Person.self)
    let person = people[1]
    
    if let index1 = people.index(of: person) {
        print("\(person.fullName) is at index \(index1)")
    }
    
    if let index2 = people.index(where: { $0.firstName.starts(with: "F") }) {
        print("Name starts with F at index \(index2)")
    }
    
    if let index3 = people.index(matching: "hairCount < %d", 10000) {
        print("Person with less than 10,000 hairs at index \(index3)")
    }
}

Example.of("Filering") {
    let people = realm.objects(Person.self)
    print("All People: \(people.count)")
    
    let living = realm.objects(Person.self).filter("deceased = nil")
    print("Living People:\(living.count)")
}












