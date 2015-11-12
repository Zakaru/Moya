import Foundation
import ReactiveCocoa

/// Extension for processing raw NSData generated by network access.
public extension RACSignal {
    
    /// Filters out responses that don't fall within the given range, generating errors when others are encountered.
    public func filterStatusCodes(range: ClosedInterval<Int>) -> RACSignal {
        return tryMap { object, error in
            do {
                return try cast(object).filterStatusCodes(range)
            } catch (let mapError) {
                error.memory = mapError as NSError
                return nil
            }
        }
    }

    public func filterStatusCode(code: Int) -> RACSignal {
        return filterStatusCodes(code...code)
    }

    public func filterSuccessfulStatusCodes() -> RACSignal {
        return filterStatusCodes(200...299)
    }
    
    public func filterSuccessfulStatusAndRedirectCodes() -> RACSignal {
        return filterStatusCodes(200...399)
    }
    
    /// Maps data received from the signal into an Image. If the conversion fails, the signal errors.
    public func mapImage() -> RACSignal {
        return tryMap { object, error in
            do {
                return try cast(object).mapImage()
            } catch (let mapError) {
                error.memory = mapError as NSError
                return nil
            }
        }
    }
    
    /// Maps data received from the signal into a JSON object. If the conversion fails, the signal errors.
    public func mapJSON() -> RACSignal {
        return tryMap { object, error in
            do {
                return try cast(object).mapJSON()
            } catch (let mapError) {
                error.memory = mapError as NSError
                return nil
            }
        }
    }
    
    /// Maps data received from the signal into a String. If the conversion fails, the signal errors.
    public func mapString() -> RACSignal {
        return tryMap { object, error in
            do {
                return try cast(object).mapString()
            } catch (let mapError) {
                error.memory = mapError as NSError
                return nil
            }
        }
    }
}

/// Trys to cast object to the expected MoyaResponse
private func cast(object: AnyObject) throws -> MoyaResponse {
    guard let response = object as? MoyaResponse else {
        throw NSError(domain: RACSignalErrorDomain, code: RACSignalErrorNoMatchingCase, userInfo: ["cast_error" : "tried to cast \(object) to MoyaResponse"])
    }
    return response
}