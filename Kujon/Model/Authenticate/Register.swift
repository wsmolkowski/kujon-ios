import Foundation

//"email": "dzi@gmail.com",
//"password": "asdasdasd",
//"device_type": "IOS",
//"device_id": "123"
//}

class Register {
    private static let EMAIL_KEY = "email"
    private static let PASSWORD_KEY = "password"
    private static let DEVICE_TYPE_KEY = "device_type"
    private static let DEVICE_ID_KEY = "device_id"
    static func createRegisterJSON(email: String, password: String) -> NSData {
        return [EMAIL_KEY : email , PASSWORD_KEY : password, DEVICE_TYPE_KEY : "IOS", DEVICE_ID_KEY : "123"]
    }
}
