//
//  FontSettings.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 21.11.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//
// swiftlint:disable file_length

import Foundation

/// You can change font list according to list below.
extension Typography: FontSettings {
    
    internal var adminFont: String {
        switch self {
            
        case .navBarTitle(_):   return "Poppins-SemiBold"
            
        case .boldTitle(_):     return "Poppins-Bold"
            
        case .semiBoldTitle(_): return "Poppins-SemiBold"
            
        case .mediumTitle(_):   return "Poppins-Medium"
            
        case .regularText(_):   return "Poppins-Regular"
            
        case .lightText(_):     return "Poppins-Light"
            
        case .buttonTitle(_):   return "Poppins-SemiBold"
            
        }
    }
    
}

// MARK: - Custom Fonts
/*
 Poppins-Light
 Poppins-Regular
 Poppins-Medium
 Poppins-SemiBold
 Poppins-Bold
 */

// MARK: - System Font List
/*
 *** Al Nile ***
 AlNile
 AlNile-Bold
 ---------------------
 *** American Typewriter ***
 AmericanTypewriter
 AmericanTypewriter-Bold
 AmericanTypewriter-Condensed
 AmericanTypewriter-CondensedBold
 AmericanTypewriter-CondensedLight
 AmericanTypewriter-Light
 AmericanTypewriter-Semibold
 ---------------------
 *** Apple Color Emoji ***
 AppleColorEmoji
 ---------------------
 *** Apple SD Gothic Neo ***
 AppleSDGothicNeo-Bold
 AppleSDGothicNeo-Light
 AppleSDGothicNeo-Medium
 AppleSDGothicNeo-Regular
 AppleSDGothicNeo-SemiBold
 AppleSDGothicNeo-Thin
 AppleSDGothicNeo-UltraLight
 ---------------------
 *** Arial ***
 Arial-BoldItalicMT
 Arial-BoldMT
 Arial-ItalicMT
 ArialMT
 ---------------------
 *** Arial Hebrew ***
 ArialHebrew
 ArialHebrew-Bold
 ArialHebrew-Light
 ---------------------
 *** Arial Rounded MT Bold ***
 ArialRoundedMTBold
 ---------------------
 *** Avenir ***
 Avenir-Black
 Avenir-BlackOblique
 Avenir-Book
 Avenir-BookOblique
 Avenir-Heavy
 Avenir-HeavyOblique
 Avenir-Light
 Avenir-LightOblique
 Avenir-Medium
 Avenir-MediumOblique
 Avenir-Oblique
 Avenir-Roman
 ---------------------
 *** Avenir Next ***
 AvenirNext-Bold
 AvenirNext-BoldItalic
 AvenirNext-DemiBold
 AvenirNext-DemiBoldItalic
 AvenirNext-Heavy
 AvenirNext-HeavyItalic
 AvenirNext-Italic
 AvenirNext-Medium
 AvenirNext-MediumItalic
 AvenirNext-Regular
 AvenirNext-UltraLight
 AvenirNext-UltraLightItalic
 ---------------------
 *** Avenir Next Condensed ***
 AvenirNextCondensed-Bold
 AvenirNextCondensed-BoldItalic
 AvenirNextCondensed-DemiBold
 AvenirNextCondensed-DemiBoldItalic
 AvenirNextCondensed-Heavy
 AvenirNextCondensed-HeavyItalic
 AvenirNextCondensed-Italic
 AvenirNextCondensed-Medium
 AvenirNextCondensed-MediumItalic
 AvenirNextCondensed-Regular
 AvenirNextCondensed-UltraLight
 AvenirNextCondensed-UltraLightItalic
 ---------------------
 *** Bangla Sangam MN ***
 ---------------------
 *** Baskerville ***
 Baskerville
 Baskerville-Bold
 Baskerville-BoldItalic
 Baskerville-Italic
 Baskerville-SemiBold
 Baskerville-SemiBoldItalic
 ---------------------
 *** Bodoni 72 ***
 BodoniSvtyTwoITCTT-Bold
 BodoniSvtyTwoITCTT-Book
 BodoniSvtyTwoITCTT-BookIta
 ---------------------
 *** Bodoni 72 Oldstyle ***
 BodoniSvtyTwoOSITCTT-Bold
 BodoniSvtyTwoOSITCTT-Book
 BodoniSvtyTwoOSITCTT-BookIt
 ---------------------
 *** Bodoni 72 Smallcaps ***
 BodoniSvtyTwoSCITCTT-Book
 ---------------------
 *** Bodoni Ornaments ***
 BodoniOrnamentsITCTT
 ---------------------
 *** Bradley Hand ***
 BradleyHandITCTT-Bold
 ---------------------
 *** Chalkboard SE ***
 ChalkboardSE-Bold
 ChalkboardSE-Light
 ChalkboardSE-Regular
 ---------------------
 *** Chalkduster ***
 Chalkduster
 ---------------------
 *** Charter ***
 Charter-Black
 Charter-BlackItalic
 Charter-Bold
 Charter-BoldItalic
 Charter-Italic
 Charter-Roman
 ---------------------
 *** Cochin ***
 Cochin
 Cochin-Bold
 Cochin-BoldItalic
 Cochin-Italic
 ---------------------
 *** Copperplate ***
 Copperplate
 Copperplate-Bold
 Copperplate-Light
 ---------------------
 *** Courier ***
 Courier
 Courier-Bold
 Courier-BoldOblique
 Courier-Oblique
 ---------------------
 *** Courier New ***
 CourierNewPS-BoldItalicMT
 CourierNewPS-BoldMT
 CourierNewPS-ItalicMT
 CourierNewPSMT
 ---------------------
 *** DIN Alternate ***
 DINAlternate-Bold
 ---------------------
 *** DIN Condensed ***
 DINCondensed-Bold
 ---------------------
 *** Damascus ***
 Damascus
 DamascusBold
 DamascusLight
 DamascusMedium
 DamascusSemiBold
 ---------------------
 *** Devanagari Sangam MN ***
 DevanagariSangamMN
 DevanagariSangamMN-Bold
 ---------------------
 *** Didot ***
 Didot
 Didot-Bold
 Didot-Italic
 ---------------------
 *** Euphemia UCAS ***
 EuphemiaUCAS
 EuphemiaUCAS-Bold
 EuphemiaUCAS-Italic
 ---------------------
 *** Farah ***
 Farah
 ---------------------
 *** Futura ***
 Futura-Bold
 Futura-CondensedExtraBold
 Futura-CondensedMedium
 Futura-Medium
 Futura-MediumItalic
 ---------------------
 *** Geeza Pro ***
 GeezaPro
 GeezaPro-Bold
 ---------------------
 *** Georgia ***
 Georgia
 Georgia-Bold
 Georgia-BoldItalic
 Georgia-Italic
 ---------------------
 *** Gill Sans ***
 GillSans
 GillSans-Bold
 GillSans-BoldItalic
 GillSans-Italic
 GillSans-Light
 GillSans-LightItalic
 GillSans-SemiBold
 GillSans-SemiBoldItalic
 GillSans-UltraBold
 ---------------------
 *** Gujarati Sangam MN ***
 GujaratiSangamMN
 GujaratiSangamMN-Bold
 ---------------------
 *** Gurmukhi MN ***
 GurmukhiMN
 GurmukhiMN-Bold
 ---------------------
 *** Heiti SC ***
 ---------------------
 *** Heiti TC ***
 ---------------------
 *** Helvetica ***
 Helvetica
 Helvetica-Bold
 Helvetica-BoldOblique
 Helvetica-Light
 Helvetica-LightOblique
 Helvetica-Oblique
 ---------------------
 *** Helvetica Neue ***
 HelveticaNeue
 HelveticaNeue-Bold
 HelveticaNeue-BoldItalic
 HelveticaNeue-CondensedBlack
 HelveticaNeue-CondensedBold
 HelveticaNeue-Italic
 HelveticaNeue-Light
 HelveticaNeue-LightItalic
 HelveticaNeue-Medium
 HelveticaNeue-MediumItalic
 HelveticaNeue-Thin
 HelveticaNeue-ThinItalic
 HelveticaNeue-UltraLight
 HelveticaNeue-UltraLightItalic
 ---------------------
 *** Hiragino Maru Gothic ProN ***
 HiraMaruProN-W4
 ---------------------
 *** Hiragino Mincho ProN ***
 HiraMinProN-W3
 HiraMinProN-W6
 ---------------------
 *** Hiragino Sans ***
 HiraginoSans-W3
 HiraginoSans-W6
 ---------------------
 *** Hoefler Text ***
 HoeflerText-Black
 HoeflerText-BlackItalic
 HoeflerText-Italic
 HoeflerText-Regular
 ---------------------
 *** Kailasa ***
 Kailasa
 Kailasa-Bold
 ---------------------
 *** Kannada Sangam MN ***
 KannadaSangamMN
 KannadaSangamMN-Bold
 ---------------------
 *** Kefa ***
 Kefa-Regular
 ---------------------
 *** Khmer Sangam MN ***
 KhmerSangamMN
 ---------------------
 *** Kohinoor Bangla ***
 KohinoorBangla-Light
 KohinoorBangla-Regular
 KohinoorBangla-Semibold
 ---------------------
 *** Kohinoor Devanagari ***
 KohinoorDevanagari-Light
 KohinoorDevanagari-Regular
 KohinoorDevanagari-Semibold
 ---------------------
 *** Kohinoor Telugu ***
 KohinoorTelugu-Light
 KohinoorTelugu-Medium
 KohinoorTelugu-Regular
 ---------------------
 *** Lao Sangam MN ***
 LaoSangamMN
 ---------------------
 *** Malayalam Sangam MN ***
 MalayalamSangamMN
 MalayalamSangamMN-Bold
 ---------------------
 *** Marker Felt ***
 MarkerFelt-Thin
 MarkerFelt-Wide
 ---------------------
 *** Menlo ***
 Menlo-Bold
 Menlo-BoldItalic
 Menlo-Italic
 Menlo-Regular
 ---------------------
 *** Mishafi ***
 DiwanMishafi
 ---------------------
 *** Myanmar Sangam MN ***
 MyanmarSangamMN
 MyanmarSangamMN-Bold
 ---------------------
 *** Noteworthy ***
 Noteworthy-Bold
 Noteworthy-Light
 ---------------------
 *** Noto Nastaliq Urdu ***
 NotoNastaliqUrdu
 ---------------------
 *** Noto Sans Chakma ***
 NotoSansChakma-Regular
 ---------------------
 *** Optima ***
 Optima-Bold
 Optima-BoldItalic
 Optima-ExtraBlack
 Optima-Italic
 Optima-Regular
 ---------------------
 *** Oriya Sangam MN ***
 OriyaSangamMN
 OriyaSangamMN-Bold
 ---------------------
 *** Palatino ***
 Palatino-Bold
 Palatino-BoldItalic
 Palatino-Italic
 Palatino-Roman
 ---------------------
 *** Papyrus ***
 Papyrus
 Papyrus-Condensed
 ---------------------
 *** Party LET ***
 PartyLetPlain
 ---------------------
 *** PingFang HK ***
 PingFangHK-Light
 PingFangHK-Medium
 PingFangHK-Regular
 PingFangHK-Semibold
 PingFangHK-Thin
 PingFangHK-Ultralight
 ---------------------
 *** PingFang SC ***
 PingFangSC-Light
 PingFangSC-Medium
 PingFangSC-Regular
 PingFangSC-Semibold
 PingFangSC-Thin
 PingFangSC-Ultralight
 ---------------------
 *** PingFang TC ***
 PingFangTC-Light
 PingFangTC-Medium
 PingFangTC-Regular
 PingFangTC-Semibold
 PingFangTC-Thin
 PingFangTC-Ultralight
 ---------------------
 *** Rockwell ***
 Rockwell-Bold
 Rockwell-BoldItalic
 Rockwell-Italic
 Rockwell-Regular
 ---------------------
 *** Savoye LET ***
 SavoyeLetPlain
 ---------------------
 *** Sinhala Sangam MN ***
 SinhalaSangamMN
 SinhalaSangamMN-Bold
 ---------------------
 *** Snell Roundhand ***
 SnellRoundhand
 SnellRoundhand-Black
 SnellRoundhand-Bold
 ---------------------
 *** Symbol ***
 Symbol
 ---------------------
 *** Tamil Sangam MN ***
 TamilSangamMN
 TamilSangamMN-Bold
 ---------------------
 *** Telugu Sangam MN ***
 ---------------------
 *** Thonburi ***
 Thonburi
 Thonburi-Bold
 Thonburi-Light
 ---------------------
 *** Times New Roman ***
 TimesNewRomanPS-BoldItalicMT
 TimesNewRomanPS-BoldMT
 TimesNewRomanPS-ItalicMT
 TimesNewRomanPSMT
 ---------------------
 *** Trebuchet MS ***
 Trebuchet-BoldItalic
 TrebuchetMS
 TrebuchetMS-Bold
 TrebuchetMS-Italic
 ---------------------
 *** Verdana ***
 Verdana
 Verdana-Bold
 Verdana-BoldItalic
 Verdana-Italic
 ---------------------
 *** Zapf Dingbats ***
 ZapfDingbatsITC
 ---------------------
 *** Zapfino ***
 Zapfino
 ---------------------
*/
