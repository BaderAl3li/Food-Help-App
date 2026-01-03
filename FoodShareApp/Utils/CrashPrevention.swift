import Foundation
import UIKit

class CrashPrevention {
    static let shared = CrashPrevention()
    
    private init() {}
    
    func setupGlobalExceptionHandling() {
        NSSetUncaughtExceptionHandler { exception in
            print("💥 Uncaught Exception: \(exception)")
            print("Stack Trace: \(exception.callStackSymbols)")
        }
        
        signal(SIGABRT) { signal in
            print("💥 SIGABRT received")
        }
        
        signal(SIGILL) { signal in
            print("💥 SIGILL received")
        }
        
        signal(SIGSEGV) { signal in
            print("💥 SIGSEGV received")
        }
        
        signal(SIGFPE) { signal in
            print("💥 SIGFPE received")
        }
        
        signal(SIGBUS) { signal in
            print("💥 SIGBUS received")
        }
    }
    
    func safeExecute<T>(_ operation: () throws -> T, fallback: T, context: String = "") -> T {
        do {
            return try operation()
        } catch {
            print("⚠️ Safe execution failed in \(context): \(error)")
            return fallback
        }
    }
    
    func safeAsyncExecute(_ operation: @escaping () -> Void, context: String = "") {
        DispatchQueue.main.async {
            do {
                operation()
            } catch {
                print("⚠️ Safe async execution failed in \(context): \(error)")
            }
        }
    }
}