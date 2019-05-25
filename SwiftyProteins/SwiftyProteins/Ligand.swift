//
//  Ligand.swift
//  SwiftyProteins
//
//  Created by Nazar NAUMENKO on 5/17/19.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import Foundation

//Optional("<?xml version=\'1.0\' standalone=\'no\' ?>\n<describeHet>\n  <ligandInfo>\n    <ligand chemicalID=\"04G\" type=\"non-polymer\" molecularWeight=\"213.189\">\n      <chemicalName>7-hydroxy-3H-phenoxazin-3-one</chemicalName>\n      <formula>C12 H7 N O3</formula>\n      <InChIKey>HSSLDCABUXLXKM-UHFFFAOYSA-N</InChIKey>\n      <InChI>InChI=1S/C12H7NO3/c14-7-1-3-9-11(5-7)16-12-6-8(15)2-4-10(12)13-9/h1-6,14H</InChI>\n      <smiles>c1cc2c(cc1O)OC3=CC(=O)C=CC3=N2</smiles>\n    </ligand>\n  </ligandInfo>\n</describeHet>\n")


struct Ligand : Codable {
    var chemicalID: String
    var molecularWeight: Double
}
