import SwiftUI

enum AppTheme: String, CaseIterable, Codable {
    case warmNeutrals = "Warm Neutrals"
    case roseGarden = "Rose Garden"
    case earthyOlive = "Earthy Olive"
    
    var displayName: String {
        return self.rawValue
    }
    
    // Light mode colors
    var lightBackground: Color {
        switch self {
        case .warmNeutrals:
            return Color(red: 0xED/255, green: 0xE9/255, blue: 0xE3/255) // WISHBONE
        case .roseGarden:
            return Color(red: 0xED/255, green: 0xE9/255, blue: 0xE3/255) // IVORY
        case .earthyOlive:
            return Color(red: 0xE2/255, green: 0xDD/255, blue: 0xD7/255) // Light beige
        }
    }
    
    var lightCodeBackground: Color {
        switch self {
        case .warmNeutrals:
            return Color(red: 0xE7/255, green: 0xD7/255, blue: 0xC9/255) // PIE CRUST
        case .roseGarden:
            return Color(red: 0xE7/255, green: 0xD7/255, blue: 0xC9/255) // NUDE
        case .earthyOlive:
            return Color(red: 0xD8/255, green: 0xCE/255, blue: 0xC5/255) // Light beige
        }
    }
    
    var lightLinkColor: Color {
        switch self {
        case .warmNeutrals:
            return Color(red: 0xA3/255, green: 0x8F/255, blue: 0x85/255) // GRAVY
        case .roseGarden:
            return Color(red: 0xD4/255, green: 0xB2/255, blue: 0xA7/255) // DUSTY ROSE
        case .earthyOlive:
            return Color(red: 0xA6/255, green: 0xB3/255, blue: 0x74/255) // Olive green
        }
    }
    
    var lightAccent: Color {
        switch self {
        case .warmNeutrals:
            return Color(red: 0xD4/255, green: 0xB2/255, blue: 0xA7/255) // APPLE PIE
        case .roseGarden:
            return Color(red: 0xA3/255, green: 0x8F/255, blue: 0x85/255) // Warm gray
        case .earthyOlive:
            return Color(red: 0x3A/255, green: 0x2D/255, blue: 0x28/255) // Dark brown
        }
    }
    
    // Dark mode colors (complementary)
    var darkBackground: Color {
        switch self {
        case .warmNeutrals:
            return Color(red: 0x1A/255, green: 0x18/255, blue: 0x16/255) // Very dark warm
        case .roseGarden:
            return Color(red: 0x1A/255, green: 0x18/255, blue: 0x16/255) // Very dark brown
        case .earthyOlive:
            return Color(red: 0x1A/255, green: 0x18/255, blue: 0x16/255) // Very dark brown
        }
    }
    
    var darkCodeBackground: Color {
        switch self {
        case .warmNeutrals:
            return Color(red: 0x2A/255, green: 0x25/255, blue: 0x22/255) // Dark warm
        case .roseGarden:
            return Color(red: 0x2A/255, green: 0x28/255, blue: 0x26/255) // Dark brown
        case .earthyOlive:
            return Color(red: 0x2A/255, green: 0x28/255, blue: 0x26/255) // Dark brown
        }
    }
    
    var darkLinkColor: Color {
        switch self {
        case .warmNeutrals:
            return Color(red: 0xC8/255, green: 0xB8/255, blue: 0xA8/255) // Light warm
        case .roseGarden:
            return Color(red: 0xE5/255, green: 0xC8/255, blue: 0xC0/255) // Light rose
        case .earthyOlive:
            return Color(red: 0xB8/255, green: 0xC8/255, blue: 0x94/255) // Lighter olive
        }
    }
    
    var darkAccent: Color {
        switch self {
        case .warmNeutrals:
            return Color(red: 0xE5/255, green: 0xC8/255, blue: 0xC0/255) // Light peachy
        case .roseGarden:
            return Color(red: 0xC8/255, green: 0xB8/255, blue: 0xA8/255) // Light warm gray
        case .earthyOlive:
            return Color(red: 0xD8/255, green: 0xCE/255, blue: 0xC5/255) // Light beige
        }
    }
    
    // Preview color swatches for settings UI
    var previewColors: [Color] {
        return [lightBackground, lightCodeBackground, lightLinkColor, lightAccent]
    }
}
