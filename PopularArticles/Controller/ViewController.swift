//
//  ViewController.swift
//  PopularArticles
//
//  Created by Nuzhat Zari on 08/09/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var viewLoader: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let reuseIdentifier = "article_cell"
    let segueSearch = "search"
    let segueDetail = "detail"
    
    var articles: [Article] = [Article]()
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        articleTableView.rowHeight = UITableView.automaticDimension
        articleTableView.estimatedRowHeight = 145
        
        viewModel = ViewModel()
        fetchArticles()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case segueSearch:
            guard let searchViewController = segue.destination as? SearchViewController else {
                return
            }
            searchViewController.articles = viewModel.articles ?? []
            searchViewController.searchButtonClickedHandler = {[weak self](searchText: String, searchDetails: [SearchDetail]) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.articles = strongSelf.viewModel.filterDataBasedOnSearch(searchText, searchDetails)
                strongSelf.articleTableView.reloadData()

            }
            
        case segueDetail:
            guard let detailViewController = segue.destination as? DetailViewController else {
                return
            }
            detailViewController.articleUrl = sender as! String
            
        default:
            break
        }
    }
    
    
    //MARK: - Button Action
    @IBAction func onBtnSearchClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: segueSearch, sender: nil)
    }
    
    
    //MARK: - UITableViewDataSource protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as!ArticleTableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        cell.title.text = article.title
        cell.author.text = article.byline
        cell.date.text = article.published_date
        return cell
    }
    
    // MARK: - UITableViewDelegate protocol
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: segueDetail, sender: articles[indexPath.row].url)
    }
        
    //MARK: - Loader
    func showLoading() {
        viewLoader?.isHidden = false
        self.view.bringSubviewToFront(viewLoader)
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        viewLoader.isHidden = true
        self.view.sendSubviewToBack(viewLoader)
        activityIndicator.stopAnimating()
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchArticles() {
        
        showLoading()
        viewModel.fetchArticleData()
        viewModel.notifyFetchArticleCompletionToController = {[weak self] (articles, error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.hideLoading()
            
            if let fetchArticles = articles {
                strongSelf.articles = fetchArticles
                strongSelf.articleTableView.reloadData()
            } else {
                strongSelf.showAlert(with: error?.localizedDescription ?? "Something went wrong, please try again later.")
            }
        
        }
    }
}

