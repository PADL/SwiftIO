/**
 Use the DigitalIn class to red the value of a digital input pin.
 
 ### Example: A simple hello world.
 
 ````
 import SwiftIO
 
 func main() {
    //Initialize a DigitalIn to DigitalId.D0
    let pin = DigitalIn(.D0)
 
    //Read and print the input value every 1 second
    while true {
        var value = pin.read()
        print("The input value is \(value)")
        sleep(1000)
    }
 }
 ````
 */
public class DigitalIn {
		
    var obj: DigitalIOObject

    private let id: Id
    private var mode: Mode {
        willSet {
            obj.inputMode = newValue.rawValue
        }
    }
    private var callback: (()->Void)?
    private var callbackMode: CallbackMode {
        willSet {
            obj.callbackMode = newValue.rawValue
        }
    }
    private var callbackState: CallbackState {
        willSet {
            obj.callbackState = newValue.rawValue
        }
    }
    

    /**
     Use this property to get the input value.
     
     - Attention: This property is **read only!**
     */
	public var value: Bool {
		return swiftHal_gpioRead(&obj) == 1 ? true : false
	}

    private func objectInit() {
        obj.id = id.rawValue
        obj.direction = Direction.input.rawValue
        obj.inputMode = mode.rawValue
        obj.callbackMode = callbackMode.rawValue
        obj.callbackState = callbackState.rawValue
        swiftHal_gpioInit(&obj)
    }

    /**
     Initialize a DigitalIn to a specified pin.
     
     - parameter id: The Digital id on the board.
     - parameter mode: The input mode.
     
     This text is above the horizontal rule.
     - - -
     And this is below.
     
     For more information, see [The Swift Programming Language.](http://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/)
     
     - SeeAlso:
     [The Swift Standard Library Reference](https://developer.apple.com/library/prerelease/ios//documentation/General/Reference/SwiftStandardLibraryReference/index.html)
     
     ### Usage Example: ###
     ````
     let pin = DigitalIn(.D0, mode: .pullDown)
     ````
     */
	public init(_ id: Id,
                mode: Mode = .pullDown) {
        self.id = id
        self.mode = mode
        self.callbackMode = .rising
        self.callbackState = .disable
        obj = DigitalIOObject()
        objectInit()
	}

    deinit {
        if callbackState == .enable {
            removeCallback()
        }
        swiftHal_gpioDeinit(&obj)
    }

    public func getMode() -> Mode {
        return mode
    }

    /**
     Set the input mode for a digital pin.
     
     - Parameter mode : The input mode.
     */
	public func setMode(_ mode: Mode) {
		self.mode = mode
		swiftHal_gpioConfig(&obj)
	}


    /**
     Read the value on a digital pin.
     
     - Attention: Depends on the hardware, the internal pull resister may be very weak. **Don't** just rely on the pull resister for reading the value. **Especially** when you just changed the input mode, the internel pad need some time to charge or discharge through the pull resister!
     
     - Returns: `true` or `false` of the logic value.
     */
	public func read() -> Bool {
		return value
	}

    /**
     Add a callback function to a pin.
    
     
     - Returns: 0 or 1 of the logic value.
     */    
    public func on(_ mode: CallbackMode, callback: @escaping ()->Void) {
        callbackMode = mode
        callbackState = .enable
        self.callback = callback
        swiftHal_gpioAddSwiftMember(&obj, getClassPtr(self)) {(ptr)->Void in
            let mySelf = Unmanaged<DigitalIn>.fromOpaque(ptr!).takeUnretainedValue()
            mySelf.callback!()
        }
        swiftHal_gpioAddCallback(&obj)
    }

    public func removeCallback() {
        callbackState = .disable
        swiftHal_gpioRemoveCallback(&obj)
    }

}




extension DigitalIn {
    
    public typealias Id = DigitalOut.Id
    
    public typealias Direction = DigitalOut.Direction
    

    public enum Mode: UInt8 {
        case pullDown = 1, pullUp, pullNone
    }

    public enum CallbackMode: UInt8 {
        case rising = 1, falling, bothEdge
    }

    public enum CallbackState: UInt8 {
        case disable, enable
    }
}