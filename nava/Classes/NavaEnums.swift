//
//  NavaEnums.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 11/9/16.
//  Copyright © 2016 manshor. All rights reserved.
//
class NavaEnums
{
    enum SearchType : String
    {
        case categories, typesearchlist, imamlist, madahlist ,None
        
        static func GetFromString(typeString : String) -> SearchType {
            switch typeString {
            case SearchType.categories.rawValue:
                return .categories
            case SearchType.typesearchlist.rawValue:
                return .typesearchlist
            case SearchType.imamlist.rawValue:
                return .imamlist
            case SearchType.madahlist.rawValue:
                return .madahlist
            default:
                return NavaEnums.SearchType(rawValue: "")!
            }
        }

    }
    
    enum ServiceType: String
    {
        case shahadat, moharam, eid
        
        static func GetFromString(typeString : String) -> ServiceType {
            switch typeString {
            case ServiceType.shahadat.rawValue:
                return .shahadat
            case ServiceType.eid.rawValue:
                return .eid
            case ServiceType.moharam.rawValue:
                return .moharam
            default:
                return NavaEnums.ServiceType(rawValue: "")!
            }
        }
    }
    
    enum ServiceMediaType: String
    {
        case all, sound, video
        
        static func GetFromString(typeString : String) -> ServiceMediaType {
            switch typeString {
            case ServiceMediaType.sound.rawValue:
                return .sound
            case ServiceMediaType.video.rawValue:
                return .video
                case "music":
                return .sound
            default:
                return ServiceMediaType.all
                
            }
        }
    }
}
