import SwiftyGPIO
import Swifter
import Dispatch
import Foundation

class Test: Codable {
 let result: String = "success"
}

print("Hello, world!")

let pwms = SwiftyGPIO.hardwarePWMs(for:.RaspberryPi2)!
let pwm = (pwms[0]?[.P18])!

let server = HttpServer()
server["/hello"] = { .ok(.html("You asked for \($0)"))  }
server.POST["/flames"] = { r in
  print("FLAMES OF DOOM!!!")

  let s1 = SG90Servo(pwm)
  s1.enable()
//  s1.move(to: .left)
//  sleep(2)
  s1.move(to: .middle)
  sleep(2)
  s1.move(to: .right)
  sleep(2)
  s1.move(to: .middle)
  sleep(2)

  s1.disable()
  
  return .accepted
}

server["test"] = { r in
  print("You hit /test")
  return .ok(.text("Done"))
}



let semaphore = DispatchSemaphore(value: 0)
do {
  try server.start()
  print("Server has started ( port = \(try server.port()) ). Try to connect now...")
  semaphore.wait()
} catch {
  print("Server start error: \(error)")
  semaphore.signal()
}

