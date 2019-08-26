//
// Created by 김경인 on 2019-08-09.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class QRCodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate: QRCodeReadDelegate?
    var recSize = CGRect(x: UIScreen.main.bounds.width*0.2, y: UIScreen.main.bounds.height*0.5-UIScreen.main.bounds.width*0.3,
            width: UIScreen.main.bounds.width*0.6, height: UIScreen.main.bounds.width*0.6)

    lazy var transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        view.frame = self.view.layer.frame
        view.alpha = 0.5

        let path = CGMutablePath()
        path.addRect(self.recSize)
        path.addRect(CGRect(origin: .zero, size: view.frame.size))

        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        view.layer.mask = maskLayer
        view.clipsToBounds = true

        return view
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.recSize)

        imageView.image = UIImage(named: "qrEdge")

        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "QR Code 인식")
        self.navigationController?.navigationBar.barTintColor = UIColor(key: "light3")

        view.backgroundColor = UIColor(key: "light3")
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed(error: "auth")
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed(error: "other")
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed(error: "other")
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.layer.frame

        captureSession?.startRunning()

        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: recSize)

        view.layer.addSublayer(previewLayer!)
        view.addSubview(imageView)
        view.addSubview(transparentView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func failed(error: String) {
        var errorBody: String?
        if(error == "auth"){
            errorBody = "카메라를 사용할 수 없습니다.\n단말기 -> 설정에서 MOAH Wallet의 카메라 권한을 허용해주세요."
        }
        else{
            errorBody = "카메라를 사용할 수 없습니다."
        }
        let util = Util()
        let alertVC = util.alert(title: "Error".localized, body: errorBody!, buttonTitle: "확인", buttonNum: 1, completion: {_ in})
        self.present(alertVC, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        else{
            dismiss(animated: true)
        }
    }

    func found(code: String) {
        self.dismiss(animated: true, completion: {() in
            self.delegate?.qrCodeRead(value: code)
        })
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
