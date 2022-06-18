//
//  ViewModel.swift
//  Rx-MVVM-MemberListApp-Sample
//
//  Created by cano on 2022/06/18.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import Action


protocol ViewModelInputs {
    var trigger: PublishSubject<Void> { get }
}

protocol ViewModelOutputs {
    var members : BehaviorRelay<[Member]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<ActionError> { get }
}

protocol ViewModelType {
    var inputs: ViewModelInputs { get }
    var outputs: ViewModelOutputs { get }
}


class ViewModel: ViewModelType, ViewModelInputs, ViewModelOutputs {

    var inputs: ViewModelInputs { return self }
    var outputs: ViewModelOutputs { return self }

    // MARK: - Inputs
    let trigger = PublishSubject<Void>()

    // MARK: - Outputs
    let members : BehaviorRelay<[Member]>
    let isLoading: Observable<Bool>
    let error: Observable<ActionError>
    
    // 内部変数
    private let action: Action<(), [Member]>
    private let disposeBag = DisposeBag()
    
    init() {
        
        // メンバー一覧
        self.members = BehaviorRelay<[Member]>(value: [])
        
        // アクション定義
        self.action = Action { _ in
            let urlStr = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"
            let url = URL(string:urlStr)!
            return URLRequest.load(resource: Resource<[Member]>(url: url))
        }
        
        // 記事
        self.action.elements
            .map { $0 }
            .bind(to:self.members)
            .disposed(by: disposeBag)
        
        // 起動
        self.trigger.asObservable()
            .bind(to:self.action.inputs)
            .disposed(by: disposeBag)
        
        // 検索中
        self.isLoading = action.executing.startWith(false)

        // エラー
        self.error = action.errors
    }
    
    func loadData() {
        self.members.accept([])
        self.trigger.onNext(())
    }
}
