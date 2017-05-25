//
//  Camera2ViewController.swift
//  12AM
//
//  Created by Nick Reichard on 5/25/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import UIKit
import AVFoundation

class Camera2ViewController : UIViewController {
    
   fileprivate let session = AVCaptureSession()
   fileprivate var camera : AVCaptureDevice?
   fileprivate var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
   fileprivate var cameraCaptureOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCaptureSession()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func displayCapturedPhoto(capturedPhoto : UIImage) {
        
        let imagePreviewViewController = storyboard?.instantiateViewController(withIdentifier: "ImagePreviewViewController") as! ImagePreviewViewController
        imagePreviewViewController.capturedImage = capturedPhoto
        navigationController?.pushViewController(imagePreviewViewController, animated: true)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        
        takePicture()
    }
    
    func initializeCaptureSession() {
        
        session.sessionPreset = AVCaptureSessionPresetHigh
        camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let cameraCaptureInput = try AVCaptureDeviceInput(device: camera!)
            cameraCaptureOutput = AVCapturePhotoOutput()
            
            session.addInput(cameraCaptureInput)
            session.addOutput(cameraCaptureOutput)
            
        } catch {
            print(error.localizedDescription)
        }
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.bounds
        cameraPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
        
        view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        session.startRunning()
    }
    
    func takePicture() {
        // Many settings to customize
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
       
        cameraCaptureOutput?.capturePhoto(with: settings, delegate: self)
    }
}

extension Camera2ViewController : AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let unwrappedError = error {
            print(unwrappedError.localizedDescription)
        } else {
            
            if let sampleBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
                
                if let finalImage = UIImage(data: dataImage) {
                    
                    displayCapturedPhoto(capturedPhoto: finalImage)
                }
            }
        }
    }
}
