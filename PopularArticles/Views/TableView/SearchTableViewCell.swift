//
//  SearchTableViewCell.swift
//  PopularArticles
//
//  Created by Nuzhat Zari on 09/09/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import UIKit
typealias OptionButtonClickedHandler = () -> Void

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var btnOptionText: UIButton!
    var optionButtonClickedHandler: OptionButtonClickedHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onBtnOptionClicked(_ sender: UIButton) {
        if optionButtonClickedHandler != nil {
            optionButtonClickedHandler!()
        }
    }

}
