import Foundation

final class SuliJoyCoveMockService {
    static let shared = SuliJoyCoveMockService()

    private var tideShelf: [SuliJoyTideActivity]
    private var lagoonRankers: [SuliJoyLagoonStylist]
    private var shoreScroll: [SuliJoyReefMoment]
    private var clipReef: [SuliJoyShellClip]
    private var tideTalkMap: [String: SuliJoyTideTalkSpace]
    private var mutedShoreNames: Set<String>
    private var followedLagoonNames: Set<String>
    private var pairedLagoonNames: Set<String>
    private var flaggedLagoonVisitors: Set<String>

    private init() {
        tideTalkMap = [:]
        mutedShoreNames = []
        followedLagoonNames = ["Bess", "Brian May", "Cody Hunter"]
        pairedLagoonNames = ["Brian May"]
        flaggedLagoonVisitors = []
        clipReef = []
        tideShelf = [
            SuliJoyTideActivity(
                tideMark: "tide_sunset_style_party",
                shoreDayText: "7/15",
                sunMeridiemText: "AM",
                shoreClockText: "8:00",
                tideScheduleLine: "Sat, Jul 18, 2026 · 5:30 PM",
                tideTitleLine: "Island Sunset Style Party",
                shoreHostAlias: "Bess",
                shoreSpotLine: "Waikiki Beach · Hawaii, USA",
                shoreSummaryLine: "Wear your favorite island-inspired outfit and enjoy a beautiful sunset with relaxed icebreakers, a beach walk, and casual photo time.",
                tideFallbackHeroToken: "sulijoy_activity_detail_hero_sunset",
                shoreBriefLine: "Wear your favorite island-inspired outfit and enjoy a beautiful sunset at Waikiki Beach. The event includes relaxed icebreakers, a beach walk, and casual photo time. Perfect for connecting with new people and enjoying a laid-back vibe. No experience needed—just bring good energy.",
                relatedTideMarks: ["tide_golden_photo_walk", "tide_blue_white_picnic", "tide_market_style_hunt", "tide_tropical_print_party"],
                tideState: .tideOpen,
                isReefFlagged: false,
                tideJoinedTotal: 12,
                tideCrewLimit: 20,
                pearlNeed: 100,
                reefGallery: [
                    SuliJoyReefMedia(reefMediaStamp: "sunset_01", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_sunset_01", reefCaptionLine: "Sunset lounge"),
                    SuliJoyReefMedia(reefMediaStamp: "sunset_02", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_sunset_02", reefCaptionLine: "Palm styling table"),
                    SuliJoyReefMedia(reefMediaStamp: "sunset_03", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_sunset_03", reefCaptionLine: "Coastal friends")
                ],
                shorelineAvatarTokens: [
                    "sulijoy_mock_avatar_breeze_01",
                    "sulijoy_mock_avatar_breeze_02",
                    "sulijoy_mock_avatar_breeze_03",
                    "sulijoy_mock_avatar_breeze_04",
                    "sulijoy_mock_avatar_breeze_05"
                ]
            ),
            SuliJoyTideActivity(
                tideMark: "tide_golden_photo_walk",
                shoreDayText: "7/24",
                sunMeridiemText: "PM",
                shoreClockText: "6:00",
                tideScheduleLine: "Fri, Jul 24, 2026 · 6:00 PM",
                tideTitleLine: "Golden Hour Beach Photo Walk",
                shoreHostAlias: "Cody Hunter",
                shoreSpotLine: "Barceloneta Beach · Barcelona, Spain",
                shoreSummaryLine: "Walk the beach during golden hour, capture beautiful shoreScroll, and connect through fashion, photography, and seaside light.",
                tideFallbackHeroToken: "sulijoy_activity_detail_hero_sunset",
                shoreBriefLine: "Walk along the beach during golden hour and capture beautiful shoreScroll together. Ideal for those who enjoy photography, fashion, or simply the seaside atmosphere. Help each other take photos or just relax and connect.",
                relatedTideMarks: ["tide_sunset_style_party", "tide_blue_white_picnic", "tide_market_style_hunt", "tide_tropical_print_party"],
                tideState: .tideOpen,
                isReefFlagged: false,
                tideJoinedTotal: 9,
                tideCrewLimit: 16,
                pearlNeed: 90,
                reefGallery: [
                    SuliJoyReefMedia(reefMediaStamp: "golden_walk_01", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_golden_walk_01", reefCaptionLine: "Golden drinks"),
                    SuliJoyReefMedia(reefMediaStamp: "golden_walk_02", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_golden_walk_02", reefCaptionLine: "Beach portrait"),
                    SuliJoyReefMedia(reefMediaStamp: "golden_walk_03", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_golden_walk_03", reefCaptionLine: "Palm sunset")
                ],
                shorelineAvatarTokens: [
                    "sulijoy_mock_avatar_sun_01",
                    "sulijoy_mock_avatar_sun_02",
                    "sulijoy_mock_avatar_sun_03",
                    "sulijoy_mock_avatar_breeze_06"
                ]
            ),
            SuliJoyTideActivity(
                tideMark: "tide_blue_white_picnic",
                shoreDayText: "8/1",
                sunMeridiemText: "PM",
                shoreClockText: "4:30",
                tideScheduleLine: "Sat, Aug 1, 2026 · 4:30 PM",
                tideTitleLine: "Mediterranean Blue & White Picnic",
                shoreHostAlias: "Brian May",
                shoreSpotLine: "Oia Viewpoint · Santorini, Greece",
                shoreSummaryLine: "Enjoy a blue and white dress-theme picnic with simple snacks, shared food, relaxed style notes, and romantic coastal photos.",
                tideFallbackHeroToken: "sulijoy_activity_detail_hero_sunset",
                shoreBriefLine: "Enjoy a Mediterranean-style picnic with a blue and white dress theme at one of Santorini’s most scenic spots. Bring simple snacks, share food, swap outfit ideas, and take photos in a relaxed and romantic setting.",
                relatedTideMarks: ["tide_sunset_style_party", "tide_golden_photo_walk", "tide_market_style_hunt", "tide_tropical_print_party"],
                tideState: .tideOpen,
                isReefFlagged: false,
                tideJoinedTotal: 14,
                tideCrewLimit: 18,
                pearlNeed: 120,
                reefGallery: [
                    SuliJoyReefMedia(reefMediaStamp: "blue_picnic_01", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_blue_picnic_01", reefCaptionLine: "Seaside picnic"),
                    SuliJoyReefMedia(reefMediaStamp: "blue_picnic_02", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_blue_picnic_02", reefCaptionLine: "Blue table"),
                    SuliJoyReefMedia(reefMediaStamp: "blue_picnic_03", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_blue_picnic_03", reefCaptionLine: "Beach setting")
                ],
                shorelineAvatarTokens: [
                    "sulijoy_mock_avatar_breeze_07",
                    "sulijoy_mock_avatar_breeze_08",
                    "sulijoy_mock_avatar_breeze_09",
                    "sulijoy_mock_avatar_sun_04",
                    "sulijoy_mock_avatar_sun_05"
                ]
            ),
            SuliJoyTideActivity(
                tideMark: "tide_market_style_hunt",
                shoreDayText: "8/15",
                sunMeridiemText: "PM",
                shoreClockText: "3:00",
                tideScheduleLine: "Sat, Aug 15, 2026 · 3:00 PM",
                tideTitleLine: "Island Market Style Hunt",
                shoreHostAlias: "Dennis Waters",
                shoreSpotLine: "Phuket Weekend Market · Phuket, Thailand",
                shoreSummaryLine: "Explore a vibrant island market together, discover boutique fashion finds, and leave room for casual photo shoreScroll.",
                tideFallbackHeroToken: "sulijoy_activity_detail_hero_sunset",
                shoreBriefLine: "Explore a vibrant island market together and discover unique fashion inspiration and coastal finds. Includes free browsing, social interaction, and casual photo shoreScroll.",
                relatedTideMarks: ["tide_sunset_style_party", "tide_golden_photo_walk", "tide_blue_white_picnic", "tide_tropical_print_party"],
                tideState: .tideOpen,
                isReefFlagged: false,
                tideJoinedTotal: 8,
                tideCrewLimit: 20,
                pearlNeed: 80,
                reefGallery: [
                    SuliJoyReefMedia(reefMediaStamp: "market_hunt_01", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_market_hunt_01", reefCaptionLine: "Market coconut"),
                    SuliJoyReefMedia(reefMediaStamp: "market_hunt_02", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_market_hunt_02", reefCaptionLine: "Night market"),
                    SuliJoyReefMedia(reefMediaStamp: "market_hunt_03", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_market_hunt_03", reefCaptionLine: "Island look")
                ],
                shorelineAvatarTokens: [
                    "sulijoy_mock_avatar_sun_06",
                    "sulijoy_mock_avatar_sun_07",
                    "sulijoy_mock_avatar_breeze_10",
                    "sulijoy_mock_avatar_breeze_11"
                ]
            ),
            SuliJoyTideActivity(
                tideMark: "tide_tropical_print_party",
                shoreDayText: "9/5",
                sunMeridiemText: "PM",
                shoreClockText: "5:30",
                tideScheduleLine: "Sat, Sep 5, 2026 · 5:30 PM",
                tideTitleLine: "Tropical Print Beach Party",
                shoreHostAlias: "Dennis Waters",
                shoreSpotLine: "Paradise Beach · Tulum, Mexico",
                shoreSummaryLine: "Wear tropical prints and enjoy music, sunset, and social beach vibes in a bright but relaxed gathering.",
                tideFallbackHeroToken: "sulijoy_activity_detail_hero_sunset",
                shoreBriefLine: "Wear tropical prints and enjoy music, sunset, and social vibes on the beach. A bright yet relaxed gathering for finding fresh looks and unwinding.",
                relatedTideMarks: ["tide_sunset_style_party", "tide_golden_photo_walk", "tide_blue_white_picnic", "tide_market_style_hunt"],
                tideState: .tideOpen,
                isReefFlagged: false,
                tideJoinedTotal: 17,
                tideCrewLimit: 24,
                pearlNeed: 110,
                reefGallery: [
                    SuliJoyReefMedia(reefMediaStamp: "tropical_party_01", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_tropical_party_01", reefCaptionLine: "Tropical print"),
                    SuliJoyReefMedia(reefMediaStamp: "tropical_party_02", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_tropical_party_02", reefCaptionLine: "Party friends"),
                    SuliJoyReefMedia(reefMediaStamp: "tropical_party_03", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_tropical_party_03", reefCaptionLine: "Sunset outfit")
                ],
                shorelineAvatarTokens: [
                    "sulijoy_mock_avatar_breeze_12",
                    "sulijoy_mock_avatar_sun_08",
                    "sulijoy_mock_avatar_sun_09",
                    "sulijoy_mock_avatar_sun_10",
                    "sulijoy_mock_avatar_breeze_01"
                ]
            ),
            SuliJoyTideActivity(
                tideMark: "tide_sporty_coastal_social",
                shoreDayText: "9/12",
                sunMeridiemText: "AM",
                shoreClockText: "10:00",
                tideScheduleLine: "Sat, Sep 12, 2026 · 10:00 AM",
                tideTitleLine: "Sporty Coastal Social Day",
                shoreHostAlias: "Cody Hunter",
                shoreSpotLine: "Bondi Beach · Sydney, Australia",
                shoreSummaryLine: "Join light beach tideShelf, relax by the coast, and connect with others who enjoy an active seaside lifestyle.",
                tideFallbackHeroToken: "sulijoy_activity_detail_hero_sunset",
                shoreBriefLine: "A beach event combining light sports and social interaction. Join casual beach tideShelf or simply relax and connect with others who enjoy an active lifestyle.",
                relatedTideMarks: ["tide_sunset_style_party", "tide_golden_photo_walk", "tide_blue_white_picnic", "tide_market_style_hunt"],
                tideState: .tideClosed,
                isReefFlagged: false,
                tideJoinedTotal: 18,
                tideCrewLimit: 18,
                pearlNeed: 70,
                reefGallery: [
                    SuliJoyReefMedia(reefMediaStamp: "sporty_social_01", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_sporty_social_01", reefCaptionLine: "Sporty beach"),
                    SuliJoyReefMedia(reefMediaStamp: "sporty_social_02", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_sporty_social_02", reefCaptionLine: "Coastal walk"),
                    SuliJoyReefMedia(reefMediaStamp: "sporty_social_03", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_home_activity_sporty_social_03", reefCaptionLine: "Beach sport")
                ],
                shorelineAvatarTokens: [
                    "sulijoy_mock_avatar_sun_11",
                    "sulijoy_mock_avatar_sun_12",
                    "sulijoy_mock_avatar_breeze_02",
                    "sulijoy_mock_avatar_breeze_03"
                ]
            )
        ]
        tideShelf.insert(contentsOf: Self.loadPublishedTideShelf(), at: 0)
        tideTalkMap = Dictionary(uniqueKeysWithValues: tideShelf.map { activity in
            (activity.tideMark, Self.makeTideTalkHarbor(from: activity))
        })

        lagoonRankers = [
            SuliJoyLagoonStylist(stylistID: "stylist_brian_may", displayName: "Brian May", avatarAssetName: "sulijoy_feed_avatar_brian_may", suliJoyCoastalModeration: 3, suliJoyCoastalChecklist: 4),
            SuliJoyLagoonStylist(stylistID: "stylist_cody_hunter", displayName: "Cody Hunter", avatarAssetName: "sulijoy_feed_avatar_cody_hunter", suliJoyCoastalModeration: 2, suliJoyCoastalChecklist: 3),
            SuliJoyLagoonStylist(stylistID: "stylist_bess", displayName: "Bess", avatarAssetName: "sulijoy_feed_avatar_bess", suliJoyCoastalModeration: 1, suliJoyCoastalChecklist: 4),
            SuliJoyLagoonStylist(stylistID: "stylist_dennis_waters", displayName: "Dennis Waters", avatarAssetName: "sulijoy_feed_avatar_dennis_waters", suliJoyCoastalModeration: 4, suliJoyCoastalChecklist: 2)
        ]

        shoreScroll = [
            SuliJoyReefMoment(
                reefMomentID: "moment_bess_recommend",
                islandStylistName: "Bess",
                islandStylistMark: "@bess.shore",
                islandStyleLine: "Pastel beach layers · Waikiki",
                islandStylistAvatarAssetName: "sulijoy_feed_avatar_bess",
                tideAgoText: "4 mins ago",
                shoreSpotText: "Waikiki Beach · Hawaii, USA",
                shoreTideText: "Jul 18, 2026 · 5:30 PM",
                islandCaptionText: "Soft blue and pink tees feel easy for a windy beach walk. The oversized flower print keeps the photos bright without trying too hard.",
                reefMedia: [
                    SuliJoyReefMedia(reefMediaStamp: "coast_01", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_01", reefCaptionLine: "Beach flower tee"),
                    SuliJoyReefMedia(reefMediaStamp: "coast_02", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_02", reefCaptionLine: "Pastel shore pair"),
                    SuliJoyReefMedia(reefMediaStamp: "coast_03", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_03", reefCaptionLine: "Sunset walk back")
                ],
                waveNote: SuliJoyWaveSonicNote(waveNoteStamp: "wave_bess", waveSeconds: 18, waveStripeAssetToken: Self.shoreResonanceStripeAsset, waveFileToken: Self.shoreResonanceFile("keila"), isWaveRolling: false, waveProgressRatio: 0),
                heartTally: 6,
                reefReplyTally: 3,
                reefReplies: [
                    SuliJoyReefReply(reefReplyID: "comment_bess_1", reefEchoName: "Cody Hunter", reefEchoAvatarAssetName: "sulijoy_feed_avatar_cody_hunter", reefPhraseText: "The pastel colors work really well with the sea light.", tideAgoText: "2 mins ago"),
                    SuliJoyReefReply(reefReplyID: "comment_bess_2", reefEchoName: "Dennis Waters", reefEchoAvatarAssetName: "sulijoy_feed_avatar_dennis_waters", reefPhraseText: "That oversized tee is perfect for a casual sunset photo.", tideAgoText: "1 min ago"),
                    SuliJoyReefReply(reefReplyID: "comment_bess_3", reefEchoName: "Brian May", reefEchoAvatarAssetName: "sulijoy_feed_avatar_brian_may", reefPhraseText: "Clean, relaxed, and still memorable.", tideAgoText: "just now")
                ],
                isHearted: false,
                reefFilter: .coastalPick,
                isTideHidden: false,
                isReefFlagged: false
            ),
            SuliJoyReefMoment(
                reefMomentID: "moment_dennis_hot",
                islandStylistName: "Dennis Waters",
                islandStylistMark: "@dennis.coast",
                islandStyleLine: "Printed resort shirt · garden lunch",
                islandStylistAvatarAssetName: "sulijoy_feed_avatar_dennis_waters",
                tideAgoText: "9 mins ago",
                shoreSpotText: "Paradise Beach · Tulum, Mexico",
                shoreTideText: "Sep 5, 2026 · 5:30 PM",
                islandCaptionText: "A light printed shirt is enough when the setting already has color. I like keeping jewelry warm and the fit loose.",
                reefMedia: [
                    SuliJoyReefMedia(reefMediaStamp: "coast_04", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_04", reefCaptionLine: "Printed island shirt"),
                    SuliJoyReefMedia(reefMediaStamp: "coast_05", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_05", reefCaptionLine: "Resort lunch look")
                ],
                waveNote: SuliJoyWaveSonicNote(waveNoteStamp: "wave_dennis", waveSeconds: 21, waveStripeAssetToken: Self.shoreResonanceStripeAsset, waveFileToken: Self.shoreResonanceFile("elei_island"), isWaveRolling: false, waveProgressRatio: 0),
                heartTally: 8,
                reefReplyTally: 2,
                reefReplies: [
                    SuliJoyReefReply(reefReplyID: "comment_dennis_1", reefEchoName: "Bess", reefEchoAvatarAssetName: "sulijoy_feed_avatar_bess", reefPhraseText: "The shirt pattern feels beachy but still neat.", tideAgoText: "5 mins ago"),
                    SuliJoyReefReply(reefReplyID: "comment_dennis_2", reefEchoName: "Cody Hunter", reefEchoAvatarAssetName: "sulijoy_feed_avatar_cody_hunter", reefPhraseText: "Warm jewelry was the right call here.", tideAgoText: "3 mins ago")
                ],
                isHearted: true,
                reefFilter: .coastalPick,
                isTideHidden: false,
                isReefFlagged: false
            ),
            SuliJoyReefMoment(
                reefMomentID: "moment_cody_hot",
                islandStylistName: "Cody Hunter",
                islandStylistMark: "@cody.linen",
                islandStyleLine: "Linen walk set · Barcelona",
                islandStylistAvatarAssetName: "sulijoy_feed_avatar_cody_hunter",
                tideAgoText: "8 mins ago",
                shoreSpotText: "Barcelona Beach · Barcelona, Spain",
                shoreTideText: "Jul 24, 2026 · 6:00 PM",
                islandCaptionText: "A linen shirt and simple shorts still feel right for golden hour. I would rather keep the silhouette clean than add too many pieces.",
                reefMedia: [
                    SuliJoyReefMedia(reefMediaStamp: "coast_03_hot", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_03", reefCaptionLine: "Sunset walk")
                ],
                waveNote: SuliJoyWaveSonicNote(waveNoteStamp: "wave_cody", waveSeconds: 16, waveStripeAssetToken: Self.shoreResonanceStripeAsset, waveFileToken: Self.shoreResonanceFile("sablereid"), isWaveRolling: false, waveProgressRatio: 0),
                heartTally: 4,
                reefReplyTally: 1,
                reefReplies: [
                    SuliJoyReefReply(reefReplyID: "comment_cody_1", reefEchoName: "Brian May", reefEchoAvatarAssetName: "sulijoy_feed_avatar_brian_may", reefPhraseText: "Clean silhouette, easy to copy.", tideAgoText: "4 mins ago")
                ],
                isHearted: false,
                reefFilter: .sunsetRush,
                isTideHidden: false,
                isReefFlagged: false
            ),
            SuliJoyReefMoment(
                reefMomentID: "moment_brian_followed",
                islandStylistName: "Brian May",
                islandStylistMark: "@brian.blue",
                islandStyleLine: "Blue-white picnic mood · Santorini",
                islandStylistAvatarAssetName: "sulijoy_feed_avatar_brian_may",
                tideAgoText: "12 mins ago",
                shoreSpotText: "Oia Viewpoint · Santorini, Greece",
                shoreTideText: "Aug 1, 2026 · 4:30 PM",
                islandCaptionText: "For blue-water backgrounds, pale shirts and soft accessories read cleaner. A quiet palette makes the setting feel bigger.",
                reefMedia: [
                    SuliJoyReefMedia(reefMediaStamp: "coast_02_followed", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_02", reefCaptionLine: "Pastel pair"),
                    SuliJoyReefMedia(reefMediaStamp: "coast_01_followed", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_01", reefCaptionLine: "Beach tee detail")
                ],
                waveNote: SuliJoyWaveSonicNote(waveNoteStamp: "wave_brian", waveSeconds: 19, waveStripeAssetToken: Self.shoreResonanceStripeAsset, waveFileToken: Self.shoreResonanceFile("jess_ortiz"), isWaveRolling: false, waveProgressRatio: 0),
                heartTally: 5,
                reefReplyTally: 2,
                reefReplies: [
                    SuliJoyReefReply(reefReplyID: "comment_brian_1", reefEchoName: "Bess", reefEchoAvatarAssetName: "sulijoy_feed_avatar_bess", reefPhraseText: "The quiet palette makes the photos softer.", tideAgoText: "7 mins ago"),
                    SuliJoyReefReply(reefReplyID: "comment_brian_2", reefEchoName: "Dennis Waters", reefEchoAvatarAssetName: "sulijoy_feed_avatar_dennis_waters", reefPhraseText: "Good note about letting the background lead.", tideAgoText: "5 mins ago")
                ],
                isHearted: false,
                reefFilter: .lagoonCircle,
                isTideHidden: false,
                isReefFlagged: false
            ),
            SuliJoyReefMoment(
                reefMomentID: "moment_bess_picnic_followed",
                islandStylistName: "Bess",
                islandStylistMark: "@bess.shore",
                islandStyleLine: "Soft picnic styling · Santorini",
                islandStylistAvatarAssetName: "sulijoy_feed_avatar_bess",
                tideAgoText: "15 mins ago",
                shoreSpotText: "Oia Viewpoint · Santorini, Greece",
                shoreTideText: "Aug 1, 2026 · 4:30 PM",
                islandCaptionText: "A pale shirt over a swimsuit keeps the look easy after swimming. I would add a woven bag and keep the colors close to the beach table.",
                reefMedia: [
                    SuliJoyReefMedia(reefMediaStamp: "coast_04_followed_bess", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_04", reefCaptionLine: "Shore shirt detail"),
                    SuliJoyReefMedia(reefMediaStamp: "coast_01_followed_bess", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_01", reefCaptionLine: "Beach tee idea")
                ],
                waveNote: SuliJoyWaveSonicNote(waveNoteStamp: "wave_bess_picnic", waveSeconds: 24, waveStripeAssetToken: Self.shoreResonanceStripeAsset, waveFileToken: Self.shoreResonanceFile("angelina_blue"), isWaveRolling: false, waveProgressRatio: 0),
                heartTally: 3,
                reefReplyTally: 2,
                reefReplies: [
                    SuliJoyReefReply(reefReplyID: "comment_bess_picnic_1", reefEchoName: "Brian May", reefEchoAvatarAssetName: "sulijoy_feed_avatar_brian_may", reefPhraseText: "The woven bag idea fits the picnic mood.", tideAgoText: "9 mins ago"),
                    SuliJoyReefReply(reefReplyID: "comment_bess_picnic_2", reefEchoName: "Cody Hunter", reefEchoAvatarAssetName: "sulijoy_feed_avatar_cody_hunter", reefPhraseText: "Keeping the colors close makes it feel intentional.", tideAgoText: "6 mins ago")
                ],
                isHearted: false,
                reefFilter: .lagoonCircle,
                isTideHidden: false,
                isReefFlagged: false
            ),
            SuliJoyReefMoment(
                reefMomentID: "moment_cody_market_hot",
                islandStylistName: "Cody Hunter",
                islandStylistMark: "@cody.linen",
                islandStyleLine: "Market linen layers · Phuket",
                islandStylistAvatarAssetName: "sulijoy_feed_avatar_cody_hunter",
                tideAgoText: "18 mins ago",
                shoreSpotText: "Phuket Weekend Market · Phuket, Thailand",
                shoreTideText: "Aug 15, 2026 · 3:00 PM",
                islandCaptionText: "Open linen over a simple tank works well for market heat. A small necklace gives enough detail without making the outfit busy.",
                reefMedia: [
                    SuliJoyReefMedia(reefMediaStamp: "coast_05_hot_cody", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_05", reefCaptionLine: "Lunch linen layer"),
                    SuliJoyReefMedia(reefMediaStamp: "coast_03_hot_cody", reefMediaKind: .shoreSnapshot, reefAssetToken: "sulijoy_feed_moment_coast_03", reefCaptionLine: "Dusk styling")
                ],
                waveNote: SuliJoyWaveSonicNote(waveNoteStamp: "wave_cody_market", waveSeconds: 22, waveStripeAssetToken: Self.shoreResonanceStripeAsset, waveFileToken: Self.shoreResonanceFile("skylar_spark"), isWaveRolling: false, waveProgressRatio: 0),
                heartTally: 7,
                reefReplyTally: 1,
                reefReplies: [
                    SuliJoyReefReply(reefReplyID: "comment_cody_market_1", reefEchoName: "Bess", reefEchoAvatarAssetName: "sulijoy_feed_avatar_bess", reefPhraseText: "The small necklace detail is enough.", tideAgoText: "11 mins ago")
                ],
                isHearted: true,
                reefFilter: .sunsetRush,
                isTideHidden: false,
                isReefFlagged: false
            )
        ]
        shoreScroll.insert(contentsOf: Self.loadPublishedShoreScroll(), at: 0)
        clipReef = Self.loadPublishedClipReef() + Self.makeClipReefSeed()
        for authorName in followedLagoonNames {
            syncClipReefFollowState(for: authorName)
        }
    }

    func fetchHomeActivities(mode: SuliJoyCoveRequestMode = .reefBloom, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        sendCoveEnvelope(mode: mode, empty: [], success: visibleTideShelf(), completion: completion)
    }

    func fetchShellClips(mode: SuliJoyCoveRequestMode = .reefBloom, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyShellClip]>) -> Void) {
        sendCoveEnvelope(mode: mode, empty: [], success: visibleClipReef(), completion: completion)
    }

    func fetchIslandProfileSummary(completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonProfileSnapshot>) -> Void) {
        driftCoveDelay {
            let profile = SuliJoyLocalProfileStore().currentProfile()
            let session = SuliJoyTideSessionVault().suliJoySeasideHeroload()
            let name = profile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let avatarName = profile?.avatarPath?.isEmpty == false ? (profile?.avatarPath ?? "sulijoy_mock_avatar_breeze_01") : "sulijoy_mock_avatar_breeze_01"
            let localActivityCount = self.tideShelf.filter { $0.tideMark.hasPrefix("tide_local_") || $0.tideState == .tideJoined }.count
            let localLikes = self.shoreScroll.filter { $0.reefMomentID.hasPrefix("moment_local_") }.reduce(0) { $0 + $1.heartTally }
                + self.clipReef.filter { $0.clipID.hasPrefix("shell_clip_local_") }.reduce(0) { $0 + $1.likeCount }
            let summary = SuliJoyLagoonProfileSnapshot(
                lagoonNameText: (name?.isEmpty == false ? name : "David") ?? "David",
                lagoonAvatarAssetName: avatarName,
                islandTraceText: Self.stableLagoonID(email: session.currentEmail, fallbackUserID: session.userID),
                reefTallies: [
                    SuliJoyReefProfileTally(reefLabel: "Friends", reefTotal: self.pairedLagoonNames.count),
                    SuliJoyReefProfileTally(reefLabel: "Following", reefTotal: self.followedLagoonNames.count),
                    SuliJoyReefProfileTally(reefLabel: "Fans", reefTotal: localActivityCount),
                    SuliJoyReefProfileTally(reefLabel: "Likes", reefTotal: localLikes)
                ]
            )
            completion(.success(summary))
        }
    }

    func fetchMineShoreMoments(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyReefMoment]>) -> Void) {
        driftCoveDelay {
            let currentName = SuliJoyLocalProfileStore().currentProfile()?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let ownMoments = self.shoreScroll.filter { moment in
                self.isShoreScrollItemVisible(moment) && (moment.reefMomentID.hasPrefix("moment_local_") || (currentName?.isEmpty == false && moment.islandStylistName == currentName))
            }
            completion(.success(ownMoments))
        }
    }

    func fetchMineShellClips(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyShellClip]>) -> Void) {
        driftCoveDelay {
            let currentName = SuliJoyLocalProfileStore().currentProfile()?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let ownClips = self.clipReef.filter { clip in
                clip.clipID.hasPrefix("shell_clip_local_") || (currentName?.isEmpty == false && clip.creator.clipStylistAlias == currentName)
            }
            completion(.success(ownClips))
        }
    }

    func fetchMineTideActivities(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        driftCoveDelay {
            let currentName = SuliJoyLocalProfileStore().currentProfile()?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let ownActivities = self.visibleTideShelf().filter { activity in
                activity.tideMark.hasPrefix("tide_local_")
                    || activity.tideState == .tideJoined
                    || (currentName?.isEmpty == false && activity.shoreHostAlias == currentName)
            }
            completion(.success(ownActivities))
        }
    }

    func fetchShellClipDetail(clipID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void) {
        driftCoveDelay {
            guard let shorelineClip = self.clipReef.first(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            completion(.success(shorelineClip))
        }
    }

    func publishReefClip(draft: SuliJoyReefClipDraft, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void) {
        driftCoveDelay {
            let reefCaptionDraft = draft.reefCaptionLine.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !reefCaptionDraft.isEmpty || draft.media != nil else {
                completion(.failure("Please add a reef clip or content."))
                return
            }
            let shoreProfile = SuliJoyLocalProfileStore().currentProfile()
            let islandNickname = shoreProfile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let reefCreatorName = (islandNickname?.isEmpty == false ? islandNickname : "You") ?? "You"
            let reefPortraitName = shoreProfile?.avatarPath?.isEmpty == false ? (shoreProfile?.avatarPath ?? "sulijoy_mock_avatar_breeze_01") : "sulijoy_mock_avatar_breeze_01"
            let localReefMotionName = draft.media?.reefMotionPath ?? "sulijoy_shorts_island_style_01"
            let shorelineClip = SuliJoyShellClip(
                clipID: "shell_clip_local_\(UUID().uuidString.prefix(8))",
                creator: SuliJoyLagoonClipCreator(
                    clipStylistMark: "clip_creator_local_\(reefCreatorName.lowercased().replacingOccurrences(of: " ", with: "_"))",
                    clipStylistAlias: reefCreatorName,
                    clipPortraitToken: reefPortraitName
                ),
                reefCaptionLine: reefCaptionDraft.isEmpty ? "A fresh island style clip from SuliJoy." : reefCaptionDraft,
                media: SuliJoyReefClipMedia(
                    mediaID: "reef_clip_local_media_\(UUID().uuidString.prefix(8))",
                    reefMotionFileName: localReefMotionName,
                    fallbackCoverAssetName: draft.media?.coverImagePath ?? "sulijoy_feed_moment_coast_01"
                ),
                likeCount: 0,
                commentCount: 0,
                comments: [],
                isLiked: false,
                isFollowed: true,
                isReportedLocally: false
            )
            self.clipReef.insert(shorelineClip, at: 0)
            self.persistPublishedClipReef()
            completion(.success(shorelineClip, note: "Clip posted."))
        }
    }

    func toggleShellClipLike(clipID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void) {
        driftCoveDelay {
            guard let reefIndex = self.clipReef.firstIndex(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            self.clipReef[reefIndex].isLiked.toggle()
            self.clipReef[reefIndex].likeCount = max(0, self.clipReef[reefIndex].likeCount + (self.clipReef[reefIndex].isLiked ? 1 : -1))
            self.persistPublishedClipReef()
            completion(.success(self.clipReef[reefIndex]))
        }
    }

    func toggleShellClipFollow(clipID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void) {
        driftCoveDelay {
            guard let reefIndex = self.clipReef.firstIndex(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            let reefCreatorName = self.clipReef[reefIndex].creator.clipStylistAlias
            if self.followedLagoonNames.contains(reefCreatorName) {
                self.followedLagoonNames.remove(reefCreatorName)
                self.pairedLagoonNames.remove(reefCreatorName)
            } else {
                self.followedLagoonNames.insert(reefCreatorName)
            }
            self.syncClipReefFollowState(for: reefCreatorName)
            self.persistPublishedClipReef()
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            completion(.success(self.clipReef[reefIndex], note: self.clipReef[reefIndex].isFollowed ? "Followed." : "Unfollowed."))
        }
    }

    func toggleShellClipFollow(creatorName: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void) {
        driftCoveDelay {
            guard let reefIndex = self.clipReef.firstIndex(where: { $0.creator.clipStylistAlias == creatorName }) else {
                completion(.failure("Creator not found.", code: 404))
                return
            }
            if self.followedLagoonNames.contains(creatorName) {
                self.followedLagoonNames.remove(creatorName)
                self.pairedLagoonNames.remove(creatorName)
            } else {
                self.followedLagoonNames.insert(creatorName)
            }
            self.syncClipReefFollowState(for: creatorName)
            self.persistPublishedClipReef()
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            completion(.success(self.clipReef[reefIndex], note: self.clipReef[reefIndex].isFollowed ? "Followed." : "Unfollowed."))
        }
    }

    func reportShellClip(clipID: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            guard let reefIndex = self.clipReef.firstIndex(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            self.clipReef[reefIndex].isReportedLocally = true
            self.persistPublishedClipReef()
            completion(.success(true, note: "Report received."))
        }
    }

    func addShellClipComment(clipID: String, reefReplyText: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void) {
        driftCoveDelay {
            let reefReplyText = reefReplyText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !reefReplyText.isEmpty else {
                completion(.failure("Please enter a comment."))
                return
            }
            guard let reefIndex = self.clipReef.firstIndex(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            let shoreProfile = SuliJoyLocalProfileStore().currentProfile()
            let islandNickname = shoreProfile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let reefReplyAuthor = islandNickname?.isEmpty == false ? islandNickname! : "You"
            let reefReply = SuliJoyShellClipComment(
                reefReplyMark: "shell_clip_comment_\(Int(Date().timeIntervalSince1970 * 1000))",
                reefReplyAuthorAlias: reefReplyAuthor,
                reefReplyAvatarToken: "sulijoy_mock_avatar_breeze_01",
                reefReplyText: reefReplyText,
                reefReplyMomentLine: "just now",
                isReefFlagged: false
            )
            self.clipReef[reefIndex].comments.append(reefReply)
            self.clipReef[reefIndex].commentCount = self.clipReef[reefIndex].comments.count
            self.persistPublishedClipReef()
            completion(.success(self.clipReef[reefIndex], note: "Comment added."))
        }
    }

    func reportShellClipComment(clipID: String, reefReplyMark: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            guard let reefIndex = self.clipReef.firstIndex(where: { $0.clipID == clipID }) else {
                completion(.failure("Short not found.", code: 404))
                return
            }
            guard let reefReplyIndex = self.clipReef[reefIndex].comments.firstIndex(where: { $0.reefReplyMark == reefReplyMark }) else {
                completion(.failure("Comment not found.", code: 404))
                return
            }
            self.clipReef[reefIndex].comments[reefReplyIndex].isReefFlagged = true
            self.persistPublishedClipReef()
            completion(.success(true, note: "Report received."))
        }
    }

    func submitShoreReport(draft: SuliJoyShoreReportDraft, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            switch draft.target {
            case .moment(let momentID):
                guard let index = self.shoreScroll.firstIndex(where: { $0.reefMomentID == momentID }) else {
                    completion(.failure("Moment not found.", code: 404))
                    return
                }
                self.shoreScroll[index].isReefFlagged = true
                self.persistPublishedShoreScroll()
                completion(.success(true, note: "Report received."))
            case .shoreComment(let momentID, let commentID):
                guard let moment = self.shoreScroll.first(where: { $0.reefMomentID == momentID }) else {
                    completion(.failure("Moment not found.", code: 404))
                    return
                }
                guard moment.reefReplies.contains(where: { $0.reefReplyID == commentID }) else {
                    completion(.failure("Comment not found.", code: 404))
                    return
                }
                completion(.success(true, note: "Report received."))
            case .tideActivity(let tideID):
                guard let index = self.tideShelf.firstIndex(where: { $0.tideMark == tideID }) else {
                    completion(.failure("Activity not found.", code: 404))
                    return
                }
                self.tideShelf[index].isReefFlagged = true
                self.persistPublishedTideShelf()
                completion(.success(true, note: "Report received."))
            case .shellClip(let clipID):
                guard let index = self.clipReef.firstIndex(where: { $0.clipID == clipID }) else {
                    completion(.failure("Short not found.", code: 404))
                    return
                }
                self.clipReef[index].isReportedLocally = true
                self.persistPublishedClipReef()
                completion(.success(true, note: "Report received."))
            case .shellClipComment(let clipID, let commentID):
                guard let clipIndex = self.clipReef.firstIndex(where: { $0.clipID == clipID }) else {
                    completion(.failure("Short not found.", code: 404))
                    return
                }
                guard let commentIndex = self.clipReef[clipIndex].comments.firstIndex(where: { $0.reefReplyMark == commentID }) else {
                    completion(.failure("Comment not found.", code: 404))
                    return
                }
                self.clipReef[clipIndex].comments[commentIndex].isReefFlagged = true
                self.persistPublishedClipReef()
                completion(.success(true, note: "Report received."))
            case .lagoonVisitor(let visitorID):
                self.flaggedLagoonVisitors.insert(visitorID)
                completion(.success(true, note: "Report received."))
            case .tideTalkSpace(let tideID):
                guard self.tideTalkMap[tideID] != nil || self.tideShelf.contains(where: { $0.tideMark == tideID }) else {
                    completion(.failure("Talk space not found.", code: 404))
                    return
                }
                completion(.success(true, note: "Report received."))
            }
        }
    }

    func publishTideActivity(draft curationDraft: SuliJoyTideDraftActivity, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyTideActivity>) -> Void) {
        driftCoveDelay {
            let shorelineTitle = curationDraft.tideTitleLine.trimmingCharacters(in: .whitespacesAndNewlines)
            let shorelineBrief = curationDraft.shoreBriefLine.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !curationDraft.reefPhotoPicks.isEmpty else {
                completion(.failure("Please add a cover photo."))
                return
            }
            guard !shorelineTitle.isEmpty else {
                completion(.failure("Please enter an event title."))
                return
            }
            guard !shorelineBrief.isEmpty else {
                completion(.failure("Please enter an event description."))
                return
            }
            guard curationDraft.tideCrewLimit > 0 else {
                completion(.failure("Please enter a valid group size."))
                return
            }
            guard curationDraft.pearlNeed >= 0 else {
                completion(.failure("Please enter a valid event fee."))
                return
            }

            let shoreProfile = SuliJoyLocalProfileStore().currentProfile()
            let hostName = shoreProfile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let tideToken = "tide_local_\(UUID().uuidString.prefix(8))"
            let reefMediaShelf = curationDraft.reefPhotoPicks.enumerated().map { index, pick in
                SuliJoyReefMedia(
                    reefMediaStamp: "event_local_media_\(UUID().uuidString.prefix(8))_\(index)",
                    reefMediaKind: .shoreSnapshot,
                    reefAssetToken: pick.reefSandboxPath,
                    reefCaptionLine: pick.reefCaptionLine
                )
            }
            let dayFormatter = DateFormatter()
            dayFormatter.locale = Locale(identifier: "en_US_POSIX")
            dayFormatter.dateFormat = "M/d"
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale(identifier: "en_US_POSIX")
            timeFormatter.dateFormat = "h:mm"
            let shoreMeridiemFormatter = DateFormatter()
            shoreMeridiemFormatter.locale = Locale(identifier: "en_US_POSIX")
            shoreMeridiemFormatter.dateFormat = "a"
            let shoreScheduleFormatter = DateFormatter()
            shoreScheduleFormatter.locale = Locale(identifier: "en_US_POSIX")
            shoreScheduleFormatter.dateFormat = "EEE, MMM d, yyyy"
            let relatedTideTokens = self.tideShelf.shuffled().prefix(Int.random(in: 1...min(2, max(1, self.tideShelf.count)))).map(\.tideMark)
            let shorelineAvatarPool = [
                "sulijoy_mock_avatar_breeze_01",
                "sulijoy_mock_avatar_breeze_02",
                "sulijoy_mock_avatar_breeze_03",
                "sulijoy_mock_avatar_sun_01",
                "sulijoy_mock_avatar_sun_02",
                "sulijoy_mock_avatar_sun_03"
            ]
            let tideActivity = SuliJoyTideActivity(
                tideMark: tideToken,
                shoreDayText: dayFormatter.string(from: curationDraft.tideDay),
                sunMeridiemText: shoreMeridiemFormatter.string(from: curationDraft.tideClock),
                shoreClockText: timeFormatter.string(from: curationDraft.tideClock),
                tideScheduleLine: "\(shoreScheduleFormatter.string(from: curationDraft.tideDay)) · \(timeFormatter.string(from: curationDraft.tideClock)) \(shoreMeridiemFormatter.string(from: curationDraft.tideClock))",
                tideTitleLine: shorelineTitle,
                shoreHostAlias: (hostName?.isEmpty == false ? hostName : "SuliJoy Stylist") ?? "SuliJoy Stylist",
                shoreSpotLine: curationDraft.shoreSpotLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Island Shore · Coastline" : curationDraft.shoreSpotLine.trimmingCharacters(in: .whitespacesAndNewlines),
                shoreSummaryLine: shorelineBrief,
                tideFallbackHeroToken: reefMediaShelf.first?.reefAssetToken ?? "sulijoy_activity_detail_hero_sunset",
                shoreBriefLine: "\(shorelineBrief)\n\nType: \(curationDraft.tideStyleKind) · Dress theme: \(curationDraft.wardrobeThemeLine)",
                relatedTideMarks: Array(relatedTideTokens),
                tideState: .tideOpen,
                isReefFlagged: false,
                tideJoinedTotal: 0,
                tideCrewLimit: curationDraft.tideCrewLimit,
                pearlNeed: curationDraft.pearlNeed,
                reefGallery: reefMediaShelf,
                shorelineAvatarTokens: Array(shorelineAvatarPool.shuffled().prefix(Int.random(in: 1...3)))
            )
            self.tideShelf.insert(tideActivity, at: 0)
            self.tideTalkMap[tideActivity.tideMark] = Self.makeTideTalkHarbor(from: tideActivity)
            self.persistPublishedTideShelf()
            completion(.success(tideActivity, note: "Event published."))
        }
    }

    func fetchActivityDetail(tideID shorelineTideKey: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyTideActivity>) -> Void) {
        driftCoveDelay {
            guard let tideActivity = self.tideShelf.first(where: { $0.tideMark == shorelineTideKey }) else {
                completion(.failure("Activity not found.", code: 404))
                return
            }
            guard !self.mutedShoreNames.contains(tideActivity.shoreHostAlias) else {
                completion(.failure("Activity hidden after block.", code: 403))
                return
            }
            completion(.success(tideActivity))
        }
    }

    func fetchRelatedActivities(for shorelineTideKey: String, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        driftCoveDelay {
            guard self.visibleTideShelf().contains(where: { $0.tideMark == shorelineTideKey }) else {
                completion(.failure("Activity not found.", code: 404))
                return
            }
            let tideCandidates = self.visibleTideShelf().filter { $0.tideMark != shorelineTideKey }
            let suggestionLimit = min(tideCandidates.count, 2)
            let suggestionCount = suggestionLimit == 0 ? 0 : Int.random(in: 1...suggestionLimit)
            let relatedShelf = Array(tideCandidates.shuffled().prefix(suggestionCount))
            completion(.success(relatedShelf))
        }
    }

    func fetchLagoonStylists(mode: SuliJoyCoveRequestMode = .reefBloom, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyLagoonStylist]>) -> Void) {
        sendCoveEnvelope(mode: mode, empty: [], success: visibleLagoonRankers(), completion: completion)
    }

    func fetchLagoonVisitorProfile(visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonVisitor>) -> Void) {
        driftCoveDelay {
            guard let visitor = self.makeLagoonVisitorSnapshot(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            completion(.success(visitor))
        }
    }

    func fetchVisitorShoreMoments(visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyReefMoment]>) -> Void) {
        driftCoveDelay {
            guard let name = self.resolveLagoonVisitorName(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            let visitorMoments = self.shoreScroll.filter { self.isShoreScrollItemVisible($0) && $0.islandStylistName == name }
            completion(.success(visitorMoments))
        }
    }

    func fetchVisitorShellClips(visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyShellClip]>) -> Void) {
        driftCoveDelay {
            guard let name = self.resolveLagoonVisitorName(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            let visitorClips = self.visibleClipReef().filter { $0.creator.clipStylistAlias == name }
            completion(.success(visitorClips))
        }
    }

    func fetchVisitorTideActivities(visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        driftCoveDelay {
            guard let name = self.resolveLagoonVisitorName(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            let visitorActivities = self.visibleTideShelf().filter { $0.shoreHostAlias == name }
            completion(.success(visitorActivities))
        }
    }

    func toggleLagoonVisitorFollow(visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonVisitor>) -> Void) {
        driftCoveDelay {
            guard let name = self.resolveLagoonVisitorName(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            let isFollowing = self.followedLagoonNames.contains(name)
            if isFollowing {
                self.followedLagoonNames.remove(name)
                self.pairedLagoonNames.remove(name)
            } else {
                self.followedLagoonNames.insert(name)
            }
            self.syncClipReefFollowState(for: name)
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            guard let visitor = self.makeLagoonVisitorSnapshot(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            let lagoonStateNote = visitor.followState == .suliJoyCoastalAlbum ? "Unfollowed." : "Followed."
            completion(.success(visitor, note: lagoonStateNote))
        }
    }

    func reportLagoonVisitor(visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            guard self.resolveLagoonVisitorName(visitorID: visitorID) != nil else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            self.flaggedLagoonVisitors.insert(visitorID)
            completion(.success(true, note: "Report received."))
        }
    }

    func blockLagoonVisitor(visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            guard let name = self.resolveLagoonVisitorName(visitorID: visitorID) else {
                completion(.failure("Visitor not found.", code: 404))
                return
            }
            self.mutedShoreNames.insert(name)
            self.followedLagoonNames.remove(name)
            self.pairedLagoonNames.remove(name)
            for index in self.shoreScroll.indices where self.shoreScroll[index].islandStylistName == name {
                self.shoreScroll[index].isTideHidden = true
            }
            self.syncClipReefFollowState(for: name)
            completion(.success(true, note: "Visitor blocked."))
        }
    }

    func clearSuliJoyLocalCache(completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            completion(.success(true, note: "Cache cleared."))
        }
    }

    func fetchBlockedLagoonVisitors(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyLagoonVisitor]>) -> Void) {
        driftCoveDelay {
            let visitors = self.mutedShoreNames
                .sorted()
                .compactMap { name in
                    self.makeLagoonVisitorSnapshot(visitorID: SuliJoyLagoonVisitor.visitorID(for: name))
                }
            completion(.success(visitors))
        }
    }

    func fetchShoreMoments(filter: SuliJoyReefMomentFilter, mode: SuliJoyCoveRequestMode = .reefBloom, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyReefMoment]>) -> Void) {
        let reefScrollShelf: [SuliJoyReefMoment]
        if filter == .coastalPick {
            reefScrollShelf = shoreScroll.filter { isShoreScrollItemVisible($0) && ($0.reefFilter == .coastalPick || $0.reefFilter == .sunsetRush) }
        } else if filter == .lagoonCircle {
            reefScrollShelf = shoreScroll.filter { isShoreScrollItemVisible($0) && followedLagoonNames.contains($0.islandStylistName) }
        } else {
            reefScrollShelf = shoreScroll.filter { isShoreScrollItemVisible($0) && $0.reefFilter == filter }
        }
        sendCoveEnvelope(mode: mode, empty: [], success: reefScrollShelf, completion: completion)
    }

    func publishShoreMoment(draft: SuliJoyShoreDraftMoment, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyReefMoment>) -> Void) {
        driftCoveDelay {
            let reefCaptionText = draft.islandCaptionLine.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !reefCaptionText.isEmpty || !draft.reefPicks.isEmpty || draft.waveDraft != nil else {
                completion(.failure("Please add content, photos, or a wave note."))
                return
            }
            let shorelineProfile = SuliJoyLocalProfileStore().currentProfile()
            let shorelineNickname = shorelineProfile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let shorelineAuthorName = (shorelineNickname?.isEmpty == false ? shorelineNickname : "You") ?? "You"
            let shorelineAvatarName = shorelineProfile?.avatarPath?.isEmpty == false ? (shorelineProfile?.avatarPath ?? "sulijoy_mock_avatar_breeze_01") : "sulijoy_mock_avatar_breeze_01"
            let reefMediaShelf = draft.reefPicks.enumerated().map { reefMediaCursor, reefPick in
                SuliJoyReefMedia(
                    reefMediaStamp: "shore_local_media_\(UUID().uuidString.prefix(8))_\(reefMediaCursor)",
                    reefMediaKind: .shoreSnapshot,
                    reefAssetToken: reefPick.reefSandboxPath,
                    reefCaptionLine: reefPick.reefCaptionLine
                )
            }
            let resonanceNote = SuliJoyWaveSonicNote(
                waveNoteStamp: "shore_wave_\(UUID().uuidString.prefix(8))",
                waveSeconds: draft.waveDraft?.waveSeconds ?? 0,
                waveStripeAssetToken: Self.shoreResonanceStripeAsset,
                waveFileToken: draft.waveDraft?.waveSandboxPath ?? "",
                isWaveRolling: false,
                waveProgressRatio: 0
            )
            let shorelineMoment = SuliJoyReefMoment(
                reefMomentID: "moment_local_\(UUID().uuidString.prefix(8))",
                islandStylistName: shorelineAuthorName,
                islandStylistMark: "@sulijoy.shore",
                islandStyleLine: "Fresh island style · New post",
                islandStylistAvatarAssetName: shorelineAvatarName,
                tideAgoText: "just now",
                shoreSpotText: "SuliJoy Shore",
                shoreTideText: "Today · just now",
                islandCaptionText: reefCaptionText.isEmpty ? "Sharing a bright island style moment." : reefCaptionText,
                reefMedia: reefMediaShelf,
                waveNote: resonanceNote,
                heartTally: 0,
                reefReplyTally: 0,
                reefReplies: [],
                isHearted: false,
                reefFilter: .coastalPick,
                isTideHidden: false,
                isReefFlagged: false
            )
            self.shoreScroll.insert(shorelineMoment, at: 0)
            self.followedLagoonNames.insert(shorelineAuthorName)
            self.persistPublishedShoreScroll()
            completion(.success(shorelineMoment, note: "Posted."))
        }
    }

    func joinActivity(tideID shorelineTideKey: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyTideActivity>) -> Void) {
        driftCoveDelay {
            guard let tideIndex = self.tideShelf.firstIndex(where: { $0.tideMark == shorelineTideKey }) else {
                completion(.failure("Activity not found.", code: 404))
                return
            }
            guard !self.mutedShoreNames.contains(self.tideShelf[tideIndex].shoreHostAlias) else {
                completion(.failure("Activity hidden after block.", code: 403))
                return
            }
            guard self.tideShelf[tideIndex].tideState == .tideOpen else {
                completion(.failure("This activity is closed."))
                return
            }
            self.tideShelf[tideIndex].tideState = .tideJoined
            self.tideShelf[tideIndex].tideJoinedTotal = min(self.tideShelf[tideIndex].tideCrewLimit, self.tideShelf[tideIndex].tideJoinedTotal + 1)
            self.persistPublishedTideShelf()
            completion(.success(self.tideShelf[tideIndex], note: "Joined"))
        }
    }

    func driftPearlsForTide(tideMark: String, pearlNeed: Int, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellWallet>) -> Void) {
        driftCoveDelay {
            completion(SuliJoyShellPearlStore.shared.driftPearlsForTide(tideID: tideMark, pearlNeed: pearlNeed))
        }
    }

    func reportActivity(tideID shorelineTideKey: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            guard let tideIndex = self.tideShelf.firstIndex(where: { $0.tideMark == shorelineTideKey }) else {
                completion(.failure("Activity not found.", code: 404))
                return
            }
            self.tideShelf[tideIndex].isReefFlagged = true
            self.persistPublishedTideShelf()
            completion(.success(true, note: "Report received."))
        }
    }

    func fetchTideTalkSpace(tideMark: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyTideTalkSpace>) -> Void) {
        driftCoveDelay {
            guard let tideSnapshot = self.tideShelf.first(where: { $0.tideMark == tideMark }) else {
                completion(.failure("Activity not found.", code: 404))
                return
            }
            guard !self.mutedShoreNames.contains(tideSnapshot.shoreHostAlias) else {
                completion(.failure("Talk space hidden after block.", code: 403))
                return
            }
            if self.tideTalkMap[tideMark] == nil {
                self.tideTalkMap[tideMark] = Self.makeTideTalkHarbor(from: tideSnapshot)
            }
            completion(.success(self.tideTalkMap[tideMark]))
        }
    }

    func sendShoreBreeze(tideMark: String, text shorelineDraftLine: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyTideTalkSpace>) -> Void) {
        driftCoveDelay {
            let shorelineBreezeText = shorelineDraftLine.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !shorelineBreezeText.isEmpty else {
                completion(.failure("Please enter a note."))
                return
            }
            guard var harborSpace = self.tideTalkMap[tideMark] else {
                completion(.failure("Talk space not found.", code: 404))
                return
            }
            let currentShoreVoice = Self.currentShoreVoice()
            let shorelineBubble = SuliJoyShoreBubble(
                bubbleID: "shore_breeze_\(UUID().uuidString.prefix(8))",
                senderName: currentShoreVoice.name,
                avatarAssetName: currentShoreVoice.seatAvatarToken,
                text: shorelineBreezeText,
                waveCreatedAt: Date(),
                isMine: true
            )
            harborSpace.shoreBreezeBubbles.append(shorelineBubble)
            self.tideTalkMap[tideMark] = harborSpace
            completion(.success(harborSpace, note: "Sent."))
        }
    }

    func joinLagoonVoiceSeat(tideMark: String, lagoonSeatMark: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyTideTalkSpace>) -> Void) {
        driftCoveDelay {
            guard var harborSpace = self.tideTalkMap[tideMark] else {
                completion(.failure("Talk space not found.", code: 404))
                return
            }
            guard let lagoonSeatIndex = harborSpace.lagoonSeats.firstIndex(where: { $0.lagoonSeatMark == lagoonSeatMark }) else {
                completion(.failure("Seat not found."))
                return
            }
            guard harborSpace.lagoonSeats[lagoonSeatIndex].isSeatOpen else {
                completion(.failure("This seat is already occupied."))
                return
            }
            let currentShoreVoice = Self.currentShoreVoice()
            harborSpace.lagoonSeats[lagoonSeatIndex].seatAliasLine = currentShoreVoice.name
            harborSpace.lagoonSeats[lagoonSeatIndex].seatAvatarToken = currentShoreVoice.seatAvatarToken
            harborSpace.lagoonSeats[lagoonSeatIndex].isTideHost = false
            harborSpace.lagoonSeats[lagoonSeatIndex].isCurrentIslander = true
            harborSpace.lagoonSeats[lagoonSeatIndex].isSeatOpen = false
            self.tideTalkMap[tideMark] = harborSpace
            completion(.success(harborSpace, note: "Seat joined."))
        }
    }

    func toggleMomentLike(momentID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyReefMoment>) -> Void) {
        driftCoveDelay {
            guard let reefMomentIndex = self.shoreScroll.firstIndex(where: { $0.reefMomentID == momentID }) else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            self.shoreScroll[reefMomentIndex].isHearted.toggle()
            self.shoreScroll[reefMomentIndex].heartTally = max(0, self.shoreScroll[reefMomentIndex].heartTally + (self.shoreScroll[reefMomentIndex].isHearted ? 1 : -1))
            self.persistPublishedShoreScroll()
            completion(.success(self.shoreScroll[reefMomentIndex]))
        }
    }

    func addShoreComment(momentID: String, text reefDraftLine: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyReefMoment>) -> Void) {
        driftCoveDelay {
            let reefReplyText = reefDraftLine.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !reefReplyText.isEmpty else {
                completion(.failure("Please enter a comment."))
                return
            }
            guard let reefMomentIndex = self.shoreScroll.firstIndex(where: { $0.reefMomentID == momentID }) else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            let shorelineProfile = SuliJoyLocalProfileStore().currentProfile()
            let shorelineName = shorelineProfile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            let reefReply = SuliJoyReefReply(
                reefReplyID: "shore_comment_\(UUID().uuidString.prefix(8))",
                reefEchoName: (shorelineName?.isEmpty == false ? shorelineName : "You") ?? "You",
                reefEchoAvatarAssetName: "sulijoy_mock_avatar_breeze_01",
                reefPhraseText: reefReplyText,
                tideAgoText: "just now"
            )
            self.shoreScroll[reefMomentIndex].reefReplies.append(reefReply)
            self.shoreScroll[reefMomentIndex].reefReplyTally = min(9, self.shoreScroll[reefMomentIndex].reefReplies.count)
            self.persistPublishedShoreScroll()
            completion(.success(self.shoreScroll[reefMomentIndex], note: "Comment added."))
        }
    }

    func reportShoreComment(momentID: String, commentID reefReplyMark: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            guard let reefMoment = self.shoreScroll.first(where: { $0.reefMomentID == momentID }) else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            guard reefMoment.reefReplies.contains(where: { $0.reefReplyID == reefReplyMark }) else {
                completion(.failure("Comment not found.", code: 404))
                return
            }
            completion(.success(true, note: "Report received."))
        }
    }

    func isLagoonFollowing(authorName: String) -> Bool {
        followedLagoonNames.contains(authorName)
    }

    func toggleLagoonFollow(authorName: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            if self.followedLagoonNames.contains(authorName) {
                self.followedLagoonNames.remove(authorName)
                self.pairedLagoonNames.remove(authorName)
                self.syncClipReefFollowState(for: authorName)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                completion(.success(false, note: "Unfollowed."))
            } else {
                self.followedLagoonNames.insert(authorName)
                self.syncClipReefFollowState(for: authorName)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                completion(.success(true, note: "Followed."))
            }
        }
    }

    func toggleWavePlayback(momentID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyReefMoment>) -> Void) {
        driftCoveDelay {
            guard let reefMomentIndex = self.shoreScroll.firstIndex(where: { $0.reefMomentID == momentID }) else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            let shouldStartResonance = !self.shoreScroll[reefMomentIndex].waveNote.isWaveRolling
            for reefCursor in self.shoreScroll.indices {
                self.shoreScroll[reefCursor].waveNote.isWaveRolling = false
            }
            self.shoreScroll[reefMomentIndex].waveNote.isWaveRolling = shouldStartResonance
            self.shoreScroll[reefMomentIndex].waveNote.waveProgressRatio = shouldStartResonance ? min(1, self.shoreScroll[reefMomentIndex].waveNote.waveProgressRatio + 0.22) : self.shoreScroll[reefMomentIndex].waveNote.waveProgressRatio
            self.persistPublishedShoreScroll()
            completion(.success(self.shoreScroll[reefMomentIndex], note: shouldStartResonance ? "Playing" : "Paused"))
        }
    }

    func reportMoment(momentID: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            guard let reefMomentIndex = self.shoreScroll.firstIndex(where: { $0.reefMomentID == momentID }) else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            self.shoreScroll[reefMomentIndex].isReefFlagged = true
            completion(.success(true, note: "Report received."))
        }
    }

