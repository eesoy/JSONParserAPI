//
//  MovieTableViewCell.swift
//  JSONParserAPI
//
//  Created by SO YOUNG on 2018. 1. 13..
//  Copyright © 2018년 SO YOUNG. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
