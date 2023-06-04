//
//  SongCell.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/5/28.
//

import UIKit
import Combine

class SongCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var viewModel:SongCellViewModel?
    private var subscription = Set<AnyCancellable>()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coverImageView.layer.cornerRadius = coverImageView.bounds.height/8
    }
    
    override func prepareForReuse() {
        //清除所有訂閱 Configur再重新綁定
        subscription.removeAll()
        coverImageView.image = nil
    }
    
    //MARK: Configure Cell 
    func configure(with viewModel: SongCellViewModel) {
        
        self.viewModel = viewModel
        let info = viewModel.data.fields
        
        rankLabel.text = info.Rank
        songLabel.text = info.SongName
        singerLabel.text = info.Singer
        releaseDateLabel.text = info.ReleaseDate
        
        imageBinding()
        
    }
    
    //MARK: Private Method
    private func imageBinding(){
        
        viewModel?.$coverImage
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                self?.coverImageView.image = image
            }
            .store(in: &subscription)
        
        viewModel?.getImage()
        
    }
    
    //MARK: IBAction
    
    //播放音樂
    @IBAction func clickPlayMusic(_ sender: UIButton) {
        viewModel?.clickFunctionType = .PlayMusic
    }
    
    //播放MV
    @IBAction func clickPlayMusicVideo(_ sender: UIButton) {
        viewModel?.clickFunctionType = .PlayMusicVideo
    }
    
}
