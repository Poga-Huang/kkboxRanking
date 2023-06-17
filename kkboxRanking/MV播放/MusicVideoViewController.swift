//
//  MusicVideoViewController.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/4.
//

import UIKit
import WebKit
import Combine

class MusicVideoViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var mvWebView: WKWebView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    //儲存所有綁訂
    private var subscriptions = Set<AnyCancellable>()
    
    //ViewModel由push的VC提供
    let viewModel:RankingViewModel
    
    //右上選單按鈕
    private lazy var optionButton:UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        button.setTitle("選單", for: .normal)
        button.addTarget(self, action: #selector(popTableView), for: .touchDown)
        return button
    }()
    
    init(viewModel:RankingViewModel){
        self.viewModel = viewModel
        super.init(nibName: "\(MusicVideoViewController.self)", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupBinding()
        setupWebView(dataIndex: viewModel.selectedFunctionFromIndexPath?.index)
    }
    
    //MARK: Private Method
    private func initView(){
        mvWebView.navigationDelegate = self
        
        self.title = FunctionType.PlayMusicVideo.rawValue
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customBackButton())
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: optionButton)
    }
    
    private func setupWebView(dataIndex:IndexPath?) {
        guard let index = dataIndex else { return }
        let currentSection = viewModel.sections[index.section]
        let cellViewModel = currentSection.items[index.row]
        guard let urlString = cellViewModel.data.fields.MusicVideoURL else { return }
        guard let url = URL(string:urlString ) else { return }
        mvWebView.load(URLRequest(url:url))
    }
    
    private func setupBinding(){
        viewModel.$selectedFunctionFromIndexPath
            .sink { [weak self] functionIndex in
                guard let self = self,
                      let functionIndex = functionIndex,
                      let index = functionIndex.index
                else {
                    return
                }
                
                self.setupWebView(dataIndex: index)
                
            }.store(in: &subscriptions)
    }
    
    @objc private func popTableView(){
        let optionTableVC = MVOptionTableViewController(viewModel: viewModel)
        
        optionTableVC.popover(on: self,
                              sourceView:optionButton,
                              preferredContentSize: CGSize(width: self.view.frame.width/2,
                                                           height: self.view.frame.height),
                              customInsets: UIEdgeInsets(top:36,
                                                         left: 0,
                                                         bottom: 0,
                                                         right: 10),
                              dismissHandler: nil)
    }
    
    //MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.stopAnimating()
    }

}
