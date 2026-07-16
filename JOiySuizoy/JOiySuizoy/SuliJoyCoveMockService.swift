import Foundation

final class SuliJoyCoveMockService {
    static let shared = SuliJoyCoveMockService()

    private var activities: [SuliJoyTideActivity]
    private var stylists: [SuliJoyLagoonStylist]
    private var moments: [SuliJoyShoreMoment]
    private var shellClips: [SuliJoyShellClip]
    private var talkSpaces: [String: SuliJoyTideTalkSpace]
    private var blockedShoreAuthors: Set<String>
    private var currentLagoonFollowedAuthors: Set<String>
    private var mutualLagoonAuthors: Set<String>
    private var reportedLagoonVisitors: Set<String>

    private init() {
        talkSpaces = [:]
        blockedShoreAuthors = []
        currentLagoonFollowedAuthors = ["Bess", "Brian May", "Cody Hunter"]
        mutualLagoonAuthors = ["Brian May"]
        reportedLagoonVisitors = []
        shellClips = []
        activities = [
            SuliJoyTideActivity(
                tideID: "tide_sunset_style_party",
                dayText: "7/15",
                meridiem: "AM",
                timeText: "8:00",
                shoreScheduleText: "Sat, Jul 18, 2026 · 5:30 PM",
                title: "Island Sunset Style Party",
                shoreHostName: "Bess",
                location: "Waikiki Beach · Hawaii, USA",
                summary: "Wear your favorite island-inspired outfit and enjoy a beautiful sunset with relaxed icebreakers, a beach walk, and casual photo time.",
                detailHeroAssetName: "sulijoy_activity_detail_hero_sunset",
                shoreBrief: "Wear your favorite island-inspired outfit and enjoy a beautiful sunset at Waikiki Beach. The event includes relaxed icebreakers, a beach walk, and casual photo time. Perfect for meeting new people and enjoying a laid-back vibe. No experience needed—just bring good energy.",
                relatedTideIDs: ["tide_golden_photo_walk", "tide_blue_white_picnic", "tide_market_style_hunt", "tide_tropical_print_party"],
                status: .open,
                isReportedLocally: false,
                joinedCount: 12,
                capacity: 20,
                gemCost: 100,
                media: [
                    SuliJoyReefMedia(mediaID: "sunset_01", kind: .image, assetName: "sulijoy_home_activity_sunset_01", caption: "Sunset lounge"),
                    SuliJoyReefMedia(mediaID: "sunset_02", kind: .image, assetName: "sulijoy_home_activity_sunset_02", caption: "Palm styling table"),
                    SuliJoyReefMedia(mediaID: "sunset_03", kind: .image, assetName: "sulijoy_home_activity_sunset_03", caption: "Coastal friends")
                ],
                avatarAssetNames: [
                    "sulijoy_mock_avatar_breeze_01",
                    "sulijoy_mock_avatar_breeze_02",
                    "sulijoy_mock_avatar_breeze_03",
                    "sulijoy_mock_avatar_breeze_04",
                    "sulijoy_mock_avatar_breeze_05"
                ]
            ),
            SuliJoyTideActivity(
                tideID: "tide_golden_photo_walk",
                dayText: "7/24",
                meridiem: "PM",
                timeText: "6:00",
                shoreScheduleText: "Fri, Jul 24, 2026 · 6:00 PM",
                title: "Golden Hour Beach Photo Walk",
                shoreHostName: "Cody Hunter",
                location: "Barceloneta Beach · Barcelona, Spain",
                summary: "Walk the beach during golden hour, capture beautiful moments, and connect through fashion, photography, and seaside light.",
                detailHeroAssetName: "sulijoy_activity_detail_hero_sunset",
                shoreBrief: "Walk along the beach during golden hour and capture beautiful moments together. Ideal for those who enjoy photography, fashion, or simply the seaside atmosphere. Help each other take photos or just relax and connect.",
                relatedTideIDs: ["tide_sunset_style_party", "tide_blue_white_picnic", "tide_market_style_hunt", "tide_tropical_print_party"],
                status: .open,
                isReportedLocally: false,
                joinedCount: 9,
                capacity: 16,
                gemCost: 90,
                media: [
                    SuliJoyReefMedia(mediaID: "golden_walk_01", kind: .image, assetName: "sulijoy_home_activity_golden_walk_01", caption: "Golden drinks"),
                    SuliJoyReefMedia(mediaID: "golden_walk_02", kind: .image, assetName: "sulijoy_home_activity_golden_walk_02", caption: "Beach portrait"),
                    SuliJoyReefMedia(mediaID: "golden_walk_03", kind: .image, assetName: "sulijoy_home_activity_golden_walk_03", caption: "Palm sunset")
                ],
                avatarAssetNames: [
                    "sulijoy_mock_avatar_sun_01",
                    "sulijoy_mock_avatar_sun_02",
                    "sulijoy_mock_avatar_sun_03",
                    "sulijoy_mock_avatar_breeze_06"
                ]
            ),
            SuliJoyTideActivity(
                tideID: "tide_blue_white_picnic",
                dayText: "8/1",
                meridiem: "PM",
                timeText: "4:30",
                shoreScheduleText: "Sat, Aug 1, 2026 · 4:30 PM",
                title: "Mediterranean Blue & White Picnic",
                shoreHostName: "Brian May",
                location: "Oia Viewpoint · Santorini, Greece",
                summary: "Enjoy a blue and white dress-theme picnic with simple snacks, shared food, relaxed chat, and romantic coastal photos.",
                detailHeroAssetName: "sulijoy_activity_detail_hero_sunset",
                shoreBrief: "Enjoy a Mediterranean-style picnic with a blue and white dress theme at one of Santorini’s most scenic spots. Bring simple snacks, share food, chat, and take photos in a relaxed and romantic setting.",
                relatedTideIDs: ["tide_sunset_style_party", "tide_golden_photo_walk", "tide_market_style_hunt", "tide_tropical_print_party"],
                status: .open,
                isReportedLocally: false,
                joinedCount: 14,
                capacity: 18,
                gemCost: 120,
                media: [
                    SuliJoyReefMedia(mediaID: "blue_picnic_01", kind: .image, assetName: "sulijoy_home_activity_blue_picnic_01", caption: "Seaside picnic"),
                    SuliJoyReefMedia(mediaID: "blue_picnic_02", kind: .image, assetName: "sulijoy_home_activity_blue_picnic_02", caption: "Blue table"),
                    SuliJoyReefMedia(mediaID: "blue_picnic_03", kind: .image, assetName: "sulijoy_home_activity_blue_picnic_03", caption: "Beach setting")
                ],
                avatarAssetNames: [
                    "sulijoy_mock_avatar_breeze_07",
                    "sulijoy_mock_avatar_breeze_08",
                    "sulijoy_mock_avatar_breeze_09",
                    "sulijoy_mock_avatar_sun_04",
                    "sulijoy_mock_avatar_sun_05"
                ]
            ),
            SuliJoyTideActivity(
                tideID: "tide_market_style_hunt",
                dayText: "8/15",
                meridiem: "PM",
                timeText: "3:00",
                shoreScheduleText: "Sat, Aug 15, 2026 · 3:00 PM",
                title: "Island Market Style Hunt",
                shoreHostName: "Dennis Waters",
                location: "Phuket Weekend Market · Phuket, Thailand",
                summary: "Explore a vibrant island market together, discover boutique fashion finds, and leave room for casual photo moments.",
                detailHeroAssetName: "sulijoy_activity_detail_hero_sunset",
                shoreBrief: "Explore a vibrant island market together and discover unique fashion inspiration and coastal finds. Includes free browsing, social interaction, and casual photo moments.",
                relatedTideIDs: ["tide_sunset_style_party", "tide_golden_photo_walk", "tide_blue_white_picnic", "tide_tropical_print_party"],
                status: .open,
                isReportedLocally: false,
                joinedCount: 8,
                capacity: 20,
                gemCost: 80,
                media: [
                    SuliJoyReefMedia(mediaID: "market_hunt_01", kind: .image, assetName: "sulijoy_home_activity_market_hunt_01", caption: "Market coconut"),
                    SuliJoyReefMedia(mediaID: "market_hunt_02", kind: .image, assetName: "sulijoy_home_activity_market_hunt_02", caption: "Night market"),
                    SuliJoyReefMedia(mediaID: "market_hunt_03", kind: .image, assetName: "sulijoy_home_activity_market_hunt_03", caption: "Island look")
                ],
                avatarAssetNames: [
                    "sulijoy_mock_avatar_sun_06",
                    "sulijoy_mock_avatar_sun_07",
                    "sulijoy_mock_avatar_breeze_10",
                    "sulijoy_mock_avatar_breeze_11"
                ]
            ),
            SuliJoyTideActivity(
                tideID: "tide_tropical_print_party",
                dayText: "9/5",
                meridiem: "PM",
                timeText: "5:30",
                shoreScheduleText: "Sat, Sep 5, 2026 · 5:30 PM",
                title: "Tropical Print Beach Party",
                shoreHostName: "Dennis Waters",
                location: "Paradise Beach · Tulum, Mexico",
                summary: "Wear tropical prints and enjoy music, sunset, and social beach vibes in a lively but relaxed gathering.",
                detailHeroAssetName: "sulijoy_activity_detail_hero_sunset",
                shoreBrief: "Wear tropical prints and enjoy music, sunset, and social vibes on the beach. A lively yet relaxed gathering for meeting new people and unwinding.",
                relatedTideIDs: ["tide_sunset_style_party", "tide_golden_photo_walk", "tide_blue_white_picnic", "tide_market_style_hunt"],
                status: .open,
                isReportedLocally: false,
                joinedCount: 17,
                capacity: 24,
                gemCost: 110,
                media: [
                    SuliJoyReefMedia(mediaID: "tropical_party_01", kind: .image, assetName: "sulijoy_home_activity_tropical_party_01", caption: "Tropical print"),
                    SuliJoyReefMedia(mediaID: "tropical_party_02", kind: .image, assetName: "sulijoy_home_activity_tropical_party_02", caption: "Party friends"),
                    SuliJoyReefMedia(mediaID: "tropical_party_03", kind: .image, assetName: "sulijoy_home_activity_tropical_party_03", caption: "Sunset outfit")
                ],
                avatarAssetNames: [
                    "sulijoy_mock_avatar_breeze_12",
                    "sulijoy_mock_avatar_sun_08",
                    "sulijoy_mock_avatar_sun_09",
                    "sulijoy_mock_avatar_sun_10",
                    "sulijoy_mock_avatar_breeze_01"
                ]
            ),
            SuliJoyTideActivity(
                tideID: "tide_sporty_coastal_social",
                dayText: "9/12",
                meridiem: "AM",
                timeText: "10:00",
                shoreScheduleText: "Sat, Sep 12, 2026 · 10:00 AM",
                title: "Sporty Coastal Social Day",
                shoreHostName: "Cody Hunter",
                location: "Bondi Beach · Sydney, Australia",
                summary: "Join light beach activities, relax by the coast, and connect with others who enjoy an active seaside lifestyle.",
                detailHeroAssetName: "sulijoy_activity_detail_hero_sunset",
                shoreBrief: "A beach event combining light sports and social interaction. Join casual beach activities or simply relax and connect with others who enjoy an active lifestyle.",
                relatedTideIDs: ["tide_sunset_style_party", "tide_golden_photo_walk", "tide_blue_white_picnic", "tide_market_style_hunt"],
                status: .closed,
                isReportedLocally: false,
                joinedCount: 18,
                capacity: 18,
                gemCost: 70,
                media: [
                    SuliJoyReefMedia(mediaID: "sporty_social_01", kind: .image, assetName: "sulijoy_home_activity_sporty_social_01", caption: "Sporty beach"),
                    SuliJoyReefMedia(mediaID: "sporty_social_02", kind: .image, assetName: "sulijoy_home_activity_sporty_social_02", caption: "Coastal walk"),
                    SuliJoyReefMedia(mediaID: "sporty_social_03", kind: .image, assetName: "sulijoy_home_activity_sporty_social_03", caption: "Beach sport")
                ],
                avatarAssetNames: [
                    "sulijoy_mock_avatar_sun_11",
                    "sulijoy_mock_avatar_sun_12",
                    "sulijoy_mock_avatar_breeze_02",
                    "sulijoy_mock_avatar_breeze_03"
                ]
            )
        ]
        activities.insert(contentsOf: Self.loadLocalPublishedActivities(), at: 0)
        talkSpaces = Dictionary(uniqueKeysWithValues: activities.map { activity in
            (activity.tideID, Self.makeTalkSpace(from: activity))
        })

        stylists = [
            SuliJoyLagoonStylist(stylistID: "stylist_brian_may", displayName: "Brian May", avatarAssetName: "sulijoy_feed_avatar_brian_may", followingCount: 3, followerCount: 4),
            SuliJoyLagoonStylist(stylistID: "stylist_cody_hunter", displayName: "Cody Hunter", avatarAssetName: "sulijoy_feed_avatar_cody_hunter", followingCount: 2, followerCount: 3),
            SuliJoyLagoonStylist(stylistID: "stylist_bess", displayName: "Bess", avatarAssetName: "sulijoy_feed_avatar_bess", followingCount: 1, followerCount: 4),
            SuliJoyLagoonStylist(stylistID: "stylist_dennis_waters", displayName: "Dennis Waters", avatarAssetName: "sulijoy_feed_avatar_dennis_waters", followingCount: 4, followerCount: 2)
        ]

        moments = [
            SuliJoyShoreMoment(
                momentID: "moment_bess_recommend",
                authorName: "Bess",
                authorHandle: "@bess.shore",
                authorStyleLine: "Pastel beach layers · Waikiki",
                authorAvatarAssetName: "sulijoy_feed_avatar_bess",
                timeAgo: "4 mins ago",
                shorePlaceText: "Waikiki Beach · Hawaii, USA",
                shoreTimeText: "Jul 18, 2026 · 5:30 PM",
                body: "Soft blue and pink tees feel easy for a windy beach walk. The oversized flower print keeps the photos bright without trying too hard.",
                media: [
                    SuliJoyReefMedia(mediaID: "coast_01", kind: .image, assetName: "sulijoy_feed_moment_coast_01", caption: "Beach flower tee"),
                    SuliJoyReefMedia(mediaID: "coast_02", kind: .image, assetName: "sulijoy_feed_moment_coast_02", caption: "Pastel shore pair"),
                    SuliJoyReefMedia(mediaID: "coast_03", kind: .image, assetName: "sulijoy_feed_moment_coast_03", caption: "Sunset walk back")
                ],
                audioNote: SuliJoyWaveAudioNote(noteID: "audio_bess", duration: 18, waveformAssetName: "sulijoy_feed_audio_wave", audioFileName: "sulijoy_shore_audio_keila.mp3", isPlaying: false, progress: 0),
                likeCount: 6,
                commentCount: 3,
                comments: [
                    SuliJoyShoreComment(commentID: "comment_bess_1", commenterName: "Cody Hunter", commenterAvatarAssetName: "sulijoy_feed_avatar_cody_hunter", text: "The pastel colors work really well with the sea light.", timeAgo: "2 mins ago"),
                    SuliJoyShoreComment(commentID: "comment_bess_2", commenterName: "Dennis Waters", commenterAvatarAssetName: "sulijoy_feed_avatar_dennis_waters", text: "That oversized tee is perfect for a casual sunset photo.", timeAgo: "1 min ago"),
                    SuliJoyShoreComment(commentID: "comment_bess_3", commenterName: "Brian May", commenterAvatarAssetName: "sulijoy_feed_avatar_brian_may", text: "Clean, relaxed, and still memorable.", timeAgo: "just now")
                ],
                isLiked: false,
                filter: .recommend,
                isBlocked: false,
                isReportedLocally: false
            ),
            SuliJoyShoreMoment(
                momentID: "moment_dennis_hot",
                authorName: "Dennis Waters",
                authorHandle: "@dennis.coast",
                authorStyleLine: "Printed resort shirt · garden lunch",
                authorAvatarAssetName: "sulijoy_feed_avatar_dennis_waters",
                timeAgo: "9 mins ago",
                shorePlaceText: "Paradise Beach · Tulum, Mexico",
                shoreTimeText: "Sep 5, 2026 · 5:30 PM",
                body: "A light printed shirt is enough when the setting already has color. I like keeping jewelry warm and the fit loose.",
                media: [
                    SuliJoyReefMedia(mediaID: "coast_04", kind: .image, assetName: "sulijoy_feed_moment_coast_04", caption: "Printed island shirt"),
                    SuliJoyReefMedia(mediaID: "coast_05", kind: .image, assetName: "sulijoy_feed_moment_coast_05", caption: "Resort lunch look")
                ],
                audioNote: SuliJoyWaveAudioNote(noteID: "audio_dennis", duration: 21, waveformAssetName: "sulijoy_feed_audio_wave", audioFileName: "sulijoy_shore_audio_elei_island.mp3", isPlaying: false, progress: 0),
                likeCount: 8,
                commentCount: 2,
                comments: [
                    SuliJoyShoreComment(commentID: "comment_dennis_1", commenterName: "Bess", commenterAvatarAssetName: "sulijoy_feed_avatar_bess", text: "The shirt pattern feels beachy but still neat.", timeAgo: "5 mins ago"),
                    SuliJoyShoreComment(commentID: "comment_dennis_2", commenterName: "Cody Hunter", commenterAvatarAssetName: "sulijoy_feed_avatar_cody_hunter", text: "Warm jewelry was the right call here.", timeAgo: "3 mins ago")
                ],
                isLiked: true,
                filter: .recommend,
                isBlocked: false,
                isReportedLocally: false
            ),
            SuliJoyShoreMoment(
                momentID: "moment_cody_hot",
                authorName: "Cody Hunter",
                authorHandle: "@cody.linen",
                authorStyleLine: "Linen walk set · Barcelona",
                authorAvatarAssetName: "sulijoy_feed_avatar_cody_hunter",
                timeAgo: "8 mins ago",
                shorePlaceText: "Barcelona Beach · Barcelona, Spain",
                shoreTimeText: "Jul 24, 2026 · 6:00 PM",
                body: "A linen shirt and simple shorts still feel right for golden hour. I would rather keep the silhouette clean than add too many pieces.",
                media: [
                    SuliJoyReefMedia(mediaID: "coast_03_hot", kind: .image, assetName: "sulijoy_feed_moment_coast_03", caption: "Sunset walk")
                ],
                audioNote: SuliJoyWaveAudioNote(noteID: "audio_cody", duration: 16, waveformAssetName: "sulijoy_feed_audio_wave", audioFileName: "sulijoy_shore_audio_sablereid.mp3", isPlaying: false, progress: 0),
                likeCount: 4,
                commentCount: 1,
                comments: [
                    SuliJoyShoreComment(commentID: "comment_cody_1", commenterName: "Brian May", commenterAvatarAssetName: "sulijoy_feed_avatar_brian_may", text: "Clean silhouette, easy to copy.", timeAgo: "4 mins ago")
                ],
                isLiked: false,
                filter: .hot,
                isBlocked: false,
                isReportedLocally: false
            ),
            SuliJoyShoreMoment(
                momentID: "moment_brian_followed",
                authorName: "Brian May",
                authorHandle: "@brian.blue",
                authorStyleLine: "Blue-white picnic mood · Santorini",
                authorAvatarAssetName: "sulijoy_feed_avatar_brian_may",
                timeAgo: "12 mins ago",
                shorePlaceText: "Oia Viewpoint · Santorini, Greece",
                shoreTimeText: "Aug 1, 2026 · 4:30 PM",
                body: "For blue-water backgrounds, pale shirts and soft accessories read cleaner. A quiet palette makes the location feel bigger.",
                media: [
                    SuliJoyReefMedia(mediaID: "coast_02_followed", kind: .image, assetName: "sulijoy_feed_moment_coast_02", caption: "Pastel pair"),
                    SuliJoyReefMedia(mediaID: "coast_01_followed", kind: .image, assetName: "sulijoy_feed_moment_coast_01", caption: "Beach tee detail")
                ],
                audioNote: SuliJoyWaveAudioNote(noteID: "audio_brian", duration: 19, waveformAssetName: "sulijoy_feed_audio_wave", audioFileName: "sulijoy_shore_audio_jess_ortiz.mp3", isPlaying: false, progress: 0),
                likeCount: 5,
                commentCount: 2,
                comments: [
                    SuliJoyShoreComment(commentID: "comment_brian_1", commenterName: "Bess", commenterAvatarAssetName: "sulijoy_feed_avatar_bess", text: "The quiet palette makes the photos softer.", timeAgo: "7 mins ago"),
                    SuliJoyShoreComment(commentID: "comment_brian_2", commenterName: "Dennis Waters", commenterAvatarAssetName: "sulijoy_feed_avatar_dennis_waters", text: "Good note about letting the background lead.", timeAgo: "5 mins ago")
                ],
                isLiked: false,
                filter: .followed,
                isBlocked: false,
                isReportedLocally: false
            ),
            SuliJoyShoreMoment(
                momentID: "moment_bess_picnic_followed",
                authorName: "Bess",
                authorHandle: "@bess.shore",
                authorStyleLine: "Soft picnic styling · Santorini",
                authorAvatarAssetName: "sulijoy_feed_avatar_bess",
                timeAgo: "15 mins ago",
                shorePlaceText: "Oia Viewpoint · Santorini, Greece",
                shoreTimeText: "Aug 1, 2026 · 4:30 PM",
                body: "A pale shirt over a swimsuit keeps the look easy after swimming. I would add a woven bag and keep the colors close to the beach table.",
                media: [
                    SuliJoyReefMedia(mediaID: "coast_04_followed_bess", kind: .image, assetName: "sulijoy_feed_moment_coast_04", caption: "Shore shirt detail"),
                    SuliJoyReefMedia(mediaID: "coast_01_followed_bess", kind: .image, assetName: "sulijoy_feed_moment_coast_01", caption: "Beach tee idea")
                ],
                audioNote: SuliJoyWaveAudioNote(noteID: "audio_bess_picnic", duration: 24, waveformAssetName: "sulijoy_feed_audio_wave", audioFileName: "sulijoy_shore_audio_angelina_blue.mp3", isPlaying: false, progress: 0),
                likeCount: 3,
                commentCount: 2,
                comments: [
                    SuliJoyShoreComment(commentID: "comment_bess_picnic_1", commenterName: "Brian May", commenterAvatarAssetName: "sulijoy_feed_avatar_brian_may", text: "The woven bag idea fits the picnic mood.", timeAgo: "9 mins ago"),
                    SuliJoyShoreComment(commentID: "comment_bess_picnic_2", commenterName: "Cody Hunter", commenterAvatarAssetName: "sulijoy_feed_avatar_cody_hunter", text: "Keeping the colors close makes it feel intentional.", timeAgo: "6 mins ago")
                ],
                isLiked: false,
                filter: .followed,
                isBlocked: false,
                isReportedLocally: false
            ),
            SuliJoyShoreMoment(
                momentID: "moment_cody_market_hot",
                authorName: "Cody Hunter",
                authorHandle: "@cody.linen",
                authorStyleLine: "Market linen layers · Phuket",
                authorAvatarAssetName: "sulijoy_feed_avatar_cody_hunter",
                timeAgo: "18 mins ago",
                shorePlaceText: "Phuket Weekend Market · Phuket, Thailand",
                shoreTimeText: "Aug 15, 2026 · 3:00 PM",
                body: "Open linen over a simple tank works well for market heat. A small necklace gives enough detail without making the outfit busy.",
                media: [
                    SuliJoyReefMedia(mediaID: "coast_05_hot_cody", kind: .image, assetName: "sulijoy_feed_moment_coast_05", caption: "Lunch linen layer"),
                    SuliJoyReefMedia(mediaID: "coast_03_hot_cody", kind: .image, assetName: "sulijoy_feed_moment_coast_03", caption: "Dusk styling")
                ],
                audioNote: SuliJoyWaveAudioNote(noteID: "audio_cody_market", duration: 22, waveformAssetName: "sulijoy_feed_audio_wave", audioFileName: "sulijoy_shore_audio_skylar_spark.mp3", isPlaying: false, progress: 0),
                likeCount: 7,
                commentCount: 1,
                comments: [
                    SuliJoyShoreComment(commentID: "comment_cody_market_1", commenterName: "Bess", commenterAvatarAssetName: "sulijoy_feed_avatar_bess", text: "The small necklace detail is enough.", timeAgo: "11 mins ago")
                ],
                isLiked: true,
                filter: .hot,
                isBlocked: false,
                isReportedLocally: false
            )
        ]
        moments.insert(contentsOf: Self.loadLocalPublishedMoments(), at: 0)
        shellClips = Self.loadLocalPublishedShellClips() + Self.makeShellClips()
        for authorName in currentLagoonFollowedAuthors {
            syncShellClipFollowState(for: authorName)
        }
    }