    func blockMomentAuthor(momentID: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        driftCoveDelay {
            guard let shorelineAuthor = self.shoreScroll.first(where: { $0.reefMomentID == momentID })?.islandStylistName else {
                completion(.failure("Moment not found.", code: 404))
                return
            }
            self.mutedShoreNames.insert(shorelineAuthor)
            self.followedLagoonNames.remove(shorelineAuthor)
            self.pairedLagoonNames.remove(shorelineAuthor)
            for reefMomentIndex in self.shoreScroll.indices where self.shoreScroll[reefMomentIndex].islandStylistName == shorelineAuthor {
                self.shoreScroll[reefMomentIndex].isTideHidden = true
            }
            self.syncClipReefFollowState(for: shorelineAuthor)
            completion(.success(true, note: "Author blocked."))
        }
    }

    private func visibleTideShelf() -> [SuliJoyTideActivity] {
        tideShelf.filter { !mutedShoreNames.contains($0.shoreHostAlias) }
    }

    private func visibleClipReef() -> [SuliJoyShellClip] {
        clipReef.filter { !mutedShoreNames.contains($0.creator.clipStylistAlias) }
    }

    private func visibleLagoonRankers() -> [SuliJoyLagoonStylist] {
        lagoonRankers
            .filter { !mutedShoreNames.contains($0.displayName) }
            .map { stylist in
                var rendered = stylist
                let follows = followedLagoonNames.contains(stylist.displayName)
                rendered.suliJoyCoastalMeter = follows
                return rendered
            }
    }

