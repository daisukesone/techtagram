//
//  ViewController.swift
//  techtagram
//
//  Created by 曽根大輔 on 2018/02/14.
//  Copyright © 2018年 曽根大輔. All rights reserved.
//

import UIKit
//snsに投稿するときに必要なフレームワーク
import Accounts

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cameraImageView: UIImageView!
    
    //画像加工するための元となる画像
    var originalImage: UIImage!
    
    //画像加工するフィルターの宣言
    var filter: CIFilter!   
    
    //スタンプの配列を生成
    var imageNameArray: [String] = ["hana","hoshi"]
    
    //選択しているスタンプ画像の番号
    var imageIndex: Int = 0
    
    //スタンプ画像が入るimageview
    var stampImageview: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //撮影する時のメソッド
    @IBAction func useCamera(){
        //カメラが使えるかの確認
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        } else{
            //カメラが使えない場合はエラーがコンソールに出る
            print("error")
            
        }
        
    }
    
    //カメラ、カメラロールを使ったときに選択した画像をアプリ内に表示させるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        originalImage = cameraImageView.image
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //表示している画像にフィルター加工する時のメソッド
    @IBAction func applyFilter(){
        
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColerControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        
        //彩度の調整
        filter.setValue(1.0	, forKey: "inputBrightness")
        
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
        
        
        
    }
    
    //編集した画像を保存するためのメソッド
    @IBAction func save(){
        
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
        
    }
    
    //カメラロールにある画像を読み込む時のメソッド
    @IBAction func openAlbum(){
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //カメラロールの画像を選択して画像を表示する
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    

    //編集した画像をシェアする時のメソッド
    @IBAction func share(){
        // 投稿するときに一緒にのせるコメント
        let shareText = "写真加工できた！"
        
        //投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    //スタンプを配置するメソッド
    @IBAction func stamp1(){
        imageIndex = 1
    }
    
    @IBAction func stamp2(){
        imageIndex = 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //タッチされた位置を取得
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self.view)
        
        //もしimageIndexが0出ないとき
        if imageIndex != 0 {
            //スタンプサイズを40pxの正方形に指定
            stampImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            
            //押されたスタンプの画像を設定
            let image: UIImage = UIImage(named: imageNameArray[imageIndex-1])!
            stampImageview.image = image
            
            //タッチされた位置に画像をおく
            stampImageview.center = CGPoint(x: location.x, y: location.y)

            //画像を表示
            self.view.addSubview(stampImageview)
            
        }
        
    }
    
    
    

}

