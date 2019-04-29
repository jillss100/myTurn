//
//  RoundedCorners.swift
//  MyTurn
//
//  Created by Jill Uhl on 4/8/19.
//  Copyright © 2019 Kidlatta. All rights reserved.
//

import UIKit

class RoundedCorners: UIButton {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
    
}