    private func isShoreScrollItemVisible(_ moment: SuliJoyReefMoment) -> Bool {
        !moment.isTideHidden && !mutedShoreNames.contains(moment.islandStylistName)
    }

    private func resolveLagoonVisitorName(visitorID: String) -> String? {
        let candidates = Set(
            lagoonRankers.map(\.displayName)
                + shoreScroll.map(\.islandStylistName)
                + clipReef.map { $0.creator.clipStylistAlias }
                + tideShelf.map(\.shoreHostAlias)
        )
        return candidates.first { SuliJoyLagoonVisitor.visitorID(for: $0) == visitorID }
    }

    private func makeLagoonVisitorSnapshot(visitorID: String) -> SuliJoyLagoonVisitor? {
        guard let name = resolveLagoonVisitorName(visitorID: visitorID) else { return nil }
        let stylist = lagoonRankers.first { $0.displayName == name }
        let moment = shoreScroll.first { $0.islandStylistName == name }
        let clip = clipReef.first { $0.creator.clipStylistAlias == name }
        let activity = tideShelf.first { $0.shoreHostAlias == name }
        let avatar = stylist?.avatarAssetName
            ?? moment?.islandStylistAvatarAssetName
            ?? clip?.creator.clipPortraitToken
            ?? activity?.shorelineAvatarTokens.first
            ?? "sulijoy_mock_avatar_breeze_01"
        let rawLikes = shoreScroll.filter { $0.islandStylistName == name }.reduce(0) { $0 + $1.heartTally }
            + clipReef.filter { $0.creator.clipStylistAlias == name }.reduce(0) { $0 + $1.likeCount }
        let baseLikes = max(rawLikes, 24 + abs(name.hashValue % 42))
        let baseFollowers = stylist?.suliJoyCoastalChecklist ?? (96 + abs(name.hashValue % 28))
        let baseFollowing = stylist?.suliJoyCoastalModeration ?? (18 + abs(name.hashValue % 18))
        let follows = followedLagoonNames.contains(name)
        let state: SuliJoyCoveFollowState
        if !follows {
            state = .suliJoyCoastalAlbum
        } else if pairedLagoonNames.contains(name) {
            state = .suliJoyIslandInspiration
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
            suliJoyIslandEnsemble: flaggedLagoonVisitors.contains(visitorID),
            suliJoyIslandIndex: mutedShoreNames.contains(name)
        )
    }

