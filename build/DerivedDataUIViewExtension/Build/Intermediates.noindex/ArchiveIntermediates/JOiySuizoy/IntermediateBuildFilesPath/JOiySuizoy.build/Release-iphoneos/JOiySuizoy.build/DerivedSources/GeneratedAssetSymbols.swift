import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "SiIcon" asset catalog image resource.
    static let siIcon = DeveloperToolsSupport.ImageResource(name: "SiIcon", bundle: resourceBundle)

    /// The "launchSuliJoy" asset catalog image resource.
    static let launchSuliJoy = DeveloperToolsSupport.ImageResource(name: "launchSuliJoy", bundle: resourceBundle)

    /// The "sulijoyHaidao" asset catalog image resource.
    static let sulijoyHaidao = DeveloperToolsSupport.ImageResource(name: "sulijoyHaidao", bundle: resourceBundle)

    /// The "sulijoy_activity_detail_hero_sunset" asset catalog image resource.
    static let sulijoyActivityDetailHeroSunset = DeveloperToolsSupport.ImageResource(name: "sulijoy_activity_detail_hero_sunset", bundle: resourceBundle)

    /// The "sulijoy_auth_camera_badge" asset catalog image resource.
    static let sulijoyAuthCameraBadge = DeveloperToolsSupport.ImageResource(name: "sulijoy_auth_camera_badge", bundle: resourceBundle)

    /// The "sulijoy_auth_check_active" asset catalog image resource.
    static let sulijoyAuthCheckActive = DeveloperToolsSupport.ImageResource(name: "sulijoy_auth_check_active", bundle: resourceBundle)

    /// The "sulijoy_auth_check_idle" asset catalog image resource.
    static let sulijoyAuthCheckIdle = DeveloperToolsSupport.ImageResource(name: "sulijoy_auth_check_idle", bundle: resourceBundle)

    /// The "sulijoy_auth_hero_front" asset catalog image resource.
    static let sulijoyAuthHeroFront = DeveloperToolsSupport.ImageResource(name: "sulijoy_auth_hero_front", bundle: resourceBundle)

    /// The "sulijoy_auth_hero_left" asset catalog image resource.
    static let sulijoyAuthHeroLeft = DeveloperToolsSupport.ImageResource(name: "sulijoy_auth_hero_left", bundle: resourceBundle)

    /// The "sulijoy_auth_hero_right" asset catalog image resource.
    static let sulijoyAuthHeroRight = DeveloperToolsSupport.ImageResource(name: "sulijoy_auth_hero_right", bundle: resourceBundle)

    /// The "sulijoy_auth_mail_badge" asset catalog image resource.
    static let sulijoyAuthMailBadge = DeveloperToolsSupport.ImageResource(name: "sulijoy_auth_mail_badge", bundle: resourceBundle)

    /// The "sulijoy_cove_search_mark" asset catalog image resource.
    static let sulijoyCoveSearchMark = DeveloperToolsSupport.ImageResource(name: "sulijoy_cove_search_mark", bundle: resourceBundle)

    /// The "sulijoy_event_create_camera_slot" asset catalog image resource.
    static let sulijoyEventCreateCameraSlot = DeveloperToolsSupport.ImageResource(name: "sulijoy_event_create_camera_slot", bundle: resourceBundle)

    /// The "sulijoy_event_create_cover_badge" asset catalog image resource.
    static let sulijoyEventCreateCoverBadge = DeveloperToolsSupport.ImageResource(name: "sulijoy_event_create_cover_badge", bundle: resourceBundle)

    /// The "sulijoy_feed_audio_wave" asset catalog image resource.
    static let sulijoyFeedAudioWave = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_audio_wave", bundle: resourceBundle)

    /// The "sulijoy_feed_avatar_bess" asset catalog image resource.
    static let sulijoyFeedAvatarBess = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_avatar_bess", bundle: resourceBundle)

    /// The "sulijoy_feed_avatar_brian_may" asset catalog image resource.
    static let sulijoyFeedAvatarBrianMay = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_avatar_brian_may", bundle: resourceBundle)

    /// The "sulijoy_feed_avatar_cody_hunter" asset catalog image resource.
    static let sulijoyFeedAvatarCodyHunter = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_avatar_cody_hunter", bundle: resourceBundle)

    /// The "sulijoy_feed_avatar_dennis_waters" asset catalog image resource.
    static let sulijoyFeedAvatarDennisWaters = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_avatar_dennis_waters", bundle: resourceBundle)

    /// The "sulijoy_feed_comment_mark" asset catalog image resource.
    static let sulijoyFeedCommentMark = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_comment_mark", bundle: resourceBundle)

    /// The "sulijoy_feed_comment_send_mark" asset catalog image resource.
    static let sulijoyFeedCommentSendMark = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_comment_send_mark", bundle: resourceBundle)

    /// The "sulijoy_feed_detail_bottom_gradient" asset catalog image resource.
    static let sulijoyFeedDetailBottomGradient = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_detail_bottom_gradient", bundle: resourceBundle)

    /// The "sulijoy_feed_follow_plus" asset catalog image resource.
    static let sulijoyFeedFollowPlus = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_follow_plus", bundle: resourceBundle)

    /// The "sulijoy_feed_like_active" asset catalog image resource.
    static let sulijoyFeedLikeActive = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_like_active", bundle: resourceBundle)

    /// The "sulijoy_feed_like_idle" asset catalog image resource.
    static let sulijoyFeedLikeIdle = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_like_idle", bundle: resourceBundle)

    /// The "sulijoy_feed_moment_coast_01" asset catalog image resource.
    static let sulijoyFeedMomentCoast01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_moment_coast_01", bundle: resourceBundle)

    /// The "sulijoy_feed_moment_coast_02" asset catalog image resource.
    static let sulijoyFeedMomentCoast02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_moment_coast_02", bundle: resourceBundle)

    /// The "sulijoy_feed_moment_coast_03" asset catalog image resource.
    static let sulijoyFeedMomentCoast03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_moment_coast_03", bundle: resourceBundle)

    /// The "sulijoy_feed_moment_coast_04" asset catalog image resource.
    static let sulijoyFeedMomentCoast04 = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_moment_coast_04", bundle: resourceBundle)

    /// The "sulijoy_feed_moment_coast_05" asset catalog image resource.
    static let sulijoyFeedMomentCoast05 = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_moment_coast_05", bundle: resourceBundle)

    /// The "sulijoy_feed_moment_resort_01" asset catalog image resource.
    static let sulijoyFeedMomentResort01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_moment_resort_01", bundle: resourceBundle)

    /// The "sulijoy_feed_send_mark" asset catalog image resource.
    static let sulijoyFeedSendMark = DeveloperToolsSupport.ImageResource(name: "sulijoy_feed_send_mark", bundle: resourceBundle)

    /// The "sulijoy_home_activity_blue_picnic_01" asset catalog image resource.
    static let sulijoyHomeActivityBluePicnic01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_blue_picnic_01", bundle: resourceBundle)

    /// The "sulijoy_home_activity_blue_picnic_02" asset catalog image resource.
    static let sulijoyHomeActivityBluePicnic02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_blue_picnic_02", bundle: resourceBundle)

    /// The "sulijoy_home_activity_blue_picnic_03" asset catalog image resource.
    static let sulijoyHomeActivityBluePicnic03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_blue_picnic_03", bundle: resourceBundle)

    /// The "sulijoy_home_activity_golden_walk_01" asset catalog image resource.
    static let sulijoyHomeActivityGoldenWalk01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_golden_walk_01", bundle: resourceBundle)

    /// The "sulijoy_home_activity_golden_walk_02" asset catalog image resource.
    static let sulijoyHomeActivityGoldenWalk02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_golden_walk_02", bundle: resourceBundle)

    /// The "sulijoy_home_activity_golden_walk_03" asset catalog image resource.
    static let sulijoyHomeActivityGoldenWalk03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_golden_walk_03", bundle: resourceBundle)

    /// The "sulijoy_home_activity_market_hunt_01" asset catalog image resource.
    static let sulijoyHomeActivityMarketHunt01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_market_hunt_01", bundle: resourceBundle)

    /// The "sulijoy_home_activity_market_hunt_02" asset catalog image resource.
    static let sulijoyHomeActivityMarketHunt02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_market_hunt_02", bundle: resourceBundle)

    /// The "sulijoy_home_activity_market_hunt_03" asset catalog image resource.
    static let sulijoyHomeActivityMarketHunt03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_market_hunt_03", bundle: resourceBundle)

    /// The "sulijoy_home_activity_sporty_social_01" asset catalog image resource.
    static let sulijoyHomeActivitySportySocial01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_sporty_social_01", bundle: resourceBundle)

    /// The "sulijoy_home_activity_sporty_social_02" asset catalog image resource.
    static let sulijoyHomeActivitySportySocial02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_sporty_social_02", bundle: resourceBundle)

    /// The "sulijoy_home_activity_sporty_social_03" asset catalog image resource.
    static let sulijoyHomeActivitySportySocial03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_sporty_social_03", bundle: resourceBundle)

    /// The "sulijoy_home_activity_sunset_01" asset catalog image resource.
    static let sulijoyHomeActivitySunset01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_sunset_01", bundle: resourceBundle)

    /// The "sulijoy_home_activity_sunset_02" asset catalog image resource.
    static let sulijoyHomeActivitySunset02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_sunset_02", bundle: resourceBundle)

    /// The "sulijoy_home_activity_sunset_03" asset catalog image resource.
    static let sulijoyHomeActivitySunset03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_sunset_03", bundle: resourceBundle)

    /// The "sulijoy_home_activity_tropical_party_01" asset catalog image resource.
    static let sulijoyHomeActivityTropicalParty01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_tropical_party_01", bundle: resourceBundle)

    /// The "sulijoy_home_activity_tropical_party_02" asset catalog image resource.
    static let sulijoyHomeActivityTropicalParty02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_tropical_party_02", bundle: resourceBundle)

    /// The "sulijoy_home_activity_tropical_party_03" asset catalog image resource.
    static let sulijoyHomeActivityTropicalParty03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_activity_tropical_party_03", bundle: resourceBundle)

    /// The "sulijoy_home_ai_banner_art" asset catalog image resource.
    static let sulijoyHomeAiBannerArt = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_ai_banner_art", bundle: resourceBundle)

    /// The "sulijoy_home_ai_banner_palm" asset catalog image resource.
    static let sulijoyHomeAiBannerPalm = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_ai_banner_palm", bundle: resourceBundle)

    /// The "sulijoy_home_event_closed_01" asset catalog image resource.
    static let sulijoyHomeEventClosed01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_event_closed_01", bundle: resourceBundle)

    /// The "sulijoy_home_event_closed_02" asset catalog image resource.
    static let sulijoyHomeEventClosed02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_event_closed_02", bundle: resourceBundle)

    /// The "sulijoy_home_event_closed_03" asset catalog image resource.
    static let sulijoyHomeEventClosed03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_event_closed_03", bundle: resourceBundle)

    /// The "sulijoy_home_event_open_badge" asset catalog image resource.
    static let sulijoyHomeEventOpenBadge = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_event_open_badge", bundle: resourceBundle)

    /// The "sulijoy_home_event_sunset_01" asset catalog image resource.
    static let sulijoyHomeEventSunset01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_event_sunset_01", bundle: resourceBundle)

    /// The "sulijoy_home_event_sunset_02" asset catalog image resource.
    static let sulijoyHomeEventSunset02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_event_sunset_02", bundle: resourceBundle)

    /// The "sulijoy_home_event_sunset_03" asset catalog image resource.
    static let sulijoyHomeEventSunset03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_home_event_sunset_03", bundle: resourceBundle)

    /// The "sulijoy_island_avatar_guest_01" asset catalog image resource.
    static let sulijoyIslandAvatarGuest01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_island_avatar_guest_01", bundle: resourceBundle)

    /// The "sulijoy_island_avatar_guest_02" asset catalog image resource.
    static let sulijoyIslandAvatarGuest02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_island_avatar_guest_02", bundle: resourceBundle)

    /// The "sulijoy_island_avatar_guest_03" asset catalog image resource.
    static let sulijoyIslandAvatarGuest03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_island_avatar_guest_03", bundle: resourceBundle)

    /// The "sulijoy_island_avatar_guest_04" asset catalog image resource.
    static let sulijoyIslandAvatarGuest04 = DeveloperToolsSupport.ImageResource(name: "sulijoy_island_avatar_guest_04", bundle: resourceBundle)

    /// The "sulijoy_island_avatar_guest_05" asset catalog image resource.
    static let sulijoyIslandAvatarGuest05 = DeveloperToolsSupport.ImageResource(name: "sulijoy_island_avatar_guest_05", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_01" asset catalog image resource.
    static let sulijoyMockAvatarBreeze01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_01", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_02" asset catalog image resource.
    static let sulijoyMockAvatarBreeze02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_02", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_03" asset catalog image resource.
    static let sulijoyMockAvatarBreeze03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_03", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_04" asset catalog image resource.
    static let sulijoyMockAvatarBreeze04 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_04", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_05" asset catalog image resource.
    static let sulijoyMockAvatarBreeze05 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_05", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_06" asset catalog image resource.
    static let sulijoyMockAvatarBreeze06 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_06", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_07" asset catalog image resource.
    static let sulijoyMockAvatarBreeze07 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_07", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_08" asset catalog image resource.
    static let sulijoyMockAvatarBreeze08 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_08", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_09" asset catalog image resource.
    static let sulijoyMockAvatarBreeze09 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_09", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_10" asset catalog image resource.
    static let sulijoyMockAvatarBreeze10 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_10", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_11" asset catalog image resource.
    static let sulijoyMockAvatarBreeze11 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_11", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_breeze_12" asset catalog image resource.
    static let sulijoyMockAvatarBreeze12 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_breeze_12", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_01" asset catalog image resource.
    static let sulijoyMockAvatarSun01 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_01", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_02" asset catalog image resource.
    static let sulijoyMockAvatarSun02 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_02", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_03" asset catalog image resource.
    static let sulijoyMockAvatarSun03 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_03", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_04" asset catalog image resource.
    static let sulijoyMockAvatarSun04 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_04", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_05" asset catalog image resource.
    static let sulijoyMockAvatarSun05 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_05", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_06" asset catalog image resource.
    static let sulijoyMockAvatarSun06 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_06", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_07" asset catalog image resource.
    static let sulijoyMockAvatarSun07 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_07", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_08" asset catalog image resource.
    static let sulijoyMockAvatarSun08 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_08", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_09" asset catalog image resource.
    static let sulijoyMockAvatarSun09 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_09", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_10" asset catalog image resource.
    static let sulijoyMockAvatarSun10 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_10", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_11" asset catalog image resource.
    static let sulijoyMockAvatarSun11 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_11", bundle: resourceBundle)

    /// The "sulijoy_mock_avatar_sun_12" asset catalog image resource.
    static let sulijoyMockAvatarSun12 = DeveloperToolsSupport.ImageResource(name: "sulijoy_mock_avatar_sun_12", bundle: resourceBundle)

    /// The "sulijoy_post_media_remove_mark" asset catalog image resource.
    static let sulijoyPostMediaRemoveMark = DeveloperToolsSupport.ImageResource(name: "sulijoy_post_media_remove_mark", bundle: resourceBundle)

    /// The "sulijoy_post_photo_slot_camera" asset catalog image resource.
    static let sulijoyPostPhotoSlotCamera = DeveloperToolsSupport.ImageResource(name: "sulijoy_post_photo_slot_camera", bundle: resourceBundle)

    /// The "sulijoy_post_record_mic" asset catalog image resource.
    static let sulijoyPostRecordMic = DeveloperToolsSupport.ImageResource(name: "sulijoy_post_record_mic", bundle: resourceBundle)

    /// The "sulijoy_post_record_pause" asset catalog image resource.
    static let sulijoyPostRecordPause = DeveloperToolsSupport.ImageResource(name: "sulijoy_post_record_pause", bundle: resourceBundle)

    /// The "sulijoy_post_record_play" asset catalog image resource.
    static let sulijoyPostRecordPlay = DeveloperToolsSupport.ImageResource(name: "sulijoy_post_record_play", bundle: resourceBundle)

    /// The "sulijoy_post_record_retry" asset catalog image resource.
    static let sulijoyPostRecordRetry = DeveloperToolsSupport.ImageResource(name: "sulijoy_post_record_retry", bundle: resourceBundle)

    /// The "sulijoy_shell_coin_gem" asset catalog image resource.
    static let sulijoyShellCoinGem = DeveloperToolsSupport.ImageResource(name: "sulijoy_shell_coin_gem", bundle: resourceBundle)

    /// The "sulijoy_shore_location_pin" asset catalog image resource.
    static let sulijoyShoreLocationPin = DeveloperToolsSupport.ImageResource(name: "sulijoy_shore_location_pin", bundle: resourceBundle)

    /// The "sulijoy_tab_feed_active" asset catalog image resource.
    static let sulijoyTabFeedActive = DeveloperToolsSupport.ImageResource(name: "sulijoy_tab_feed_active", bundle: resourceBundle)

    /// The "sulijoy_tab_feed_idle" asset catalog image resource.
    static let sulijoyTabFeedIdle = DeveloperToolsSupport.ImageResource(name: "sulijoy_tab_feed_idle", bundle: resourceBundle)

    /// The "sulijoy_tab_home_active" asset catalog image resource.
    static let sulijoyTabHomeActive = DeveloperToolsSupport.ImageResource(name: "sulijoy_tab_home_active", bundle: resourceBundle)

    /// The "sulijoy_tab_home_idle" asset catalog image resource.
    static let sulijoyTabHomeIdle = DeveloperToolsSupport.ImageResource(name: "sulijoy_tab_home_idle", bundle: resourceBundle)

    /// The "sulijoy_tab_profile_active" asset catalog image resource.
    static let sulijoyTabProfileActive = DeveloperToolsSupport.ImageResource(name: "sulijoy_tab_profile_active", bundle: resourceBundle)

    /// The "sulijoy_tab_profile_idle" asset catalog image resource.
    static let sulijoyTabProfileIdle = DeveloperToolsSupport.ImageResource(name: "sulijoy_tab_profile_idle", bundle: resourceBundle)

    /// The "sulijoy_tab_publish_active" asset catalog image resource.
    static let sulijoyTabPublishActive = DeveloperToolsSupport.ImageResource(name: "sulijoy_tab_publish_active", bundle: resourceBundle)

    /// The "sulijoy_tab_video_active" asset catalog image resource.
    static let sulijoyTabVideoActive = DeveloperToolsSupport.ImageResource(name: "sulijoy_tab_video_active", bundle: resourceBundle)

    /// The "sulijoy_tab_video_idle" asset catalog image resource.
    static let sulijoyTabVideoIdle = DeveloperToolsSupport.ImageResource(name: "sulijoy_tab_video_idle", bundle: resourceBundle)

    /// The "sulijoy_tide_room_close_mark" asset catalog image resource.
    static let sulijoyTideRoomCloseMark = DeveloperToolsSupport.ImageResource(name: "sulijoy_tide_room_close_mark", bundle: resourceBundle)

    /// The "sulijoy_tide_room_exit_badge" asset catalog image resource.
    static let sulijoyTideRoomExitBadge = DeveloperToolsSupport.ImageResource(name: "sulijoy_tide_room_exit_badge", bundle: resourceBundle)

    /// The "sulijoy_tide_room_send_mark" asset catalog image resource.
    static let sulijoyTideRoomSendMark = DeveloperToolsSupport.ImageResource(name: "sulijoy_tide_room_send_mark", bundle: resourceBundle)

    /// The "sulijoy_tide_room_sunset_bg" asset catalog image resource.
    static let sulijoyTideRoomSunsetBg = DeveloperToolsSupport.ImageResource(name: "sulijoy_tide_room_sunset_bg", bundle: resourceBundle)

    /// The "sulijoy_tide_room_warning_badge" asset catalog image resource.
    static let sulijoyTideRoomWarningBadge = DeveloperToolsSupport.ImageResource(name: "sulijoy_tide_room_warning_badge", bundle: resourceBundle)

    /// The "sulijoy_visitor_unlock_notice_badge" asset catalog image resource.
    static let sulijoyVisitorUnlockNoticeBadge = DeveloperToolsSupport.ImageResource(name: "sulijoy_visitor_unlock_notice_badge", bundle: resourceBundle)

    /// The "sulijoy_wallet_gem_large" asset catalog image resource.
    static let sulijoyWalletGemLarge = DeveloperToolsSupport.ImageResource(name: "sulijoy_wallet_gem_large", bundle: resourceBundle)

    /// The "sulijoy_wallet_gem_small" asset catalog image resource.
    static let sulijoyWalletGemSmall = DeveloperToolsSupport.ImageResource(name: "sulijoy_wallet_gem_small", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "SiIcon" asset catalog image.
    static var siIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .siIcon)
#else
        .init()
#endif
    }

    /// The "launchSuliJoy" asset catalog image.
    static var launchSuliJoy: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchSuliJoy)
