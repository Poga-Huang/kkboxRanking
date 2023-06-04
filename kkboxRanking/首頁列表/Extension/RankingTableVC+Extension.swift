//
//  RankingTableVC+Extension.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/4.
//

import UIKit

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
}
