//
//  Repository.swift
//  Rx-MVVM-MemberListApp-Sample
//
//  Created by cano on 2026/02/04.
//

import Foundation
import RxSwift

// 通信部分を抽象化
protocol MemberRepositoryType {
    func fetchMembers() -> Observable<[Member]>
}

class MemberRepository: MemberRepositoryType {
    func fetchMembers() -> Observable<[Member]> {
        let urlStr = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"
        let url = URL(string:urlStr)!
        return URLRequest.load(resource: Resource<[Member]>(url: url))
    }
}
