//
//  UserDefaultCommands.swift
//  GameEven
//
//  Created by Jader Rocha on 05/11/20.
//

import Foundation

enum UserDefaultsKeys : String {
    case playerLevel
}

extension UserDefaults{

    //MARK: Salvar número da fase
    func savePlayerLevel(playerLevel: Int) {
        set(Int8(playerLevel), forKey: UserDefaultsKeys.playerLevel.rawValue)
    }

    //MARK: Carregar número da fase
    func loadPlayerLevel()-> Int {
        return integer(forKey: UserDefaultsKeys.playerLevel.rawValue)
    }
    
    //MARK: Resetar progresso de fases para 0
    func resetPlayerLevel() {
        set(Int8(0), forKey: UserDefaultsKeys.playerLevel.rawValue)
    }
}
