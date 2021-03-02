//
//  LocalizedOjbect+CoreDataClass.swift
//  AlbionAssistant (iOS)
//
//  Created by Yaroslav Ark on 02.02.2021.
//
//

import Foundation
import CoreData

enum LocalisationLenguage:String {
    case en = "EN-US"
    case de = "DE-DE"
    case fr = "FR-FR"
    case ru = "RU-RU"
    case pl = "PL-PL"
    case es = "ES-ES"
    case pt = "PT-BR"
    case zh = "ZH-CN"
    case ko = "KO-KR"
}

@objc(LocalizedOjbect)
public class LocalizedOjbect: NSManagedObject {

}