    func fetchHomeActivities(mode: SuliJoyCoveRequestMode = .success, completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        respond(mode: mode, empty: [], success: visibleActivities(), completion: completion)
    }

    func fetchShellClips(mode: SuliJoyCoveRequestMode = .success, completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyShellClip]>) -> Void) {
        respond(mode: mode, empty: [], success: visibleShellClips(), completion: completion)
    }

    func fetchIslandProfileSummary(completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyIslandProfileSummary>) -> Void) {
        delay {
            let profile = SuliJoyLocalProfileStore().currentProfile()
            let session = SuliJoyLagoonSessionStore().load()
            let name = profile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let avatarName = profile?.avatarPath?.isEmpty == false ? (profile?.avatarPath ?? "sulijoy_mock_avatar_breeze_01") : "sulijoy_mock_avatar_breeze_01"
            let localActivityCount = self.activities.filter { $0.tideID.hasPrefix("tide_local_") || $0.status == .joined }.count
            let localLikes = self.moments.filter { $0.momentID.hasPrefix("moment_local_") }.reduce(0) { $0 + $1.likeCount }
                + self.shellClips.filter { $0.clipID.hasPrefix("shell_clip_local_") }.reduce(0) { $0 + $1.likeCount }
            let summary = SuliJoyIslandProfileSummary(
                displayName: (name?.isEmpty == false ? name : "David") ?? "David",
                avatarAssetName: avatarName,
                islandID: Self.stableIslandID(email: session.currentEmail, fallbackUserID: session.userID),
                metrics: [
                    SuliJoyShoreProfileMetric(title: "Friends", value: self.mutualLagoonAuthors.count),
                    SuliJoyShoreProfileMetric(title: "Following", value: self.currentLagoonFollowedAuthors.count),
                    SuliJoyShoreProfileMetric(title: "Fans", value: localActivityCount),
                    SuliJoyShoreProfileMetric(title: "Likes", value: localLikes)
                ]
            )
            completion(.success(summary))
        }
    }

    func fetchMineShoreMoments(completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyShoreMoment]>) -> Void) {
        delay {
            let currentName = SuliJoyLocalProfileStore().currentProfile()?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let ownMoments = self.moments.filter { moment in
                self.isMomentVisible(moment) && (moment.momentID.hasPrefix("moment_local_") || (currentName?.isEmpty == false && moment.authorName == currentName))
            }
            completion(.success(ownMoments))
        }
    }

    func fetchMineShellClips(completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyShellClip]>) -> Void) {
        delay {
            let currentName = SuliJoyLocalProfileStore().currentProfile()?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let ownClips = self.shellClips.filter { clip in
                clip.clipID.hasPrefix("shell_clip_local_") || (currentName?.isEmpty == false && clip.creator.displayName == currentName)
            }
            completion(.success(ownClips))
        }
    }

    func fetchMineTideActivities(completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        delay {
            let currentName = SuliJoyLocalProfileStore().currentProfile()?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let ownActivities = self.visibleActivities().filter { activity in
                activity.tideID.hasPrefix("tide_local_")
                    || activity.status == .joined
                    || (currentName?.isEmpty == false && activity.shoreHostName == currentName)
            }
            completion(.success(ownActivities))
        }
    }

    func fetchShellClipDetail(clipID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShellClip>) -> Void) {
        delay {
            guard let clip = self.shellClips.first(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            completion(.success(clip))
        }
    }

    func publishReefClip(draft: SuliJoyReefClipDraft, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShellClip>) -> Void) {
        delay {
            let trimmedCaption = draft.caption.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedCaption.isEmpty || draft.media != nil else {
                completion(.failure("Please add a video or content."))
                return
            }
            let profile = SuliJoyLocalProfileStore().currentProfile()
            let nickname = profile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let creatorName = (nickname?.isEmpty == false ? nickname : "You") ?? "You"
            let avatarName = profile?.avatarPath?.isEmpty == false ? (profile?.avatarPath ?? "sulijoy_mock_avatar_breeze_01") : "sulijoy_mock_avatar_breeze_01"
            let localVideoName = draft.media?.localVideoPath ?? "sulijoy_shorts_island_style_01"
            let clip = SuliJoyShellClip(
                clipID: "shell_clip_local_\(UUID().uuidString.prefix(8))",
                creator: SuliJoyLagoonClipCreator(
                    creatorID: "clip_creator_local_\(creatorName.lowercased().replacingOccurrences(of: " ", with: "_"))",
                    displayName: creatorName,
                    avatarAssetName: avatarName
                ),
                caption: trimmedCaption.isEmpty ? "A fresh island style clip from SuliJoy." : trimmedCaption,
                media: SuliJoyReefClipMedia(
                    mediaID: "reef_clip_local_media_\(UUID().uuidString.prefix(8))",
                    localVideoFileName: localVideoName,
                    fallbackCoverAssetName: draft.media?.coverImagePath ?? "sulijoy_feed_moment_coast_01"
                ),
                likeCount: 0,
                commentCount: 0,
                comments: [],
                isLiked: false,
                isFollowed: true,
                isReportedLocally: false
            )
            self.shellClips.insert(clip, at: 0)
            self.persistLocalPublishedShellClips()
            completion(.success(clip, message: "Clip posted."))
        }
    }

    func toggleShellClipLike(clipID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShellClip>) -> Void) {
        delay {
            guard let index = self.shellClips.firstIndex(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            self.shellClips[index].isLiked.toggle()
            self.shellClips[index].likeCount = max(0, self.shellClips[index].likeCount + (self.shellClips[index].isLiked ? 1 : -1))
            self.persistLocalPublishedShellClips()
            completion(.success(self.shellClips[index]))
        }
    }

    func toggleShellClipFollow(clipID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShellClip>) -> Void) {
        delay {
            guard let index = self.shellClips.firstIndex(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            let creatorName = self.shellClips[index].creator.displayName
            if self.currentLagoonFollowedAuthors.contains(creatorName) {
                self.currentLagoonFollowedAuthors.remove(creatorName)
                self.mutualLagoonAuthors.remove(creatorName)
            } else {
                self.currentLagoonFollowedAuthors.insert(creatorName)
            }
            self.syncShellClipFollowState(for: creatorName)
            self.persistLocalPublishedShellClips()
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            completion(.success(self.shellClips[index], message: self.shellClips[index].isFollowed ? "Followed." : "Unfollowed."))
        }
    }

    func toggleShellClipFollow(creatorName: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShellClip>) -> Void) {
        delay {
            guard let index = self.shellClips.firstIndex(where: { $0.creator.displayName == creatorName }) else {
                completion(.failure("Creator not found.", code: 404))
                return
            }
            if self.currentLagoonFollowedAuthors.contains(creatorName) {
                self.currentLagoonFollowedAuthors.remove(creatorName)
                self.mutualLagoonAuthors.remove(creatorName)
            } else {
                self.currentLagoonFollowedAuthors.insert(creatorName)
            }
            self.syncShellClipFollowState(for: creatorName)
            self.persistLocalPublishedShellClips()
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            completion(.success(self.shellClips[index], message: self.shellClips[index].isFollowed ? "Followed." : "Unfollowed."))
        }
    }

    func reportShellClip(clipID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            guard let index = self.shellClips.firstIndex(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            self.shellClips[index].isReportedLocally = true
            self.persistLocalPublishedShellClips()
            completion(.success(true, message: "Report received."))
        }
    }

    func addShellClipComment(clipID: String, text: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShellClip>) -> Void) {
        delay {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else {
                completion(.failure("Please enter a comment."))
                return
            }
            guard let index = self.shellClips.firstIndex(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            let profile = SuliJoyLocalProfileStore().currentProfile()
            let nickname = profile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let commenter = nickname?.isEmpty == false ? nickname! : "You"
            let comment = SuliJoyShellClipComment(
                commentID: "shell_clip_comment_\(Int(Date().timeIntervalSince1970 * 1000))",
                commenterName: commenter,
                commenterAvatarAssetName: "sulijoy_mock_avatar_breeze_01",
                text: trimmed,
                timeAgo: "just now",
                isReportedLocally: false
            )
            self.shellClips[index].comments.append(comment)
            self.shellClips[index].commentCount = self.shellClips[index].comments.count
            self.persistLocalPublishedShellClips()
            completion(.success(self.shellClips[index], message: "Comment added."))
        }
    }

    func reportShellClipComment(clipID: String, commentID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            guard let clipIndex = self.shellClips.firstIndex(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            guard let commentIndex = self.shellClips[clipIndex].comments.firstIndex(where: { $0.commentID == commentID }) else {
                completion(.failure("Comment not found.", code: 404))
                return
            }
            self.shellClips[clipIndex].comments[commentIndex].isReportedLocally = true
            self.persistLocalPublishedShellClips()
            completion(.success(true, message: "Report received."))
        }
    }

    func submitShoreReport(draft: SuliJoyShoreReportDraft, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            switch draft.target {
            case .moment(let momentID):
                guard let index = self.moments.firstIndex(where: { $0.momentID == momentID }) else {
                    completion(.failure("Moment not found.", code: 404))
                    return
                }
                self.moments[index].isReportedLocally = true
                self.persistLocalPublishedMoments()
                completion(.success(true, message: "Report received."))
            case .shoreComment(let momentID, let commentID):
                guard let moment = self.moments.first(where: { $0.momentID == momentID }) else {
                    completion(.failure("Moment not found.", code: 404))
                    return
                }
                guard moment.comments.contains(where: { $0.commentID == commentID }) else {
                    completion(.failure("Comment not found.", code: 404))
                    return
                }
                completion(.success(true, message: "Report received."))
            case .tideActivity(let tideID):
                guard let index = self.activities.firstIndex(where: { $0.tideID == tideID }) else {
                    completion(.failure("Activity not found.", code: 404))
                    return
                }
                self.activities[index].isReportedLocally = true
                self.persistLocalPublishedActivities()
                completion(.success(true, message: "Report received."))
            case .shellClip(let clipID):
                guard let index = self.shellClips.firstIndex(where: { $0.clipID == clipID }) else {
                    completion(.failure("Short not found.", code: 404))
                    return
                }
                self.shellClips[index].isReportedLocally = true
                self.persistLocalPublishedShellClips()
                completion(.success(true, message: "Report received."))
            case .shellClipComment(let clipID, let commentID):
                guard let clipIndex = self.shellClips.firstIndex(where: { $0.clipID == clipID }) else {
                    completion(.failure("Short not found.", code: 404))
                    return
                }
                guard let commentIndex = self.shellClips[clipIndex].comments.firstIndex(where: { $0.commentID == commentID }) else {
                    completion(.failure("Comment not found.", code: 404))
                    return
                }
                self.shellClips[clipIndex].comments[commentIndex].isReportedLocally = true
                self.persistLocalPublishedShellClips()
                completion(.success(true, message: "Report received."))
            case .lagoonVisitor(let visitorID):
                self.reportedLagoonVisitors.insert(visitorID)
                completion(.success(true, message: "Report received."))
            case .tideTalkSpace(let tideID):
                guard self.talkSpaces[tideID] != nil || self.activities.contains(where: { $0.tideID == tideID }) else {
                    completion(.failure("Talk space not found.", code: 404))
                    return
                }
                completion(.success(true, message: "Report received."))
            }
        }
    }

    func publishTideActivity(draft: SuliJoyTideDraftActivity, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyTideActivity>) -> Void) {
        delay {
            let trimmedTitle = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedDescription = draft.description.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !draft.photoPicks.isEmpty else {
                completion(.failure("Please add a cover photo."))
                return
            }
            guard !trimmedTitle.isEmpty else {
                completion(.failure("Please enter an event title."))
                return
            }
            guard !trimmedDescription.isEmpty else {
                completion(.failure("Please enter an event description."))
                return
            }
            guard draft.groupSize > 0 else {
                completion(.failure("Please enter a valid group size."))
                return
            }
            guard draft.gemCost >= 0 else {
                completion(.failure("Please enter a valid event price."))
                return
            }

            let profile = SuliJoyLocalProfileStore().currentProfile()
            let hostName = profile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let eventID = "tide_local_\(UUID().uuidString.prefix(8))"
            let media = draft.photoPicks.enumerated().map { index, pick in
                SuliJoyReefMedia(
                    mediaID: "event_local_media_\(UUID().uuidString.prefix(8))_\(index)",
                    kind: .image,
                    assetName: pick.localPath,
                    caption: pick.caption
                )
            }
            let dayFormatter = DateFormatter()
            dayFormatter.locale = Locale(identifier: "en_US_POSIX")
            dayFormatter.dateFormat = "M/d"
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale(identifier: "en_US_POSIX")
            timeFormatter.dateFormat = "h:mm"
            let meridiemFormatter = DateFormatter()
            meridiemFormatter.locale = Locale(identifier: "en_US_POSIX")
            meridiemFormatter.dateFormat = "a"
            let scheduleFormatter = DateFormatter()
            scheduleFormatter.locale = Locale(identifier: "en_US_POSIX")
            scheduleFormatter.dateFormat = "EEE, MMM d, yyyy"
            let relatedIDs = self.activities.shuffled().prefix(Int.random(in: 1...min(2, max(1, self.activities.count)))).map(\.tideID)
            let avatarPool = [
                "sulijoy_mock_avatar_breeze_01",
                "sulijoy_mock_avatar_breeze_02",
                "sulijoy_mock_avatar_breeze_03",
                "sulijoy_mock_avatar_sun_01",
                "sulijoy_mock_avatar_sun_02",
                "sulijoy_mock_avatar_sun_03"
            ]
            let activity = SuliJoyTideActivity(
                tideID: eventID,
                dayText: dayFormatter.string(from: draft.eventDate),
                meridiem: meridiemFormatter.string(from: draft.eventTime),
                timeText: timeFormatter.string(from: draft.eventTime),
                shoreScheduleText: "\(scheduleFormatter.string(from: draft.eventDate)) · \(timeFormatter.string(from: draft.eventTime)) \(meridiemFormatter.string(from: draft.eventTime))",
                title: trimmedTitle,
                shoreHostName: (hostName?.isEmpty == false ? hostName : "SuliJoy Stylist") ?? "SuliJoy Stylist",
                location: draft.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Island Shore · Coastline" : draft.location.trimmingCharacters(in: .whitespacesAndNewlines),
                summary: trimmedDescription,
                detailHeroAssetName: media.first?.assetName ?? "sulijoy_activity_detail_hero_sunset",
                shoreBrief: "\(trimmedDescription)\n\nType: \(draft.eventType) · Dress theme: \(draft.dressTheme)",
                relatedTideIDs: Array(relatedIDs),
                status: .open,
                isReportedLocally: false,
                joinedCount: 0,
                capacity: draft.groupSize,
                gemCost: draft.gemCost,
                media: media,
                avatarAssetNames: Array(avatarPool.shuffled().prefix(Int.random(in: 1...3)))
            )
            self.activities.insert(activity, at: 0)
            self.talkSpaces[activity.tideID] = Self.makeTalkSpace(from: activity)
            self.persistLocalPublishedActivities()
            completion(.success(activity, message: "Event published."))
        }
    }

    func fetchActivityDetail(tideID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyTideActivity>) -> Void) {
        delay {
            guard let activity = self.activities.first(where: { $0.tideID == tideID }) else {
                completion(.failure("Activity not found.", code: 404))
                return
            }
            guard !self.blockedShoreAuthors.contains(activity.shoreHostName) else {
                completion(.failure("Activity hidden after block.", code: 403))
                return
            }
            completion(.success(activity))
        }
    }

    func fetchRelatedActivities(for tideID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        delay {
            guard self.visibleActivities().contains(where: { $0.tideID == tideID }) else {
                completion(.failure("Activity not found.", code: 404))
                return
            }
            let candidates = self.visibleActivities().filter { $0.tideID != tideID }
            let maxCount = min(candidates.count, 2)
            let count = maxCount == 0 ? 0 : Int.random(in: 1...maxCount)
            let related = Array(candidates.shuffled().prefix(count))
            completion(.success(related))
        }
    }

    func fetchLagoonStylists(mode: SuliJoyCoveRequestMode = .success, completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyLagoonStylist]>) -> Void) {
        respond(mode: mode, empty: [], success: visibleStylists(), completion: completion)
    }

    func fetchLagoonVisitorProfile(visitorID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyLagoonVisitor>) -> Void) {
        delay {
            guard let visitor = self.makeLagoonVisitor(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            completion(.success(visitor))
        }
    }

    func fetchVisitorShoreMoments(visitorID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyShoreMoment]>) -> Void) {
        delay {
            guard let name = self.resolveVisitorName(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            let visitorMoments = self.moments.filter { self.isMomentVisible($0) && $0.authorName == name }
            completion(.success(visitorMoments))
        }
    }

    func fetchVisitorShellClips(visitorID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyShellClip]>) -> Void) {
        delay {
            guard let name = self.resolveVisitorName(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            let visitorClips = self.visibleShellClips().filter { $0.creator.displayName == name }
            completion(.success(visitorClips))
        }
    }

    func fetchVisitorTideActivities(visitorID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        delay {
            guard let name = self.resolveVisitorName(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            let visitorActivities = self.visibleActivities().filter { $0.shoreHostName == name }
            completion(.success(visitorActivities))
        }
    }

    func toggleLagoonVisitorFollow(visitorID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyLagoonVisitor>) -> Void) {
        delay {
            guard let name = self.resolveVisitorName(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            let isFollowing = self.currentLagoonFollowedAuthors.contains(name)
            if isFollowing {
                self.currentLagoonFollowedAuthors.remove(name)
                self.mutualLagoonAuthors.remove(name)
            } else {
                self.currentLagoonFollowedAuthors.insert(name)
            }
            self.syncShellClipFollowState(for: name)
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            guard let visitor = self.makeLagoonVisitor(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            let message = visitor.followState == .notFollowing ? "Unfollowed." : "Followed."
            completion(.success(visitor, message: message))
        }
    }

    func reportLagoonVisitor(visitorID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            guard self.resolveVisitorName(visitorID: visitorID) != nil else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            self.reportedLagoonVisitors.insert(visitorID)
            completion(.success(true, message: "Report received."))
        }
    }

    func blockLagoonVisitor(visitorID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            guard let name = self.resolveVisitorName(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            self.blockedShoreAuthors.insert(name)
            self.currentLagoonFollowedAuthors.remove(name)
            self.mutualLagoonAuthors.remove(name)
            for index in self.moments.indices where self.moments[index].authorName == name {
                self.moments[index].isBlocked = true
            }
            self.syncShellClipFollowState(for: name)
            completion(.success(true, message: "Visitor blocked."))
        }
    }

    func clearSuliJoyLocalCache(completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            completion(.success(true, message: "Cache cleared."))
        }
    }

    func fetchBlockedLagoonVisitors(completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyLagoonVisitor]>) -> Void) {
        delay {
            let visitors = self.blockedShoreAuthors
                .sorted()
                .compactMap { name in
                    self.makeLagoonVisitor(visitorID: SuliJoyLagoonVisitor.visitorID(for: name))
                }
            completion(.success(visitors))
        }
    }

    func fetchShoreMoments(filter: SuliJoyShoreMomentFilter, mode: SuliJoyCoveRequestMode = .success, completion: @escaping (SuliJoyLocalRequestEnvelope<[SuliJoyShoreMoment]>) -> Void) {
        let feed: [SuliJoyShoreMoment]
        if filter == .recommend {
            feed = moments.filter { isMomentVisible($0) && ($0.filter == .recommend || $0.filter == .hot) }
        } else if filter == .followed {
            feed = moments.filter { isMomentVisible($0) && currentLagoonFollowedAuthors.contains($0.authorName) }
        } else {
            feed = moments.filter { isMomentVisible($0) && $0.filter == filter }
        }
        respond(mode: mode, empty: [], success: feed, completion: completion)
    }

    func publishShoreMoment(draft: SuliJoyShoreDraftMoment, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShoreMoment>) -> Void) {
        delay {
            let trimmedBody = draft.body.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedBody.isEmpty || !draft.mediaPicks.isEmpty || draft.audioDraft != nil else {
                completion(.failure("Please add content, photos, or audio."))
                return
            }
            let profile = SuliJoyLocalProfileStore().currentProfile()
            let nickname = profile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let authorName = (nickname?.isEmpty == false ? nickname : "You") ?? "You"
            let avatarName = profile?.avatarPath?.isEmpty == false ? (profile?.avatarPath ?? "sulijoy_mock_avatar_breeze_01") : "sulijoy_mock_avatar_breeze_01"
            let media = draft.mediaPicks.enumerated().map { index, pick in
                SuliJoyReefMedia(
                    mediaID: "shore_local_media_\(UUID().uuidString.prefix(8))_\(index)",
                    kind: .image,
                    assetName: pick.localPath,
                    caption: pick.caption
                )
            }
            let audio = SuliJoyWaveAudioNote(
                noteID: "shore_local_audio_\(UUID().uuidString.prefix(8))",
                duration: draft.audioDraft?.duration ?? 0,
                waveformAssetName: "sulijoy_feed_audio_wave",
                audioFileName: draft.audioDraft?.localPath ?? "",
                isPlaying: false,
                progress: 0
            )
            let moment = SuliJoyShoreMoment(
                momentID: "moment_local_\(UUID().uuidString.prefix(8))",
                authorName: authorName,
                authorHandle: "@sulijoy.shore",
                authorStyleLine: "Fresh island style · New post",
                authorAvatarAssetName: avatarName,
                timeAgo: "just now",
                shorePlaceText: "SuliJoy Shore",
                shoreTimeText: "Today · just now",
                body: trimmedBody.isEmpty ? "Sharing a bright island style moment." : trimmedBody,
                media: media,
                audioNote: audio,
                likeCount: 0,
                commentCount: 0,
                comments: [],
                isLiked: false,
                filter: .recommend,
                isBlocked: false,
                isReportedLocally: false
            )
            self.moments.insert(moment, at: 0)
            self.currentLagoonFollowedAuthors.insert(authorName)
            self.persistLocalPublishedMoments()
            completion(.success(moment, message: "Posted."))
        }
    }

    func joinActivity(tideID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyTideActivity>) -> Void) {
        delay {
            guard let index = self.activities.firstIndex(where: { $0.tideID == tideID }) else {
                completion(.failure("Activity not found.", code: 404))
                return
            }
            guard !self.blockedShoreAuthors.contains(self.activities[index].shoreHostName) else {
                completion(.failure("Activity hidden after block.", code: 403))
                return
            }
            guard self.activities[index].status == .open else {
                completion(.failure("This activity is closed."))
                return
            }
            self.activities[index].status = .joined
            self.activities[index].joinedCount = min(self.activities[index].capacity, self.activities[index].joinedCount + 1)
            self.persistLocalPublishedActivities()
            completion(.success(self.activities[index], message: "Joined"))
        }
    }

    func spendCoinsForActivity(tideID: String, coinCost: Int, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShellWallet>) -> Void) {
        delay {
            completion(SuliJoyShellWalletStore.shared.spendForActivity(tideID: tideID, coinCost: coinCost))
        }
    }

    func reportActivity(tideID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            guard let index = self.activities.firstIndex(where: { $0.tideID == tideID }) else {
                completion(.failure("Activity not found.", code: 404))
                return
            }
            self.activities[index].isReportedLocally = true
            self.persistLocalPublishedActivities()
            completion(.success(true, message: "Report received."))
        }
    }

    func fetchTideTalkSpace(tideID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyTideTalkSpace>) -> Void) {
        delay {
            guard let activity = self.activities.first(where: { $0.tideID == tideID }) else {
                completion(.failure("Activity not found.", code: 404))
                return
            }
            guard !self.blockedShoreAuthors.contains(activity.shoreHostName) else {
                completion(.failure("Talk space hidden after block.", code: 403))
                return
            }
            if self.talkSpaces[tideID] == nil {
                self.talkSpaces[tideID] = Self.makeTalkSpace(from: activity)
            }
            completion(.success(self.talkSpaces[tideID]))
        }
    }

    func sendShoreChat(tideID: String, text: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyTideTalkSpace>) -> Void) {
        delay {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else {
                completion(.failure("Please enter a message."))
                return
            }
            guard var space = self.talkSpaces[tideID] else {
                completion(.failure("Talk space not found.", code: 404))
                return
            }
            let current = Self.currentShoreSpeaker()
            let bubble = SuliJoyShoreChatBubble(
                bubbleID: "shore_chat_\(UUID().uuidString.prefix(8))",
                senderName: current.name,
                avatarAssetName: current.avatarAssetName,
                text: trimmed,
                createdAt: Date(),
                isMine: true
            )
            space.chatBubbles.append(bubble)
            self.talkSpaces[tideID] = space
            completion(.success(space, message: "Message sent."))
        }
    }

    func joinLagoonVoiceSeat(tideID: String, seatID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyTideTalkSpace>) -> Void) {
        delay {
            guard var space = self.talkSpaces[tideID] else {
                completion(.failure("Talk space not found.", code: 404))
                return
            }
            guard let index = space.voiceSeats.firstIndex(where: { $0.seatID == seatID }) else {
                completion(.failure("Seat not found."))
                return
            }
            guard space.voiceSeats[index].isOpen else {
                completion(.failure("This seat is already occupied."))
                return
            }
            let current = Self.currentShoreSpeaker()
            space.voiceSeats[index].displayName = current.name
            space.voiceSeats[index].avatarAssetName = current.avatarAssetName
            space.voiceSeats[index].isOwner = false
            space.voiceSeats[index].isCurrentUser = true
            space.voiceSeats[index].isOpen = false
            self.talkSpaces[tideID] = space
            completion(.success(space, message: "Seat joined."))
        }
    }

    func toggleMomentLike(momentID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShoreMoment>) -> Void) {
        delay {
            guard let index = self.moments.firstIndex(where: { $0.momentID == momentID }) else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            self.moments[index].isLiked.toggle()
            self.moments[index].likeCount = max(0, self.moments[index].likeCount + (self.moments[index].isLiked ? 1 : -1))
            self.persistLocalPublishedMoments()
            completion(.success(self.moments[index]))
        }
    }

    func addShoreComment(momentID: String, text: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShoreMoment>) -> Void) {
        delay {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else {
                completion(.failure("Please enter a comment."))
                return
            }
            guard let index = self.moments.firstIndex(where: { $0.momentID == momentID }) else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            let profile = SuliJoyLocalProfileStore().currentProfile()
            let name = profile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let comment = SuliJoyShoreComment(
                commentID: "shore_comment_\(UUID().uuidString.prefix(8))",
                commenterName: (name?.isEmpty == false ? name : "You") ?? "You",
                commenterAvatarAssetName: "sulijoy_mock_avatar_breeze_01",
                text: trimmed,
                timeAgo: "just now"
            )
            self.moments[index].comments.append(comment)
            self.moments[index].commentCount = min(9, self.moments[index].comments.count)
            self.persistLocalPublishedMoments()
            completion(.success(self.moments[index], message: "Comment added."))
        }
    }

    func reportShoreComment(momentID: String, commentID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            guard let moment = self.moments.first(where: { $0.momentID == momentID }) else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            guard moment.comments.contains(where: { $0.commentID == commentID }) else {
                completion(.failure("Comment not found.", code: 404))
                return
            }
            completion(.success(true, message: "Report received."))
        }
    }

    func isLagoonFollowing(authorName: String) -> Bool {
        currentLagoonFollowedAuthors.contains(authorName)
    }

    func toggleLagoonFollow(authorName: String, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            if self.currentLagoonFollowedAuthors.contains(authorName) {
                self.currentLagoonFollowedAuthors.remove(authorName)
                self.mutualLagoonAuthors.remove(authorName)
                self.syncShellClipFollowState(for: authorName)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                completion(.success(false, message: "Unfollowed."))
            } else {
                self.currentLagoonFollowedAuthors.insert(authorName)
                self.syncShellClipFollowState(for: authorName)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                completion(.success(true, message: "Followed."))
            }
        }
    }

    func toggleAudioPlayback(momentID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<SuliJoyShoreMoment>) -> Void) {
        delay {
            guard let index = self.moments.firstIndex(where: { $0.momentID == momentID }) else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            let shouldPlay = !self.moments[index].audioNote.isPlaying
            for item in self.moments.indices {
                self.moments[item].audioNote.isPlaying = false
            }
            self.moments[index].audioNote.isPlaying = shouldPlay
            self.moments[index].audioNote.progress = shouldPlay ? min(1, self.moments[index].audioNote.progress + 0.22) : self.moments[index].audioNote.progress
            self.persistLocalPublishedMoments()
            completion(.success(self.moments[index], message: shouldPlay ? "Playing" : "Paused"))
        }
    }

    func reportMoment(momentID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            guard let index = self.moments.firstIndex(where: { $0.momentID == momentID }) else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            self.moments[index].isReportedLocally = true
            completion(.success(true, message: "Report received."))
        }
    }

    func blockMomentAuthor(momentID: String, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
        delay {
            guard let author = self.moments.first(where: { $0.momentID == momentID })?.authorName else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            self.blockedShoreAuthors.insert(author)
            self.currentLagoonFollowedAuthors.remove(author)
            self.mutualLagoonAuthors.remove(author)
            for index in self.moments.indices where self.moments[index].authorName == author {
                self.moments[index].isBlocked = true
            }
            self.syncShellClipFollowState(for: author)
            completion(.success(true, message: "Author blocked."))
        }
    }

    private func visibleActivities() -> [SuliJoyTideActivity] {
        activities.filter { !blockedShoreAuthors.contains($0.shoreHostName) }
    }

    private func visibleShellClips() -> [SuliJoyShellClip] {
        shellClips.filter { !blockedShoreAuthors.contains($0.creator.displayName) }
    }

    private func visibleStylists() -> [SuliJoyLagoonStylist] {
        stylists
            .filter { !blockedShoreAuthors.contains($0.displayName) }
            .map { stylist in
                var rendered = stylist
                let follows = currentLagoonFollowedAuthors.contains(stylist.displayName)
                rendered.isFollowed = follows
                return rendered
            }
    }

    private func isMomentVisible(_ moment: SuliJoyShoreMoment) -> Bool {
        !moment.isBlocked && !blockedShoreAuthors.contains(moment.authorName)
    }

    private func resolveVisitorName(visitorID: String) -> String? {
        let candidates = Set(
            stylists.map(\.displayName)
                + moments.map(\.authorName)
                + shellClips.map { $0.creator.displayName }
                + activities.map(\.shoreHostName)
        )
        return candidates.first { SuliJoyLagoonVisitor.visitorID(for: $0) == visitorID }
    }

    private func makeLagoonVisitor(visitorID: String) -> SuliJoyLagoonVisitor? {
        guard let name = resolveVisitorName(visitorID: visitorID) else { return nil }
        let stylist = stylists.first { $0.displayName == name }
        let moment = moments.first { $0.authorName == name }
        let clip = shellClips.first { $0.creator.displayName == name }
        let activity = activities.first { $0.shoreHostName == name }
        let avatar = stylist?.avatarAssetName
            ?? moment?.authorAvatarAssetName
            ?? clip?.creator.avatarAssetName
            ?? activity?.avatarAssetNames.first
            ?? "sulijoy_mock_avatar_breeze_01"
        let rawLikes = moments.filter { $0.authorName == name }.reduce(0) { $0 + $1.likeCount }
            + shellClips.filter { $0.creator.displayName == name }.reduce(0) { $0 + $1.likeCount }
        let baseLikes = max(rawLikes, 24 + abs(name.hashValue % 42))
        let baseFollowers = stylist?.followerCount ?? (96 + abs(name.hashValue % 28))
        let baseFollowing = stylist?.followingCount ?? (18 + abs(name.hashValue % 18))
        let follows = currentLagoonFollowedAuthors.contains(name)
        let state: SuliJoyCoveFollowState
        if !follows {
            state = .notFollowing
        } else if mutualLagoonAuthors.contains(name) {
            state = .mutualFollowing
        } else {
            state = .followingPending
        }
        return SuliJoyLagoonVisitor(
            visitorID: visitorID,
            displayName: name,
            avatarAssetName: avatar,
            likeCount: min(9999, baseLikes),
            followerCount: max(0, baseFollowers + (follows ? 1 : 0)),
            followingCount: max(0, baseFollowing),
            followState: state,
            isReportedLocally: reportedLagoonVisitors.contains(visitorID),
            isBlockedLocally: blockedShoreAuthors.contains(name)
        )
    }

    private func syncShellClipFollowState(for creatorName: String) {
        let state = currentLagoonFollowedAuthors.contains(creatorName)
        for index in shellClips.indices where shellClips[index].creator.displayName == creatorName {
            shellClips[index].isFollowed = state
        }
    }

    private func persistLocalPublishedMoments() {
        let localMoments = moments.filter { $0.momentID.hasPrefix("moment_local_") }
        guard let data = try? JSONEncoder().encode(localMoments) else { return }
        try? data.write(to: Self.localPublishedMomentsURL, options: [.atomic])
    }

    private func persistLocalPublishedActivities() {
        let localActivities = activities.filter { $0.tideID.hasPrefix("tide_local_") }
        guard let data = try? JSONEncoder().encode(localActivities) else { return }
        try? data.write(to: Self.localPublishedActivitiesURL, options: [.atomic])
    }

    private func persistLocalPublishedShellClips() {
        let localClips = shellClips.filter { $0.clipID.hasPrefix("shell_clip_local_") }
        guard let data = try? JSONEncoder().encode(localClips) else { return }
        try? data.write(to: Self.localPublishedShellClipsURL, options: [.atomic])
    }

    private static func loadLocalPublishedMoments() -> [SuliJoyShoreMoment] {
        guard let data = try? Data(contentsOf: localPublishedMomentsURL),
              let moments = try? JSONDecoder().decode([SuliJoyShoreMoment].self, from: data) else {
            return []
        }
        return moments
    }

    private static func loadLocalPublishedActivities() -> [SuliJoyTideActivity] {
        guard let data = try? Data(contentsOf: localPublishedActivitiesURL),
              let activities = try? JSONDecoder().decode([SuliJoyTideActivity].self, from: data) else {
            return []
        }
        return activities
    }

    private static func loadLocalPublishedShellClips() -> [SuliJoyShellClip] {
        guard let data = try? Data(contentsOf: localPublishedShellClipsURL),
              let clips = try? JSONDecoder().decode([SuliJoyShellClip].self, from: data) else {
            return []
        }
        return clips
    }

    private static var localPublishedMomentsURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let base = documents ?? FileManager.default.temporaryDirectory
        return base.appendingPathComponent("sulijoy_shore_published_moments.json")
    }

    private static var localPublishedActivitiesURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let base = documents ?? FileManager.default.temporaryDirectory
        return base.appendingPathComponent("sulijoy_tide_published_activities.json")
    }

    private static var localPublishedShellClipsURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let base = documents ?? FileManager.default.temporaryDirectory
        return base.appendingPathComponent("sulijoy_shell_published_clips.json")
    }

    private func respond<T>(mode: SuliJoyCoveRequestMode, empty: T, success: T, completion: @escaping (SuliJoyLocalRequestEnvelope<T>) -> Void) {
        delay {
            switch mode {
            case .success:
                completion(.success(success))
            case .empty:
                completion(.success(empty, message: "No data yet."))
            case .failure:
                completion(.failure("Request failed.", code: 500))
            }
        }
    }

    private func delay(_ work: @escaping () -> Void) {
        let delay = Double.random(in: 0.3...0.6)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }

    private static func stableIslandID(email: String?, fallbackUserID: String?) -> String {
        if let fallbackUserID, !fallbackUserID.isEmpty {
            let digits = fallbackUserID.filter(\.isNumber)
            if digits.count >= 6 {
                return String(digits.suffix(10))
            }
        }
        let source = (email?.isEmpty == false ? email! : "sulijoy.local").unicodeScalars
        let seed = source.reduce(3_994_920_304) { partial, scalar in
            (partial &* 31 &+ Int(scalar.value)) % 9_000_000_000
        }
        return String(format: "%010d", seed + 1_000_000_000)
    }

    private static func makeTalkSpace(from activity: SuliJoyTideActivity) -> SuliJoyTideTalkSpace {
        let names = ["Lucie Ray", "Gordon", "Vargas", "Claudia", "Tom"]
        let occupiedCount = min(5, activity.avatarAssetNames.count)
        var seats: [SuliJoyLagoonVoiceSeat] = []
        for index in 0..<9 {
            if index < occupiedCount {
                seats.append(
                    SuliJoyLagoonVoiceSeat(
                        seatID: "lagoon_seat_\(activity.tideID)_\(index)",
                        displayName: names[index % names.count],
                        avatarAssetName: activity.avatarAssetNames[index],
                        isOwner: index == 0,
                        isCurrentUser: false,
                        isOpen: false
                    )
                )
            } else {
                seats.append(
                    SuliJoyLagoonVoiceSeat(
                        seatID: "lagoon_seat_\(activity.tideID)_\(index)",
                        displayName: "Open Seat",
                        avatarAssetName: nil,
                        isOwner: false,
                        isCurrentUser: false,
                        isOpen: true
                    )
                )
            }
        }
        let firstAvatar = activity.avatarAssetNames.first
        let bubbles = [
            SuliJoyShoreChatBubble(bubbleID: "shore_chat_welcome_1_\(activity.tideID)", senderName: "Cora Bush", avatarAssetName: firstAvatar, text: "welcome to lucy", createdAt: Date(), isMine: false),
            SuliJoyShoreChatBubble(bubbleID: "shore_chat_welcome_2_\(activity.tideID)", senderName: "Cora Bush", avatarAssetName: firstAvatar, text: "show your island style", createdAt: Date(), isMine: false),
            SuliJoyShoreChatBubble(bubbleID: "shore_chat_welcome_3_\(activity.tideID)", senderName: "Cora Bush", avatarAssetName: firstAvatar, text: "keep it friendly and relaxed", createdAt: Date(), isMine: false)
        ]
        return SuliJoyTideTalkSpace(
            tideID: activity.tideID,
            tideTitle: activity.title,
            hostName: names.first ?? "Lucie Ray",
            backgroundAssetName: "sulijoy_tide_room_sunset_bg",
            participantAvatarAssetNames: Array(activity.avatarAssetNames.prefix(3)),
            voiceSeats: seats,
            chatBubbles: bubbles
        )
    }

    private static func currentShoreSpeaker() -> (name: String, avatarAssetName: String?) {
        let profile = SuliJoyLocalProfileStore().currentProfile()
        let name = profile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        return ((name?.isEmpty == false ? name : "You") ?? "You", "sulijoy_mock_avatar_breeze_01")
    }

    private static func makeShellClips() -> [SuliJoyShellClip] {
        let creators = [
            SuliJoyLagoonClipCreator(creatorID: "clip_creator_victoria", displayName: "Victoria", avatarAssetName: "sulijoy_mock_avatar_breeze_08"),
            SuliJoyLagoonClipCreator(creatorID: "clip_creator_lynch", displayName: "Lynch", avatarAssetName: "sulijoy_mock_avatar_sun_10"),
            SuliJoyLagoonClipCreator(creatorID: "clip_creator_mira_coast", displayName: "Mira Coast", avatarAssetName: "sulijoy_feed_avatar_bess"),
            SuliJoyLagoonClipCreator(creatorID: "clip_creator_sienna_ray", displayName: "Sienna Ray", avatarAssetName: "sulijoy_mock_avatar_breeze_12"),
            SuliJoyLagoonClipCreator(creatorID: "clip_creator_noa_palm", displayName: "Noa Palm", avatarAssetName: "sulijoy_feed_avatar_cody_hunter")
        ]
        let captions = [
            "Choose matches that have a natural element feel—standing by the sea makes the colors softer.",
            "If you want to play freely on the island, your outfit should be movable!",
            "A loose linen shirt keeps a resort look calm without losing shape.",
            "Sunset colors work best when one detail feels bright and the rest stays easy.",
            "Beach clips are better when the look can handle wind, sand, and walking."
        ]
        let fileNames = [
            "sulijoy_shorts_island_style_01",
            "sulijoy_shorts_island_style_02",
            "sulijoy_shorts_island_style_03",
            "sulijoy_shorts_island_style_04",
            "sulijoy_shorts_island_style_01"
        ]
        return creators.indices.map { index in
            SuliJoyShellClip(
                clipID: "shell_clip_\(index + 1)",
                creator: creators[index],
                caption: captions[index],
                media: SuliJoyReefClipMedia(
                    mediaID: "reef_clip_media_\(index + 1)",
                    localVideoFileName: fileNames[index],
                    fallbackCoverAssetName: ["sulijoy_feed_moment_coast_01", "sulijoy_feed_moment_coast_02", "sulijoy_feed_moment_coast_03", "sulijoy_feed_moment_coast_04", "sulijoy_feed_moment_coast_05"][index]
                ),
                likeCount: [7, 5, 8, 4, 6][index],
                commentCount: Self.makeShellClipComments(for: index).count,
                comments: Self.makeShellClipComments(for: index),
                isLiked: index == 2,
                isFollowed: false,
                isReportedLocally: false
            )
        }
    }

    private static func makeShellClipComments(for index: Int) -> [SuliJoyShellClipComment] {
        let pools = [
            [
                ("Shane Gregory", "sulijoy_mock_avatar_sun_05", "The outfit is so elegant!"),
                ("Jeffery Thompson", "sulijoy_mock_avatar_breeze_10", "Great shot! I love it")
            ],
            [
                ("Bruno Pham", "sulijoy_island_avatar_guest_02", "This linen color works perfectly."),
                ("Maya Shore", "sulijoy_mock_avatar_breeze_03", "The beach mood feels real.")
            ],
            [
                ("Cora Rush", "sulijoy_mock_avatar_breeze_07", "Soft layers make this look easy."),
                ("Noelle Sun", "sulijoy_mock_avatar_sun_08", "Saving this for my trip.")
            ],
            [
                ("Dennis Waters", "sulijoy_feed_avatar_dennis_waters", "The sunset tones are clean."),
                ("Lina Coast", "sulijoy_mock_avatar_breeze_11", "Simple but memorable.")
            ],
            [
                ("Brian May", "sulijoy_feed_avatar_brian_may", "Wind friendly styling matters."),
                ("Rhea Palm", "sulijoy_mock_avatar_sun_12", "The walking fit is practical.")
            ]
        ]
        return pools[index].enumerated().map { offset, item in
            SuliJoyShellClipComment(
                commentID: "shell_clip_comment_\(index)_\(offset)",
                commenterName: item.0,
                commenterAvatarAssetName: item.1,
                text: item.2,
                timeAgo: "2 mins ago",
                isReportedLocally: false
            )
        }
    }
}
