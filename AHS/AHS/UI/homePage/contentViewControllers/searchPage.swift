//
//  searchPage.swift
//  AHS
//
//  Created by Richard Wei on 5/7/21.
//

import Foundation
import UIKit

class searchPageController : homeContentPageViewController, UITableViewDataSource, UISearchBarDelegate{
    
    internal let searchBar = UISearchBar();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let searchBarWidth = AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding;
        let searchBarFrame = CGRect(x: homePageHorizontalPadding, y: 0, width: searchBarWidth, height: searchBarWidth * 0.12);
        searchBar.frame = searchBarFrame;
        
        searchBar.delegate = self;
        
        self.view.addSubview(searchBar);
        
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
            print("snippet count - \(snippetArray.count)")
            
        });
        
    }
    
    // delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell();
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false;
        self.searchBar.text = "";
        self.searchBar.resignFirstResponder();
        dismissKeyboard();
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false;
        dismissKeyboard();
    }
    
}
