//
//  Favourites.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 26.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

class Favourites {
    
    var music, dish, song, hobby, city: String
    var sport, book, movie, colour, tvChoice: String
    
    init(from dict: JSON) {
        self.music = dict["music"] as? String ?? ""
        self.dish = dict["dish"] as? String ?? ""
        self.song = dict["song"] as? String ?? ""
        self.hobby = dict["hobby"] as? String ?? ""
        self.city = dict["city"] as? String ?? ""
        self.sport = dict["sport"] as? String ?? ""
        self.book = dict["book"] as? String ?? ""
        self.movie = dict["movie"] as? String ?? ""
        self.colour = dict["colour"] as? String ?? ""
        self.tvChoice = dict["tv"] as? String ?? ""
    }
}

extension Favourites: CustomStringConvertible {
    
    var description: String {
        var text = ""
        
        text += getText(before: " - Music: ", favorite: music, after: " ")
        text += getText(before: " - Dish: ", favorite: dish, after: " ")
        text += getText(before: " - Song: ", favorite: song, after: " ")
        text += getText(before: " - Hobby: ", favorite: hobby, after: " ")
        text += getText(before: " - City: ", favorite: city, after: " ")
        text += getText(before: " - Sport: ", favorite: sport, after: " ")
        text += getText(before: " - Book: ", favorite: book, after: " ")
        text += getText(before: " - Movie: ", favorite: movie, after: " ")
        text += getText(before: " - Color: ", favorite: colour, after: " ")
        text += getText(before: " - TV Show:: ", favorite: tvChoice, after: " ")

        return text
    }
    
    private func getText(before: String, favorite: String, after: String) -> String {
        let favoriteText = favorite.htmlAttributedString ?? ""
        
        return favoriteText.isEmpty
        ? ""
        : "\(before)\(favoriteText)\(after)"
    }
}
