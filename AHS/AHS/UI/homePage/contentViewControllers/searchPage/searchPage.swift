//
//  searchPage.swift
//  AHS
//
//  Created by Richard Wei on 5/7/21.
//

import Foundation
import UIKit

class searchPageController : homeContentPageViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    internal let searchBar = UISearchBar();
    internal let resultsTableView = UITableView();
    
    internal var searchResultsArray : [articleSnippetData] = [];
    internal var articleSnippetsArray : [articleSnippetData] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let searchBarWidth = AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding;
        let searchBarFrame = CGRect(x: homePageHorizontalPadding, y: 0, width: searchBarWidth, height: searchBarWidth * 0.12);
        searchBar.frame = searchBarFrame;
        
        searchBar.delegate = self;
        
        self.view.addSubview(searchBar);
        
        //
        
        let resultsTableViewFrame = CGRect(x: homePageHorizontalPadding, y: searchBar.frame.height, width: AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding, height: 0);
        resultsTableView.frame = resultsTableViewFrame;
        
        resultsTableView.delegate = self;
        resultsTableView.dataSource = self;
        resultsTableView.isScrollEnabled = false;
        resultsTableView.register(searchPageCollectionViewCell.self, forCellReuseIdentifier: searchPageCollectionViewCell.identifier);
        
        self.view.addSubview(resultsTableView);
        
        //
        updateParentHeightConstraint();
        
        hideKeyboardWhenTappedAround();
        loadArticleSnippetList();
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadArticleSnippetList), name: NSNotification.Name(rawValue: homePageRefreshNotification), object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: homePageRefreshNotification), object: nil);
    }
    
    @objc internal func loadArticleSnippetList(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageBeginRefreshing), object: nil);
        dataManager.getAllArticleSnippets(completion: { (snippetArray) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageEndRefreshing), object: nil);
            self.articleSnippetsArray = snippetArray;
            self.searchBarSearchButtonClicked(self.searchBar);
        });
        
    }
    
    internal func updateSearchResults(_ searchBarText: String){
        
        searchResultsArray = searchBarText.isEmpty ? articleSnippetsArray : articleSnippetsArray.filter{ (article: articleSnippetData) -> Bool in
            return article.title.range(of: searchBarText, options: .caseInsensitive, range: nil, locale: nil) != nil || article.author.range(of: searchBarText, options: .caseInsensitive, range: nil, locale: nil) != nil;
        }
        
    }
    
    internal func updateSearchTable(){ // search results in searchResultsArray
        
        resultsTableView.reloadData();
    
        self.resultsTableView.frame.size.height = self.resultsTableView.contentSize.height;
        
        nextContentY = self.resultsTableView.frame.maxY + 10;
        
        updateParentHeightConstraint();
    }
    
    internal func updateAll(){
        updateSearchResults(self.searchBar.text ?? "");
        updateSearchTable();
    }
    
    // delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchPageCollectionViewCell.identifier, for: indexPath) as! searchPageCollectionViewCell;
        cell.selectionStyle = .none;
        
        let index = indexPath.row;
        if (index < searchResultsArray.count){
            cell.updateContent(searchResultsArray[index]);
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row;
        if (index < searchResultsArray.count){
            let articleData = searchResultsArray[index];
            
            let articleDataDict : [String : String] = ["articleID" : articleData.articleID];
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: articlePageNotification), object: nil, userInfo: articleDataDict);
            
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty){
            updateAll();
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false;
        self.searchBar.text = "";
        self.searchBar.resignFirstResponder();
        dismissKeyboard();
        
        updateAll();
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false;
        dismissKeyboard();
        
        updateAll();
    }
    
}
