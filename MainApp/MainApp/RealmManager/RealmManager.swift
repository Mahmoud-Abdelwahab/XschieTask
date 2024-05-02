//
//  RealmManager.swift
//  List
//
//  Created by Mahmoud Abdelwahab on 02/05/2024.
//
//
import RealmSwift
import UniversityList

public class RealmManager {
    public static let shared = RealmManager()
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
}

extension RealmManager: UniversityCachingProtocol {
    
    public func saveUniversitiesToRealmDB(_ universities: [UniversityCellVM]) throws {
        do {
            try realm.write {
                realm.deleteAll()
                for university in universities {
                    let universityObject = UniversityObject()
                    universityObject.name = university.name
                    universityObject.stateProvince = university.stateProvince
                    universityObject.webPage = university.webPage
                    universityObject.alphaTwoCode = university.countryCode
                    universityObject.country = university.country
                    realm.add(universityObject)
                }
            }
        } catch {
            throw error
        }
    }
    
    public func fetchUniversitiesFromRealmDB() -> [UniversityCellVM]? {
        let universityObjects = realm.objects(UniversityObject.self)
        let universityObjectsArray = Array(universityObjects)
        return universityObjectsArray.map { universityObject in
            universityObject.toUniversityCellVM()
        }
    }
    
    func fetchUniversitiesFromRealm() -> [UniversityObject]? {
        let universityObjects = realm.objects(UniversityObject.self)
        return Array(universityObjects)
    }
}
