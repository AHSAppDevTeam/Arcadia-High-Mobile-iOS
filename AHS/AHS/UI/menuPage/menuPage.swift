//
//  menuPage.swift
//  AHS
//
//  Created by Akshaj Kanumuri on 2/6/25.
//

import UIKit
import AMPopTip
import Foundation
import FirebaseCore
import FirebaseDatabase

class menuPageViewController: mainPageViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.pageName = "Lunch"
        self.secondaryPageName = "Menu"
        self.viewControllerIconName = "fork.knife"
    }

    required init?(coder : NSCoder) {
        super.init(coder: coder)
    }

    internal var horizontalCalendar: HorizontalCalendar!  // Declare the HorizontalCalendar
    internal var currentDate: Date = Date()

    internal let topBarView : UIView = UIView()

    // Declare weeks, verticalPadding, and nextY
    internal var weeks: [[Date]] = []  // Stores weeks for calendar
    internal let verticalPadding: CGFloat = 10  // Adjust padding as needed
    internal var nextY: CGFloat = 0  // Keep track of the Y position
    var ref: DatabaseReference! = Database.database().reference();

    // Properties for refresh control and main scroll view
    internal let refreshControl : UIRefreshControl = UIRefreshControl()
    internal let mainScrollView : UIScrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBar()  // Set up the top bar with title
        setupHorizontalCalendar() // Set up the new calendar
        setupScrollView();
        renderContent(with: generateSampleMenu());
    }

    func setupTopBar() {
//        // Set up the top bar with a title (optional: you can customize this)
//        topBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)  // Adjust height as needed
//        topBarView.backgroundColor = .blue  // Background color for visibility
//        self.view.addSubview(topBarView)
//
//        // Set the title for the page (can be customized)
//        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
//        titleLabel.text = "Lunch Menu"
//        titleLabel.textAlignment = .center
//        titleLabel.textColor = .white
//        topBarView.addSubview(titleLabel)
    }

    func setupHorizontalCalendar() {
        // Set up the calendar's frame, starting just below the top bar
        let calendarHeight: CGFloat = 150
        let calendarY = topBarView.frame.maxY

        horizontalCalendar = HorizontalCalendar(frame: CGRect(x: 0, y: calendarY, width: self.view.frame.width, height: calendarHeight))
        horizontalCalendar.onSelectionChange = { [weak self] selectedDate in
//            print("Selected Date: \(selectedDate)")
            self?.currentDate = selectedDate
            self?.loadMenuDataOnce(for: selectedDate);
        }

        self.view.addSubview(horizontalCalendar) // Add to the main view
    }

    // Define loadCalendarData method
    func loadCalendarData() {
        let calendar = Calendar.current
        var startOfWeek = calendar.startOfDay(for: currentDate)

        // Clear the existing weeks data
        weeks.removeAll()

        for _ in 0..<6 {
            var week: [Date] = []

            for dayOffset in 0..<7 {
                if let day = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                    week.append(day)
                }
            }

            weeks.append(week)
            startOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
        }
    }
    
    func loadMenuDataOnce(for date: Date) {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd";
        let dateString = dateFormatter.string(from: date);
        
        let calendar = Calendar.current;
        let year = calendar.component(.year, from: date);
        let month = calendar.component(.month, from: date);
        let monthKey = "\(year) - \(String(month).padding(toLength: 1, withPad: "0", startingAt: 0))";
        
        ref.child("menus").child(monthKey).child(dateString).observeSingleEvent(of: .value, with: { snapshot in
            if let menuDict = snapshot.value as? [String: Any] {
                if let menuItem = MenuItem(dict: menuDict) {
                    self.renderContent(with: menuItem)
                } else {
                    print("Error: Could not parse menu data for \(dateString)");
                    // Create an empty dictionary with the expected keys
                    let emptyMenuDict: [String: [String]] = [
                        "MAIN ENTREE": [],
                        "FRUIT": [],
                        "VEGETABLE": [],
                        "MILK": [],
                        "CONDIMENT": []
                    ]
                    if let emptyMenuItem = MenuItem(dict: emptyMenuDict, empty: true) {
                        self.renderContent(with: emptyMenuItem)
                    } else {
                        print("Fatal Error: Could not create empty MenuItem")
                        // Handle this critical error appropriately, maybe show an error message to the user
                        return
                    }
                }
            } else {
                print("No menu data for \(monthKey) / \(dateString)");
                // Create an empty dictionary with the expected keys
                let emptyMenuDict: [String: [String]] = [
                    "MAIN ENTREE": [],
                    "FRUIT": [],
                    "VEGETABLE": [],
                    "MILK": [],
                    "CONDIMENT": []
                ]
                if let emptyMenuItem = MenuItem(dict: emptyMenuDict, empty: true) {
                    self.renderContent(with: emptyMenuItem)
                } else {
                    print("Fatal Error: Could not create empty MenuItem")
                    // Handle this critical error appropriately, maybe show an error message to the user
                    return
                }
            }
        }, withCancel: { error in
            print("Error fetching menu data: \(error)");
            // Create an empty dictionary with the expected keys
            let emptyMenuDict: [String: [String]] = [
                "MAIN ENTREE": [],
                "FRUIT": [],
                "VEGETABLE": [],
                "MILK": [],
                "CONDIMENT": []
            ]
            if let emptyMenuItem = MenuItem(dict: emptyMenuDict, empty: true) {
                self.renderContent(with: emptyMenuItem)
            } else {
                print("Fatal Error: Could not create empty MenuItem")
                // Handle this critical error appropriately, maybe show an error message to the user
                return
            }
        })
    }
    
    func updateMenuData() {
        
    }
    
    struct MenuItem {
        let mainEntrees: [String];
        let fruits: [String];
        let vegetables: [String];
        let milk: [String];
        let condiments: [String];
        let empty: Bool;
        
        init? (dict: [String: Any], empty: Bool = false) {
            self.empty = empty;
            if !empty {
                guard let mainEntrees = dict["MAIN ENTREE"] as? [String],
                      let fruits = dict["FRUIT"] as? [String],
                      let vegetables = dict["VEGETABLE"] as? [String],
                      let milk = dict["MILK"] as? [String],
                      let condiments = dict["CONDIMENT"] as? [String] else {
                    return nil;
                }
                
                self.mainEntrees = mainEntrees;
                self.fruits = fruits;
                self.vegetables = vegetables;
                self.milk = milk;
                self.condiments = condiments;
            } else {
                self.mainEntrees = [];
                self.fruits = [];
                self.vegetables = [];
                self.milk = [];
                self.condiments = [];
            }
        }
    }
    
    func generateSampleMenu() -> MenuItem {
        let sampleMenu: [String: [String]] = [
            "MAIN ENTREE" : ["Mongolian Beef with Fried Rice", "Grilled Cheese Sandwich", "Chicken Sandwich", "Lunch Parfait"],
            "FRUIT" : ["Banana (Green Tip)", "Apple Slices", "Orange"],
            "VEGETABLE" : ["Steamed Broccoli", "Carrot Sticks", "Side Salad"],
            "MILK" : ["1% Milk", "Chocolate Milk", "Lactose-Free Milk"],
            "CONDIMENT" : ["Ketchup", "Mustard", "Mayonnaise", "Ranch Dressing"]
        ];

        return MenuItem(dict: sampleMenu)!
    }
    
    func setupScrollView() {
        mainScrollView.frame = CGRect(x: 0, y: horizontalCalendar.frame.maxY + 10, width: view.frame.width, height: view.frame.height - horizontalCalendar.frame.maxY - 10);
        mainScrollView.showsVerticalScrollIndicator = true;
        view.addSubview(mainScrollView);
    }

    // Define renderContent method
    internal func renderContent(with menuData: MenuItem) {
        for subview in mainScrollView.subviews {
            subview.removeFromSuperview();
        }

        nextY = 0;
        
        if (!menuData.empty) {
            nextY = addMenuSection(title: "Main Entree", items: menuData.mainEntrees, startY: nextY);
            nextY = addMenuSection(title: "Fruit & Veggie", items: menuData.fruits + menuData.vegetables, startY: nextY);
            nextY = addMenuSection(title: "Milk", items: menuData.milk, startY: nextY);
            nextY = addMenuSection(title: "Condiments", items: menuData.condiments, startY: nextY);
            
            mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: nextY + verticalPadding + 300);
        }
        else {
            let titleLabel = UILabel();
            titleLabel.text = "No School!";
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold);
            titleLabel.frame = CGRect(x: mainScrollView.frame.width / 2 - 50, y: 10, width: mainScrollView.frame.width, height: 25);
            titleLabel.sizeToFit();
            mainScrollView.addSubview(titleLabel);
            mainScrollView.contentSize = titleLabel.frame.size;
        }
    }
    
    func addMenuSection(title: String, items: [String], startY: CGFloat) -> CGFloat {
        let titleLabel = UILabel();
        titleLabel.text = title;
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold);
        titleLabel.frame = CGRect(x: 20, y: startY, width: mainScrollView.frame.width - 40, height: 25);
        mainScrollView.addSubview(titleLabel);

        var currentY = startY + titleLabel.frame.height + verticalPadding / 2;

        for item in items {
            let itemLabel = UILabel();
            itemLabel.text = item;
            itemLabel.textColor = .white;
            itemLabel.font = UIFont.systemFont(ofSize: 16);
            itemLabel.textAlignment = .left;
            itemLabel.numberOfLines = 0;
            itemLabel.lineBreakMode = .byWordWrapping;

            let labelWidth = mainScrollView.frame.width - 40 - 30; // Account for menuItemView padding
            let size = itemLabel.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude));
            itemLabel.frame = CGRect(x: 15, y: 10, width: labelWidth, height: size.height);

            let menuItemView = UIView();
            menuItemView.backgroundColor = UIColor(red: 47/255, green: 164/255, blue: 177/255, alpha: 1.0);
            menuItemView.layer.cornerRadius = 10;
            // Set the menuItemView's height based on the label's height + padding
            menuItemView.frame = CGRect(x: 20, y: currentY, width: mainScrollView.frame.width - 40, height: size.height + 20);

            menuItemView.addSubview(itemLabel);
            mainScrollView.addSubview(menuItemView);
            currentY += menuItemView.frame.height + verticalPadding / 2;
        }

        return currentY + verticalPadding / 2;
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.view.backgroundColor = BackgroundColor
    }
}