#else
        .init()
#endif
    }

    /// The "sulijoyHaidao" asset catalog image.
    static var sulijoyHaidao: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHaidao)
#else
        .init()
#endif
    }

    /// The "sulijoy_activity_detail_hero_sunset" asset catalog image.
    static var sulijoyActivityDetailHeroSunset: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyActivityDetailHeroSunset)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_camera_badge" asset catalog image.
    static var sulijoyAuthCameraBadge: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyAuthCameraBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_check_active" asset catalog image.
    static var sulijoyAuthCheckActive: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyAuthCheckActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_check_idle" asset catalog image.
    static var sulijoyAuthCheckIdle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyAuthCheckIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_hero_front" asset catalog image.
    static var sulijoyAuthHeroFront: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyAuthHeroFront)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_hero_left" asset catalog image.
    static var sulijoyAuthHeroLeft: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyAuthHeroLeft)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_hero_right" asset catalog image.
    static var sulijoyAuthHeroRight: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyAuthHeroRight)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_mail_badge" asset catalog image.
    static var sulijoyAuthMailBadge: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyAuthMailBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_cove_search_mark" asset catalog image.
    static var sulijoyCoveSearchMark: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyCoveSearchMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_event_create_camera_slot" asset catalog image.
    static var sulijoyEventCreateCameraSlot: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyEventCreateCameraSlot)
