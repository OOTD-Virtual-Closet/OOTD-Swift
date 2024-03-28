////
////  image.swift
////  OOTD-Swift
////
////  Created by Rishabh Pandey on 2/25/24.
////
//
//import SwiftUI
//import Vision
//
//struct ImageSegmentation: View {
//    
//    @State var outputImage : UIImage = UIImage(named: "car")!
//    @State var inputImage : UIImage = UIImage(named: "car")!
//    
//    var body: some View {
//        ScrollView{
//            VStack{
//                HStack{
//                    Image(uiImage: inputImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                    
//                    Spacer()
//                    Image(uiImage: outputImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    runVisionRequest()
//                },
//                label: {
//                    Text("Run Image Segmentation")
//                })
//                .padding()
//            }
//        }
//    }
//    
//    func runVisionRequest() {
//            
//            guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model)
//            else { return }
//            
//            let request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
//            request.imageCropAndScaleOption = .scaleFill
//            DispatchQueue.global().async {
//                
//                let handler = VNImageRequestHandler(cgImage: inputImage.cgImage!, options: [:])
//                
//                do {
//                    try handler.perform([request])
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    
//    
//    func visionRequestDidComplete(request: VNRequest, error: Error?) {
//                DispatchQueue.main.async {
//                    if let observations = request.results as? [VNCoreMLFeatureValueObservation],
//                        let segmentationmap = observations.first?.featureValue.multiArrayValue {
//                        let segmentationMask = segmentationmap.postProcessImage()
//                        self.outputImage = segmentationMask!
//                    }
//                }
//        }
//}
//    
//extension MLMultiArray {
//    func postProcessImage(size: Int = 256) -> UIImage? {
//        let rawPointer = malloc(size*size*3)!
//        let bytes = rawPointer.bindMemory(to: UInt8.self, capacity: size*size*3)
//        
//        let mlArray = self.dataPointer.bindMemory(to: Float32.self, capacity: size*size*3)
//        for index in 0..<self.count/(3) {
//            bytes[index*3 + 0] = UInt8(max(min(mlArray[index]*255, 255), 0))
//            bytes[index*3 + 1] = UInt8(max(min(mlArray[index + size*size]*255, 255), 0))
//            bytes[index*3 + 2] = UInt8(max(min(mlArray[index + size*size*2]*255, 255), 0))
//        }
//        
//        let selftureSize = size*size*3
//        
//        let provider = CGDataProvider(dataInfo: nil, data: rawPointer, size: selftureSize, releaseData: { (_, data, size) in
//            data.deallocate()
//        })!
//       
//        let rawBitmapInfo = CGImageAlphaInfo.none.rawValue
//        let bitmapInfo = CGBitmapInfo(rawValue: rawBitmapInfo)
//        let pColorSpace = CGColorSpaceCreateDeviceRGB()
//
//        let rowBytesCount = size*3
//        let cgImage = CGImage(width: size, height: size, bitsPerComponent: 8, bitsPerPixel: 24, bytesPerRow: rowBytesCount, space: pColorSpace, bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)!
//        let uiImage = UIImage(cgImage: cgImage)
//            
//        return uiImage
//    }
//}
//
//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageSegmentation()
//    }
//}
//
