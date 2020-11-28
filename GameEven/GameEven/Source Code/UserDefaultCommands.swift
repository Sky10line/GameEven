//
//  UserDefaultCommands.swift
//  GameEven
//
//  Created by Jader Rocha on 05/11/20.
//

import Foundation

enum UserDefaultsKeys : String {
    case playerLevel
    case muteMusic
    case muteSound
}

extension UserDefaults{
    
    /// Funções relacionadas ao nível do jogador
    
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
    
    /// Funções relacionadas às opções de áudio
    
    //MARK: Salva a opção de mutada da música.
    func changeMusicOption() {
        if isMusicOption() == true { // Salvar como desligado
            set(false, forKey: UserDefaultsKeys.muteMusic.rawValue)
        } else { // Salvar como ligado
            set(true, forKey: UserDefaultsKeys.muteMusic.rawValue)
        }
    }
    
    //MARK: Retorna se a música esta ligada ou não
    func isMusicOption() -> Bool {
        if string(forKey: UserDefaultsKeys.muteMusic.rawValue) == nil {
            return true
        }
        return bool(forKey: UserDefaultsKeys.muteMusic.rawValue)
    }
    
    //MARK: Salva a opção de mutada do som.
    func changeSoundOption() {
        if isSoundOption() == true { // Salvar como desligado
            set(false, forKey: UserDefaultsKeys.muteSound.rawValue)
        } else { // Salvar como ligado
            set(true, forKey: UserDefaultsKeys.muteSound.rawValue)
        }
    }
    
    //MARK: Retorna se a música esta ligada ou não
    func isSoundOption() -> Bool {
        if string(forKey: UserDefaultsKeys.muteSound.rawValue) == nil {
            return true
        }
        return bool(forKey: UserDefaultsKeys.muteSound.rawValue) // True = Som Ligado
    }
}