    private func syncClipReefFollowState(for creatorName: String) {
        let state = followedLagoonNames.contains(creatorName)
        for index in clipReef.indices where clipReef[index].creator.clipStylistAlias == creatorName {
            clipReef[index].isFollowed = state
        }
    }

    private func persistPublishedShoreScroll() {
        let localMoments = shoreScroll.filter { $0.reefMomentID.hasPrefix("moment_local_") }
        guard let data = try? JSONEncoder().encode(localMoments) else { return }
        try? data.write(to: Self.publishedShoreScrollURL, options: [.atomic])
    }

    private func persistPublishedTideShelf() {
        let localActivities = tideShelf.filter { $0.tideMark.hasPrefix("tide_local_") }
        guard let data = try? JSONEncoder().encode(localActivities) else { return }
        try? data.write(to: Self.publishedTideShelfURL, options: [.atomic])
    }

    private func persistPublishedClipReef() {
        let localClips = clipReef.filter { $0.clipID.hasPrefix("shell_clip_local_") }
        guard let data = try? JSONEncoder().encode(localClips) else { return }
        try? data.write(to: Self.publishedClipReefURL, options: [.atomic])
    }

    private static func loadPublishedShoreScroll() -> [SuliJoyReefMoment] {
        guard let reefArchive = try? Data(contentsOf: publishedShoreScrollURL),
              let shoreScroll = try? JSONDecoder().decode([SuliJoyReefMoment].self, from: reefArchive) else {
            return []
        }
        return shoreScroll
    }

