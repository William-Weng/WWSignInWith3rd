//
//  Constant.swift
//  WWSignInWith3rd
//
//  Created by William.Weng on 2023/8/25.
//

import Foundation

final class Constant: NSObject {}

extension Constant {
    
    /// 自訂錯誤
    public enum MyError: Error, LocalizedError {
        
        var errorDescription: String { errorMessage() }

        case unknown
        case unregistered
        case isEmpty
        case isCancel
        
        /// 顯示錯誤說明
        /// - Returns: String
        private func errorMessage() -> String {

            switch self {
            case .unknown: return "未知錯誤"
            case .unregistered: return "尚未註冊"
            case .isEmpty: return "資料是空的"
            case .isCancel: return "取消"
            }
        }
    }
}
