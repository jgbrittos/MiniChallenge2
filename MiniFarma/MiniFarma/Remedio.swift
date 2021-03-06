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
    var dataValidade = Date()
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
    var notas: String = ""
    
    var temInformacoesNulas: Bool = false
    
    var dataEmString: String {
        let f = DateFormatter()
        if Locale.current.identifier == "pt_BR" {
            f.dateFormat = "dd/MM/y"
        }else{
            f.dateFormat = "MM/dd/y"
        }
        return f.string(from: self.dataValidade)
    }
    
    var fotoRemedioUIImage: UIImage? {
        if self.fotoRemedio == "sem foto"{
            return UIImage(named: "semFoto")
        }
        let caminhos = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentos: String = caminhos[0] 
        let caminhoCompleto = documentos + "/" + self.fotoRemedio
        return UIImage(contentsOfFile: caminhoCompleto)
    }
    
    var fotoReceitaUIImage: UIImage? {
        if self.fotoReceita == "sem foto"{
            return UIImage(named: "semFoto")!
        }
        let caminhos = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentos: String = caminhos[0] 
        let caminhoCompleto = documentos + self.fotoReceita
        return UIImage(contentsOfFile: caminhoCompleto)
    }
    
    override init() {}
    
    //Remedio do banco
    init(idRemedio:Int?, nomeRemedio:String?, dataValidade:Date?, numeroQuantidade: Int?,
        unidade:Int?, preco:Double?, numeroDose:Int?, fotoRemedio:String?,
        fotoReceita:String?,vencido:Int?,idFarmacia:Int?, idCategoria:Int?, idLocal:Int?,idIntervalo:Int?, notas:String?){
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
        
        if let nota = notas {
            self.notas = nota
        }
    }
    
    //Remedio criado
    init(nomeRemedio:String?, dataValidade:Date?, numeroQuantidade: Int?,
        unidade:Int?, preco:Double?, numeroDose:Int?,fotoRemedio:String?,fotoReceita:String?,
        idFarmacia:Int?, idCategoria:Int?, idLocal:Int?,idIntervalo:Int?, notas: String?){
        
        let formatador = DateFormatter()
        
        if Locale.current.identifier == "pt_BR" {
            formatador.dateFormat = "dd/MM/y"
        }else{
            formatador.dateFormat = "MM/dd/y"
        }

        let dataControle = formatador.date(from: "01/01/1900")!
            
        if let n = nomeRemedio {
            self.nomeRemedio = n
        }
            
        if let d = dataValidade {
            self.dataValidade = d
        }else{
            self.dataValidade = dataControle
            self.temInformacoesNulas = true
        }
        
        if let nq = numeroQuantidade {
            self.numeroQuantidade = nq
        }else{
            self.temInformacoesNulas = true
        }

        if let u = unidade {
            self.unidade = u
        }else{
            self.temInformacoesNulas = true
        }
        
        if let p = preco {
            self.preco = p
        }else{
            self.temInformacoesNulas = true
        }
        
        if let nd = numeroDose {
            self.numeroDose = nd
        }else{
            self.temInformacoesNulas = true
        }
        
        if let frem = fotoRemedio {
            self.fotoRemedio = frem
            if frem == "sem foto" {
                self.temInformacoesNulas = true
            }
        }
        
        if let frec = fotoReceita {
            self.fotoReceita = frec
            if frec == "sem foto" {
                self.temInformacoesNulas = true
            }
        }
        
        if self.dataValidade.compare(Date()) == .orderedDescending {
            //se data de validade maior que a data de hoje
            self.vencido = 0
        }else if self.dataValidade.compare(dataControle) == .orderedSame {
            self.vencido = 0
        }else{
            self.vencido = 1
        }
        
        if let idf = idFarmacia {
            self.idFarmacia = idf
            if idf == 0 {
                self.temInformacoesNulas = true
            }
        }
        
        if let idc = idCategoria {
            self.idCategoria = idc
            if idc == 0 {
                self.temInformacoesNulas = true
            }
        }
        
        if let idl = idLocal {
            self.idLocal = idl
            if idl == 0 {
                self.temInformacoesNulas = true
            }
        }
        
        if let idi = idIntervalo {
            self.idIntervalo = idi
            if idi == 0 {
                self.temInformacoesNulas = true
            }
        }
            
        if let nota = notas {
            self.notas = nota
        }
    }
}