#else
        .init()
#endif
    }

    /// The "sulijoy_event_create_cover_badge" asset catalog image.
    static var sulijoyEventCreateCoverBadge: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyEventCreateCoverBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_audio_wave" asset catalog image.
    static var sulijoyFeedAudioWave: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedAudioWave)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_avatar_bess" asset catalog image.
    static var sulijoyFeedAvatarBess: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedAvatarBess)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_avatar_brian_may" asset catalog image.
    static var sulijoyFeedAvatarBrianMay: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedAvatarBrianMay)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_avatar_cody_hunter" asset catalog image.
    static var sulijoyFeedAvatarCodyHunter: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedAvatarCodyHunter)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_avatar_dennis_waters" asset catalog image.
    static var sulijoyFeedAvatarDennisWaters: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedAvatarDennisWaters)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_comment_mark" asset catalog image.
    static var sulijoyFeedCommentMark: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedCommentMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_comment_send_mark" asset catalog image.
    static var sulijoyFeedCommentSendMark: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedCommentSendMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_detail_bottom_gradient" asset catalog image.
    static var sulijoyFeedDetailBottomGradient: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedDetailBottomGradient)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_follow_plus" asset catalog image.
    static var sulijoyFeedFollowPlus: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedFollowPlus)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_like_active" asset catalog image.
    static var sulijoyFeedLikeActive: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedLikeActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_like_idle" asset catalog image.
    static var sulijoyFeedLikeIdle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedLikeIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_coast_01" asset catalog image.
    static var sulijoyFeedMomentCoast01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedMomentCoast01)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_coast_02" asset catalog image.
    static var sulijoyFeedMomentCoast02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedMomentCoast02)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_coast_03" asset catalog image.
    static var sulijoyFeedMomentCoast03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedMomentCoast03)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_coast_04" asset catalog image.
    static var sulijoyFeedMomentCoast04: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedMomentCoast04)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_coast_05" asset catalog image.
    static var sulijoyFeedMomentCoast05: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedMomentCoast05)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_resort_01" asset catalog image.
    static var sulijoyFeedMomentResort01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedMomentResort01)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_send_mark" asset catalog image.
    static var sulijoyFeedSendMark: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyFeedSendMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_blue_picnic_01" asset catalog image.
    static var sulijoyHomeActivityBluePicnic01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityBluePicnic01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_blue_picnic_02" asset catalog image.
    static var sulijoyHomeActivityBluePicnic02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityBluePicnic02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_blue_picnic_03" asset catalog image.
    static var sulijoyHomeActivityBluePicnic03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityBluePicnic03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_golden_walk_01" asset catalog image.
    static var sulijoyHomeActivityGoldenWalk01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityGoldenWalk01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_golden_walk_02" asset catalog image.
    static var sulijoyHomeActivityGoldenWalk02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityGoldenWalk02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_golden_walk_03" asset catalog image.
    static var sulijoyHomeActivityGoldenWalk03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityGoldenWalk03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_market_hunt_01" asset catalog image.
    static var sulijoyHomeActivityMarketHunt01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityMarketHunt01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_market_hunt_02" asset catalog image.
    static var sulijoyHomeActivityMarketHunt02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityMarketHunt02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_market_hunt_03" asset catalog image.
    static var sulijoyHomeActivityMarketHunt03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityMarketHunt03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sporty_social_01" asset catalog image.
    static var sulijoyHomeActivitySportySocial01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivitySportySocial01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sporty_social_02" asset catalog image.
    static var sulijoyHomeActivitySportySocial02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivitySportySocial02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sporty_social_03" asset catalog image.
    static var sulijoyHomeActivitySportySocial03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivitySportySocial03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sunset_01" asset catalog image.
    static var sulijoyHomeActivitySunset01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivitySunset01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sunset_02" asset catalog image.
    static var sulijoyHomeActivitySunset02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivitySunset02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sunset_03" asset catalog image.
    static var sulijoyHomeActivitySunset03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivitySunset03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_tropical_party_01" asset catalog image.
    static var sulijoyHomeActivityTropicalParty01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityTropicalParty01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_tropical_party_02" asset catalog image.
    static var sulijoyHomeActivityTropicalParty02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityTropicalParty02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_tropical_party_03" asset catalog image.
    static var sulijoyHomeActivityTropicalParty03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeActivityTropicalParty03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_ai_banner_art" asset catalog image.
    static var sulijoyHomeAiBannerArt: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeAiBannerArt)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_ai_banner_palm" asset catalog image.
    static var sulijoyHomeAiBannerPalm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeAiBannerPalm)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_closed_01" asset catalog image.
    static var sulijoyHomeEventClosed01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeEventClosed01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_closed_02" asset catalog image.
    static var sulijoyHomeEventClosed02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeEventClosed02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_closed_03" asset catalog image.
    static var sulijoyHomeEventClosed03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeEventClosed03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_open_badge" asset catalog image.
    static var sulijoyHomeEventOpenBadge: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeEventOpenBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_sunset_01" asset catalog image.
    static var sulijoyHomeEventSunset01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeEventSunset01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_sunset_02" asset catalog image.
    static var sulijoyHomeEventSunset02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeEventSunset02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_sunset_03" asset catalog image.
    static var sulijoyHomeEventSunset03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyHomeEventSunset03)
