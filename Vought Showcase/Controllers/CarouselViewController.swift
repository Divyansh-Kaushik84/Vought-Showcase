//
//  CarouselViewController.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import Foundation
import UIKit


final class CarouselViewController: UIViewController, SegmentedProgressBarDelegate {
    func segmentedProgressBarChangedIndex(index: Int) {
        
//        if(currentItemIndex < index){
//            navigateController(index: index)
//        } 
//        else if(currentItemIndex > index){
////            navigateController(index: index-1)
//        }
    }
    
    func segmentedProgressBarFinished() {
        
    }
    
    
    /// Container view for the carousel
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet weak var storyProgressBarView: UIView!//added the outlet for the view that will contain the progress bar
    var storyProgressBar : SegmentedProgressBar?//the segmented progress bar for instagram story style experience
    
    /// Carousel control with page indicator
//    @IBOutlet private weak var carouselControl: UIPageControl!


    /// Page view controller for carousel
    private var pageViewController: UIPageViewController?
    
    /// Carousel items
    private var items: [CarouselItem] = []
    
    /// Current item index
    private var currentItemIndex: Int = 0 {
        didSet {
            // Update carousel control page
//            self.carouselControl.currentPage = currentItemIndex
        }
    }

    /// Initializer
    /// - Parameter items: Carousel items
    public init(items: [CarouselItem]) {
        self.items = items
        super.init(nibName: "CarouselViewController", bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        storyProgressBar?.startAnimation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageViewController()
//        initCarouselControl()
        storyProgressBar = SegmentedProgressBar(numberOfSegments: items.count,
                                                 duration: 5)
        storyProgressBar?.frame = CGRect(x: 0,
                                          y: 0,
                                         width: UIScreen.main.bounds.width,
                                         height: 5)
        storyProgressBarView?.addSubview(storyProgressBar!)
        storyProgressBar?.delegate = self


//        
//        view.addSubview(storyProgressBarView)
//        view.addSubview(SegmentedProgressBar(numberOfSegments: items.count, duration: 5))//it is not showing the number of stories equal to items
        
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) 
    {
        storyProgressBar?.rewind()//go to the previous segment
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) 
    {
        storyProgressBar?.skip()//go to the next segment
    }
    //    public override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    
    /// Initialize page view controller
    private func initPageViewController() {

        // Create pageViewController
        pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal,
        options: nil)

        // Set up pageViewController
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        pageViewController?.setViewControllers(
            [getController(at: currentItemIndex)], direction: .forward, animated: true)

        guard let theController = pageViewController else {
            return
        }
        pageViewController?.gestureRecognizers.forEach { $0.isEnabled = false } // disable the swipe gesture now we can go to the next VC by pressing the buttons only

        // Add pageViewController in container view
        add(asChildViewController: theController,
            containerView: containerView)
    }

    /// Initialize carousel control
//    private func initCarouselControl() {
        // Set page indicator color
//        carouselControl.currentPageIndicatorTintColor = UIColor.darkGray
//        carouselControl.pageIndicatorTintColor = UIColor.lightGray
        
        // Set number of pages in carousel control and current page
//        carouselControl.numberOfPages = items.count
//        carouselControl.currentPage = currentItemIndex
        
        // Add target for page control value change
//        carouselControl.addTarget(
//                    self,
//                    action: #selector(updateCurrentPage(sender:)),
//                    for: .valueChanged)
//    }

    /// Update current page
    /// Parameter sender: UIPageControl
//    @objc func updateCurrentPage(sender: UIPageControl) {
//        // Get direction of page change based on current item index
//        let direction: UIPageViewController.NavigationDirection = sender.currentPage > currentItemIndex ? .forward : .reverse
//        
//        // Get controller for the page
//        let controller = getController(at: sender.currentPage)
//        
//        // Set view controller in pageViewController
//        pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
//        
//        // Update current item index
//        currentItemIndex = sender.currentPage
//    }
    
    /// Get controller at index
    /// - Parameter index: Index of the controller
    /// - Returns: UIViewController
    private func getController(at index: Int) -> UIViewController {
        return items[index].getController()
    }
    func navigateController(index: Int)
    {
        if(currentItemIndex+1 != items.count)
        {
            currentItemIndex = currentItemIndex + 1
            print(currentItemIndex)
                pageViewController?.setViewControllers([getController(at: currentItemIndex)],
                                                       direction: .forward,
                                                       animated: false,
                                                       completion: nil)
            
        }
        else if(currentItemIndex != 0)
        {
            currentItemIndex = currentItemIndex - 1
            print(currentItemIndex)

            pageViewController?.setViewControllers([getController(at: currentItemIndex)],
                                                       direction: .reverse,
                                                       animated: false,
                                                       completion: nil)
        }
    }
}

// MARK: UIPageViewControllerDataSource methods
extension CarouselViewController: UIPageViewControllerDataSource {
    
    /// Get previous view controller
    /// - Parameters:
    ///  - pageViewController: UIPageViewController
    ///  - viewController: UIViewController
    /// - Returns: UIViewController
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            // Check if current item index is first item
            // If yes, return last item controller
            // Else, return previous item controller
            if currentItemIndex == 0 {
                return items.last?.getController()
            }
            return getController(at: currentItemIndex-1)
        }

    /// Get next view controller
    /// - Parameters:
    ///  - pageViewController: UIPageViewController
    ///  - viewController: UIViewController
    /// - Returns: UIViewController
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
           
            // Check if current item index is last item
            // If yes, return first item controller
            // Else, return next item controller
            if currentItemIndex + 1 == items.count {
                return items.first?.getController()
            }
            return getController(at: currentItemIndex + 1)
        }
}

// MARK: UIPageViewControllerDelegate methods
extension CarouselViewController: UIPageViewControllerDelegate {
    
    /// Page view controller did finish animating
    /// - Parameters:
    /// - pageViewController: UIPageViewController
    /// - finished: Bool
    /// - previousViewControllers: [UIViewController]
    /// - completed: Bool
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = items.firstIndex(where: { $0.getController() == visibleViewController }){
                currentItemIndex = index
            }
        }
}
