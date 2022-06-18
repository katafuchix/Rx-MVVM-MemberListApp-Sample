//
//  MemberDetailViewController.swift
//  Rx-MVVM-MemberListApp-Sample
//
//  Created by cano on 2022/06/18.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemberDetailViewController: UIViewController {

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var age: UILabel!
    
    public var member = BehaviorRelay<Member?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUpViews()
        self.bind()
    }
    
    func setUpViews() {
        self.id.text = ""
        self.avatarImage.image = UIImage()
        self.name.text = ""
        self.job.text = ""
        self.age.text = ""
    }
    
    func bind() {
        self.member
            .filter { $0 != nil }
            .subscribe(onNext: { [unowned self] member in
                guard let member = member else { return }
                self.id.text = "ID : \(member.id)"
                self.avatarImage.sd_setImage(with: URL(string: member.avatar.replacingOccurrences(of: "size=50x50&", with: "")))
                self.name.text = member.name
                self.job.text = member.job
                self.age.text = "\(member.age)"
            }).disposed(by: rx.disposeBag)
        
        /*
        self.member
            .filter { $0 != nil }
            .map{ "\($0!.id)" }
            .bind(to: self.id.rx.text)
            .disposed(by: rx.disposeBag)
         */
    }

}
