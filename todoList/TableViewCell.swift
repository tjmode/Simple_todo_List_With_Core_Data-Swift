//
//  TableViewCell.swift
//  todoList
//
//  Created by Tonywilson Jesuraj on 22/03/21.
//  Copyright © 2021 Tonywilson Jesuraj. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var todoListLabel: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
