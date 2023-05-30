//
//  TokenResponse.swift
//  Domain
//
//  Created by 박천송 on 2023/05/30.
//

import Foundation

struct TokenResponse: Codable {
  let accessToken: String
  let refreshToken: String

  var isValid: Bool {
    !accessToken.isEmpty && !refreshToken.isEmpty
  }

  enum CodingKeys: String, CodingKey {
    case accessToken
    case refreshToken
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    accessToken = try container.decode(String.self, forKey: .accessToken)
    refreshToken = try container.decode(String.self, forKey: .refreshToken)
  }
}