#else
        .init()
#endif
    }

    /// The "sulijoy_island_avatar_guest_01" asset catalog image.
    static var sulijoyIslandAvatarGuest01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyIslandAvatarGuest01)
#else
        .init()
#endif
    }

    /// The "sulijoy_island_avatar_guest_02" asset catalog image.
    static var sulijoyIslandAvatarGuest02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyIslandAvatarGuest02)
#else
        .init()
#endif
    }

    /// The "sulijoy_island_avatar_guest_03" asset catalog image.
    static var sulijoyIslandAvatarGuest03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyIslandAvatarGuest03)
#else
        .init()
#endif
    }

    /// The "sulijoy_island_avatar_guest_04" asset catalog image.
    static var sulijoyIslandAvatarGuest04: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyIslandAvatarGuest04)
#else
        .init()
#endif
    }

    /// The "sulijoy_island_avatar_guest_05" asset catalog image.
    static var sulijoyIslandAvatarGuest05: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyIslandAvatarGuest05)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_01" asset catalog image.
    static var sulijoyMockAvatarBreeze01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze01)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_02" asset catalog image.
    static var sulijoyMockAvatarBreeze02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze02)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_03" asset catalog image.
    static var sulijoyMockAvatarBreeze03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze03)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_04" asset catalog image.
    static var sulijoyMockAvatarBreeze04: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze04)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_05" asset catalog image.
    static var sulijoyMockAvatarBreeze05: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze05)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_06" asset catalog image.
    static var sulijoyMockAvatarBreeze06: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze06)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_07" asset catalog image.
    static var sulijoyMockAvatarBreeze07: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze07)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_08" asset catalog image.
    static var sulijoyMockAvatarBreeze08: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze08)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_09" asset catalog image.
    static var sulijoyMockAvatarBreeze09: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze09)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_10" asset catalog image.
    static var sulijoyMockAvatarBreeze10: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze10)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_11" asset catalog image.
    static var sulijoyMockAvatarBreeze11: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze11)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_12" asset catalog image.
    static var sulijoyMockAvatarBreeze12: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarBreeze12)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_01" asset catalog image.
    static var sulijoyMockAvatarSun01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun01)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_02" asset catalog image.
    static var sulijoyMockAvatarSun02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun02)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_03" asset catalog image.
    static var sulijoyMockAvatarSun03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun03)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_04" asset catalog image.
    static var sulijoyMockAvatarSun04: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun04)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_05" asset catalog image.
    static var sulijoyMockAvatarSun05: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun05)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_06" asset catalog image.
    static var sulijoyMockAvatarSun06: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun06)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_07" asset catalog image.
    static var sulijoyMockAvatarSun07: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun07)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_08" asset catalog image.
    static var sulijoyMockAvatarSun08: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun08)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_09" asset catalog image.
    static var sulijoyMockAvatarSun09: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun09)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_10" asset catalog image.
    static var sulijoyMockAvatarSun10: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun10)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_11" asset catalog image.
    static var sulijoyMockAvatarSun11: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun11)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_12" asset catalog image.
    static var sulijoyMockAvatarSun12: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyMockAvatarSun12)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_media_remove_mark" asset catalog image.
    static var sulijoyPostMediaRemoveMark: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyPostMediaRemoveMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_photo_slot_camera" asset catalog image.
    static var sulijoyPostPhotoSlotCamera: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyPostPhotoSlotCamera)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_record_mic" asset catalog image.
    static var sulijoyPostRecordMic: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyPostRecordMic)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_record_pause" asset catalog image.
    static var sulijoyPostRecordPause: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyPostRecordPause)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_record_play" asset catalog image.
    static var sulijoyPostRecordPlay: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyPostRecordPlay)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_record_retry" asset catalog image.
    static var sulijoyPostRecordRetry: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyPostRecordRetry)
