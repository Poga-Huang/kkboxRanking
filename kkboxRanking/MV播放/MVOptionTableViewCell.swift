//
//  MVOptionTableViewCell.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/13.
//

import UIKit

class MVOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureCell(with viewModel:SongCellViewModel){
        songNameLabel.text = viewModel.data.fields.ShortSongName
    }
    
}
