//
//  ViewController.swift
//  Wolf
//
//  Created by Mohamed Elbana on 22/11/2023.
//  Copyright © 2023 Mohamed Elbana. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private var wolfNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupConfigurations()
        createWolfNode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// setupConfigurations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func setupScene() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    private func setupConfigurations() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    private func createARPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        let pos = SCNVector3Make(anchor.transform.columns.3.x,
                                 anchor.transform.columns.3.y,
                                 anchor.transform.columns.3.z)
        
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), 
                             height: CGFloat(anchor.extent.z))
        let grassImage = UIImage(named: "Landscape")
        let grassMaterial = SCNMaterial()
        grassMaterial.diffuse.contents = grassImage
        grassMaterial.isDoubleSided = true
        plane.materials = [grassMaterial]
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = pos
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        if wolfNode == nil {
            if let wolfScene = SCNScene(named: "art.scnassets/wolf.dae") {
                wolfNode = wolfScene.rootNode.childNode(withName: "wolf", recursively: true)
                wolfNode.position = pos
                sceneView.scene.rootNode.addChildNode(wolfNode!)
            }
        }
        return planeNode
    }
    
    private func createWolfNode() {
        let wolfScene = SCNScene(named: "art.scnassets/wolf.dae")
        wolfNode = wolfScene?.rootNode.childNode(withName: "wolf", recursively: true)
        wolfNode.position = SCNVector3(x: 0, y: 0, z: -0.5)
        wolfNode.rotation = SCNVector4(30, 0, 0, 0)
        sceneView.scene.rootNode.addChildNode(wolfNode!)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        /// let planeNode = createARPlaneNode(anchor: planeAnchor)
        /// node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        /*
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        let planeNode = createARPlaneNode(anchor: planeAnchor)
        node.addChildNode(planeNode)
        */
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        /*
        guard anchor is ARPlaneAnchor else { return }
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        */
    }
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
}