#else
        .init()
#endif
    }

    /// The "sulijoy_shell_coin_gem" asset catalog image.
    static var sulijoyShellCoinGem: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyShellCoinGem)
#else
        .init()
#endif
    }

    /// The "sulijoy_shore_location_pin" asset catalog image.
    static var sulijoyShoreLocationPin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyShoreLocationPin)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_feed_active" asset catalog image.
    static var sulijoyTabFeedActive: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTabFeedActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_feed_idle" asset catalog image.
    static var sulijoyTabFeedIdle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTabFeedIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_home_active" asset catalog image.
    static var sulijoyTabHomeActive: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTabHomeActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_home_idle" asset catalog image.
    static var sulijoyTabHomeIdle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTabHomeIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_profile_active" asset catalog image.
    static var sulijoyTabProfileActive: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTabProfileActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_profile_idle" asset catalog image.
    static var sulijoyTabProfileIdle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTabProfileIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_publish_active" asset catalog image.
    static var sulijoyTabPublishActive: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTabPublishActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_video_active" asset catalog image.
    static var sulijoyTabVideoActive: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTabVideoActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_video_idle" asset catalog image.
    static var sulijoyTabVideoIdle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTabVideoIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_tide_room_close_mark" asset catalog image.
    static var sulijoyTideRoomCloseMark: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTideRoomCloseMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_tide_room_exit_badge" asset catalog image.
    static var sulijoyTideRoomExitBadge: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTideRoomExitBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_tide_room_send_mark" asset catalog image.
    static var sulijoyTideRoomSendMark: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTideRoomSendMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_tide_room_sunset_bg" asset catalog image.
    static var sulijoyTideRoomSunsetBg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTideRoomSunsetBg)
