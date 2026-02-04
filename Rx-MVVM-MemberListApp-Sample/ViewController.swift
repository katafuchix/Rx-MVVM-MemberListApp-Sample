//
//  ViewController.swift
//  Rx-MVVM-MemberListApp-Sample
//
//  Created by cano on 2022/06/18.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import MBProgressHUD

class ViewController: UIViewController {

    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var loadButton: UIButton!
    
    let viewModel = ViewModel(repository: MemberRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupViews()
        self.bind()
        
        // トリガ起動
        //self.viewModel.inputs.trigger.onNext(())
        
        // バインド（購読）が成立したタイミングでトリガが起動される
        /*Observable.just(()) // 一度だけストリームを流して完了
            .bind(to: self.viewModel.inputs.trigger)
            .disposed(by: rx.disposeBag)*/
    }

    func setupViews() {
        
    }
    
    func bind() {
        // メンバー一覧
        self.viewModel.outputs
            .members
            .asObservable().bind(to: self.tableView.rx.items) { (tableView, row, element ) in
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.memberCell, for:  IndexPath(row : row, section : 0))!
                cell.configure(element)
                return cell
            }.disposed(by: rx.disposeBag)
        
        // セル選択
        self.tableView.rx.modelSelected(Member.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] member in
                guard let self = self, let vc = R.storyboard.main.memberDetailViewController() else { return }
                vc.member.accept(member)
                self.present(vc, animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        // メンバー取得中はMBProgressHUDを表示
        self.viewModel.outputs
            .isLoading.asDriver(onErrorJustReturn: false)
            .distinctUntilChanged()
            .drive(MBProgressHUD.rx.isAnimating(view: self.view))
            .disposed(by: rx.disposeBag)
        
        // 再読み込み
        // loadData()メソッドを介さず、triggerに直接流し込む
        /*
        self.loadButton.rx.tap
            .bind(to: self.viewModel.inputs.trigger)
            .disposed(by: rx.disposeBag)
        */
        
        // まとめて記述
        // ボタンのタップ or 画面起動時のシグナル、どちらかが来たら trigger へ
        Observable.merge([
            self.loadButton.rx.tap.asObservable(),
            Observable.just(()) // 起動時の一発
        ])
        .bind(to: self.viewModel.inputs.trigger)
        .disposed(by: rx.disposeBag)
    }
    
    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
}

