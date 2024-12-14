//
//  SearchViewControllerExtensions.swift
//  Bond_Helper
//


import Foundation
import UIKit
 
extension SearchViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.BondSearchController.isActive {
            return self.searchArray.count
        } else {
            return self.bondArray.count
        }
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "MyCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                 for: indexPath)
        cell.accessoryType = .detailDisclosureButton
         
        if self.BondSearchController.isActive {
            cell.textLabel?.text = self.searchArray[indexPath.row]
            return cell
        } else {
            cell.textLabel?.text = self.bondArray[indexPath.row]
            return cell
        }
        
    }
    
}
 
extension SearchViewController
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print("1")
        tableView.deselectRow(at: indexPath, animated: true)
        //let itemString = self.bondArray[indexPath.row]
        let itemString = indexPath.row
        print(indexPath.row)
        print(bondArray[indexPath.row])
        self.performSegue(withIdentifier: "ShowDetailView", sender: itemString)

    }
}
 
extension SearchViewController: UISearchResultsUpdating
{
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        self.searchArray = self.bondArray.filter { (bond) -> Bool in
            return bond.contains(searchController.searchBar.text!)
      
        }

    }
}