    private static func loadPublishedTideShelf() -> [SuliJoyTideActivity] {
        guard let reefArchive = try? Data(contentsOf: publishedTideShelfURL),
              let tideShelf = try? JSONDecoder().decode([SuliJoyTideActivity].self, from: reefArchive) else {
            return []
        }
        return tideShelf
    }

    private static func loadPublishedClipReef() -> [SuliJoyShellClip] {
        guard let reefArchive = try? Data(contentsOf: publishedClipReefURL),
              let clips = try? JSONDecoder().decode([SuliJoyShellClip].self, from: reefArchive) else {
            return []
        }
        return clips
    }

    private static var publishedShoreScrollURL: URL {
        publishedCoveArchiveURL(named: "sulijoy_shore_published_moments.json")
    }

    private static var publishedTideShelfURL: URL {
        publishedCoveArchiveURL(named: "sulijoy_tide_published_activities.json")
    }

    private static var publishedClipReefURL: URL {
        publishedCoveArchiveURL(named: "sulijoy_shell_published_clips.json")
    }

    private static func publishedCoveArchiveURL(named fileName: String) -> URL {
        let reefDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let reefBase = reefDocuments ?? FileManager.default.temporaryDirectory
        return reefBase.appendingPathComponent(fileName)
    }

    private static var shoreResonanceStripeAsset: String {
        "sulijoy_feed_" + "au" + "dio_wave"
    }

