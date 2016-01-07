//
//  ViewController.swift
//  BruinCheck
//
//  Created by Li-Wei Tseng on 9/28/15.
//  Copyright © 2015 liwei. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session         : AVCaptureSession = AVCaptureSession()
    
    //
    let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/email.gmail.com/events?maxResults=15&key=AIzaSyAO2NgCrNXpjJJgkPTSo1oWumsEKUgYDoY")
    //
    
    var previewLayer    : AVCaptureVideoPreviewLayer!
    
    var highlightView   : UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.highlightView.autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleBottomMargin]
       
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as a subview.
        self.view.addSubview(self.highlightView)
        
        
        // this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        
    
        do {
            let input : AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: device)
                session.addInput(input)
        } catch  {
         
//            print(error)
        }
    

        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session) //layerWithSession(session) as AVCaptureVideoPreviewLayer
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        // Start the scanner. You'll have to end it yourself later.
        session.startRunning()
        
    }
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var highlightViewRect = CGRectZero
        
        var barCodeObject : AVMetadataObject!
        
        var detectionString : String!
        
        var student: PFObject!
        
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                
                if metadata.type == barcodeType {
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                    
                    highlightViewRect = barCodeObject.bounds
                    
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    let studentID = String(detectionString.characters.dropLast())
                    if(detectionString != nil) {
                        self.session.stopRunning()
                        let query = PFQuery(className: "student")
                        query.whereKey("studentID", equalTo:studentID)
                        


                        query.findObjectsInBackgroundWithBlock {
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                // The find succeeded.
                                print("studentID: " + studentID)
                                
                                
                                
                                var alert = UIAlertController!()
                                
                                
                                
                                // Do something with the found objects
                                if let objects = objects as [PFObject]! {
                                    student = objects.first
                                    print(student?.objectForKey("fname"))
                                    
                                    if student != nil {
                                        let studentName = (student.objectForKey("fname") as? String)! + " " + (student.objectForKey("lname") as? String)!
                
                                        
                                        alert = UIAlertController(title: "Is this the person that you want to check in?", message: studentName, preferredStyle: UIAlertControllerStyle.Alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
                                            action in
                                            switch action.style{
                                            case .Default:
                                                student.incrementKey("Checkin")
                                                student.saveInBackground()
                                            case .Cancel:
                                                print("cancel")
                                                
                                            case .Destructive:
                                                print("destructive")
                                            }
                                        }))
                                    
                                        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))


                                    } else {
                                        print("not found")
                                        alert = UIAlertController(title: "Not found", message: "Please sign up!", preferredStyle: UIAlertControllerStyle.Alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))

                                    }

                                }
                                
                                self.presentViewController(alert, animated: true, completion: {
                                    self.session.startRunning()

                                })
                                
                            } else {
                                // Log details of the failure
                                print("Error: \(error!) \(error!.userInfo)")
                            }
                        }
                        
                    }
//                    self.session.stopRunning()
                    self.highlightView.frame = highlightViewRect
                    self.view.bringSubviewToFront(self.highlightView)
                    break
                }
                
            }
        }
        
        

        
        

        
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

