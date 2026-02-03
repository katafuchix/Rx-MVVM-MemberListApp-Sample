//
//  Member.swift
//  Rx-MVVM-MemberListApp-Sample
//
//  Created by cano on 2022/06/18.
//

import Foundation

struct Member: Codable {
    let id : Int
    let name: String
    let avatar: String
    let job: String
    let age: Int
    
    init(id: Int, name: String, avatar: String, job: String, age: Int) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.job = job
        self.age = age
    }
}

extension Member {
    static let EMPTY = Member(id: 0, name: "name", avatar: "", job: "job", age: 0)
}
