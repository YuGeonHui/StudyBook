//
//  UserCoreData.swift
//  StudyBook
//
//  Created by geonhui Yu on 10/31/24.
//

import Foundation
import CoreData

public protocol UserCoreDataProtocol {
    func getFavoriteUser() -> Result<[UserListItem], CoreDataError>
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
}

public struct UserCoreData: UserCoreDataProtocol {
    private let viewContext: NSManagedObjectContext
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    public func getFavoriteUser() -> Result<[UserListItem], CoreDataError> {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        do {
            let result = try viewContext.fetch(fetchRequest)
            let userList: [UserListItem] = result.compactMap {
                guard let login = $0.login, let imageURL = $0.imageURL else { return nil }
                return UserListItem(id: Int($0.id), login: login, imageURL: imageURL)
            }
            return .success(userList)
        } catch {
            return .failure(.readError(error.localizedDescription))
        }
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteUser", in: viewContext) else {
            return .failure(.entityNotFound("FavoriteUser"))
        }
        let userObject = NSManagedObject(entity: entity, insertInto: viewContext)
        userObject.setValue(user.id, forKey: "id")
        userObject.setValue(user.login, forKey: "login")
        userObject.setValue(user.imageURL, forKey: "imageURL")
        
        do {
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.saveError(error.localizedDescription))
        }
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", userID)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            result.forEach {
                viewContext.delete($0)
            }
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.deleteError(error.localizedDescription))
        }
    }
}
