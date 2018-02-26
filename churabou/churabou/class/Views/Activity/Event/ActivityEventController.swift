import UIKit

class ActivityEventController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ target: ActivityEventTarget) {
        self.init(nibName: nil, bundle: nil)
        viewModel.target = target
    }
    

    let viewModel = ActivityEventViewModel()
    let baseView = ActivityEventView()
    
    override func viewDidLoad() {
        parent?.title = "News"
        baseView.viewModel = viewModel
        baseView.frame = view.frame
        view.addSubview(baseView)
        bindToViewModel()
        baseView.refresh()
        hud.setUp(view)
    }
    
    
    let hud = HUDView()
    fileprivate func bindToViewModel() {
        
        viewModel.isLoadingDidSet = { (isloading) in
            if isloading {
                self.hud.show()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                     self.hud.hide()
                })
   
            }
        }
        
        viewModel.eventsDidSet = { _ in
            self.baseView.update()
        }
        
        viewModel.errorDidSet = { (error) in
//            print(error)
            ErrorAlert.show(self)
        }
        
        baseView.reachedBottomDidSet = { (reachedBottom) in
            self.viewModel.loadMoreEvent()
        }
    }
}
