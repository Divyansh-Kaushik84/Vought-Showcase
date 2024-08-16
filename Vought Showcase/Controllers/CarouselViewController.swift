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
        
        if(currentItemIndex < index){
            goToNextPage(index: index)
        }
        else if(currentItemIndex > index){
            goToPreviousPage(index: index)
        }
    }
    
    func segmentedProgressBarFinished() {
        self.dismiss(animated: true, completion: nil)

    }
    
    
    /// Container view for the carousel
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet weak var storyProgressBarView: UIView!//added the outlet for the view that will contain the progress bar
    var storyProgressBar : SegmentedProgressBar?//the segmented progress bar for instagram story style experience
    
    /// Page view controller for carousel
    private var pageViewController: UIPageViewController?
    
    /// Carousel items
    private var items: [CarouselItem] = []
    
    /// Current item index
    private var currentItemIndex: Int = 0
    

    /// Initializer
    /// - Parameter items: Carousel items
    public init(items: [CarouselItem]) {
        self.items = items
        super.init(nibName: "CarouselViewController", bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        storyProgressBar?.startAnimation()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initPageViewController()
        showStoryProgressBar()     //adding storyProgressBar to VC
        swipeDown()               //adding swipe down funcationality
    }
    
    func showStoryProgressBar()
        {
            storyProgressBar = SegmentedProgressBar(numberOfSegments: items.count, duration: 5)
            storyProgressBar?.frame = CGRect(x: 0, y: 0,  width: UIScreen.main.bounds.width, height: storyProgressBarView.bounds.height)
            storyProgressBarView?.addSubview(storyProgressBar!)
            storyProgressBar?.delegate = self
        }
    
    
    func swipeDown()
        {
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
            swipeDown.direction = .down
            view.addGestureRecognizer(swipeDown)
        }
    @objc func handleSwipeDown(_ gesture: UISwipeGestureRecognizer)
        {
            self.dismiss(animated: true, completion: nil)
        }
        
    
    @IBAction func previousButtonTapped(_ sender: UIButton)
    {
        storyProgressBar?.rewind()//go to the previous segment
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) 
    {
        storyProgressBar?.skip()//go to the next segment
    }


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
           
            if currentItemIndex + 1 == items.count {
                return items.first?.getController()
            }
            return getController(at: currentItemIndex + 1)
        }
    func goToNextPage(index:Int){
        if(currentItemIndex + 1 != items.count)
        {
            currentItemIndex = currentItemIndex + 1
            pageViewController?.setViewControllers([getController(at: currentItemIndex)], direction: .forward, animated: false)
        }
    }
    func goToPreviousPage(index:Int){
        currentItemIndex = currentItemIndex - 1
        pageViewController?.setViewControllers([getController(at: currentItemIndex)], direction: .reverse, animated: false)
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
