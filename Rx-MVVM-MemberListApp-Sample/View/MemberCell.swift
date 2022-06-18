//
//  MemberCell.swift
//  Rx-MVVM-MemberListApp-Sample
//
//  Created by cano on 2022/06/18.
//

import UIKit
import SDWebImage

class MemberCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ member: Member) {
        self.clear()
        
        self.avatarImage.sd_setImage(with: URL(string: member.avatar))
        self.nameLabel.text = "\(member.name)"
        self.jobLabel.text = "\(member.job)"
        self.ageLabel.text = "(\(member.age))"
    }
    
    func clear() {
        self.avatarImage.image = UIImage()
        self.nameLabel.text = ""
        self.jobLabel.text = ""
        self.ageLabel.text = ""
    }
}
