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
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var rankTable: UITableView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet var typeButtons: [UIButton]!
    
    //重新整理按鈕
    private lazy var refreshButton:UIButton = {
        var refreshButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        refreshButton.tintColor = .white
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchDown)
        return refreshButton
    }()
    
    internal let viewModel = RankingViewModel()
    //Diffable DataSource
    private var dataSource:UITableViewDiffableDataSource<Section,SongCellViewModel>!
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
        //初始化上排Button
        typeButtons.enumerated().forEach { (index,btn) in
            btn.setTitle(SectionType.allCases[index].typeName, for: .normal)
            btn.setTitleColor(UIColor.unSelectedTextColor, for: .normal)
            btn.backgroundColor = .unSelectedBackgroundColor
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.unSelectedBorderColor.cgColor
            btn.tag = SectionType.allCases[index].rawValue
        }
        
        rankTable.register(UINib(nibName: "\(SongCell.self)", bundle: nil), forCellReuseIdentifier: "SongCell")
        
        //titleView
        let titleView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 30)))
        titleView.image = UIImage(named: "titleView")
        self.navigationItem.titleView = titleView
        
        //refresh
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshButton)
    }
    
    private func resetButton(){
        typeButtons.enumerated().forEach { (index,btn) in
            btn.setTitleColor(UIColor.unSelectedTextColor, for: .normal)
            btn.backgroundColor = .unSelectedBackgroundColor
            btn.layer.borderColor = UIColor.unSelectedBorderColor.cgColor
        }
    }
    
    private func setSelectedButton(_ type:SectionType){
        typeButtons[type.rawValue].setTitleColor(UIColor.selectedTextColor, for: .normal)
        typeButtons[type.rawValue].backgroundColor = UIColor.selectedBackgroundColor
        typeButtons[type.rawValue].layer.borderColor = UIColor.selectedBorderColor.cgColor
    }
    
    private func createDataSource(){
        dataSource = UITableViewDiffableDataSource<Section,SongCellViewModel>(tableView: rankTable, cellProvider: { (tableView, indexPath,viewModel)->UITableViewCell? in
            
             let item = tableView.dequeueReusableCell(withIdentifier: "\(SongCell.self)", for: indexPath) as! SongCell
            
            item.configure(with: viewModel)
            
            return item
        })
        
        rankTable.dataSource = dataSource
        rankTable.delegate = self
    }
    
    private func setupBinding(){
        
        //綁定ViewModel的資料轉換，結束再重新Apply一次Snapshot
        viewModel.$sections
            .sink { [weak self] sections in
                var snapShot = NSDiffableDataSourceSnapshot<Section,SongCellViewModel>()
                snapShot.appendSections(sections)
                
                sections.forEach { section in
                    //坑：要指定給Section不然會出現Section Rows為0 執行捲動會Crash
                    snapShot.appendItems(section.items,toSection: section)
                }
                
                self?.dataSource.apply(snapShot,animatingDifferences: false)
        }.store(in: &subscriptions)
        
        //綁定viewModel的loading，loading開始轉圈，loading暫停轉圈，loading中不可重新整理
        viewModel.$loading
            .receive(on: RunLoop.main)
            .sink { [weak self] loading in
                if loading{
                    self?.loadingView.startAnimating()
                }
                else{
                    self?.loadingView.stopAnimating()
                }
                self?.buttonStackView.isUserInteractionEnabled = !loading
                self?.refreshButton.isEnabled = !loading
            }.store(in: &subscriptions)
        
        //綁定現在點擊的歌曲語種
        viewModel.$currentSelectedType
            .sink { [weak self] type in
                
                self?.resetButton()
                self?.setSelectedButton(type)
                
            }.store(in: &subscriptions)
        
        viewModel.$selectedFunctionFromIndexPath
            .sink { [weak self] functionIndex in
                guard let self = self,
                      let functionIndex = functionIndex,
                      let type = functionIndex.type
                else {
                    return
                }
                
                switch type{
                case.PlayMusic:
                    break
                case.PlayMusicVideo:
                    let mvvc = MusicVideoViewController(viewModel: viewModel)
                    self.navigationController?.pushViewController(mvvc, animated: true)
                }
            }.store(in: &subscriptions)
    }
    
    @objc private func refresh(){
        viewModel.loading = true
    }

    
    //MARK: IBAction
    @IBAction func quickSelectSongTypeToScroll(_ sender: UIButton) {
        viewModel.currentSelectedType = SectionType.allCases[sender.tag]
        rankTable.scrollToRow(at: IndexPath(row: 0, section: sender.tag), at: .top, animated: true)
    }
    
    
}
