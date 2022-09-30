//
//  ViewController.swift
//  FaceCap
//

import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var snapshotButton: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    
    @IBAction func snapshotbuttonhandler(sender: UIButton) {
        recordingData = true
        recordSnapshot = true
    }
    
    @IBAction func recordbuttonhandler(sender: UIButton) {
        if (recordButton.titleLabel?.text == "Start Record") {
            recordingData = true
            recordButton.setTitle("End Record", for: .normal)
        } else if (recordButton.titleLabel?.text == "End Record") {
            recordingData = false
            recordButton.setTitle("Start Record", for: .normal)
            
            saveData()
        } else {
            fatalError("Something went wrong.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard ARFaceTrackingConfiguration.isSupported else {
          fatalError("Face tracking is not supported on this device")
        }
        
         sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
            
      // 1
      let configuration = ARFaceTrackingConfiguration()
            
      // 2
      sceneView.session.run(configuration)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
            
      // 1
      sceneView.session.pause()
    }
    
}

var count = 0
var recordingData = false

var leftBlinkValues = [Float]()
var rightBlinkValues = [Float]()

var eyeLookUpLeftValues = [Float]()
var eyeLookDownLeftValues = [Float]()
var eyeLookOutLeftValues = [Float]()
var eyeLookInLeftValues = [Float]()
var eyeSquintLeftValues = [Float]()

var eyeLookUpRightValues = [Float]()
var eyeLookDownRightValues = [Float]()
var eyeLookOutRightValues = [Float]()
var eyeLookInRightValues = [Float]()
var eyeSquintRightValues = [Float]()

var jawOpenValues = [Float]()
var mouthFunnelValues = [Float]()
var mouthPuckerValues = [Float]()
var mouthSmileLeftValues = [Float]()
var mouthSmileRightValues = [Float]()
var mouthFrownLeftValues = [Float]()
var mouthFrownRightValues = [Float]()
var mouthUpperUpLeftValues = [Float]()
var mouthUpperUpRightValues = [Float]()
var mouthLowerDownLeftValues = [Float]()
var mouthLowerDownRightValues = [Float]()
var mouthPressLeftValues = [Float]()
var mouthPressRightValues = [Float]()
var mouthShrugUpperValues = [Float]()
var mouthShrugLowerValues = [Float]()
var mouthRollUpperValues = [Float]()
var mouthRollLowerValues = [Float]()
var mouthStretchLeftValues = [Float]()
var mouthStretchRightValues = [Float]()
var mouthDimpleLeftValues = [Float]()
var mouthDimpleRightValues = [Float]()
var mouthLeftValues = [Float]()
var mouthRightValues = [Float]()

var recordSnapshot = false

func saveData() {
    let file = "animdata"
    let text = """
    {
        "leftBlinkValues" : \(leftBlinkValues),
        "rightBlinkValues" : \(rightBlinkValues),
    
        "eyeSquintLeftValues" : \(eyeSquintLeftValues),
        "eyeSquintRightValues" : \(eyeSquintRightValues),
    
        "jawOpenValues" : \(jawOpenValues),
        "mouthFunnelValues" : \(mouthFunnelValues),
        "mouthPuckerValues" : \(mouthPuckerValues),
        "mouthSmileLeftValues" : \(mouthSmileLeftValues),
        "mouthSmileRightValues" : \(mouthSmileRightValues),
        "mouthFrownLeftValues" : \(mouthFrownLeftValues),
        "mouthFrownRightValues" : \(mouthFrownRightValues),
        "mouthUpperUpLeftValues" : \(mouthUpperUpLeftValues),
        "mouthUpperUpRightValues" : \(mouthUpperUpRightValues),
        "mouthLowerDownLeftValues" : \(mouthLowerDownLeftValues),
        "mouthLowerDownRightValues" : \(mouthLowerDownRightValues),
        "mouthPressLeftValues" : \(mouthPressLeftValues),
        "mouthPressRightValues" : \(mouthPressRightValues),
        "mouthShrugUpperValues" : \(mouthShrugUpperValues),
        "mouthShrugLowerValues" : \(mouthShrugLowerValues),
        "mouthRollUpperValues" : \(mouthRollUpperValues),
        "mouthRollLowerValues" : \(mouthRollLowerValues),
        "mouthStretchLeftValues" : \(mouthStretchLeftValues),
        "mouthStretchRightValues" : \(mouthStretchRightValues),
        "mouthDimpleLeftValues" : \(mouthDimpleLeftValues),
        "mouthDimpleRightValues" : \(mouthDimpleRightValues),
        "mouthLeftValues" : \(mouthLeftValues),
        "mouthRightValues" : \(mouthRightValues)
    }
    """

    let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let fileURL = DocumentDirURL.appendingPathComponent(file).appendingPathExtension("json")
    
    print("File Path: \(fileURL.path)")
    
    do {
        try text.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print("Failed to write to URL: ")
        print(error)
        
    }
}

