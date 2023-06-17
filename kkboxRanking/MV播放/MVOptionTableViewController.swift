//
//  MVOptionTableViewController.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/13.
//

import UIKit

class MVOptionTableViewController: UITableViewController {
        
    let viewModel:RankingViewModel
    private var dataSource:UITableViewDiffableDataSource<Section,SongCellViewModel>!
    
    init(viewModel:RankingViewModel){
        self.viewModel = viewModel
        super.init(nibName: "\(MVOptionTableViewController.self)", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        createDataSource()
        createSnapShot()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.superview?.clipsToBounds = false
    }
    
    //MARK: PrivateMethod
    private func initView(){
        
        self.tableView.register(UINib(nibName: "\(MVOptionTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "optionCell")
        
        self.tableView.bounces = false
    }

    // MARK: - Table view data source
    private func createDataSource(){
        dataSource = UITableViewDiffableDataSource<Section,SongCellViewModel>(tableView: self.tableView, cellProvider: { (tableView, indexPath,viewModel)->UITableViewCell? in
            
            guard let item = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as? MVOptionTableViewCell
            else{
                return UITableViewCell()
            }
            
            item.configureCell(with: viewModel)
            return item
        })
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
    }
    
    private func createSnapShot(){
        var snapShot = NSDiffableDataSourceSnapshot<Section, SongCellViewModel>()
        snapShot.appendSections(viewModel.sections)
        
        viewModel.sections.forEach { section in
            snapShot.appendItems(section.items ,toSection: section)
        }
        dataSource.apply(snapShot,animatingDifferences: true,completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.selectedFunctionFromIndexPath = FunctionIndex(index: indexPath)
        self.dismiss(animated: true)
    }
    
}
