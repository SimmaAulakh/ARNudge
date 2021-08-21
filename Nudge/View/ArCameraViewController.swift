//
//  ArCameraViewController.swift
//  Nudge
//
//  Created by Simranjeet Singh on 10/09/19.
//  Copyright © 2019 Simranjeet Singh. All rights reserved.
//

import UIKit
import ARKit
import SceneKit.ModelIO

class ArCameraViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var sceneView: ARSCNView!
    
     //MARK:- Variables
    let anchorDistance: Float = -0.25
    
    let anchorDistancey: Float = 0.25
    
    var animations = [String: CAAnimation]()
    
    private var animationInfo: AnimationInfo?
    
    var isFromCameraButton = false
    
    var numberOfModels = 1
    
    var indexForTexture = 0
    
    let animatedModel = AnimatedModel()
    
    let boxTextures = [#imageLiteral(resourceName: "Gift_Box_Diff"),#imageLiteral(resourceName: "Gift_Box_Gray_Diff"),#imageLiteral(resourceName: "Gift_Box_Red_Diff")]
    
    let baloonTextures = [#imageLiteral(resourceName: "Balloon_Diff"),#imageLiteral(resourceName: "Balloon_Gray_Diff"),#imageLiteral(resourceName: "Balloon_Red_Diff")]
    
    let nodeNames = ["aa","ww","bb"]
    
    let productNames = ["Perfume","Lipstick_01","Starbucks","Perfume","Lipstick_01","Starbucks","Perfume","Lipstick_01","Starbucks","Perfume","Lipstick_01","Starbucks","Perfume","Lipstick_01","Starbucks","Perfume","Lipstick_01","Starbucks","Perfume","Lipstick_01","Starbucks"]
    
    var random: Double {
        
        return Double(arc4random()) / 0xFFFFFFFF
        
    }
    
    //MARK:- Controller life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setUpSceneView(fromCameraButton:isFromCameraButton)
        //add observer for notification that will invalidate the ARsession when view will not in use.
        NotificationCenter.default.addObserver(self, selector: #selector(pauseARSession), name: NSNotification.Name("InvalidateARSession"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        HelpingClass.shared.delay(2.0) {
            //Run loop to create desired number of markers in the scene to place 3D model objects
            for i in 1...self.numberOfModels{
                
                self.createObjectAnchor(posZ: Float(-0.50 * Double(i+1)), posY: self.isFromCameraButton == true ? Float(self.random) : 0)
                
                }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        pauseARSession()
    }
    
    //MARK:- Custom methods
    
    @objc func pauseARSession(){
        
        sceneView.session.pause()
        
       // sceneView.removeFromSuperview()
        
      //  sceneView = nil
        
    }
    
   // Setup scene view with configuration to be used
    @objc func setUpSceneView(fromCameraButton:Bool) {
        
        guard ARWorldTrackingConfiguration.isSupported else {return}
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.automaticallyUpdatesLighting = false
        sceneView.antialiasingMode = .multisampling4X
        sceneView.delegate = self
        sceneView.debugOptions = []
        
    }
    
    //This functions loads the 3D model in the scene on the custom anchors placed in scene
    private func loadModel(rootNode:SCNNode,anchor:ARAnchor,boxTexture:UIImage,baloonTexture:UIImage,nodeName:String,productName:String) {
        
        let contentRootNode = SCNNode()
        contentRootNode.name = "jj"
        
        //load model from "art.scnassets" folder
        guard let virtualObjectScene = SCNScene(named:"art.scnassets/GiftBalloon.dae") else {
            return
        }
        
        let wrapperNode = SCNNode()
      //  wrapperNode.name = "nodeName"
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        //add the node that contains model to rootNode
        rootNode.addChildNode(contentRootNode)
        
        // scale the node to desired value
        wrapperNode.scale = SCNVector3(0.02, 0.02, 0.02)
        
        contentRootNode.addChildNode(wrapperNode)
        
        for wrapnode in wrapperNode.childNodes{
            
            for nnode in wrapnode.childNodes{
                
                if nnode.name == "Gift_Box_Grp"{
                    
                for node in nnode.childNodes{
                    
                    if node.name == "box_animation"{
                        
                        for n in node.childNodes{
                            
                            if n.name == "Box_Base"{
                                //change Textures
                                changeTexture(texture: boxTexture, node: n)
                                
                            }else if n.name == "Box_Cap"{
                                //change Textures
                                changeTexture(texture: boxTexture, node: n)
                            }
                            
                        }
                        
                    }else if node.name == "Balloon_1"{
                        //change Textures
                        changeTexture(texture: baloonTexture, node: node)
                        
                        }
                    
                    }
                    
                }
                
            }
            
        }
        
        let plane = SCNPlane(width: 4.5, height: 4.5)
        plane.materials.first?.colorBufferWriteMask = SCNColorMask(rawValue:0)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0.1
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        let lightNode = SCNNode()
        
        let lightNode2 = SCNNode()
        
        let ambientLightNode = SCNNode()
        
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 1, z: 1)//SCNVector3(x: 0, y: 1, z: 1)
        
        contentRootNode.addChildNode(lightNode)
        
        // create main light that cast shadow
        
        lightNode2.light = SCNLight()
        lightNode2.light!.type = .directional
        lightNode2.position = SCNVector3(x: -1, y: 10, z: 1)
        lightNode2.eulerAngles = SCNVector3(136,190,338) //136 190 338
        lightNode2.light?.intensity = 1
        lightNode2.light?.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lightNode2.light?.shadowRadius = 0
        lightNode2.light?.castsShadow = true // to cast shadow
        lightNode2.light?.shadowMode = .deferred // to render shadow in transparent plane
        lightNode2.light?.shadowSampleCount = 1  //remove flickering of shadow and soften shadow
        lightNode2.light?.shadowMapSize = CGSize(width: 2048, height: 2048) //sharpen or detail shadow
        
        contentRootNode.addChildNode(lightNode2)

        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        
        contentRootNode.addChildNode(ambientLightNode)
        if productName != "Starbucks"{
        replaceModel(modelName:productName)
        }
        
    }
    
    //function for changing textures on a node
    func changeTexture(texture:UIImage,node:SCNNode){
        let material = SCNMaterial()
        material.lightingModel = .phong
        material.diffuse.contents = texture
        node.geometry?.firstMaterial = material
    }
    
    //replace model from balloon model
    func replaceModel(modelName:String){
        //load model from "art.scnassets" folder
        guard let virtualObjectScene = SCNScene(named:"art.scnassets/\(modelName).dae") else {
            return
            
        }
     
        let newNode = SCNNode()
    
        for child in virtualObjectScene.rootNode.childNodes {
            newNode.addChildNode(child)
        }
        
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            print(node.name ?? "")
            if node.name == "Starbucks"{
                
                //get parent node of node to be replaced
                let parentNode = node.parent
                
                //set transformation to new node as of previous node
                let transformation = node.transform
                newNode.transform = transformation
                
                //extract animations of previous node and set it to new node
                for key in node.animationKeys{
                    if let animation = node.animation(forKey: key){
                        animation.usesSceneTimeBase = false;                     // make it system time based
                        animation.repeatCount = 100
                        newNode.addAnimation(animation, forKey: key)
                    }
                    
                }
               
                //remove node that is to be replaced and add new node to the parent node
                node.removeFromParentNode()
                parentNode?.addChildNode(newNode)
            }
            
        }
        
    }
    
    //This function is declared to use any .gif file as a SCNMaterial
    func loadGif() -> SCNMaterial{
        
        let bundleURL = Bundle.main.url(forResource: "giphy", withExtension: "gif")
        
        let animation : CAKeyframeAnimation = createGIFAnimation(url: bundleURL!)!
        
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 900, height: 900)
        layer.add(animation, forKey: "contents")
        
        let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: 900, height: 900))
        tempView.layer.bounds = CGRect(x: -450, y: -450, width: tempView.frame.size.width, height: tempView.frame.size.height)
        tempView.backgroundColor = .clear
        tempView.layer.addSublayer(layer)
        
        let newMaterial = SCNMaterial()
        newMaterial.isDoubleSided = true
        newMaterial.diffuse.contents = tempView.layer
        return newMaterial
        
    }
    
    func createGIFAnimation(url:URL) -> CAKeyframeAnimation? {
        
        guard let src = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        
        let frameCount = CGImageSourceGetCount(src)
        
        // Total loop time
        
        var time : Float = 0
        
        // Arrays
        
        var framesArray = [AnyObject]()
        
        var tempTimesArray = [NSNumber]()
        
        // Loop
        
        for i in 0..<frameCount {
            
            // Frame default duration
            
            var frameDuration : Float = 0.1;
            
            let cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(src, i, nil)
            
            guard let framePrpoerties = cfFrameProperties as? [String:AnyObject] else {return nil}
            
            guard let gifProperties = framePrpoerties[kCGImagePropertyGIFDictionary as String] as? [String:AnyObject]
                else { return nil }
            
            // Use kCGImagePropertyGIFUnclampedDelayTime or kCGImagePropertyGIFDelayTime
            if let delayTimeUnclampedProp = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber {
                
                frameDuration = delayTimeUnclampedProp.floatValue
                
            } else {
                
                if let delayTimeProp = gifProperties[kCGImagePropertyGIFDelayTime as String] as? NSNumber {
                    
                    frameDuration = delayTimeProp.floatValue
                    
                }
                
            }
            
            // Make sure its not too small
            
            if frameDuration < 0.011 {
                
                frameDuration = 0.100;
                
            }
            
            // Add frame to array of frames
            
            if let frame = CGImageSourceCreateImageAtIndex(src, i, nil) {
                
                tempTimesArray.append(NSNumber(value: frameDuration))
                
                framesArray.append(frame)
                
            }
            
            // Compile total loop time
            
            time = time + frameDuration
            
        }
        
        var timesArray = [NSNumber]()
        
        var base : Float = 0
        
        for duration in tempTimesArray {
            
            timesArray.append(NSNumber(value: base))
            
            base += ( duration.floatValue / time )
            
        }
        
        // From documentation of 'CAKeyframeAnimation':
        // the first value in the array must be 0.0 and the last value must be 1.0.
        // The array should have one more entry than appears in the values array.
        // For example, if there are two values, there should be three key times.
        
        timesArray.append(NSNumber(value: 1.0))
        
        // Create animation
        let animation = CAKeyframeAnimation(keyPath: "contents")
        animation.beginTime = AVCoreAnimationBeginTimeAtZero
        animation.duration = CFTimeInterval(time)
        animation.repeatCount = Float.greatestFiniteMagnitude;
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.values = framesArray
        animation.keyTimes = timesArray
        
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.calculationMode = CAAnimationCalculationMode.discrete
        return animation;
    }
    
    //Method called when a node is tapped in scene
    @objc func handleTap(rec: UITapGestureRecognizer){
        
        if rec.state == .ended {
            
            let location: CGPoint = rec.location(in: sceneView)
            
            let hits = self.sceneView.hitTest(location, options: nil)
            
            if !hits.isEmpty{
                
                let tappedNode = hits.first?.node
               
                guard let rootNode = self.getRoot(for: tappedNode!) else {return}
                
                rootNode.isPaused = false
                
                HelpingClass.shared.delay(4.0) {
                    
                    rootNode.removeFromParentNode()
                    
                    let offerVC = self.storyboard?.instantiateViewController(withIdentifier: "OfferViewController") as? OfferViewController
                    offerVC?.modalPresentationStyle = .overCurrentContext
                    offerVC?.isFromCameraButton = self.isFromCameraButton
                    self.present(offerVC!, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    func createObjectAnchor(posZ:Float,posY:Float) {
        
        guard let sceneView = self.sceneView,
            let currentFrame = sceneView.session.currentFrame
            else { return }
        
        // Place AR objects upright infront of camera
        var translation = matrix_identity_float4x4
        translation.columns.3.z = posZ
        translation.columns.3.y = posY
        translation.columns.3.x = 0.50
        
        let transform = currentFrame.camera.transform
        
        let rotation = matrix_float4x4(SCNMatrix4MakeRotation(Float.pi/2, 0, 0, 1))
        
        let anchorTransform = matrix_multiply(transform, matrix_multiply(translation, rotation))
        
        let anchor = ARAnchor(name:"BaloonAnchor",transform: anchorTransform)
        
        sceneView.isUserInteractionEnabled = true
        sceneView.session.add(anchor: anchor)
        
    }
    
    // This function is used to get the root node
    func getRoot(for node: SCNNode) -> SCNNode? {
        
        if let node = node.parent {
            
            return node.name == "jj" ? node : getRoot(for: node)
            
        }
            
        else {
            
            return node
            
        }
        
    }
    
    //MARK:- IBActions
    
    @IBAction func backButtonClicked(_ sender: Any) {
        
        self.hidesBottomBarWhenPushed = false
       
        self.dismiss(animated: true, completion: nil)
       
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
            
        }
    }
    
    // MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message,  preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            
            alertController.dismiss(animated: true, completion: nil)
            
            self.setUpSceneView(fromCameraButton: self.isFromCameraButton)
            
        }
        
        alertController.addAction(restartAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func changeModelPlacement(anchor:SCNNode){
        let constraint = SCNLookAtConstraint(target:sceneView.pointOfView)
        constraint.isGimbalLockEnabled = true
        //        constraint.localFront = SCNVector3(x: 0, y: 0.5, z: 1)
        constraint.localFront = SCNVector3(x: 0, y: 0.5, z: 1)
//        sceneView.scene.rootNode.constraints = [constraint]
        
        sceneView.scene.rootNode.transform = anchor.transform
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//            self.sceneView.scene.rootNode.constraints = []
        })
    }
    
}

extension ArCameraViewController:ARSCNViewDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor.name == "BaloonAnchor"{
            
            //Load 3d model in scene
            self.loadModel(rootNode: node, anchor: anchor, boxTexture: boxTextures[indexForTexture], baloonTexture: baloonTextures[indexForTexture], nodeName: "", productName: productNames[indexForTexture])
            
            indexForTexture += 1
            
            indexForTexture = indexForTexture == 3 ? 0 : indexForTexture
            
            HelpingClass.shared.delay(4.0) {
                
                //Add tap gesture on sceneView
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(rec:)))
                
                self.sceneView.addGestureRecognizer(tap)
                
                for node in self.sceneView.scene.rootNode.childNodes{

                    //Find the main node with name and pause it
                    let parentNode = node.childNode(withName: "jj", recursively: true)
                    
                    parentNode?.isPaused = true
                    
                }
                
            }
            
        }
        
    
        
        
        
    }
    
     func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else{return}
        