func roundNum(number: Float) -> Float {
    var newNumber = round(number * 1000)
    newNumber = newNumber / 1000.0
    return newNumber
}

// 1
extension ViewController: ARSCNViewDelegate {
    
  // 2
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    
    // 3
    guard let device = sceneView.device else {
      return nil
    }
      
      
    
    // 4
    let faceGeometry = ARSCNFaceGeometry(device: device)
    
    // 5
    let node = SCNNode(geometry: faceGeometry)
    
    // 6
    node.geometry?.firstMaterial?.fillMode = .lines
      
    // 7
    return node
  }
    
    // 1
    func renderer(
      _ renderer: SCNSceneRenderer,
      didUpdate node: SCNNode,
      for anchor: ARAnchor) {
       
      // 2
      guard let faceAnchor = anchor as? ARFaceAnchor,
        let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
          return
      }
          
          let eyeBlinkLeft = faceAnchor.blendShapes[.eyeBlinkLeft]?.floatValue ?? 0.000
          let eyeBlinkRight = faceAnchor.blendShapes[.eyeBlinkRight]?.floatValue ?? 0.000
            
          let eyeLookUpLeft = faceAnchor.blendShapes[.eyeLookUpLeft]?.floatValue ?? 0.000
          let eyeLookDownLeft = faceAnchor.blendShapes[.eyeLookUpLeft]?.floatValue ?? 0.000
          let eyeLookOutLeft = faceAnchor.blendShapes[.eyeLookOutLeft]?.floatValue ?? 0.000
          let eyeLookInLeft = faceAnchor.blendShapes[.eyeLookInLeft]?.floatValue ?? 0.000
          let eyeSquintLeft = faceAnchor.blendShapes[.eyeSquintLeft]?.floatValue ?? 0.000
            
          let eyeLookUpRight = faceAnchor.blendShapes[.eyeLookUpRight]?.floatValue ?? 0.000
          let eyeLookDownRight = faceAnchor.blendShapes[.eyeLookUpRight]?.floatValue ?? 0.000
          let eyeLookOutRight = faceAnchor.blendShapes[.eyeLookOutRight]?.floatValue ?? 0.000
          let eyeLookInRight = faceAnchor.blendShapes[.eyeLookInRight]?.floatValue ?? 0.000
          let eyeSquintRight = faceAnchor.blendShapes[.eyeSquintRight]?.floatValue ?? 0.000
          
          let jawOpen = faceAnchor.blendShapes[.jawOpen]?.floatValue ?? 0.000
          let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel]?.floatValue ?? 0.000
          let mouthPucker = faceAnchor.blendShapes[.mouthPucker]?.floatValue ?? 0.000
          let mouthSmileLeft = faceAnchor.blendShapes[.mouthSmileLeft]?.floatValue ?? 0.000
          let mouthSmileRight = faceAnchor.blendShapes[.mouthSmileRight]?.floatValue ?? 0.000
          let mouthFrownLeft = faceAnchor.blendShapes[.mouthFrownLeft]?.floatValue ?? 0.000
          let mouthFrownRight = faceAnchor.blendShapes[.mouthFrownRight]?.floatValue ?? 0.000
          let mouthUpperUpLeft = faceAnchor.blendShapes[.mouthUpperUpLeft]?.floatValue ?? 0.000
          let mouthUpperUpRight = faceAnchor.blendShapes[.mouthUpperUpRight]?.floatValue ?? 0.000
          let mouthLowerDownLeft = faceAnchor.blendShapes[.mouthLowerDownLeft]?.floatValue ?? 0.000
          let mouthLowerDownRight = faceAnchor.blendShapes[.mouthLowerDownRight]?.floatValue ?? 0.000
          let mouthPressLeft = faceAnchor.blendShapes[.mouthPressLeft]?.floatValue ?? 0.000
          let mouthPressRight = faceAnchor.blendShapes[.mouthPressRight]?.floatValue ?? 0.000
          let mouthShrugLower = faceAnchor.blendShapes[.mouthShrugLower]?.floatValue ?? 0.000
          let mouthShrugUpper = faceAnchor.blendShapes[.mouthShrugUpper]?.floatValue ?? 0.000
          let mouthRollUpper = faceAnchor.blendShapes[.mouthRollUpper]?.floatValue ?? 0.000
          let mouthRollLower = faceAnchor.blendShapes[.mouthRollLower]?.floatValue ?? 0.000
          let mouthStretchLeft = faceAnchor.blendShapes[.mouthStretchLeft]?.floatValue ?? 0.000
          let mouthStretchRight = faceAnchor.blendShapes[.mouthStretchRight]?.floatValue ?? 0.000
          let mouthDimpleLeft = faceAnchor.blendShapes[.mouthDimpleLeft]?.floatValue ?? 0.000
          let mouthDimpleRight = faceAnchor.blendShapes[.mouthDimpleRight]?.floatValue ?? 0.000
          let mouthLeft = faceAnchor.blendShapes[.mouthLeft]?.floatValue ?? 0.000
          let mouthRight = faceAnchor.blendShapes[.mouthRight]?.floatValue ?? 0.000
          
          if recordingData == true {
              count += 1
              if (count == 2) {
                  count = 0
                  // Capture Data
                  leftBlinkValues.append(roundNum(number: eyeBlinkLeft * 0.7))
                  rightBlinkValues.append(roundNum(number: eyeBlinkRight * 0.7))
                  
                  eyeLookUpLeftValues.append(roundNum(number: eyeLookUpLeft))
                  eyeLookDownLeftValues.append(roundNum(number: eyeLookDownLeft))
                  eyeLookOutLeftValues.append(roundNum(number: eyeLookOutLeft))
                  eyeLookInLeftValues.append(roundNum(number: eyeLookInLeft))
                  eyeSquintLeftValues.append(roundNum(number: eyeSquintLeft))
                  
                  eyeLookUpRightValues.append(roundNum(number: eyeLookUpRight))
                  eyeLookDownRightValues.append(roundNum(number: eyeLookDownRight))
                  eyeLookOutRightValues.append(roundNum(number: eyeLookOutRight))
                  eyeLookInRightValues.append(roundNum(number: eyeLookInRight))
                  eyeSquintRightValues.append(roundNum(number: eyeSquintRight))
                  
                  jawOpenValues.append(roundNum(number: jawOpen))
                  mouthFunnelValues.append(roundNum(number: mouthFunnel))
                  mouthPuckerValues.append(roundNum(number: mouthPucker))
                  mouthSmileLeftValues.append(roundNum(number: mouthSmileLeft))
                  mouthSmileRightValues.append(roundNum(number: mouthSmileRight))
                  mouthFrownLeftValues.append(roundNum(number: mouthFrownLeft))
                  mouthFrownRightValues.append(roundNum(number: mouthFrownRight))
                  mouthUpperUpLeftValues.append(roundNum(number: mouthUpperUpLeft))
                  mouthUpperUpRightValues.append(roundNum(number: mouthUpperUpRight))
                  mouthLowerDownLeftValues.append(roundNum(number: mouthLowerDownLeft))
                  mouthLowerDownRightValues.append(roundNum(number: mouthLowerDownRight))
                  mouthPressLeftValues.append(roundNum(number: mouthPressLeft))
                  mouthPressRightValues.append(roundNum(number: mouthPressRight))
                  mouthShrugUpperValues.append(roundNum(number: mouthShrugUpper))
                  mouthShrugLowerValues.append(roundNum(number: mouthShrugLower))
                  mouthRollUpperValues.append(roundNum(number: mouthRollUpper))
                  mouthRollLowerValues.append(roundNum(number: mouthRollLower))
                  mouthStretchLeftValues.append(roundNum(number: mouthStretchLeft))
                  mouthStretchRightValues.append(roundNum(number: mouthStretchRight))
                  mouthDimpleLeftValues.append(roundNum(number: mouthDimpleLeft))
                  mouthDimpleRightValues.append(roundNum(number: mouthDimpleRight))
                  mouthLeftValues.append(roundNum(number: mouthLeft))
                  mouthRightValues.append(roundNum(number: mouthRight))
                  
                  if recordSnapshot == true {
                      recordingData = false
                      recordSnapshot = false
                      
                      saveData()
                  }
              }
          }
          
          
        
      // 3
      faceGeometry.update(from: faceAnchor.geometry)
    }

}


