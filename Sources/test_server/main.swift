import SwiftyGPIO
import SG90Servo
import Swifter
import Dispatch
import Foundation

class Test: Codable {
 let result: String = "success"
}

print("Hello, world!")

let server = HttpServer()
server["/hello"] = { .ok(.html("You asked for \($0)"))  }
server.POST["/flames"] = { r in
  print("FLAMES OF DOOM!!!")
  return .accepted
}
server["test"] = { r in
  print("You hit /test")
  return .ok(.text("Done"))
}

let pwms = SwiftyGPIO.hardwarePWMs(for:.RaspberryPi2)!
let pwm = (pwms[0]?[.P18])!

let s1 = SG90Servo(pwm)
s1.enable()
s1.move(to: .left)
sleep(1)
s1.move(to: .middle)
sleep(1)
s1.move(to: .right)
sleep(1)

s1.disable()

let semaphore = DispatchSemaphore(value: 0)
do {
  try server.start()
  print("Server has started ( port = \(try server.port()) ). Try to connect now...")
  semaphore.wait()
} catch {
  print("Server start error: \(error)")
  semaphore.signal()
}

