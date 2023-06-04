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
    @Published var currentIndexPath:IndexPath
    
    //ViewModel由push的VC提供
    let viewModel:RankingViewModel
    
    init(viewModel:RankingViewModel,index:IndexPath){
        self.viewModel = viewModel
        self.currentIndexPath = index
        super.init(nibName: "\(MusicVideoViewController.self)", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupBinding()
    }
    
    //MARK: Private Method
    private func initView(){
        mvWebView.navigationDelegate = self
        
        self.title = FunctionType.PlayMusicVideo.rawValue
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customBackButton())
        
    }
    
    private func setupWebView(){
        let currentSection = viewModel.sections[currentIndexPath.section]
        let cellViewModel = currentSection.items[currentIndexPath.row]
        guard let urlString = cellViewModel.data.fields.MusicVideoURL else { return }
        guard let url = URL(string:urlString ) else { return }
        mvWebView.load(URLRequest(url:url))
    }
    
    private func setupBinding(){
        $currentIndexPath.sink {[weak self] _ in
            self?.setupWebView()
        }.store(in: &subscriptions)
    }
    
    //MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.stopAnimating()
    }

}
