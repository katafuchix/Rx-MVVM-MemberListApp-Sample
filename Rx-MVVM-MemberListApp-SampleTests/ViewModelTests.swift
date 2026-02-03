//
//  ViewModelTest.swift
//  Rx-MVVM-MemberListApp-Sample
//
//  Created by cano on 2026/02/04.
//


import XCTest
import RxSwift
import RxRelay
import RxTest

@testable import Rx_MVVM_MemberListApp_Sample

class ViewModelTests: XCTestCase {

    var viewModel: ViewModel!
    var mockRepository: MockMemberRepository!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        // 1. 仮想時間を扱うスケジューラを作成
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        
        self.mockRepository = MockMemberRepository()
        // テスト用の scheduler を注入してインスタンス化！
        self.viewModel = ViewModel(repository: self.mockRepository, scheduler: self.scheduler)
    }
    
    func test_loadData_success() {
        // 1. 準備
        let mockMembers = [Rx_MVVM_MemberListApp_Sample.Member(id: 1, name: "田中", avatar: "", job: "", age: 0)]
        mockRepository.stubbedMembers = .just(mockMembers)//.delay(.milliseconds(1), scheduler: scheduler)
        
        let membersObserver = scheduler.createObserver([Rx_MVVM_MemberListApp_Sample.Member].self)
        let loadingObserver = scheduler.createObserver(Bool.self)
        
        viewModel.outputs.members.subscribe(membersObserver).disposed(by: disposeBag)
        viewModel.outputs.isLoading.subscribe(loadingObserver).disposed(by: disposeBag)

        // 2. 実行
        viewModel.loadData()
        
        // Action の内部処理が進むように時間を進める
        scheduler.advanceTo(10)

        // 3. 検証
        // members の検証
        let memberEvents = membersObserver.events.compactMap { $0.value.element }
        XCTAssertEqual(memberEvents.last?.first?.name, "田中")

        // isLoading の検証 (false -> true -> false の順に変化するはず)
        let loadingEvents = loadingObserver.events.compactMap { $0.value.element }
        XCTAssertEqual(loadingEvents, [false, true, false])
    }
}


// MARK: - Test Helpers
final class MockMemberRepository: Rx_MVVM_MemberListApp_Sample.MemberRepositoryType {

    var stubbedMembers: Observable<[Rx_MVVM_MemberListApp_Sample.Member]> = .empty()// 成功時に返したいデータ
    var shouldReturnError = false  // エラーを発生させたい場合は true にする
    
    func fetchMembers() -> Observable<[Rx_MVVM_MemberListApp_Sample.Member]> {
        return stubbedMembers
    }
}
