//
//  SearchResultsTableViewController.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    var searchResults = ProductSearchResults()

    @IBOutlet var searchInputView: SearchInputView!
    var searchTerm: String {
        return self.searchInputView.textField.text ?? ""
    }

    private let numberFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        numberFormatter.currencySymbol = "$"
        numberFormatter.currencyGroupingSeparator = ","
        numberFormatter.numberStyle = .currency

        self.searchInputView.setup()
        self.navigationItem.titleView = self.searchInputView

        self.navigationController?.view.tintColor = .orange
    }

    @IBAction func search(_ sender: UIControl) {
        guard let siv = searchInputView else { return }
        guard let text = siv.textField.text else { return }

        newSearchForTerm(text)
        siv.textField.resignFirstResponder()
    }

    @IBAction func textFieldDidBecomeActive(_ sender: UITextField) {
        self.searchResults.reset()
        self.tableView.reloadData()
    }
    
    func newSearchForTerm(_ term: String) {
        if term.count > 2 {
            self.searchForTerm(term, inSection: 0)
        }
        else {
            self.searchResults.reset()
            self.tableView.reloadData()
        }
    }

    func searchForTerm(_ term: String, inSection section: Int) {
        Network.shared.search(term, atPage: section + 1) { (result) in
            switch result {
            case .failure(let error):
                // We should probably have better error handling here.
                print(error)
                break
            case .success(let page):
                self.searchResults.updateWith(page: page)
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchResultsTableViewController: UITableViewDataSourcePrefetching {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.searchResults.sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && (self.searchResults.showEmptyResults || self.searchResults.showInstructions) {
            return 1
        }
        if self.searchResults.isPageLoadedForSection(section) {
            return self.searchResults.numberOfProductsInSection(section)
        }
        else {
            // We only want to show one loading view at a time.
            if section > 0 && self.searchResults.isPageLoadedForSection(section - 1) {
                // So make sure the section before this one isn't loading.
                return 1
            }
            else {
                // And return zero if it is.
                return 0
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.searchResults.showInstructions {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: InstructionsCell.self))!
        }
        else if self.searchResults.showEmptyResults {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: NoResultsCell.self))!
        }
        if self.searchResults.isPageLoadedForSection(indexPath.section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCell.self)) as! ProductCell
            let product = self.searchResults.productAtIndexPath(indexPath)!

            cell.productImageView.setImage(with: product.imageUrl)
            cell.skuLabel.text = "\(product.sku)"
            cell.nameLabel.text = product.name
            cell.priceLabel.text = numberFormatter.string(for: product.price)
            if let rating = product.rating {
                cell.ratingView.rating = rating
                cell.ratingView.isHidden = false
            }
            else {
                cell.ratingView.isHidden = true
            }

            return cell
        }
        else {
            // If unloaded cells are visible when reloading the tableview it won't call the prefetch method.
            // Do it manually.
            self.tableView(tableView, prefetchRowsAt: [indexPath])
            return tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingCell.self))!
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if self.searchResults.showEmptyResults || self.searchResults.showInstructions {
            return nil
        }
        else if self.searchResults.isPageLoadedForSection(indexPath.section) == false {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pdvc: ProductDetailsViewController = ProductDetailsViewController.fromStoryboard()
        pdvc.product = self.searchResults.productAtIndexPath(indexPath)

        self.navigationController?.pushViewController(pdvc, animated: true)
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.map { $0.section }
            .forEach { (section) in
                if self.searchResults.isPageLoadedForSection(section) == false {
                    self.searchForTerm(self.searchTerm, inSection: section)
                }
            }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.map { $0.section }
            .forEach { (section) in
                Network.shared.cancelSearch(self.searchTerm, atPage: section + 1)
        }
    }
}

class SearchInputView: UIView, UITextFieldDelegate {
    @IBOutlet var textFieldContainer: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var button: UIButton!
    @IBOutlet var widthConstraint: NSLayoutConstraint!

    func setup() {
        guard let textField = textField else { return }
        self.button.isEnabled = false

        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextField.textDidChangeNotification, object: textField)
    }

    override var bounds: CGRect {
        didSet {
            let radius = (round((bounds.height/2) * UIScreen.main.nativeScale)) / UIScreen.main.nativeScale
            self.layer.cornerRadius = radius
            self.button.layer.cornerRadius = radius - 4
            self.textFieldContainer.layer.cornerRadius = radius - 4
        }
    }

    @objc func textDidChange(notification: Notification) {
        if let text = self.textField.text {
            self.button.isEnabled = text.count > 2
        }
        else {
            self.button.isEnabled = false
        }

    }

}
