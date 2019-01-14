//
//  SectionViewController.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 1/2/19.
//  Copyright © 2019 Tomer Landesman. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController, UIPageViewControllerDataSource , UIPageViewControllerDelegate , UIScrollViewDelegate{
    
    enum Diraction: Int {
        case LEFT = 0
        case RIGHT = 1
        case NONE = 3
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = orderedViewControllers.firstIndex(of: viewController) else{
            return nil
        }
       
        let prevIndex = vcIndex - 1
        
        if prevIndex < 0 {
            return nil
        }
        currentPageIndex = vcIndex
        return orderedViewControllers[prevIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = orderedViewControllers.firstIndex(of: viewController) else{
            return nil
        }
        
        let nextIndex = vcIndex + 1

        if nextIndex >= orderedViewControllers.count{
            return nil
        }
        currentPageIndex = vcIndex
        return orderedViewControllers[nextIndex]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let mb = self.menuBar else {
            return
        }
        
        let scrollPos = (scrollView.contentOffset.x - 375 ) / 4
        print(scrollPos)
        let currentVC = pageController.viewControllers?.first
        let vcIndex: IndexPath
            switch currentVC {
            case vc0: // Main Screen
                vcIndex = IndexPath(item: 0 , section: 0)

                break
            case vc1: // Report
                vcIndex = IndexPath(item: 1 , section: 0)
                break
            case vc2: // News
                vcIndex = IndexPath(item: 2 , section: 0)
                break
            default:
                return
        }
        if  scrollPos <= 105{
            mb.horizontalBarLeftConstraint?.constant = mb.cellLeftAnchorConstant[vcIndex]! + scrollPos
            mb.horizontalBarWidthConstraint?.constant = mb.cellsWidthList[vcIndex]!
        }


    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentVC = pageController.viewControllers?.first
        let vcIndex: IndexPath
        if completed {
            switch currentVC{
            case vc0:
                vcIndex = IndexPath(item: 0 ,section: 0)
            
            case vc1:
                vcIndex = IndexPath(item: 1 ,section: 0)
        
            case vc2:
                vcIndex = IndexPath(item: 2 ,section: 0)
            case .none:
                return
            case .some(_):
                return
            }
            
            menuBar?.collectionView.selectItem(at: vcIndex, animated: false, scrollPosition: [])
            
        }

    }
    

    func scrollToMenuItem(menuIndex: Int){
        
        let indexPath = IndexPath(item: menuIndex, section: 0)
        guard menuBar != nil else {
            print ("Error")
            return
        }
        
        switch(indexPath.item){
            case(0):
                currentPageIndex = indexPath.section
                pageController.setViewControllers([vc0!], direction: .forward, animated: false, completion: nil)
            case(1):
                currentPageIndex = indexPath.section
                pageController.setViewControllers([vc1!], direction: .forward, animated: false, completion: nil)
            case(2):
                currentPageIndex = indexPath.section
                pageController.setViewControllers([vc2!], direction: .forward, animated: false, completion: nil)
            default:
                print("Error")
                return
            }
    }
    
    
    let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal,
                                              options: [UIPageViewController.OptionsKey.spineLocation: 0])
    
    var currentPageIndex: Int = 0
    
    var currentCountry: String = "us"
    
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        return view
    }()
    
    var sections: HomeCollectionView? = nil
    
    var menuBar: MenuBar? = nil
    
    var settingsLauncher = SettingsLauncher()
    
    var orderedViewControllers: [UIViewController] = []
    
    var lastCoo: Coordinate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.textColor = UIColor.white
        titleLabel.text = "  Home"
        navigationItem.titleView = titleLabel
        
        navigationController?.navigationBar.isTranslucent = false
        
        setupMenuBar()
        setupNavigationButtons()
        setupPageController()
        settingsLauncher.collectionView.parentVC = self

        

    }
    
    var vc0: UIViewController? = nil
    var vc1: UIViewController? = nil
    var vc2: UIViewController? = nil
    
    func setupPageController() {
        
        pageController.delegate = self
        pageController.dataSource = self
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
         vc0 = storyboard.instantiateViewController(withIdentifier: "mainViewController")
         (vc0 as! OptionsScreen).countryDelegate = self
        
         vc1 = storyboard.instantiateViewController(withIdentifier: "NewsVC")
        
         vc2 = storyboard.instantiateViewController(withIdentifier: "MapVC")
        (vc0 as! Map).cooDelegate = self
    
        
        pageController.setViewControllers([vc0!], direction: .forward, animated: false, completion: nil)
        
        orderedViewControllers.append(vc0!)
        orderedViewControllers.append(vc1!)
        orderedViewControllers.append(vc2!)
        
        self.view.addSubview(pageController.view)
        self.view.sendSubviewToBack(pageController.view)
        
        guard let mb = menuBar else {
            print("error: menu bar is nil")
            return
        }
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.topAnchor.constraint(equalTo: mb.topAnchor).isActive = true
        pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        pageController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        pageController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        let height = self.view.frame.height - (self.menuBar?.frame.height)!
        pageController.view.heightAnchor.constraint(equalToConstant: height)
        
        for v in pageController.view.subviews {
            if v.isKind(of: UIScrollView.self){
                (v as! UIScrollView).delegate = self
                (v as! UIScrollView).isPagingEnabled = true
            }
        }
        
    }

    private func setupNavigationButtons(){
        var dotsImage = UIImage(named: "3dots")?.withRenderingMode(.alwaysOriginal)
        dotsImage = UIImage.resizeImage(image: dotsImage! , newWidth: 20)
        let dots = UIBarButtonItem(image: dotsImage , style: .plain, target: self, action: #selector(optionsMenuAction))
        navigationItem.rightBarButtonItem = dots
        
    }
    
    @objc func optionsMenuAction(){
        settingsLauncher.showSettings()
    }
    
    private func setupMenuBar(){
        navigationController?.hidesBarsOnSwipe = false
        
        let blueView = UIView()
        blueView.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 180)
        view.addSubview(blueView)
        view.sendSubviewToBack(blueView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: blueView)
        view.addConstraintsWithFormat(format: "V:|[v0(30)]", views: blueView)

        
        // add menu bar and constraints for menu bar
        menuBar = MenuBar()
        menuBar!.parentVC = self
        
        
        
        view.addSubview(self.menuBar!)

        //setMenuBarConstraints(newView: menuBar!)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.menuBar!)
        view.addConstraintsWithFormat(format: "V:[v0(30)]", views: self.menuBar!)
        menuBar?.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func setupCollectionView(){
        
        sections = HomeCollectionView()
        sections!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sections!)
        
        
        sections!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sections!.topAnchor.constraint(equalTo: (menuBar?.bottomAnchor)!).isActive = true
        sections!.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sections!.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    
    }
    
    func setMenuBarConstraints(newView: MenuBar){
        self.edgesForExtendedLayout = []//Optional our as per your view ladder
        
        self.view.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            newView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            newView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            newView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            newView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        } else {
            NSLayoutConstraint(item: newView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: view, attribute: .top,
                               multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: newView,
                               attribute: .leading,
                               relatedBy: .equal, toItem: view,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            NSLayoutConstraint(item: newView, attribute: .trailing,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            
            newView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
    }
    
    func scrollDiraction(velocity: CGFloat) -> Diraction{
        if velocity < 0 {
            return Diraction.LEFT
        }
        else if velocity > 0{
            return Diraction.RIGHT
        }
        return Diraction.NONE
    }
    var lastXPos: CGFloat = 0
    
    func scrollDiraction(XPos: CGFloat) -> Diraction{
        if XPos > lastXPos {
            return Diraction.RIGHT
        }
        else{
            return Diraction.LEFT
        }
    }
    
    func clickedReport(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let reportVC = sb.instantiateViewController(withIdentifier: "ReportViewController")
        navigationController?.pushViewController(reportVC, animated: true)
        settingsLauncher.dismissMenuTap()

        
    }
    
    func didChangeCountry(country: String){
        currentCountry = country
        let cc = CountryCodes()
        (vc1 as! NewsViewController).currentCountry = cc.getCountryCode(country: country)
    }
    
    func didChooseCoordinateFromMap(coordinate: Coordinate){
        (vc0 as! OptionsScreen).handleWeather(lng: coordinate.lng, lat: coordinate.lat, displayAddress: coordinate.address)
    }

}
