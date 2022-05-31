//
//  GameModel.swift
//
//


import UIKit
import SwiftyJSON

enum TurnType: String {
    case cross = "X"
    case zero = "0"
}


class SavedGameData {
    var winCountA: Int
    var winCountB: Int
    var currentGame: [GameModel]
    var isCurrentTurnA: Bool
    
    init(_ json: JSON = JSON()) {
        winCountA = json["winCountA"].intValue
        winCountB = json["winCountB"].intValue
        currentGame = json["currentGame"].arrayValue.map({GameModel($0)})
        isCurrentTurnA = json["isCurrentTurnA"].boolValue
    }

    func getDict() -> [String: Any] {
        return ["winCountA": winCountA,
                "winCountB": winCountB,
                "currentGame": currentGame.map({$0.getDict()}),
                "isCurrentTurnA": isCurrentTurnA]
    }
}

class GameModel {
    var index: Int = 0
    var value: TurnType?
    
    init(_ json: JSON = JSON()) {
        index = json["index"].intValue
        value = TurnType(rawValue: json["value"].stringValue)
    }
    
    func getDict() -> [String: Any] {
        return ["index": index, "value": value?.rawValue ?? ""]
    }
    
}


enum ApplicationUserDefaults {
    
    enum Key: String {
        case gameData
    }
    
    static func value(forKey key: Key) -> JSON {
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            return JSON.null
        }
        return JSON(value)
    }
    static func save(value: Any, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    static func removeValue(forKey key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    static func removeAllValues() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
        }
    }
}