#else
        .init()
#endif
    }

    /// The "sulijoy_tide_room_warning_badge" asset catalog image.
    static var sulijoyTideRoomWarningBadge: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyTideRoomWarningBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_visitor_unlock_notice_badge" asset catalog image.
    static var sulijoyVisitorUnlockNoticeBadge: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyVisitorUnlockNoticeBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_wallet_gem_large" asset catalog image.
    static var sulijoyWalletGemLarge: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyWalletGemLarge)
#else
        .init()
#endif
    }

    /// The "sulijoy_wallet_gem_small" asset catalog image.
    static var sulijoyWalletGemSmall: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sulijoyWalletGemSmall)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "SiIcon" asset catalog image.
    static var siIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .siIcon)
#else
        .init()
#endif
    }

    /// The "launchSuliJoy" asset catalog image.
    static var launchSuliJoy: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchSuliJoy)
#else
        .init()
#endif
    }

    /// The "sulijoyHaidao" asset catalog image.
    static var sulijoyHaidao: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHaidao)
#else
        .init()
#endif
    }

    /// The "sulijoy_activity_detail_hero_sunset" asset catalog image.
    static var sulijoyActivityDetailHeroSunset: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyActivityDetailHeroSunset)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_camera_badge" asset catalog image.
    static var sulijoyAuthCameraBadge: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyAuthCameraBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_check_active" asset catalog image.
    static var sulijoyAuthCheckActive: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyAuthCheckActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_check_idle" asset catalog image.
    static var sulijoyAuthCheckIdle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyAuthCheckIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_hero_front" asset catalog image.
    static var sulijoyAuthHeroFront: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyAuthHeroFront)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_hero_left" asset catalog image.
    static var sulijoyAuthHeroLeft: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyAuthHeroLeft)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_hero_right" asset catalog image.
    static var sulijoyAuthHeroRight: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyAuthHeroRight)
#else
        .init()
#endif
    }

    /// The "sulijoy_auth_mail_badge" asset catalog image.
    static var sulijoyAuthMailBadge: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyAuthMailBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_cove_search_mark" asset catalog image.
    static var sulijoyCoveSearchMark: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyCoveSearchMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_event_create_camera_slot" asset catalog image.
    static var sulijoyEventCreateCameraSlot: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyEventCreateCameraSlot)
#else
        .init()
