// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Alert {
    /// Localizable.strings
    ///   CryptoAssets
    /// 
    ///   Created by Globus Dev on 26.11.2022.
    public static let ok = L10n.tr("Localizable", "alert.ok", fallback: "OK")
  }
  public enum Assets {
    /// Assets
    public static let title = L10n.tr("Localizable", "assets.title", fallback: "Assets")
  }
  public enum AssetsDetails {
    /// Market Cap
    public static let marketCap = L10n.tr("Localizable", "assets-details.market-cap", fallback: "Market Cap")
    /// Supply
    public static let supply = L10n.tr("Localizable", "assets-details.supply", fallback: "Supply")
    /// Volume (24h)
    public static let volume24h = L10n.tr("Localizable", "assets-details.volume24h", fallback: "Volume (24h)")
  }
  public enum Error {
    /// Internet Connection appears to be offline
    public static let offline = L10n.tr("Localizable", "error.offline", fallback: "Internet Connection appears to be offline")
    /// Error
    public static let title = L10n.tr("Localizable", "error.title", fallback: "Error")
  }
  public enum IconSelection {
    /// Black
    public static let black = L10n.tr("Localizable", "icon-selection.black", fallback: "Black")
    /// Icon
    public static let title = L10n.tr("Localizable", "icon-selection.title", fallback: "Icon")
    /// White
    public static let white = L10n.tr("Localizable", "icon-selection.white", fallback: "White")
    /// Yellow
    public static let yellow = L10n.tr("Localizable", "icon-selection.yellow", fallback: "Yellow")
  }
  public enum Settings {
    /// Icon
    public static let icon = L10n.tr("Localizable", "settings.icon", fallback: "Icon")
    /// Settings
    public static let title = L10n.tr("Localizable", "settings.title", fallback: "Settings")
  }
  public enum TabBar {
    /// Assets
    public static let asset = L10n.tr("Localizable", "tab_bar.asset", fallback: "Assets")
    /// Watchlist
    public static let favorite = L10n.tr("Localizable", "tab_bar.favorite", fallback: "Watchlist")
    /// Settings
    public static let settings = L10n.tr("Localizable", "tab_bar.settings", fallback: "Settings")
  }
  public enum Watchlist {
    /// Remove
    public static let remove = L10n.tr("Localizable", "watchlist.remove", fallback: "Remove")
    /// Watchlist
    public static let title = L10n.tr("Localizable", "watchlist.title", fallback: "Watchlist")
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
