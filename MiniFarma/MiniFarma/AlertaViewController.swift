//
//  AlertaViewController.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class AlertaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewAlerta: UITableView!
    @IBOutlet weak var segmentedControlAtividadeRemedios: UISegmentedControl!
    
    let alertasAtivos = ["Novalgina", "Resfenol"]
    let alertasInativos = ["Viagra","Tylenol","Dorflex"]
    var alertasDaVez = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableViewAlerta.delegate = self
        self.tableViewAlerta.dataSource = self
        
        self.alertasDaVez = self.alertasAtivos
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func alteraDadosDaTabelaAlerta(sender: AnyObject) {
        switch segmentedControlAtividadeRemedios.selectedSegmentIndex {
        case 0:
            self.alertasDaVez = self.alertasAtivos
            break
        case 1:
            self.alertasDaVez = self.alertasInativos
            break
        default:
            self.alertasDaVez = self.alertasAtivos
            println("Algo ocorreu no método alteraDadosDaTabelaAlerta na classe AlertaViewController!")
            break
        }
        
        self.tableViewAlerta.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alertasDaVez.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableViewAlerta.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as! UITableViewCell
        
        cell.textLabel?.text = self.alertasDaVez[indexPath.row]
        cell.detailTextLabel?.text = self.alertasDaVez[indexPath.row]
        
        return cell
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