#endif
    }

    /// The "sulijoy_event_create_cover_badge" asset catalog image.
    static var sulijoyEventCreateCoverBadge: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyEventCreateCoverBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_audio_wave" asset catalog image.
    static var sulijoyFeedAudioWave: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedAudioWave)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_avatar_bess" asset catalog image.
    static var sulijoyFeedAvatarBess: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedAvatarBess)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_avatar_brian_may" asset catalog image.
    static var sulijoyFeedAvatarBrianMay: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedAvatarBrianMay)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_avatar_cody_hunter" asset catalog image.
    static var sulijoyFeedAvatarCodyHunter: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedAvatarCodyHunter)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_avatar_dennis_waters" asset catalog image.
    static var sulijoyFeedAvatarDennisWaters: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedAvatarDennisWaters)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_comment_mark" asset catalog image.
    static var sulijoyFeedCommentMark: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedCommentMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_comment_send_mark" asset catalog image.
    static var sulijoyFeedCommentSendMark: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedCommentSendMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_detail_bottom_gradient" asset catalog image.
    static var sulijoyFeedDetailBottomGradient: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedDetailBottomGradient)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_follow_plus" asset catalog image.
    static var sulijoyFeedFollowPlus: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedFollowPlus)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_like_active" asset catalog image.
    static var sulijoyFeedLikeActive: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedLikeActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_like_idle" asset catalog image.
    static var sulijoyFeedLikeIdle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedLikeIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_coast_01" asset catalog image.
    static var sulijoyFeedMomentCoast01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedMomentCoast01)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_coast_02" asset catalog image.
    static var sulijoyFeedMomentCoast02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedMomentCoast02)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_coast_03" asset catalog image.
    static var sulijoyFeedMomentCoast03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedMomentCoast03)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_coast_04" asset catalog image.
    static var sulijoyFeedMomentCoast04: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedMomentCoast04)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_coast_05" asset catalog image.
    static var sulijoyFeedMomentCoast05: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedMomentCoast05)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_moment_resort_01" asset catalog image.
    static var sulijoyFeedMomentResort01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedMomentResort01)
#else
        .init()
#endif
    }

    /// The "sulijoy_feed_send_mark" asset catalog image.
    static var sulijoyFeedSendMark: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyFeedSendMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_blue_picnic_01" asset catalog image.
    static var sulijoyHomeActivityBluePicnic01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityBluePicnic01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_blue_picnic_02" asset catalog image.
    static var sulijoyHomeActivityBluePicnic02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityBluePicnic02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_blue_picnic_03" asset catalog image.
    static var sulijoyHomeActivityBluePicnic03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityBluePicnic03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_golden_walk_01" asset catalog image.
    static var sulijoyHomeActivityGoldenWalk01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityGoldenWalk01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_golden_walk_02" asset catalog image.
    static var sulijoyHomeActivityGoldenWalk02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityGoldenWalk02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_golden_walk_03" asset catalog image.
    static var sulijoyHomeActivityGoldenWalk03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityGoldenWalk03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_market_hunt_01" asset catalog image.
    static var sulijoyHomeActivityMarketHunt01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityMarketHunt01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_market_hunt_02" asset catalog image.
    static var sulijoyHomeActivityMarketHunt02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityMarketHunt02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_market_hunt_03" asset catalog image.
    static var sulijoyHomeActivityMarketHunt03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityMarketHunt03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sporty_social_01" asset catalog image.
    static var sulijoyHomeActivitySportySocial01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivitySportySocial01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sporty_social_02" asset catalog image.
    static var sulijoyHomeActivitySportySocial02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivitySportySocial02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sporty_social_03" asset catalog image.
    static var sulijoyHomeActivitySportySocial03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivitySportySocial03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sunset_01" asset catalog image.
    static var sulijoyHomeActivitySunset01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivitySunset01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sunset_02" asset catalog image.
    static var sulijoyHomeActivitySunset02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivitySunset02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_sunset_03" asset catalog image.
    static var sulijoyHomeActivitySunset03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivitySunset03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_tropical_party_01" asset catalog image.
    static var sulijoyHomeActivityTropicalParty01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityTropicalParty01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_tropical_party_02" asset catalog image.
    static var sulijoyHomeActivityTropicalParty02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityTropicalParty02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_activity_tropical_party_03" asset catalog image.
    static var sulijoyHomeActivityTropicalParty03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeActivityTropicalParty03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_ai_banner_art" asset catalog image.
    static var sulijoyHomeAiBannerArt: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeAiBannerArt)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_ai_banner_palm" asset catalog image.
    static var sulijoyHomeAiBannerPalm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeAiBannerPalm)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_closed_01" asset catalog image.
    static var sulijoyHomeEventClosed01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeEventClosed01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_closed_02" asset catalog image.
    static var sulijoyHomeEventClosed02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeEventClosed02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_closed_03" asset catalog image.
    static var sulijoyHomeEventClosed03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeEventClosed03)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_open_badge" asset catalog image.
    static var sulijoyHomeEventOpenBadge: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeEventOpenBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_sunset_01" asset catalog image.
    static var sulijoyHomeEventSunset01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeEventSunset01)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_sunset_02" asset catalog image.
    static var sulijoyHomeEventSunset02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeEventSunset02)
#else
        .init()
#endif
    }

    /// The "sulijoy_home_event_sunset_03" asset catalog image.
    static var sulijoyHomeEventSunset03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyHomeEventSunset03)
#else
        .init()
#endif
    }

    /// The "sulijoy_island_avatar_guest_01" asset catalog image.
    static var sulijoyIslandAvatarGuest01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyIslandAvatarGuest01)
#else
        .init()
#endif
    }

    /// The "sulijoy_island_avatar_guest_02" asset catalog image.
    static var sulijoyIslandAvatarGuest02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyIslandAvatarGuest02)
#else
        .init()
#endif
    }

    /// The "sulijoy_island_avatar_guest_03" asset catalog image.
    static var sulijoyIslandAvatarGuest03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyIslandAvatarGuest03)
#else
        .init()
