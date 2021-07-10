//
//  profilePage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class profilePageViewController : mainPageViewController{
    
    internal var tableView = UITableView()
    
    internal var infoButtonTitlesArray = ["About Us", "App Version", "Terms and Agreements"]
    
    internal var transitionDelegateVar : transitionDelegate!;
    
    //
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Your";
        self.secondaryPageName = "Profile";
        self.viewControllerIconName = "person.circle.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    // Sets up About Us button
    lazy var AboutUS: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitle("About US                                                          >", for: .normal)
        button.titleLabel?.font = UIFont(name: SFProDisplay_Semibold, size: 18)
        button.setTitleColor(BackgroundGrayColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.layer.shadowRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        return button
    }()
    
    // Sets up App Version button
    lazy var AppVersion: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitle("App Version                                                     >", for: .normal)
        button.titleLabel?.font = UIFont(name: SFProDisplay_Semibold, size: 18)
        button.setTitleColor(BackgroundGrayColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.layer.shadowRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        return button
    }()
    // Sets up Terms and Agreements button
    lazy var TermsandAgreements: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitle("Terms and Agreements                               >", for: .normal)
        button.titleLabel?.font = UIFont(name: SFProDisplay_Semibold, size: 18)
        button.setTitleColor(BackgroundGrayColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.layer.shadowRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        return button
    }()
    // Sets up Notifications button
    lazy var Notifications: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitle("Notifications                                                    >", for: .normal)
        button.titleLabel?.font = UIFont(name: SFProDisplay_Semibold, size: 18)
        button.setTitleColor(BackgroundGrayColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.layer.shadowRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        return button
    }()
    
    // Sets up Schedule button
    lazy var Schedule: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Schedule", for: .normal)
        button.titleLabel?.font = UIFont(name: SFProDisplay_Bold, size: 18)
        button.setTitleColor(InverseBackgroundColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.layer.shadowRadius = 15
        button.layer.cornerRadius = 13
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        return button
    }()
    
    // Sets up Payment button
    lazy var Payment: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        button.setTitle("Payment", for: .normal)
        button.titleLabel?.font = UIFont(name: SFProDisplay_Bold, size: 18)
        button.setTitleColor(InverseBackgroundColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.layer.shadowRadius = 15
        button.layer.cornerRadius = 13
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        return button
    }()
    
    // Sets up PeriodTime button
    lazy var PeriodTime: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.setTitle("PeriodTime", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.layer.shadowRadius = 15
        button.layer.cornerRadius = 13
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        return button
    }()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = BackgroundColor;
        return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            
            self.view.addSubview(scrollView)
            
            
            // constrain the scroll view to 8-pts on each side
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            // add labelOne to the scroll view
            
            CreateItemsInScrollView()
            
        }
        
    }
    
    //
    
    func CreateItemsInScrollView() {
        
        //The items are made in order of top to bottom so that they can have constraints to the item above them.
        
        let optionsTextLabel2 = UITextField()
        optionsTextLabel2.frame = CGRect(x: 32, y: 30, width: 300, height: 200)
        scrollView.addSubview(optionsTextLabel2)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        optionsTextLabel2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 1000).isActive = true
        optionsTextLabel2.textAlignment = NSTextAlignment.justified
        optionsTextLabel2.textColor = UIColor.white
        optionsTextLabel2.text = " Name\nLast Name"
        optionsTextLabel2.backgroundColor = .red
        optionsTextLabel2.font = UIFont.boldSystemFont(ofSize: 30)
        optionsTextLabel2.layer.cornerRadius = 6
        
        
        
        
        scrollView.addSubview(Schedule)
        Schedule.translatesAutoresizingMaskIntoConstraints = false
        Schedule.heightAnchor.constraint(equalToConstant: 55).isActive = true
        Schedule.widthAnchor.constraint(equalToConstant: 140).isActive = true
        Schedule.topAnchor.constraint(equalTo: optionsTextLabel2.bottomAnchor, constant: 10).isActive = true
        Schedule.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: -80).isActive = true
        
        Schedule.addTarget(self, action: #selector(didTapScheduleButton), for: .touchUpInside)
        
        
        let schedile = UILabel()
        schedile.text = "Schedule"
        schedile.frame = CGRect(x: 10, y: 0, width: 140, height: 55)
        schedile.textColor = .white
        
        
        
        
        let ScheduleBackGround = CAGradientLayer()
        ScheduleBackGround.colors = [UIColor(hex: "#70afb4").cgColor, UIColor(hex: "#167e96").cgColor]
        CAGradientLayer().cornerRadius = 13
        ScheduleBackGround.startPoint = CGPoint(x: 0.0, y: 1.0)
        ScheduleBackGround.endPoint = CGPoint(x: 1.0, y: 1.0)
        ScheduleBackGround.frame = CGRect(x: 0, y: 0, width: 140, height: 55)
        Schedule.layer.addSublayer(ScheduleBackGround)
        Schedule.addSubview(schedile)
        
        
        
        
        scrollView.addSubview(Payment)
        
        Payment.translatesAutoresizingMaskIntoConstraints = false
        Payment.heightAnchor.constraint(equalToConstant: 55).isActive = true
        Payment.widthAnchor.constraint(equalToConstant: 140).isActive = true
        Payment.topAnchor.constraint(equalTo: optionsTextLabel2.bottomAnchor, constant: 10).isActive = true
        Payment.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 80).isActive = true
        
        Payment.addTarget(self, action: #selector(didTapPaymentButton), for: .touchUpInside)
        
        scrollView.addSubview(PeriodTime)
        PeriodTime.translatesAutoresizingMaskIntoConstraints = false
        PeriodTime.heightAnchor.constraint(equalToConstant: 80).isActive = true
        PeriodTime.widthAnchor.constraint(equalToConstant: 300).isActive = true
        PeriodTime.topAnchor.constraint(equalTo: Payment.bottomAnchor, constant: 10).isActive = true
        PeriodTime.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        
        
        let optionsTextLabel = UILabel()
        scrollView.addSubview(optionsTextLabel)
        optionsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsTextLabel.topAnchor.constraint(equalTo: PeriodTime.bottomAnchor, constant: 10).isActive = true
        optionsTextLabel.centerXAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 60).isActive = true
        optionsTextLabel.textAlignment = NSTextAlignment.justified
        optionsTextLabel.textColor = UIColor.black
        optionsTextLabel.text = "Options"
        optionsTextLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        
        scrollView.addSubview(Notifications)
        Notifications.translatesAutoresizingMaskIntoConstraints = false
        Notifications.heightAnchor.constraint(equalToConstant: 45).isActive = true
        Notifications.widthAnchor.constraint(equalToConstant: 380).isActive = true
        Notifications.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        Notifications.topAnchor.constraint(equalTo: optionsTextLabel.bottomAnchor).isActive = true
        Notifications.addTarget(self, action: #selector(didTapNotificationsButton), for: .touchUpInside)
        
        
        let ThemeModeTextLabel = UILabel()
        ThemeModeTextLabel.frame = CGRect(x: 30, y: 250, width: 150, height: 35)
        scrollView.addSubview(ThemeModeTextLabel)
        ThemeModeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        ThemeModeTextLabel.topAnchor.constraint(equalTo: Notifications.bottomAnchor, constant: 10).isActive = true
        ThemeModeTextLabel.centerXAnchor.constraint(equalTo: Notifications.centerXAnchor, constant: -121).isActive = true
        ThemeModeTextLabel.textAlignment = NSTextAlignment.justified
        ThemeModeTextLabel.textColor = UIColor.gray
        ThemeModeTextLabel.text = "Theme mode"
        ThemeModeTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        
        let myswitch = UISwitch()
        //myswitch.frame = CGRect(x: 30, y: 250, width: 150, height: 35)
        myswitch.isOn = false
        myswitch.thumbTintColor = UIColor.white
        myswitch.tintColor = UIColor.blue
        myswitch.onTintColor = UIColor.blue
        self.scrollView.addSubview(myswitch)
        myswitch.translatesAutoresizingMaskIntoConstraints = false
        myswitch.centerYAnchor.constraint(equalTo: ThemeModeTextLabel.centerYAnchor).isActive = true
        myswitch.centerXAnchor.constraint(equalTo: ThemeModeTextLabel.centerXAnchor, constant: 265).isActive = true
        
        
        
        let infoTextLabel = UILabel()
        //infoTextLabel.frame = CGRect(x: 30, y: 360, width: 90, height: 35)
        scrollView.addSubview(infoTextLabel)
        infoTextLabel.translatesAutoresizingMaskIntoConstraints = false
        infoTextLabel.topAnchor.constraint(equalTo: ThemeModeTextLabel.bottomAnchor, constant: 10).isActive = true
        infoTextLabel.centerXAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 35).isActive = true
        infoTextLabel.textAlignment = NSTextAlignment.justified
        infoTextLabel.textColor = UIColor.black
        infoTextLabel.text = "Info"
        infoTextLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        
        //sets up and adds table view for info section
        
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.red
        tableView.isScrollEnabled = false
        scrollView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.heightAnchor.constraint(equalToConstant: CGFloat(infoButtonTitlesArray.count) * 50).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: 380).isActive = true
        tableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: infoTextLabel.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        //TermsandAgreements.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        tableView.register(infoTableViewCell.self, forCellReuseIdentifier: infoTableViewCell.identifier);
    }
    
    //Open Schedule Page
    
    @objc private func didTapScheduleButton(){
        openPresentablePage(schedulePageViewController());
    }
    
    @objc private func didTapPaymentButton(){
        openPresentablePage(paymentPageViewController());
    }
    
    @objc private func didTapNotificationsButton(){
        openPresentablePage(notificationSettingsPageViewController());
    }
    
    
    private func openPresentablePage(_ vc: presentableViewController){
        transitionDelegateVar = transitionDelegate();
        vc.transitioningDelegate = transitionDelegateVar;
        vc.modalPresentationStyle = .custom;
        
        self.present(vc, animated: true);
    }
    
}
