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
}

extension Member {
    static let EMPTY = Member(id: 0, name: "name", avatar: "", job: "job", age: 0)
}
