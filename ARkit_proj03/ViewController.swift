//
//  ViewController.swift
//  ARkit_proj03
//
//  Created by Fernando Jt on 15/8/18.
//  Copyright © 2018 Fernando Jumbo Tandazo. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuracion = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuracion)
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,ARSCNDebugOptions.showWorldOrigin]
        
        //Para detectar toques en la pantalla y colisiones
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        // añadimos el reconocedor de gesturas a nuestra escena
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//ROTACION DE OBJETOS
        //creamo unos cubos
        let cubo1 = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01))
        cubo1.position = SCNVector3(-0.1,0,-0.5)
        cubo1.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        cubo1.eulerAngles = SCNVector3(Float(-30.gradosARadianes),Float(-30.gradosARadianes),Float(-45.gradosARadianes))
        
        let cubo2 = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01))
        cubo2.position = SCNVector3(0.1,0,-0.5)
        cubo2.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        cubo2.eulerAngles = SCNVector3(Float(-30.gradosARadianes),Float(-30.gradosARadianes),Float(-45.gradosARadianes))
        
        self.sceneView.autoenablesDefaultLighting = true
        
        //self.sceneView.scene.rootNode.addChildNode(cubo1)
        //self.sceneView.scene.rootNode.addChildNode(cubo2)
        
        //AÑADIMOS ACCIONES A CADA UNO DE LOS CUBOS
        let accionCubo1 = SCNAction.rotateBy(x: 0, y: CGFloat(360.gradosARadianes), z: 0, duration: 2)
        let accionCubo2 = SCNAction.rotateBy(x: 0, y: CGFloat(-360.gradosARadianes), z: 0, duration: 2)
        
        //PARA HACER QUE LOS CUBES GIREN TODO EL TIEMPO
        let foreverCubo1 = SCNAction.repeatForever(accionCubo1)
        let foreverCubo2 = SCNAction.repeatForever(accionCubo2)
        
        //ASIGNAMOS LA ACCION A CADA NODO
        cubo1.runAction(foreverCubo1)
        cubo2.runAction(foreverCubo2)
        
//TEXTURAS : diffuse , TEXTURAS ESPECULARES: specular , MAPA DE NORMALES, MAPAS DE DESPLAZAMIENTO
        let esponja = SCNNode(geometry: SCNSphere(radius: 0.2))
        esponja.position = SCNVector3(-0.2,0,-0.5)
        esponja.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "esponjaDifFuse")
        esponja.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "esponjaSpecular")
        //Agregamos mapa de normales (se usa para detalles 3D)
        esponja.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "esponjaNormal")
        //Agregamos mapa de desplazamiento
        //esponja.geometry?.firstMaterial?.displacement.contents = #imageLiteral(resourceName: "esponjaDesplazamiento")
        
        
        let roca = SCNNode(geometry: SCNSphere(radius: 0.05))
        roca.position = SCNVector3(0.3,0,-0.5)
        roca.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "rocaDiffuse")
        roca.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "rocaSpecular")
        //Agregamos mapa de normales (se usa para detalles 3D)
        roca.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "rocaNormal")
         //Agregamos mapa de desplazamiento
        roca.geometry?.firstMaterial?.displacement.contents = #imageLiteral(resourceName: "rocaDesplazamiento")
       
        
        self.sceneView.autoenablesDefaultLighting = true
        
        self.sceneView.scene.rootNode.addChildNode(esponja)
        self.sceneView.scene.rootNode.addChildNode(roca)
        
        //AÑADIMOS ACCIONES A CADA UNO DE LOS CUBOS
        let accionEsponja = SCNAction.rotateBy(x: 0, y: CGFloat(360.gradosARadianes), z: 0, duration: 7)
        let accionRoca = SCNAction.rotateBy(x: 0, y: CGFloat(-360.gradosARadianes), z: 0, duration: 7)
        
        //PARA HACER QUE LOS CUBES GIREN TODO EL TIEMPO
        let foreverEsponja = SCNAction.repeatForever(accionEsponja)
        let foreverRoca = SCNAction.repeatForever(accionRoca)
        
        //ASIGNAMOS LA ACCION A CADA NODO
        esponja.runAction(foreverEsponja)
        roca.runAction(foreverRoca)
        
        
    }
    //funcion handleTap
    //Para identificar el objeto que tocamos colocamos sender: UITapGestureRecognizer como parámatro en nuestra funcion
    @objc func handleTap(sender: UITapGestureRecognizer){
        //detectamos la vista que hemos tocado
        let sceneViewTapped = sender.view as! SCNView
        //coordenadas de nuestro toque
        let touchCoordinates = sender.location(in: sceneViewTapped)
        //hit-testing nos da un array de las posiciones donde hemos tocado
        let hitTest = sceneViewTapped.hitTest(touchCoordinates, options: nil)
        if hitTest.isEmpty {
            print("No has tocado nada")
        }else{
            if let resuts = hitTest.first{
                let geometry = resuts.node
                
                //corregir para que la alimacion no se vaya al vacio
                if geometry.animationKeys.isEmpty{
                    
                    //llamamos a la animacion
                    self.animarNodo(node: geometry)
                }
                
               
            }
            
        }
    }
    
    //FUNCION PARA ANIMAR LOS OBJETOS AL TOCARLOS
    func animarNodo(node: SCNNode){
        //configurar la animacion
        let animation = CABasicAnimation(keyPath: "position")
        //desde donde queremos que vaya
        animation.fromValue = node.presentation.position
        //hacia donde queremos que vaya
        //(desde donde esté se vaya un metro para atrás)
        animation.toValue = SCNVector3(0,0,node.presentation.position.z - 1)
        //tiempo de la animacion
        animation.duration = 2
        //para repetir la animacion
        animation.repeatCount = 3
        //para regresar la animacion de la misma manera
        animation.autoreverses = true
        
        //añadir la animacion al nodo
        node.addAnimation(animation, forKey: "position")
    }

}

extension Int{
    var gradosARadianes : Double{
        return Double(self) * .pi/180
    }
}
