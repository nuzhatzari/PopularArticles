//
//  SearchViewController.swift
//  PopularArticles
//
//  Created by Nuzhat Zari on 09/09/20.
//  Copyright © 2020 Nuzhat Zari. All rights reserved.
//

import UIKit

typealias SearchButtonClickedHandler = (_ searchText: String, _ searchDetails: [SearchDetail]) -> Void

class SearchViewController: UIViewController, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtSearchKeyword: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerBackgroundView: UIView!
    
    let searchTableViewReuseIdentifier = "search_cell"
    public var articles = [Article]()
    var selectedIndex: Int?
    
    var searchDetails = [SearchDetail]()
    var options = [String]()
    var searchButtonClickedHandler: SearchButtonClickedHandler?
    var searchViewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: searchTableViewReuseIdentifier
        searchViewModel = SearchViewModel(articles: articles)
        searchDetails = searchViewModel.createSearchCriteria()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Button Action
    @IBAction func onBtnCloseClicked() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onBtnDoneClicked() {
        hidePicker()
    }
    
    @IBAction func onBtnSearchClicked() {
        if self.searchButtonClickedHandler != nil {
            self.searchButtonClickedHandler!(self.txtSearchKeyword.text ?? "", self.searchDetails)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITableViewDataSource protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchTableViewReuseIdentifier) as! SearchTableViewCell

        let searchKey = searchDetails[indexPath.row]
        cell.btnOptionText.setTitle(searchKey.text.count > 0 ? searchKey.text : searchKey.title, for: .normal)
        cell.optionButtonClickedHandler = {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.selectedIndex = indexPath.row
            strongSelf.showPicker(for: searchKey.key)
        }
        return cell
    }
    
    //MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }


    //MARK: - PICKER
    func showPicker(for key: String) {
        options = searchViewModel.fetchOptions(for: key)
        
        pickerBackgroundView.isHidden = false
        self.view.bringSubviewToFront(pickerBackgroundView)
        pickerView.reloadAllComponents()
    }
    
    func hidePicker() {
        if let index = selectedIndex {
            let searchKey = searchDetails[index]
            searchKey.text = options[pickerView.selectedRow(inComponent: 0)]
        }
        
        pickerBackgroundView.isHidden = true
        self.view.sendSubviewToBack(pickerBackgroundView)
        self.tableView.reloadData()
    }

    
}
//MARK: - UIViewController Extension
extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
