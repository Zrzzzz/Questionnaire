//
//  TotalFunc.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/5.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit


/// its rect will be insert at screen's center
/// - Parameters:
///   - y:
///   - width:
///   - height:
func TRect(y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    let x = (UIScreen.main.bounds.width - width) / 2
    return CGRect(x: x, y: y, width: width, height: height)
}

func TRect(xOffset: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    let x = (UIScreen.main.bounds.width - width) / 2
    return CGRect(x: x + xOffset, y: y, width: width, height: height)
}

func calcIfValid(_ startTime: Int, _ endTime: Int) -> PaperStatus {
    let now = Int(Date().timeIntervalSince1970)
    switch now {
    case 0..<startTime:
        return .notPub
    case startTime..<endTime:
        return .pubed
    default:
        return .overed
    }
}


/// Make a Line
func lineMake(color: UIColor = .black, lineWidth: CGFloat = 1, points: CGPoint...) -> CAShapeLayer {
    let linePath = UIBezierPath()
    linePath.move(to: points.first!)
    for point in points.dropFirst() {
        linePath.addLine(to: point)
    }
    let line = CAShapeLayer()
    line.path = linePath.cgPath
    line.strokeColor = color.cgColor
    line.lineWidth = lineWidth
    
    return line
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}


