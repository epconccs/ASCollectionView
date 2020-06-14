// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public class AS_TableViewController: UIViewController
{
	weak var coordinator: ASTableViewCoordinator?

	var style: UITableView.Style
    var tableHeaderView: AnyView?
    var tableViewHeaderHeight: CGFloat = 0

	lazy var tableView: AS_UITableView = {
        
		let tableView = AS_UITableView(frame: .zero, style: style)
        
        if let headerView = self.tableHeaderView {
            
            let vc = ASHostingController(headerView)
            vc.viewController.view.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: self.tableViewHeaderHeight)
            vc.viewController.view.setNeedsLayout()
            vc.viewController.view.layoutIfNeeded()
            
            addChild(vc.viewController)
            
            tableView.tableHeaderView = vc.viewController.view
            
            vc.viewController.didMove(toParent: self)
            
        } else {
            tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude))) // Remove unnecessary padding in Style.grouped/insetGrouped
        }
        
		tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude))) // Remove separators for non-existent cells
        
		return tableView
	}()

	public init(style: UITableView.Style, tableViewHeaderHeight: CGFloat, tableHeaderView: AnyView? = nil)
    {
        self.style = style
        self.tableHeaderView = tableHeaderView
        self.tableViewHeaderHeight = tableViewHeaderHeight
        super.init(nibName: nil, bundle: nil)
    }

	required init?(coder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override public func loadView()
	{
		view = tableView
	}

	override public func viewDidLoad()
	{
		super.viewDidLoad()
	}

	override public func viewDidLayoutSubviews()
	{
		super.viewDidLayoutSubviews()
		coordinator?.didUpdateContentSize(tableView.contentSize)
	}

	override public func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		// NOTE: Due to some SwiftUI bugs currently, we've chosen to call this here instead of actual parent call
		coordinator?.onMoveToParent()
	}

	override public func viewDidDisappear(_ animated: Bool)
	{
		super.viewDidDisappear(animated)
		// NOTE: Due to some SwiftUI bugs currently, we've chosen to call this here instead of actual parent call
		coordinator?.onMoveFromParent()
	}
}

@available(iOS 13.0, *)
class AS_UITableView: UITableView {}
