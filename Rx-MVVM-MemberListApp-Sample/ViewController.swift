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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadButton: UIButton!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupViews()
        self.bind()
        
        self.viewModel.inputs.trigger.onNext(())
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
            .subscribe(onNext: { [unowned self] member in
                let vc = R.storyboard.main.memberDetailViewController()!
                vc.member.accept(member)
                self.present(vc, animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        // メンバー取得中はMBProgressHUDを表示
        self.viewModel.outputs
            .isLoading.asDriver(onErrorJustReturn: false)
            .drive(MBProgressHUD.rx.isAnimating(view: self.view))
            .disposed(by: rx.disposeBag)
        
        // activityIndicator
        self.viewModel.outputs
            .members
            .observe(on: MainScheduler.instance)
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] visible in
                self?.setVisibleWithAnimation(self?.activityIndicator, visible)
            })
            .disposed(by: rx.disposeBag)
        
        // 再読み込み
        self.loadButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.viewModel.loadData()
            })
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

