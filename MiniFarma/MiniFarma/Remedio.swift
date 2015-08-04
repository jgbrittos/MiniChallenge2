//
//  Remedio.swift
//  MiniFarma
//
//  Created by João Gabriel de Britto e Silva on 19/07/15.
//  Copyright (c) 2015 JGBrittoS. All rights reserved.
//

import UIKit

class Remedio: NSObject {
    
    var idRemedio:Int = 0
    var nomeRemedio:String = ""
    var dataValidade = NSDate()
    var numeroQuantidade:Int = 0
    var unidade: Int = 0
    var preco: Double = 0
    var numeroDose: Int = 0
    var fotoRemedio: String = ""
    var fotoReceita: String = ""
    var vencido: Int = 0
    var idFarmacia: Int = 0
    var idCategoria: Int = 0
    var idLocal: Int = 0
    var idIntervalo: Int = 0
    
    var dataEmString: String {
        let f = NSDateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.stringFromDate(self.dataValidade)
    }
    
    var fotoRemedioUIImage: UIImage {
        if self.fotoRemedio == "sem foto"{
            return UIImage(named: "semFoto")!
        }
        let caminhos = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var documentos: String = caminhos[0] as! String
        let caminhoCompleto = documentos.stringByAppendingPathComponent(self.nomeRemedio+"Remedio.png")
        return UIImage(contentsOfFile: caminhoCompleto)!
    }
    
    var fotoReceitaUIImage: UIImage {
        if self.fotoReceita == "sem foto"{
            return UIImage(named: "semFoto")!
        }
        let caminhos = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var documentos: String = caminhos[0] as! String
        let caminhoCompleto = documentos.stringByAppendingPathComponent(self.nomeRemedio+"Receita.png")
        return UIImage(contentsOfFile: caminhoCompleto)!
    }
    
    override init() {}
    
    //Remedio do banco
    init(idRemedio:Int?, nomeRemedio:String?, dataValidade:NSDate?, numeroQuantidade: Int?,
        unidade:Int?, preco:Double?, numeroDose:Int?, fotoRemedio:String?,
        fotoReceita:String?,vencido:Int?,idFarmacia:Int?, idCategoria:Int?, idLocal:Int?,idIntervalo:Int?){
        if let idr = idRemedio{
            self.idRemedio = idr
        }
        
        if let n = nomeRemedio {
            self.nomeRemedio = n
        }
        
        if let d = dataValidade {
            self.dataValidade = d
        }
        
        if let nq = numeroQuantidade {
            self.numeroQuantidade = nq
        }
        
        if let u = unidade {
            self.unidade = u
        }
        
        if let p = preco {
            self.preco = p
        }
        
        if let nd = numeroDose {
            self.numeroDose = nd
        }
        
        if let frem = fotoRemedio {
            self.fotoRemedio = frem
        }
        
        if let frec = fotoReceita {
            self.fotoReceita = frec
        }
        
        if let v = vencido {
            self.vencido = v
        }
        
        if let idf = idFarmacia {
            self.idFarmacia = idf
        }
        
        if let idc = idCategoria {
            self.idCategoria = idc
        }
        
        if let idl = idLocal {
            self.idLocal = idl
        }
        
        if let idi = idIntervalo {
            self.idIntervalo = idi
        }
    }
    
    //Remedio criado
    init(nomeRemedio:String?, dataValidade:NSDate?, numeroQuantidade: Int?, unidade:Int?,
        preco:Double?, numeroDose:Int?,fotoRemedio:String?,fotoReceita:String?,
        idFarmacia:Int?, idCategoria:Int?, idLocal:Int?,idIntervalo:Int?){
        
        let formatador = NSDateFormatter()
        formatador.dateFormat = "dd-MM-yyyy"
        let dataControle = formatador.dateFromString("01/01/1900")!
            
        if let n = nomeRemedio {
            self.nomeRemedio = n
        }
            
        if let d = dataValidade {
            self.dataValidade = d
        }else{
            self.dataValidade = dataControle
        }
        
        if let nq = numeroQuantidade {
            self.numeroQuantidade = nq
        }

        if let u = unidade {
            self.unidade = u
        }
        
        if let p = preco {
            self.preco = p
        }
        
        if let nd = numeroDose {
            self.numeroDose = nd
        }
        
        if let frem = fotoRemedio {
            self.fotoRemedio = frem
        }
        
        if let frec = fotoReceita {
            self.fotoReceita = frec
        }
        
        if self.dataValidade.compare(NSDate()) == .OrderedDescending {
            //se data de validade maior que a data de hoje
            self.vencido = 0
        }else if self.dataValidade.compare(dataControle) == .OrderedSame {
            self.vencido = 0
        }else{
            self.vencido = 1
        }
        
        if let idf = idFarmacia {
            self.idFarmacia = idf
        }
        
        if let idc = idCategoria {
            self.idCategoria = idc
        }
        
        if let idl = idLocal {
            self.idLocal = idl
        }
        
        if let idi = idIntervalo {
            self.idIntervalo = idi
        }
    }
}