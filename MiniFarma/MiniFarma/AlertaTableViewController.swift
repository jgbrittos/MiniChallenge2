//
//  AlertaTableViewController.swift
//  MiniFarma
//
//  Created by Caique de Paula Pereira on 31/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class AlertaTableViewController: UITableViewController,UITextFieldDelegate {

   
    @IBOutlet weak var dataInicioPicker: UIDatePicker!
    @IBOutlet weak var txtDuracaoQuantidade: UITextField!
    @IBOutlet weak var duracaoUnidadeSegmented: UISegmentedControl!
    @IBOutlet weak var lblIntervalo: UILabel!
    @IBOutlet weak var lblRemedio: UILabel!
    
    var unidadeDuracao: Int = 0
    var idIntervalo: Int = 0
    var idRemedio: Int = 0

    let alertaDAO = AlertaDAO()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtDuracaoQuantidade.delegate = self
        
        lblIntervalo.text = ""
        lblRemedio.text = ""
        unidadeDuracao = 0
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 6
    }

    
    @IBAction func salvaAlarme(sender: AnyObject) {
        
        let alerta = Alerta(dataInicio: dataInicioPicker.date, numeroDuracao: txtDuracaoQuantidade.text.toInt()!, unidadeDuracao: unidadeDuracao, ativo: 1, idIntervalo: idIntervalo, idRemedio: idRemedio)
        
        
        
        //falta metodo que leva pra outra view
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        txtDuracaoQuantidade.resignFirstResponder()
        self.view.endEditing(true)
    }

    
    @IBAction func indexMudou(sender: AnyObject) {
        
        switch duracaoUnidadeSegmented.selectedSegmentIndex{
            case 0:
                unidadeDuracao = 0
                break
            case 1:
                unidadeDuracao = 1
                break
            case 2:
                unidadeDuracao = 3
                break
            default:
                break
        }
        
    }
    
    
    
    
    
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        //if((tableView.dequeueReusableCellWithIdentifier("Data")) != nil){
//            let cell = tableView.dequeueReusableCellWithIdentifier("Data", forIndexPath: indexPath) as! UITableViewCell
///
//
//        
//        return cell
//
//            }
//    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
