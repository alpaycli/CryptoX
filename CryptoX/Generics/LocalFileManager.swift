//
//  LocalFileManager.swift
//  CryptoX
//
//  Created by Alpay Calalli on 09.09.23.
//

import SwiftUI

final class LocalFileManager {
    static let shared = LocalFileManager()
    private init() { }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        // createFolderIfNeeded
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard
            let image = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName) else {
            return
        }
        
        // save image to path
        do {
            try image.write(to: url)
        } catch {
            print("Error while saving image. \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                print("Error while creating folder \(folderName):", error)
            }
        }
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else { return nil }
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    
}
