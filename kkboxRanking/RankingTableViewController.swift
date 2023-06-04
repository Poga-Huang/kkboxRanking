//
//  RankingTableViewController.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/5/28.
//

import UIKit
import Combine

class RankingTableViewController: UIViewController {
    
    //MARK: IBOulet
    @IBOutlet weak var quickSegment: UISegmentedControl!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var rankTable: UITableView!
    
    //重新整理按鈕
    private lazy var refreshButton:UIButton = {
        var refreshButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        refreshButton.tintColor = .white
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchDown)
        return refreshButton
    }()
    
    private let viewModel = RankingViewModel()
    //Diffable DataSource
    var dataSource:UITableViewDiffableDataSource<SongType,SongCellViewModel>!
    //儲存所有綁訂
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        createDataSource()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: Private Method
    
    private func initView(){
        SongType.allCases.enumerated().forEach { index,type in
            quickSegment.setTitle(type.rawValue, forSegmentAt: index)
        }
        
        rankTable.register(UINib(nibName: "\(SongCell.self)", bundle: nil), forCellReuseIdentifier: "SongCell")
        
        //titleView
        let titleView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 30)))
        titleView.image = UIImage(named: "titleView")
        self.navigationItem.titleView = titleView
        
        //refresh
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshButton)
    }
    
    private func createDataSource(){
        dataSource = UITableViewDiffableDataSource<SongType,SongCellViewModel>(tableView: rankTable, cellProvider: { (tableView, indexPath,viewModel)->UITableViewCell? in
            
             let item = tableView.dequeueReusableCell(withIdentifier: "\(SongCell.self)", for: indexPath) as! SongCell
            
            item.configure(with: viewModel)
            
            return item
        })
        
        rankTable.dataSource = dataSource
    }
    
    private func setupBinding(){
        
        //綁定ViewModel的資料轉換，結束再重新Apply一次Snapshot
        viewModel.$covertDataEnd
            .sink { _ in
            var snapShot = NSDiffableDataSourceSnapshot<SongType,SongCellViewModel>()
            snapShot.appendSections([.Chinese,.English,.Japanese,.Korean,.Taiwanese])
            snapShot.appendItems(self.viewModel.chineseVM, toSection: .Chinese)
            snapShot.appendItems(self.viewModel.englishVM, toSection: .English)
            snapShot.appendItems(self.viewModel.japaneseVM,toSection: .Japanese)
            snapShot.appendItems(self.viewModel.koreanVM,toSection: .Korean)
            snapShot.appendItems(self.viewModel.taiwaneseVM,toSection: .Taiwanese)
            self.dataSource.apply(snapShot,animatingDifferences: false)
        }.store(in: &subscriptions)
        
        //綁定viewModel的loading，loading開始轉圈，loading暫停轉圈
        //loading中不可重新整理
        viewModel.$loading
            .receive(on: RunLoop.main)
            .sink { loading in
                if loading{
                    self.loadingView.startAnimating()
                }
                else{
                    self.loadingView.stopAnimating()
                }
                self.refreshButton.isEnabled = !loading
            }.store(in: &subscriptions)
    }
    
    @objc private func refresh(){
        //已綁定viewModel的loading，當值改變監聽到可執行
        viewModel.loading = true
    }

    
    //MARK: IBAction
    @IBAction func quickSelectSongType(_ sender: UISegmentedControl) {
        let indexPath = IndexPath(row: 0, section: sender.selectedSegmentIndex)
        rankTable.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    

}
