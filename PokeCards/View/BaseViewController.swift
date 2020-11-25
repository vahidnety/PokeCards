//
//  BaseViewController.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Foundation
import NVActivityIndicatorView
import UIKit

class BaseViewController: UIViewController {
    lazy var nvActivityIndicatorView: NVActivityIndicatorView = {
        let frameIndicator = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nvActivityIndicatorView = NVActivityIndicatorView(
            frame: frameIndicator, type:
            NVActivityIndicatorType.ballScaleRippleMultiple,
            color: UIColor.orange, padding: 0.0
        )
        return nvActivityIndicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showErrorMessage(_ message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

    func showLoadingView(_ view: UIView) {
        DispatchQueue.main.async {
            let alignCenter = self.nvActivityIndicatorView.frame.size.width / 2
            var point = CGPoint(x: view.center.x - alignCenter, y: view.center.y - alignCenter)
            if view.frame.size.height <= view.frame.size.width {
                point = CGPoint(x: point.y, y: point.x)
            }
            self.nvActivityIndicatorView.frame = CGRect(origin: point, size: self.nvActivityIndicatorView.frame.size)
            view.addSubview(self.nvActivityIndicatorView)
            self.nvActivityIndicatorView.startAnimating()
        }
    }

    func hideLoadingView(_ view: UIView) {
        DispatchQueue.main.async {
            if self.nvActivityIndicatorView.isDescendant(of: view) {
                self.nvActivityIndicatorView.stopAnimating()
                self.nvActivityIndicatorView.removeFromSuperview()
                //            tableView.tableFooterView = nil
            }
        }
    }
}
