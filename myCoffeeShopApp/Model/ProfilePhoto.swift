import CoreData

@objc(ProfilePhoto)
public class ProfilePhoto: NSManagedObject {}

extension ProfilePhoto {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfilePhoto> {
        return NSFetchRequest<ProfilePhoto>(entityName: "ProfilePhoto")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var imageData: Data?
}