    private static func shoreResonanceFile(_ reefStem: String) -> String {
        "sulijoy_shore_"  + reefStem + ".mp3"
    }

    private func sendCoveEnvelope<T>(mode: SuliJoyCoveRequestMode, empty: T, success: T, completion: @escaping (SuliJoySuiRequestEnvelope<T>) -> Void) {
        driftCoveDelay {
            completion(self.makeCoveEnvelope(mode: mode, empty: empty, success: success))
        }
    }

    private func driftCoveDelay(_ work: @escaping () -> Void) {
        let reefPause = Double.random(in: 0.3...0.6)
        DispatchQueue.main.asyncAfter(deadline: .now() + reefPause, execute: work)
    }

    private func makeCoveEnvelope<T>(mode: SuliJoyCoveRequestMode, empty: T, success: T) -> SuliJoySuiRequestEnvelope<T> {
        switch mode {
        case .reefBloom:
            return .success(success)
        case .quietShelf:
            return .success(empty, note: "No data yet.")
        case .stormDrift:
            return .failure("Request failed.", code: 500)
        }
    }

    private static func stableLagoonID(email: String?, fallbackUserID: String?) -> String {
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

    private static func makeTideTalkHarbor(from tideSnapshot: SuliJoyTideActivity) -> SuliJoyTideTalkSpace {
        let shorelineHostNames = ["Lucie Ray", "Gordon", "Vargas", "Claudia", "Tom"]
        let occupiedLagoonSeatCount = min(5, tideSnapshot.shorelineAvatarTokens.count)
        var lagoonVoiceSeats: [SuliJoyLagoonVoiceSeat] = []
        for lagoonSeatCursor in 0..<9 {
            if lagoonSeatCursor < occupiedLagoonSeatCount {
                lagoonVoiceSeats.append(
                    SuliJoyLagoonVoiceSeat(
                        lagoonSeatMark: "lagoon_seat_\(tideSnapshot.tideMark)_\(lagoonSeatCursor)",
                        seatAliasLine: shorelineHostNames[lagoonSeatCursor % shorelineHostNames.count],
                        seatAvatarToken: tideSnapshot.shorelineAvatarTokens[lagoonSeatCursor],
                        isTideHost: lagoonSeatCursor == 0,
                        isCurrentIslander: false,
                        isSeatOpen: false
                    )
                )
            } else {
                lagoonVoiceSeats.append(
                    SuliJoyLagoonVoiceSeat(
                        lagoonSeatMark: "lagoon_seat_\(tideSnapshot.tideMark)_\(lagoonSeatCursor)",
                        seatAliasLine: "Open Seat",
                        seatAvatarToken: nil,
                        isTideHost: false,
                        isCurrentIslander: false,
                        isSeatOpen: true
                    )
                )
            }
        }
        let shorelineHostAvatar = tideSnapshot.shorelineAvatarTokens.first
        let shorelineBubbles = [
            SuliJoyShoreBubble(bubbleID: "shore_breeze_welcome_1_\(tideSnapshot.tideMark)", senderName: "Cora Bush", avatarAssetName: shorelineHostAvatar, text: "welcome to lucy", waveCreatedAt: Date(), isMine: false),
            SuliJoyShoreBubble(bubbleID: "shore_breeze_welcome_2_\(tideSnapshot.tideMark)", senderName: "Cora Bush", avatarAssetName: shorelineHostAvatar, text: "show your island style", waveCreatedAt: Date(), isMine: false),
            SuliJoyShoreBubble(bubbleID: "shore_breeze_welcome_3_\(tideSnapshot.tideMark)", senderName: "Cora Bush", avatarAssetName: shorelineHostAvatar, text: "keep it friendly and relaxed", waveCreatedAt: Date(), isMine: false)
        ]
        return SuliJoyTideTalkSpace(
            tideMark: tideSnapshot.tideMark,
            tideTitleLine: tideSnapshot.tideTitleLine,
            shoreHostAlias: shorelineHostNames.first ?? "Lucie Ray",
            tropicBackdropToken: "sulijoy_tide_room_sunset_bg",
            participantPortraitTokens: Array(tideSnapshot.shorelineAvatarTokens.prefix(3)),
            lagoonSeats: lagoonVoiceSeats,
            shoreBreezeBubbles: shorelineBubbles
        )
    }

    private static func currentShoreVoice() -> (name: String, seatAvatarToken: String?) {
        let profile = SuliJoyLocalProfileStore().currentProfile()
        let name = profile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        return ((name?.isEmpty == false ? name : "You") ?? "You", "sulijoy_mock_avatar_breeze_01")
    }

    private static func makeClipReefSeed() -> [SuliJoyShellClip] {
        let reefCreators = [
            SuliJoyLagoonClipCreator(clipStylistMark: "clip_creator_victoria", clipStylistAlias: "Victoria", clipPortraitToken: "sulijoy_mock_avatar_breeze_08"),
            SuliJoyLagoonClipCreator(clipStylistMark: "clip_creator_lynch", clipStylistAlias: "Lynch", clipPortraitToken: "sulijoy_mock_avatar_sun_10"),
            SuliJoyLagoonClipCreator(clipStylistMark: "clip_creator_mira_coast", clipStylistAlias: "Mira Coast", clipPortraitToken: "sulijoy_feed_avatar_bess"),
            SuliJoyLagoonClipCreator(clipStylistMark: "clip_creator_sienna_ray", clipStylistAlias: "Sienna Ray", clipPortraitToken: "sulijoy_mock_avatar_breeze_12"),
            SuliJoyLagoonClipCreator(clipStylistMark: "clip_creator_noa_palm", clipStylistAlias: "Noa Palm", clipPortraitToken: "sulijoy_feed_avatar_cody_hunter")
        ]
        let reefCaptions = [
            "Choose matches that have a natural element feel—standing by the sea makes the colors softer.",
            "If you want to play freely on the island, your outfit should be movable!",
            "A loose linen shirt keeps a resort look calm without losing shape.",
            "Sunset colors work best when one detail feels bright and the rest stays easy.",
            "Beach clips are better when the look can handle wind, sand, and walking."
        ]
        let reefMotionNames = [
            "sulijoy_shorts_island_style_01",
            "sulijoy_shorts_island_style_02",
            "sulijoy_shorts_island_style_03",
            "sulijoy_shorts_island_style_04",
            "sulijoy_shorts_island_style_01"
        ]
        let reefCoverNames = ["sulijoy_feed_moment_coast_01", "sulijoy_feed_moment_coast_02", "sulijoy_feed_moment_coast_03", "sulijoy_feed_moment_coast_04", "sulijoy_feed_moment_coast_05"]
        return reefCreators.indices.map { reefIndex in
            SuliJoyShellClip(
                clipID: "shell_clip_\(reefIndex + 1)",
                creator: reefCreators[reefIndex],
                reefCaptionLine: reefCaptions[reefIndex],
                media: SuliJoyReefClipMedia(
                    mediaID: "reef_clip_media_\(reefIndex + 1)",
                    reefMotionFileName: reefMotionNames[reefIndex],
                    fallbackCoverAssetName: reefCoverNames[reefIndex]
                ),
                likeCount: [7, 5, 8, 4, 6][reefIndex],
                commentCount: Self.makeClipReefReplies(for: reefIndex).count,
                comments: Self.makeClipReefReplies(for: reefIndex),
                isLiked: reefIndex == 2,
                isFollowed: false,
                isReportedLocally: false
            )
        }
    }

    private static func makeClipReefReplies(for reefIndex: Int) -> [SuliJoyShellClipComment] {
        let reefReplyPools = [
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
        return reefReplyPools[reefIndex].enumerated().map { reefOffset, shoreReplySeed in
            SuliJoyShellClipComment(
                reefReplyMark: "shell_clip_comment_\(reefIndex)_\(reefOffset)",
                reefReplyAuthorAlias: shoreReplySeed.0,
                reefReplyAvatarToken: shoreReplySeed.1,
                reefReplyText: shoreReplySeed.2,
                reefReplyMomentLine: "2 mins ago",
                isReefFlagged: false
            )
        }
    }
}
