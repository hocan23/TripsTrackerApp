//
//  ViewController.swift
//  TripsTrackerApp
//
//  Created by Hasan onur Can on 16.08.2022.
//



import UIKit

class HomeViewController: UIViewController {
    
    
    var viewModel = HomeViewModel()
    
    
    @IBOutlet weak var tripsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        confiureTripsTableView()
        //        configureViewModel()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchTripsFromCoreData()
    }
    
    private func configureView(){
        view.backgroundColor = .white
    }
    
    private func confiureTripsTableView(){
        self.tripsTableView.backgroundColor = .white
        self.tripsTableView.delegate = self
        self.tripsTableView.dataSource = self
    }
    
    private func configureViewModel(){
        viewModel = HomeViewModel()
    }
    
    private func bindViewModel(){
        updateViewWithData()
    }
    
    private func updateViewWithData(){
        viewModel.updateTableViewClosure = { DispatchQueue.main.async {
            self.navigationController?.title = "Trips Tracker"
            self.tripsTableView.reloadData() } }
    }
    
    
    
    @IBAction func pushMap(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        viewController.showRoute = false
        self.navigationController?.pushViewController(viewController, animated: true)    }
    
}


extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVM = viewModel.getTripCellViewModel(at: indexPath)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        viewController.cellVmData = cellVM
        viewController.showRoute = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.getNumberOfCells())
        return viewModel.getNumberOfCells() 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        
        let cellVM = viewModel.getTripCellViewModel(at: indexPath)
        let title = cellVM.tripName 
        cell.tripNameLabel.text = "\(title)"
        return cell
    }
    
    
}