#endif
    }

    /// The "sulijoy_island_avatar_guest_04" asset catalog image.
    static var sulijoyIslandAvatarGuest04: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyIslandAvatarGuest04)
#else
        .init()
#endif
    }

    /// The "sulijoy_island_avatar_guest_05" asset catalog image.
    static var sulijoyIslandAvatarGuest05: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyIslandAvatarGuest05)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_01" asset catalog image.
    static var sulijoyMockAvatarBreeze01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze01)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_02" asset catalog image.
    static var sulijoyMockAvatarBreeze02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze02)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_03" asset catalog image.
    static var sulijoyMockAvatarBreeze03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze03)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_04" asset catalog image.
    static var sulijoyMockAvatarBreeze04: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze04)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_05" asset catalog image.
    static var sulijoyMockAvatarBreeze05: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze05)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_06" asset catalog image.
    static var sulijoyMockAvatarBreeze06: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze06)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_07" asset catalog image.
    static var sulijoyMockAvatarBreeze07: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze07)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_08" asset catalog image.
    static var sulijoyMockAvatarBreeze08: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze08)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_09" asset catalog image.
    static var sulijoyMockAvatarBreeze09: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze09)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_10" asset catalog image.
    static var sulijoyMockAvatarBreeze10: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze10)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_11" asset catalog image.
    static var sulijoyMockAvatarBreeze11: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze11)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_breeze_12" asset catalog image.
    static var sulijoyMockAvatarBreeze12: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarBreeze12)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_01" asset catalog image.
    static var sulijoyMockAvatarSun01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun01)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_02" asset catalog image.
    static var sulijoyMockAvatarSun02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun02)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_03" asset catalog image.
    static var sulijoyMockAvatarSun03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun03)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_04" asset catalog image.
    static var sulijoyMockAvatarSun04: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun04)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_05" asset catalog image.
    static var sulijoyMockAvatarSun05: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun05)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_06" asset catalog image.
    static var sulijoyMockAvatarSun06: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun06)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_07" asset catalog image.
    static var sulijoyMockAvatarSun07: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun07)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_08" asset catalog image.
    static var sulijoyMockAvatarSun08: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun08)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_09" asset catalog image.
    static var sulijoyMockAvatarSun09: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun09)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_10" asset catalog image.
    static var sulijoyMockAvatarSun10: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun10)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_11" asset catalog image.
    static var sulijoyMockAvatarSun11: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun11)
#else
        .init()
#endif
    }

    /// The "sulijoy_mock_avatar_sun_12" asset catalog image.
    static var sulijoyMockAvatarSun12: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyMockAvatarSun12)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_media_remove_mark" asset catalog image.
    static var sulijoyPostMediaRemoveMark: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyPostMediaRemoveMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_photo_slot_camera" asset catalog image.
    static var sulijoyPostPhotoSlotCamera: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyPostPhotoSlotCamera)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_record_mic" asset catalog image.
    static var sulijoyPostRecordMic: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyPostRecordMic)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_record_pause" asset catalog image.
    static var sulijoyPostRecordPause: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyPostRecordPause)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_record_play" asset catalog image.
    static var sulijoyPostRecordPlay: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyPostRecordPlay)
#else
        .init()
#endif
    }

    /// The "sulijoy_post_record_retry" asset catalog image.
    static var sulijoyPostRecordRetry: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyPostRecordRetry)
#else
        .init()
#endif
    }

    /// The "sulijoy_shell_coin_gem" asset catalog image.
    static var sulijoyShellCoinGem: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyShellCoinGem)
#else
        .init()
#endif
    }

    /// The "sulijoy_shore_location_pin" asset catalog image.
    static var sulijoyShoreLocationPin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyShoreLocationPin)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_feed_active" asset catalog image.
    static var sulijoyTabFeedActive: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTabFeedActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_feed_idle" asset catalog image.
    static var sulijoyTabFeedIdle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTabFeedIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_home_active" asset catalog image.
    static var sulijoyTabHomeActive: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTabHomeActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_home_idle" asset catalog image.
    static var sulijoyTabHomeIdle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTabHomeIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_profile_active" asset catalog image.
    static var sulijoyTabProfileActive: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTabProfileActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_profile_idle" asset catalog image.
    static var sulijoyTabProfileIdle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTabProfileIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_publish_active" asset catalog image.
    static var sulijoyTabPublishActive: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTabPublishActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_video_active" asset catalog image.
    static var sulijoyTabVideoActive: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTabVideoActive)
#else
        .init()
#endif
    }

    /// The "sulijoy_tab_video_idle" asset catalog image.
    static var sulijoyTabVideoIdle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTabVideoIdle)
#else
        .init()
#endif
    }

    /// The "sulijoy_tide_room_close_mark" asset catalog image.
    static var sulijoyTideRoomCloseMark: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTideRoomCloseMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_tide_room_exit_badge" asset catalog image.
    static var sulijoyTideRoomExitBadge: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTideRoomExitBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_tide_room_send_mark" asset catalog image.
    static var sulijoyTideRoomSendMark: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTideRoomSendMark)
#else
        .init()
#endif
    }

    /// The "sulijoy_tide_room_sunset_bg" asset catalog image.
    static var sulijoyTideRoomSunsetBg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTideRoomSunsetBg)
#else
        .init()
#endif
    }

    /// The "sulijoy_tide_room_warning_badge" asset catalog image.
    static var sulijoyTideRoomWarningBadge: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyTideRoomWarningBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_visitor_unlock_notice_badge" asset catalog image.
    static var sulijoyVisitorUnlockNoticeBadge: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyVisitorUnlockNoticeBadge)
#else
        .init()
#endif
    }

    /// The "sulijoy_wallet_gem_large" asset catalog image.
    static var sulijoyWalletGemLarge: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyWalletGemLarge)
#else
        .init()
#endif
    }

    /// The "sulijoy_wallet_gem_small" asset catalog image.
    static var sulijoyWalletGemSmall: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sulijoyWalletGemSmall)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