//        changeModelPlacement(anchor: node)
    }
    
}

public extension Float {
    
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random:Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    /*
     Create a random num Float
     
     - parameter min: Float
     - parameter max: Float
     
     - returns: Float
     */
    static func random(min: Float, max: Float) -> Float {
        
        return Float.random * (max - min) + min
        
    }
}
class BMOriginVisualizer: SCNNode {
    
    //----------------------
    //MARK: - Initialization
    //---------------------
    
    /// Creates An AxisNode To Vizualize ARAnchors
    ///
    /// - Parameter scale: CGFloat
    
    init(scale: CGFloat = 1) {
        
        super.init()
        
        //1. Create The X Axis
        let xNode = SCNNode()
        
        let xNodeGeometry = SCNBox(width: 1, height: 0.01, length: 0.01, chamferRadius: 0)
        
        xNode.geometry = xNodeGeometry
        
        xNodeGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        xNode.position = SCNVector3(0.5, 0, 0)
        
        self.addChildNode(xNode)
        
        //2. Create The Y Axis
        let yNode = SCNNode()
        
        let yNodeGeometry = SCNBox(width: 0.01, height: 1, length: 0.01, chamferRadius: 0)
        
        yNode.geometry = yNodeGeometry
        
        yNode.position = SCNVector3(0, 0.5, 0)
        
        yNodeGeometry.firstMaterial?.diffuse.contents = UIColor.green
        
        self.addChildNode(yNode)
        
        //3. Create The Z Axis
        let zNode = SCNNode()
        
        let zNodeGeometry = SCNBox(width: 0.01, height: 0.01, length: 1, chamferRadius: 0)
        
        zNode.geometry = zNodeGeometry
        
        zNodeGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        zNode.position = SCNVector3(0, 0, 0.5)
        
        self.addChildNode(zNode)
        
        //4. Scale Our Axis
        self.scale = SCNVector3(scale, scale, scale)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) { fatalError("Vizualizer Coder Not Implemented") }
}
