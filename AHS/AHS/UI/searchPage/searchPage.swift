//
//  searchPage.swift
//  AHS
//
//  Created by Richard Wei on 5/7/21.
//

import Foundation
import UIKit

class searchPageViewController : mainPageViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Search";
        self.secondaryPageName = "Page";
        //self.viewControllerIconName = "house.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    internal let topBarView = UIButton();
    internal let searchBarView = UISearchBar();
    internal let resultsTableView = UITableView();
    internal var resultsTableViewHeight : CGFloat = 0;
    
    internal let resultsTableViewRefreshControl = UIRefreshControl();
    
    internal var searchResultsArray : [articleSnippetData] = [];
    internal var articleSnippetsArray : [articleSnippetData] = [];
    
    internal let verticalPadding : CGFloat = 5;
    internal let horizontalPadding : CGFloat = homePageHorizontalPadding;
    
    //
    
    internal var transitionDelegateVar : transitionDelegate!;
    
    internal var panGestureRecognizer = UIPanGestureRecognizer();
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            setupPanGesture();
            
            //
            
            self.view.backgroundColor = BackgroundColor;
            
            //
            
            let contentWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
            
            //
            
            let searchBarViewFrame = CGRect(x: horizontalPadding, y: 0, width: contentWidth, height: contentWidth * 0.12);
            searchBarView.frame = searchBarViewFrame;
            
            searchBarView.delegate = self;
            searchBarView.backgroundColor = BackgroundColor;
            //searchBarView.tintColor = BackgroundColor;
            
            self.searchBarView.showsCancelButton = true;
            keepSearchBarCancelButtonEnabled();
            
            self.view.addSubview(searchBarView);
            
            //
            resultsTableViewHeight = self.view.frame.height - searchBarView.frame.height - verticalPadding;
            let resultsTableViewFrame = CGRect(x: horizontalPadding, y: searchBarView.frame.height + verticalPadding, width: contentWidth, height: resultsTableViewHeight);
            resultsTableView.frame = resultsTableViewFrame;
        
            resultsTableView.backgroundColor = BackgroundColor;
            resultsTableView.delegate = self;
            resultsTableView.dataSource = self;
            resultsTableView.isScrollEnabled = true;
            resultsTableView.register(searchPageViewControllerCell.self, forCellReuseIdentifier: searchPageViewControllerCell.identifier);
            
            self.view.addSubview(resultsTableView);
            
            //
            
            resultsTableViewRefreshControl.addTarget(self, action: #selector(self.loadArticleSnippetList), for: .valueChanged)
            resultsTableView.addSubview(resultsTableViewRefreshControl);
            
            //
            
            //updateParentHeightConstraint();
            hideKeyboardWhenTappedAround();
            
            resultsTableViewRefreshControl.beginRefreshing();
            loadArticleSnippetList();
            
            self.hasBeenSetup = true;
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetContentOffset), name: NSNotification.Name(rawValue: setScrollViewZeroContentOffset), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: setScrollViewZeroContentOffset), object: nil);
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    //
    
    @objc override func dismissKeyboard(){
        self.view.endEditing(true);
        keepSearchBarCancelButtonEnabled();
    }

    @objc internal func loadArticleSnippetList(){
        dataManager.getAllArticleSnippets(completion: { (snippetArray) in
            self.resultsTableViewRefreshControl.endRefreshing();
            
            self.filterHiddenSnippets(snippetArray: snippetArray, completion: { (filteredSnippetArray) in
                self.articleSnippetsArray = filteredSnippetArray;
                self.searchBarSearchButtonClicked(self.searchBarView);
            });
            
        });
        
    }
    
    @objc private func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer){
        dismissKeyboard();
        popTransition.handlePan(panGestureRecognizer, fromViewController: self, dismissCompletionHandler: {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height);
            }, completion: { _ in
                UIImpactFeedbackGenerator(style: .medium).impactOccurred();
                self.dismiss();
            });
        });
    }
    
    @objc internal func handleKeyboardShow(_ notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            resultsTableView.frame = CGRect(x: resultsTableView.frame.minX, y: resultsTableView.frame.minY, width: resultsTableView.frame.width, height: resultsTableViewHeight - (keyboardSize.height - navigationViewController.navigationBarViewHeight));
        }
    }
    
    @objc internal func handleKeyboardHide(_ notification: NSNotification){
        resultsTableView.frame = CGRect(x: resultsTableView.frame.minX, y: resultsTableView.frame.minY, width: resultsTableView.frame.width, height: resultsTableViewHeight);
    }
    
    //
    
    internal func setupPanGesture(){
        panGestureRecognizer.addTarget(self, action: #selector(self.handlePan));
        self.view.addGestureRecognizer(panGestureRecognizer);
    }
    
    internal func filterHiddenSnippets(snippetArray: [articleSnippetData], completion: @escaping ([articleSnippetData]) -> Void){
        
        var filteredSnippetArray : [articleSnippetData] = [];
        
        for snippet in snippetArray{
            if (!snippet.categoryID.isEmpty && dataManager.getCachedCategoryData(snippet.categoryID).visible){
                filteredSnippetArray.append(snippet);
            }
        }
        
        completion(filteredSnippetArray);
    }
    
    internal func updateSearchResults(){
        
        let searchBarText = self.searchBarView.text ?? "";
        
    
        DispatchQueue(label: "searchQueue", qos: .userInitiated, attributes: .concurrent).async {
            //print("updating search results for \(searchBarText)");
            self.searchResultsArray = searchBarText.isEmpty ? self.articleSnippetsArray : self.articleSnippetsArray.filter{ (article: articleSnippetData) -> Bool in
                return article.title.range(of: searchBarText, options: .caseInsensitive, range: nil, locale: nil) != nil || article.author.range(of: searchBarText, options: .caseInsensitive, range: nil, locale: nil) != nil;
            }
            //print("finished updating search results for \(searchBarText) with count \(self.searchResultsArray.count)");
            
            DispatchQueue.main.async {
                self.updateSearchTable();
            }

        }
        
    }
    
    internal func updateSearchTable(){ // search results in searchResultsArray
        //print("updating search table");
        resultsTableView.reloadData();
        
        //self.resultsTableView.frame.size.height = self.resultsTableView.contentSize.height;
        
        //nextContentY = self.resultsTableView.frame.maxY + 10;
        
        //updateParentHeightConstraint();
        //print("finished updating search table - EVENT END");
    }
    
    internal func keepSearchBarCancelButtonEnabled(){
        //print("keep cancel")
        if let cancelBtn = self.searchBarView.value(forKey: "cancelButton") as? UIButton{
            //print("keep canceled")
            cancelBtn.isEnabled = true;
            cancelBtn.tintColor = mainThemeColor;
        }
    }
    
    /*internal func updateAll(){
        updateSearchResults(self.searchBar.text ?? "");
        //updateSearchTable();
    }*/
    
    // delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchPageViewControllerCell.identifier, for: indexPath) as! searchPageViewControllerCell;
        cell.selectionStyle = .none;
        
        let index = indexPath.row;
        if (index < searchResultsArray.count){
            cell.updateContent(searchResultsArray[index]);
        }
        //print("cell for \(indexPath.row) done");

        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row;
        if (index < searchResultsArray.count){
            let articleData = searchResultsArray[index];
            
            let articleDataDict : [String : String] = ["articleID" : articleData.articleID];
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: articlePageNotification), object: nil, userInfo: articleDataDict);
            
        }
        //keepSearchBarCancelButtonEnabled();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*if (searchText.isEmpty){
            updateAll();
        }*/
        //print("EVENT TRIGGERED")
        updateSearchResults();
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        /*self.searchBarView.showsCancelButton = false;
        self.searchBarView.text = "";
        self.searchBarView.resignFirstResponder();
        dismissKeyboard();
        
        updateSearchResults();*/
        dismissKeyboard();
        keepSearchBarCancelButtonEnabled();
        //print("dismiss")
        
        dismiss();
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.searchBarView.showsCancelButton = false;
        //print("search button clicked")
        dismissKeyboard();
        keepSearchBarCancelButtonEnabled();
        
        updateSearchResults();
    }
    
    //
    
    internal func dismiss(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: hideSearchPageNotification), object: nil, userInfo: nil);
    }
    
    @objc internal func resetContentOffset(){
        if (resultsTableView.contentOffset != .zero){
            resultsTableView.setContentOffset(.zero, animated: true);
        }
        else{
            dismiss();
        }
    }
    
}
