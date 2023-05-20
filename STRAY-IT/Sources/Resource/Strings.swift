// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// 検索
  public static let search = L10n.tr("Localizable", "Search", fallback: "検索")
  /// STRAY-ITへようこそ!!
  public static let welcomeToSTRAYIT = L10n.tr("Localizable", "Welcome to STRAY-IT!!", fallback: "STRAY-ITへようこそ!!")
  public enum ThisAppUsesYourLocationForNavigation {
    /// このアプリは、ナビゲーションにあなたの位置情報を使用します。あなたの位置情報は、あなたの同意なしに収集または共有されることはありません。
    public static let yourLocationWillNotBeCollectedOrSharedWithoutYourConsent = L10n.tr("Localizable", "This app uses your location for navigation. Your location will not be collected or shared without your consent.", fallback: "このアプリは、ナビゲーションにあなたの位置情報を使用します。あなたの位置情報は、あなたの同意なしに収集または共有されることはありません。")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
