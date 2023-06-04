//
//  RankingTableVC+Extension.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/4.
//

import UIKit

//MARK: UITableViewDelegate
extension RankingTableViewController:UITableViewDelegate{
    //捲動TableView跟著切換上方Button
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: rankTable.frame.width/2, y: rankTable.contentOffset.y + rankTable.frame.height/2)
        //取得Table可視範圍的IndexPath
        guard let centerCell = rankTable.indexPathForRow(at: centerPoint) else { return }
        viewModel.currentSelectedType = SectionType.allCases[centerCell.section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 10, y: 0), size: CGSize(width: 100, height: 44)))
        titleLabel.text = SectionType.allCases[section].headerTitle
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? SongCell else { return }
        //彈跳功能Alert
        let functionAlert = UIAlertController(title: "請選擇", message: "當前要使用的功能", preferredStyle: .alert)
        functionAlert.addAction(UIAlertAction(title:FunctionType.PlayMusic.rawValue, style: .default,handler: { _ in
            selectedCell.viewModel?.clickFunctionType = .PlayMusic
        }))
        functionAlert.addAction(UIAlertAction(title:FunctionType.PlayMusicVideo.rawValue, style: .destructive,handler: { _ in
            selectedCell.viewModel?.clickFunctionType = .PlayMusicVideo
        }))
        functionAlert.addAction(UIAlertAction(title: "關閉", style: .cancel))
        
        self.present(functionAlert, animated: true)
    }
}

//MARK: FunctionButtonDelegate
extension RankingTableViewController:FunctionButtonDelegate{
    func clickFunctionButton(_ type: FunctionType, withIndexPath index:IndexPath) {
        switch type {
        case .PlayMusic:
            break
        case .PlayMusicVideo:
            let mvvc = MusicVideoViewController(viewModel: viewModel, index: index)
            self.navigationController?.pushViewController(mvvc, animated: true)
        }
    }
}
