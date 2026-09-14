import UIKit

final class SuliJoyTideCoastalDetailController: SuliJoyTropicCanvasController, UIScrollViewDelegate {
    private let shorelineTideKey: String
    private var shorelineTideDetail: SuliJoyTideActivity?
    private var coastalSuggestionShelf: [SuliJoyTideActivity] = []

    private let shoreDetailScrollCanvas = UIScrollView()
    private let shoreDetailDeck = UIView()
    private let shoreHeroCarousel = UIScrollView()
    private let shoreHeroRibbon = UIStackView()
    private let shoreHeroDots = UIPageControl()
    private let shoreInfoCard = UIView()
    private let shoreTitleGlyph = UILabel()
    private let shoreStateGlyph = UILabel()
    private let shorePlaceGlyph = UILabel()
    private let shoreTimingGlyph = UILabel()
    private let shoreAvatarRail = UIStackView()
    private let shoreCrewCountGlyph = UILabel()
    private let shoreBriefCard = UIView()
    private let shoreBriefGlyph = UILabel()
    private let shoreSuggestionCard = UIView()
    private let shoreSuggestionGrid = UIStackView()
    private let shoreActionFooter = UIView()
    private let shorePrimaryControl = SuliJoyGradientButton(reefHeadline: "JgoAiznq tEmvueCnhtG".suliJoyPalmUnfurled)
    private let shoreFlagControl = UIButton(type: .system)
    private let shoreSpinner = UIActivityIndicatorView(style: .large)

    convenience init(crinkleLinen tideID: String) {
        self.init(shorelineTideKey: tideID)
    }

    init(shorelineTideKey: String) {
        self.shorelineTideKey = shorelineTideKey
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("iEnZiStu(qcFoRdaewrk:m)t ohlatse pnyoOtS Obaeeesne FilmwpXlkeAmVeonltKemdv".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        shoreDetailScrollCanvas.contentInsetAdjustmentBehavior = .never
        raiseShorelineDetailScene()
        loadShorelineDetail()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            tabBarController?.tabBar.isHidden = false
        }
    }

    private func raiseShorelineDetailScene() {
        shoreDetailScrollCanvas.translatesAutoresizingMaskIntoConstraints = false
        shoreDetailScrollCanvas.showsVerticalScrollIndicator = false
        shoreDetailDeck.translatesAutoresizingMaskIntoConstraints = false

        shoreHeroCarousel.translatesAutoresizingMaskIntoConstraints = false
        shoreHeroCarousel.isPagingEnabled = true
        shoreHeroCarousel.showsHorizontalScrollIndicator = false
        shoreHeroCarousel.bounces = true
        shoreHeroCarousel.delegate = self
        shoreHeroCarousel.backgroundColor = UIColor(red: 1, green: 0.84, blue: 0.58, alpha: 1)

        shoreHeroRibbon.translatesAutoresizingMaskIntoConstraints = false
        shoreHeroRibbon.axis = .horizontal
        shoreHeroRibbon.spacing = 0
        shoreHeroRibbon.distribution = .fillEqually

        shoreHeroDots.translatesAutoresizingMaskIntoConstraints = false
        shoreHeroDots.currentPageIndicatorTintColor = .white
        shoreHeroDots.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.48)
        shoreHeroDots.hidesForSinglePage = true

        let beachwearCapsule = UIButton(type: .system)
        beachwearCapsule.translatesAutoresizingMaskIntoConstraints = false
        beachwearCapsule.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        beachwearCapsule.tintColor = .black
        beachwearCapsule.backgroundColor = UIColor.white.withAlphaComponent(0.42)
        beachwearCapsule.layer.cornerRadius = 18
        beachwearCapsule.addTarget(self, action: #selector(driftBackFromShoreDetail), for: .touchUpInside)

        shoreFlagControl.translatesAutoresizingMaskIntoConstraints = false
        shoreFlagControl.setImage(UIImage(systemName: "flag.fill"), for: .normal)
        shoreFlagControl.tintColor = UIColor(red: 1, green: 0.42, blue: 0.18, alpha: 1)
        shoreFlagControl.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        shoreFlagControl.layer.cornerRadius = 15
        shoreFlagControl.accessibilityLabel = "Report shorelineTideDetail"
        shoreFlagControl.addTarget(self, action: #selector(openShoreModerationMenu), for: .touchUpInside)

        tuneShorelineCard(shoreInfoCard)
        tuneShorelineCard(shoreBriefCard)
        tuneShorelineCard(shoreSuggestionCard)

        shoreTitleGlyph.font = UIFont.systemFont(ofSize: 18, weight: .black)
        shoreTitleGlyph.textColor = .suliInk
        shoreTitleGlyph.numberOfLines = 2

        shoreStateGlyph.font = UIFont.italicSystemFont(ofSize: 14).suliWithWeight(.bold)
        shoreStateGlyph.textAlignment = .center
        shoreStateGlyph.layer.cornerRadius = 11
        shoreStateGlyph.clipsToBounds = true

        [shorePlaceGlyph, shoreTimingGlyph].forEach {
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .suliInk
            $0.numberOfLines = 1
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        shoreAvatarRail.axis = .horizontal
        shoreAvatarRail.spacing = -6
        shoreCrewCountGlyph.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        shoreCrewCountGlyph.textColor = .white
        shoreCrewCountGlyph.textAlignment = .center
        shoreCrewCountGlyph.backgroundColor = .black
        shoreCrewCountGlyph.layer.cornerRadius = 12
        shoreCrewCountGlyph.clipsToBounds = true

        let infoBlock = UIView()
        infoBlock.translatesAutoresizingMaskIntoConstraints = false
        infoBlock.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        infoBlock.layer.cornerRadius = 8

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)

        [shoreTitleGlyph, shoreStateGlyph, infoBlock, shoreAvatarRail, shoreCrewCountGlyph].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            shoreInfoCard.addSubview($0)
        }
        [shorePlaceGlyph, separator, shoreTimingGlyph].forEach { infoBlock.addSubview($0) }

        let descTitle = UILabel()
        descTitle.translatesAutoresizingMaskIntoConstraints = false
        descTitle.text = "EkvmeQndte JDgeyshcMrTivpctyigornC".suliJoyPalmUnfurled
        descTitle.font = UIFont.systemFont(ofSize: 17, weight: .black)
        descTitle.textColor = .suliInk
        shoreBriefGlyph.translatesAutoresizingMaskIntoConstraints = false
        shoreBriefGlyph.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        shoreBriefGlyph.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
        shoreBriefGlyph.numberOfLines = 0
        [descTitle, shoreBriefGlyph].forEach { shoreBriefCard.addSubview($0) }

        let relatedTitle = UILabel()
        relatedTitle.translatesAutoresizingMaskIntoConstraints = false
        relatedTitle.text = "OStBhherrf vaXcktpiYvPiotOiDehsy".suliJoyPalmUnfurled
        relatedTitle.font = UIFont.systemFont(ofSize: 17, weight: .black)
        relatedTitle.textColor = .suliInk
        shoreSuggestionGrid.axis = .vertical
        shoreSuggestionGrid.spacing = 12
        shoreSuggestionGrid.translatesAutoresizingMaskIntoConstraints = false
        [relatedTitle, shoreSuggestionGrid].forEach { shoreSuggestionCard.addSubview($0) }

        shoreActionFooter.translatesAutoresizingMaskIntoConstraints = false
        shoreActionFooter.backgroundColor = .white
        shorePrimaryControl.translatesAutoresizingMaskIntoConstraints = false
        shorePrimaryControl.titleLabel?.font = UIFont.italicSystemFont(ofSize: 20).suliWithWeight(.black)
        shorePrimaryControl.addTarget(self, action: #selector(runShorePrimaryAction), for: .touchUpInside)
        shoreActionFooter.addSubview(shorePrimaryControl)

        shoreSpinner.translatesAutoresizingMaskIntoConstraints = false
        shoreSpinner.color = .suliInk
        shoreSpinner.hidesWhenStopped = true

        view.addSubview(shoreDetailScrollCanvas)
        view.addSubview(beachwearCapsule)
        view.addSubview(shoreFlagControl)
        view.addSubview(shoreActionFooter)
        view.addSubview(shoreSpinner)
        shoreDetailScrollCanvas.addSubview(shoreDetailDeck)
        shoreHeroCarousel.addSubview(shoreHeroRibbon)
        [shoreHeroCarousel, shoreHeroDots, shoreInfoCard, shoreBriefCard, shoreSuggestionCard].forEach { shoreDetailDeck.addSubview($0) }

        NSLayoutConstraint.activate([
            shoreDetailScrollCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            shoreDetailScrollCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreDetailScrollCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreDetailScrollCanvas.bottomAnchor.constraint(equalTo: shoreActionFooter.topAnchor),
            shoreDetailDeck.topAnchor.constraint(equalTo: shoreDetailScrollCanvas.contentLayoutGuide.topAnchor),
            shoreDetailDeck.leadingAnchor.constraint(equalTo: shoreDetailScrollCanvas.contentLayoutGuide.leadingAnchor),
            shoreDetailDeck.trailingAnchor.constraint(equalTo: shoreDetailScrollCanvas.contentLayoutGuide.trailingAnchor),
            shoreDetailDeck.bottomAnchor.constraint(equalTo: shoreDetailScrollCanvas.contentLayoutGuide.bottomAnchor),
            shoreDetailDeck.widthAnchor.constraint(equalTo: shoreDetailScrollCanvas.frameLayoutGuide.widthAnchor),

            shoreHeroCarousel.topAnchor.constraint(equalTo: shoreDetailDeck.topAnchor),
            shoreHeroCarousel.leadingAnchor.constraint(equalTo: shoreDetailDeck.leadingAnchor),
            shoreHeroCarousel.trailingAnchor.constraint(equalTo: shoreDetailDeck.trailingAnchor),
            shoreHeroCarousel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.46),
            shoreHeroRibbon.topAnchor.constraint(equalTo: shoreHeroCarousel.contentLayoutGuide.topAnchor),
            shoreHeroRibbon.leadingAnchor.constraint(equalTo: shoreHeroCarousel.contentLayoutGuide.leadingAnchor),
            shoreHeroRibbon.trailingAnchor.constraint(equalTo: shoreHeroCarousel.contentLayoutGuide.trailingAnchor),
            shoreHeroRibbon.bottomAnchor.constraint(equalTo: shoreHeroCarousel.contentLayoutGuide.bottomAnchor),
            shoreHeroRibbon.heightAnchor.constraint(equalTo: shoreHeroCarousel.frameLayoutGuide.heightAnchor),
            shoreHeroDots.centerXAnchor.constraint(equalTo: shoreHeroCarousel.centerXAnchor),
            shoreHeroDots.bottomAnchor.constraint(equalTo: shoreHeroCarousel.bottomAnchor, constant: -84),

            beachwearCapsule.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            beachwearCapsule.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            beachwearCapsule.widthAnchor.constraint(equalToConstant: 36),
            beachwearCapsule.heightAnchor.constraint(equalToConstant: 36),
            shoreFlagControl.centerYAnchor.constraint(equalTo: beachwearCapsule.centerYAnchor),
            shoreFlagControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            shoreFlagControl.widthAnchor.constraint(equalToConstant: 30),
            shoreFlagControl.heightAnchor.constraint(equalToConstant: 30),

            shoreInfoCard.topAnchor.constraint(equalTo: shoreHeroCarousel.bottomAnchor, constant: -72),
            shoreInfoCard.leadingAnchor.constraint(equalTo: shoreDetailDeck.leadingAnchor, constant: 22),
            shoreInfoCard.trailingAnchor.constraint(equalTo: shoreDetailDeck.trailingAnchor, constant: -22),
            shoreTitleGlyph.topAnchor.constraint(equalTo: shoreInfoCard.topAnchor, constant: 18),
            shoreTitleGlyph.leadingAnchor.constraint(equalTo: shoreInfoCard.leadingAnchor, constant: 22),
            shoreTitleGlyph.trailingAnchor.constraint(lessThanOrEqualTo: shoreStateGlyph.leadingAnchor, constant: -12),
            shoreStateGlyph.centerYAnchor.constraint(equalTo: shoreTitleGlyph.centerYAnchor),
            shoreStateGlyph.trailingAnchor.constraint(equalTo: shoreInfoCard.trailingAnchor, constant: -14),
            shoreStateGlyph.widthAnchor.constraint(greaterThanOrEqualToConstant: 82),
            shoreStateGlyph.heightAnchor.constraint(equalToConstant: 32),
            infoBlock.topAnchor.constraint(equalTo: shoreTitleGlyph.bottomAnchor, constant: 18),
            infoBlock.leadingAnchor.constraint(equalTo: shoreTitleGlyph.leadingAnchor),
            infoBlock.trailingAnchor.constraint(equalTo: shoreStateGlyph.trailingAnchor),
            infoBlock.heightAnchor.constraint(equalToConstant: 88),
            shorePlaceGlyph.topAnchor.constraint(equalTo: infoBlock.topAnchor, constant: 13),
            shorePlaceGlyph.leadingAnchor.constraint(equalTo: infoBlock.leadingAnchor, constant: 14),
            shorePlaceGlyph.trailingAnchor.constraint(equalTo: infoBlock.trailingAnchor, constant: -14),
            
            separator.topAnchor.constraint(equalTo: shorePlaceGlyph.bottomAnchor, constant: 12),
            separator.leadingAnchor.constraint(equalTo: shorePlaceGlyph.leadingAnchor, constant: 22),
            separator.trailingAnchor.constraint(equalTo: infoBlock.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            shoreTimingGlyph.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12),
            shoreTimingGlyph.leadingAnchor.constraint(equalTo: shorePlaceGlyph.leadingAnchor),
            shoreTimingGlyph.trailingAnchor.constraint(equalTo: shorePlaceGlyph.trailingAnchor),
            shoreAvatarRail.topAnchor.constraint(equalTo: infoBlock.bottomAnchor, constant: 16),
            shoreAvatarRail.leadingAnchor.constraint(equalTo: infoBlock.leadingAnchor, constant: 12),
            shoreAvatarRail.heightAnchor.constraint(equalToConstant: 24),
            shoreCrewCountGlyph.leadingAnchor.constraint(equalTo: shoreAvatarRail.trailingAnchor, constant: -3),
            shoreCrewCountGlyph.centerYAnchor.constraint(equalTo: shoreAvatarRail.centerYAnchor),
            shoreCrewCountGlyph.widthAnchor.constraint(equalToConstant: 24),
            shoreCrewCountGlyph.heightAnchor.constraint(equalToConstant: 24),
            shoreCrewCountGlyph.trailingAnchor.constraint(lessThanOrEqualTo: infoBlock.trailingAnchor, constant: -6),
            shoreInfoCard.bottomAnchor.constraint(equalTo: shoreAvatarRail.bottomAnchor, constant: 20),

            shoreBriefCard.topAnchor.constraint(equalTo: shoreInfoCard.bottomAnchor, constant: 20),
            shoreBriefCard.leadingAnchor.constraint(equalTo: shoreInfoCard.leadingAnchor),
            shoreBriefCard.trailingAnchor.constraint(equalTo: shoreInfoCard.trailingAnchor),
            descTitle.topAnchor.constraint(equalTo: shoreBriefCard.topAnchor, constant: 20),
            descTitle.leadingAnchor.constraint(equalTo: shoreBriefCard.leadingAnchor, constant: 22),
            descTitle.trailingAnchor.constraint(equalTo: shoreBriefCard.trailingAnchor, constant: -22),
            shoreBriefGlyph.topAnchor.constraint(equalTo: descTitle.bottomAnchor, constant: 14),
            shoreBriefGlyph.leadingAnchor.constraint(equalTo: descTitle.leadingAnchor),
            shoreBriefGlyph.trailingAnchor.constraint(equalTo: descTitle.trailingAnchor),
            shoreBriefGlyph.bottomAnchor.constraint(equalTo: shoreBriefCard.bottomAnchor, constant: -22),

            shoreSuggestionCard.topAnchor.constraint(equalTo: shoreBriefCard.bottomAnchor, constant: 22),
            shoreSuggestionCard.leadingAnchor.constraint(equalTo: shoreInfoCard.leadingAnchor),
            shoreSuggestionCard.trailingAnchor.constraint(equalTo: shoreInfoCard.trailingAnchor),
            shoreSuggestionCard.bottomAnchor.constraint(equalTo: shoreDetailDeck.bottomAnchor, constant: -20),
            relatedTitle.topAnchor.constraint(equalTo: shoreSuggestionCard.topAnchor, constant: 22),
            relatedTitle.leadingAnchor.constraint(equalTo: shoreSuggestionCard.leadingAnchor, constant: 22),
            relatedTitle.trailingAnchor.constraint(equalTo: shoreSuggestionCard.trailingAnchor, constant: -22),
            shoreSuggestionGrid.topAnchor.constraint(equalTo: relatedTitle.bottomAnchor, constant: 16),
            shoreSuggestionGrid.leadingAnchor.constraint(equalTo: relatedTitle.leadingAnchor),
            shoreSuggestionGrid.trailingAnchor.constraint(equalTo: relatedTitle.trailingAnchor),
            shoreSuggestionGrid.bottomAnchor.constraint(equalTo: shoreSuggestionCard.bottomAnchor, constant: -22),

            shoreActionFooter.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreActionFooter.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreActionFooter.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            shorePrimaryControl.topAnchor.constraint(equalTo: shoreActionFooter.topAnchor, constant: 12),
            shorePrimaryControl.leadingAnchor.constraint(equalTo: shoreActionFooter.leadingAnchor, constant: 30),
            shorePrimaryControl.trailingAnchor.constraint(equalTo: shoreActionFooter.trailingAnchor, constant: -30),
            shorePrimaryControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),

            shoreSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shoreSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func tuneShorelineCard(_ card: UIView) {
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 22
        card.layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        card.layer.shadowOpacity = 1
        card.layer.shadowRadius = 16
        card.layer.shadowOffset = CGSize(width: 0, height: 8)
    }

    private func loadShorelineDetail() {
        shoreSpinner.startAnimating()
        SuliJoyCoveMockService.shared.fetchActivityDetail(tideID: shorelineTideKey) { [weak self] tideEnvelope in
            guard let self else { return }
            guard tideEnvelope.beachwearCapsule == 200, let tideSnapshot = tideEnvelope.sandbarLayering else {
                self.shoreSpinner.stopAnimating()
                self.showLagoonToast(tideEnvelope.coastalWardrobe)
                return
            }
            self.shorelineTideDetail = tideSnapshot
            self.render(tideSnapshot)
            SuliJoyCoveMockService.shared.fetchRelatedActivities(for: tideSnapshot.tideMark) { suggestionEnvelope in
                self.shoreSpinner.stopAnimating()
                self.coastalSuggestionShelf = suggestionEnvelope.sandbarLayering ?? []
                self.renderCoastalSuggestions()
            }
        }
    }

    private func render(_ shorelineTideDetail: SuliJoyTideActivity) {
        renderShoreHeroCarousel(for: shorelineTideDetail)
        shoreTitleGlyph.text = shorelineTideDetail.tideTitleLine
        shorePlaceGlyph.text = shorelineTideDetail.shoreSpotLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Island Shore · Coastline"
            : shorelineTideDetail.shoreSpotLine
        shoreTimingGlyph.text = shorelineTideDetail.tideScheduleLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "\(shorelineTideDetail.shoreDayText) \(shorelineTideDetail.sunMeridiemText) \(shorelineTideDetail.shoreClockText)"
            : shorelineTideDetail.tideScheduleLine
        shoreBriefGlyph.text = shorelineTideDetail.shoreBriefLine
        renderShoreState(shorelineTideDetail.tideState)
        renderShoreAvatars(shorelineTideDetail.shorelineAvatarTokens, reefNumber: shorelineTideDetail.tideJoinedTotal)
        renderShorePrimaryAction(shorelineTideDetail)
    }

    private func renderShoreHeroCarousel(for shorelineTideDetail: SuliJoyTideActivity) {
        shoreHeroRibbon.arrangedSubviews.forEach { heroSlide in
            shoreHeroRibbon.removeArrangedSubview(heroSlide)
            heroSlide.removeFromSuperview()
        }

        let mediaAssetTokens = shorelineTideDetail.reefGallery.map(\.reefAssetToken).filter { !$0.isEmpty }
        let heroAssetTokens = mediaAssetTokens.isEmpty ? [shorelineTideDetail.tideFallbackHeroToken] : mediaAssetTokens

        for heroAssetToken in heroAssetTokens {
            let shoreImageView = UIImageView()
            shoreImageView.translatesAutoresizingMaskIntoConstraints = false
            shoreImageView.contentMode = .scaleAspectFill
            shoreImageView.clipsToBounds = true
            shoreImageView.backgroundColor = UIColor(red: 1, green: 0.84, blue: 0.58, alpha: 1)
            shoreImageView.image = UIImage.suliJoyAssetOrLocal(named: heroAssetToken) ?? UIImage.suliJoyAssetOrLocal(named: shorelineTideDetail.tideFallbackHeroToken)
            shoreHeroRibbon.addArrangedSubview(shoreImageView)
            NSLayoutConstraint.activate([
                shoreImageView.widthAnchor.constraint(equalTo: shoreHeroCarousel.frameLayoutGuide.widthAnchor),
                shoreImageView.heightAnchor.constraint(equalTo: shoreHeroCarousel.frameLayoutGuide.heightAnchor)
            ])
        }

        shoreHeroDots.numberOfPages = heroAssetTokens.count
        shoreHeroDots.currentPage = 0
        shoreHeroDots.isHidden = heroAssetTokens.count <= 1
        shoreHeroCarousel.setContentOffset(.zero, animated: false)
    }

    func scrollViewDidScroll(_ shoreDetailScrollCanvas: UIScrollView) {
        guard shoreDetailScrollCanvas === shoreHeroCarousel else { return }
        let width = shoreDetailScrollCanvas.bounds.width
        guard width > 0 else { return }
        let page = Int(round(shoreDetailScrollCanvas.contentOffset.x / width))
        shoreHeroDots.currentPage = max(0, min(shoreHeroDots.numberOfPages - 1, page))
    }

    private func renderShoreState(_ status: SuliJoyTideActivityStatus) {
        shoreStateGlyph.text = status.rawValue
        switch status {
        case .tideOpen, .tideJoined:
            shoreStateGlyph.backgroundColor = UIColor(red: 0.88, green: 1, blue: 0.91, alpha: 1)
            shoreStateGlyph.textColor = UIColor(red: 0.19, green: 0.82, blue: 0.61, alpha: 1)
        case .tideClosed:
            shoreStateGlyph.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            shoreStateGlyph.textColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1)
        }
    }

    private func renderShoreAvatars(_ assets: [String], reefNumber: Int) {
        shoreAvatarRail.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let heroAssetTokens = Array(assets.prefix(min(6, max(0, reefNumber))))
        for asset in heroAssetTokens {
            let shoreImageView = UIImageView(image: UIImage(named: asset))
            shoreImageView.translatesAutoresizingMaskIntoConstraints = false
            shoreImageView.contentMode = .scaleAspectFill
            shoreImageView.clipsToBounds = true
            shoreImageView.layer.cornerRadius = 12
            shoreImageView.layer.borderColor = UIColor.white.cgColor
            shoreImageView.layer.borderWidth = 1
            shoreAvatarRail.addArrangedSubview(shoreImageView)
            shoreImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            shoreImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        }
        let page = max(0, reefNumber - heroAssetTokens.count)
        shoreCrewCountGlyph.text = "+\(page)"
        shoreCrewCountGlyph.isHidden = page == 0
    }

    private func renderShorePrimaryAction(_ shorelineTideDetail: SuliJoyTideActivity) {
        switch shorelineTideDetail.tideState {
        case .tideOpen:
            shorePrimaryControl.setTitle("Join Event (🔥 \(shorelineTideDetail.pearlNeed))", for: .normal)
            shorePrimaryControl.isEnabled = true
            shorePrimaryControl.alpha = 1
        case .tideJoined:
            shorePrimaryControl.setTitle("OdpVeKnC YEjvJeQnhto qRuowodmM".suliJoyPalmUnfurled, for: .normal)
            shorePrimaryControl.isEnabled = true
            shorePrimaryControl.alpha = 1
        case .tideClosed:
            shorePrimaryControl.setTitle("OVpreZnS UENvFeKnEtg DRwoMoymP".suliJoyPalmUnfurled, for: .normal)
            shorePrimaryControl.isEnabled = false
            shorePrimaryControl.alpha = 0.45
        }
    }

    private func renderCoastalSuggestions() {
        shoreSuggestionGrid.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var suggestionCursor = 0
        while suggestionCursor < coastalSuggestionShelf.count {
            let suggestionRow = UIStackView()
            suggestionRow.axis = .horizontal
            suggestionRow.spacing = 12
            suggestionRow.distribution = .fillEqually
            suggestionRow.translatesAutoresizingMaskIntoConstraints = false
            for shorelineTideDetail in coastalSuggestionShelf[suggestionCursor..<min(suggestionCursor + 2, coastalSuggestionShelf.count)] {
                let card = SuliJoyCoastalSuggestionCard(shorelineTideDetail: shorelineTideDetail)
                card.onShoreTap = { [weak self] shorelineTideKey in
                    self?.switchShorelineDetail(to: shorelineTideKey)
                }
                suggestionRow.addArrangedSubview(card)
            }
            if suggestionRow.arrangedSubviews.count == 1 {
                suggestionRow.addArrangedSubview(UIView())
            }
            shoreSuggestionGrid.addArrangedSubview(suggestionRow)
            suggestionCursor += 2
        }
    }

    private func switchShorelineDetail(to newShorelineTideKey: String) {
        let shorelineDetailController = SuliJoyTideCoastalDetailController(shorelineTideKey: newShorelineTideKey)
        navigationController?.pushViewController(shorelineDetailController, animated: true)
    }

    @objc private func runShorePrimaryAction() {
        guard let shorelineTideDetail else { return }
        switch shorelineTideDetail.tideState {
        case .tideOpen:
            shorePrimaryControl.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let self else { return }
                guard SuliJoyShellPearlStore.shared.currentPearlBalance() >= shorelineTideDetail.pearlNeed else {
                    self.shorePrimaryControl.isLoading = false
                    self.showShorePearlShortageDialog()
                    return
                }
                SuliJoyCoveMockService.shared.driftPearlsForTide(tideMark: shorelineTideDetail.tideMark, pearlNeed: shorelineTideDetail.pearlNeed) { [weak self] pearlEnvelope in
                    guard let self else { return }
                    guard pearlEnvelope.beachwearCapsule == 200 else {
                        self.shorePrimaryControl.isLoading = false
                        self.showShorePearlShortageDialog()
                        return
                    }
                    SuliJoyCoveMockService.shared.joinActivity(tideID: shorelineTideDetail.tideMark) { [weak self] joinEnvelope in
                        guard let self else { return }
                        self.shorePrimaryControl.isLoading = false
                        guard joinEnvelope.beachwearCapsule == 200, let joinedTideSnapshot = joinEnvelope.sandbarLayering else {
                            self.showLagoonToast(joinEnvelope.coastalWardrobe)
                            return
                        }
                        self.shorelineTideDetail = joinedTideSnapshot
                        self.render(joinedTideSnapshot)
                        self.showLagoonToast("JFoziRnHeRda.i".suliJoyPalmUnfurled)
                    }
                }
            }
        case .tideJoined:
            let shorelineTalkController = SuliJoyTideTalkSpaceViewController(shorelineTideDetail: shorelineTideDetail)
            navigationController?.pushViewController(shorelineTalkController, animated: true)
        case .tideClosed:
            break
        }
    }

    @objc private func driftBackFromShoreDetail() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func openShoreModerationMenu() {
        guard let shorelineTideDetail else { return }
        presentSuliJoyHarborGuardMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .wideLegLinen(crinkleLinen: shorelineTideDetail.tideMark)) { [weak self] in
                self?.shorelineTideDetail?.isReefFlagged = true
            }
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.lagoonGuestToken(for: shorelineTideDetail.shoreHostAlias)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(seersuckerStripe: visitorID) { guardEnvelope in
                self?.showLagoonToast(guardEnvelope.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func showShorePearlShortageDialog() {
        let shortageVeil = UIControl()
        shortageVeil.translatesAutoresizingMaskIntoConstraints = false
        shortageVeil.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        shortageVeil.alpha = 0
        shortageVeil.addTarget(self, action: #selector(dismissShorePearlDialog(_:)), for: .touchUpInside)

        let shortageCard = UIView()
        shortageCard.translatesAutoresizingMaskIntoConstraints = false
        shortageCard.backgroundColor = .white
        shortageCard.layer.cornerRadius = 20
        shortageCard.clipsToBounds = true

        let shortageTitleGlyph = UILabel()
        shortageTitleGlyph.translatesAutoresizingMaskIntoConstraints = false
        shortageTitleGlyph.text = "NJoftP OebnxoBuBgBhO U".suliJoyPalmUnfurled + "cxod".suliJoyPalmUnfurled + "iHnOsq".suliJoyPalmUnfurled
        shortageTitleGlyph.font = UIFont.systemFont(ofSize: 21, weight: .black)
        shortageTitleGlyph.textColor = .black
        shortageTitleGlyph.textAlignment = .center
        shortageTitleGlyph.adjustsFontSizeToFitWidth = true
        shortageTitleGlyph.minimumScaleFactor = 0.8

        let shortageNoticeGlyph = UILabel()
        shortageNoticeGlyph.translatesAutoresizingMaskIntoConstraints = false
        shortageNoticeGlyph.text = "SoorrjrXyI,r MyOoEui gdZotnV'YtZ khGaHvceY PeYnEoauwgihv y".suliJoyPalmUnfurled + "cRoj".suliJoyPalmUnfurled + "iFnvsR Stjoi Z".suliJoyPalmUnfurled + "pWat".suliJoyPalmUnfurled + "yY,U OpLlPefaIsbeq Agwoc fthol crgeFcVhTaErKgIeF".suliJoyPalmUnfurled
        shortageNoticeGlyph.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        shortageNoticeGlyph.textColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1)
        shortageNoticeGlyph.textAlignment = .center
        shortageNoticeGlyph.numberOfLines = 0

        let harborEntryControl = SuliJoyGradientButton(reefHeadline: "BiumyE".suliJoyPalmUnfurled)
        harborEntryControl.translatesAutoresizingMaskIntoConstraints = false
        var harborEntryConfiguration = UIButton.Configuration.plain()
        harborEntryConfiguration.title = harborEntryControl.title(for: .normal)
        harborEntryConfiguration.image = UIImage(named: "sulijoy_shell_" + "co" + "in_gem")?.withRenderingMode(.alwaysOriginal)
        harborEntryConfiguration.imagePadding = 10
        harborEntryConfiguration.baseForegroundColor = .suliInk
        harborEntryConfiguration.contentInsets = .zero
        harborEntryConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { shoreAttributes in
            var tropicalAttributes = shoreAttributes
            tropicalAttributes.font = UIFont.systemFont(ofSize: 20, weight: .black)
            return tropicalAttributes
        }
        harborEntryControl.configuration = harborEntryConfiguration
        harborEntryControl.imageView?.contentMode = .scaleAspectFit
        harborEntryControl.constraints.first(where: { $0.firstAttribute == .height })?.constant = 48
        harborEntryControl.paintGradientTideBloom([
            UIColor(red: 1, green: 179 / 255, blue: 120 / 255, alpha: 1),
            UIColor(red: 1, green: 248 / 255, blue: 122 / 255, alpha: 1),
            UIColor(red: 204 / 255, green: 1, blue: 206 / 255, alpha: 1)
        ])
        harborEntryControl.addTarget(self, action: #selector(openPearlHarborFromShoreDialog(_:)), for: .touchUpInside)

        view.addSubview(shortageVeil)
        shortageVeil.addSubview(shortageCard)
        [shortageTitleGlyph, shortageNoticeGlyph, harborEntryControl].forEach { shortageCard.addSubview($0) }

        let shortageCardWidth = shortageCard.widthAnchor.constraint(equalToConstant: 287)
        shortageCardWidth.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            shortageVeil.topAnchor.constraint(equalTo: view.topAnchor),
            shortageVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shortageVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shortageVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            shortageCard.centerXAnchor.constraint(equalTo: shortageVeil.centerXAnchor),
            shortageCard.centerYAnchor.constraint(equalTo: shortageVeil.centerYAnchor),
            shortageCard.leadingAnchor.constraint(greaterThanOrEqualTo: shortageVeil.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            shortageCard.trailingAnchor.constraint(lessThanOrEqualTo: shortageVeil.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            shortageCardWidth,
            shortageTitleGlyph.topAnchor.constraint(equalTo: shortageCard.topAnchor, constant: 31),
            shortageTitleGlyph.leadingAnchor.constraint(equalTo: shortageCard.leadingAnchor, constant: 18),
            shortageTitleGlyph.trailingAnchor.constraint(equalTo: shortageCard.trailingAnchor, constant: -18),
            shortageNoticeGlyph.topAnchor.constraint(equalTo: shortageTitleGlyph.bottomAnchor, constant: 12),
            shortageNoticeGlyph.leadingAnchor.constraint(equalTo: shortageCard.leadingAnchor, constant: 30),
            shortageNoticeGlyph.trailingAnchor.constraint(equalTo: shortageCard.trailingAnchor, constant: -30),
            harborEntryControl.topAnchor.constraint(equalTo: shortageNoticeGlyph.bottomAnchor, constant: 14),
            harborEntryControl.leadingAnchor.constraint(equalTo: shortageCard.leadingAnchor, constant: 25),
            harborEntryControl.trailingAnchor.constraint(equalTo: shortageCard.trailingAnchor, constant: -25),
            harborEntryControl.bottomAnchor.constraint(equalTo: shortageCard.bottomAnchor, constant: -24)
        ])

        UIView.animate(withDuration: 0.2) {
            shortageVeil.alpha = 1
        }
    }

    @objc private func dismissShorePearlDialog(_ sender: UIControl) {
        UIView.animate(withDuration: 0.18, animations: {
            sender.alpha = 0
        }, completion: { _ in
            sender.removeFromSuperview()
        })
    }

    @objc private func openPearlHarborFromShoreDialog(_ sender: UIButton) {
        guard let overlay = sender.superview?.superview as? UIControl else { return }
        overlay.removeFromSuperview()
        navigationController?.pushViewController(SuliJoyPearlHarborViewController(), animated: true)
    }
}

private final class SuliJoyCoastalSuggestionCard: UIControl {
    var onShoreTap: ((String) -> Void)?
    private let shorelineTideDetail: SuliJoyTideActivity
    private let shoreImageView = UIImageView()
    private let shoreStateGlyph = UILabel()
    private let shoreDateGlyph = UILabel()
    private let shoreTimeGlyph = UILabel()
    private let shoreTitleGlyph = UILabel()
    private let shoreAvatarRail = UIStackView()
//    private let joinButton = SuliJoyGradientButton(reefHeadline: "JsoqiFnE yEpvFePnPtr".suliJoyPalmUnfurled)

    init(shorelineTideDetail: SuliJoyTideActivity) {
        self.shorelineTideDetail = shorelineTideDetail
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        raiseShorelineDetailScene()
        render(shorelineTideDetail)
        addTarget(self, action: #selector(open), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("ignmiNtr(EcDoBdxeArC:r)b ihLaPsp tneontJ sbSedeZnx EiemUpPlRelmBecnxtNeudW".suliJoyPalmUnfurled)
    }

    private func raiseShorelineDetailScene() {
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = UIColor(red: 1, green: 0.91, blue: 0.73, alpha: 1)

        shoreImageView.translatesAutoresizingMaskIntoConstraints = false
        shoreImageView.contentMode = .scaleAspectFill
        shoreImageView.clipsToBounds = true

        shoreStateGlyph.translatesAutoresizingMaskIntoConstraints = false
        shoreStateGlyph.font = UIFont.italicSystemFont(ofSize: 11).suliWithWeight(.bold)
        shoreStateGlyph.textColor = .white
        shoreStateGlyph.textAlignment = .center
        shoreStateGlyph.backgroundColor = UIColor(red: 0.19, green: 0.82, blue: 0.61, alpha: 1)
        shoreStateGlyph.layer.cornerRadius = 8
        shoreStateGlyph.clipsToBounds = true

        let info = UIView()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.backgroundColor = .white
        info.layer.cornerRadius = 8
        info.clipsToBounds = true

        shoreDateGlyph.font = UIFont.systemFont(ofSize: 18, weight: .black)
        shoreTimeGlyph.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        shoreTimeGlyph.numberOfLines = 2
        shoreTitleGlyph.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        shoreTitleGlyph.textColor = .suliInk
        shoreTitleGlyph.lineBreakMode = .byTruncatingTail
        shoreAvatarRail.axis = .horizontal
        shoreAvatarRail.spacing = -6
//        joinButton.titleLabel?.font = UIFont.italicSystemFont(ofSize: 11).suliWithWeight(.black)
//        joinButton.isUserInteractionEnabled = false

        [shoreImageView, shoreStateGlyph, info].forEach { addSubview($0) }
        [shoreDateGlyph, shoreTimeGlyph, shoreTitleGlyph, shoreAvatarRail].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            info.addSubview($0)
        }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 164),
            shoreImageView.topAnchor.constraint(equalTo: topAnchor),
            shoreImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shoreImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shoreImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shoreStateGlyph.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            shoreStateGlyph.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            shoreStateGlyph.widthAnchor.constraint(equalToConstant: 70),
            shoreStateGlyph.heightAnchor.constraint(equalToConstant: 26),
            info.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            info.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            info.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            info.heightAnchor.constraint(equalToConstant: 58),
            shoreDateGlyph.leadingAnchor.constraint(equalTo: info.leadingAnchor, constant: 8),
            shoreDateGlyph.topAnchor.constraint(equalTo: info.topAnchor, constant: 7),
            shoreTimeGlyph.leadingAnchor.constraint(equalTo: shoreDateGlyph.trailingAnchor, constant: 4),
            shoreTimeGlyph.centerYAnchor.constraint(equalTo: shoreDateGlyph.centerYAnchor),
            shoreTitleGlyph.leadingAnchor.constraint(equalTo: shoreTimeGlyph.trailingAnchor, constant: 8),
            shoreTitleGlyph.trailingAnchor.constraint(equalTo: info.trailingAnchor, constant: -8),
            shoreTitleGlyph.centerYAnchor.constraint(equalTo: shoreDateGlyph.centerYAnchor),
            shoreAvatarRail.leadingAnchor.constraint(equalTo: shoreDateGlyph.leadingAnchor),
            shoreAvatarRail.bottomAnchor.constraint(equalTo: info.bottomAnchor, constant: -7),
            shoreAvatarRail.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func render(_ shorelineTideDetail: SuliJoyTideActivity) {
        shoreImageView.image = UIImage.suliJoyAssetOrLocal(named: shorelineTideDetail.reefGallery.first?.reefAssetToken ?? "")
        shoreStateGlyph.text = shorelineTideDetail.tideState.rawValue
        shoreStateGlyph.backgroundColor = shorelineTideDetail.tideState == .tideClosed ? UIColor(white: 0.88, alpha: 1) : UIColor(red: 0.19, green: 0.82, blue: 0.61, alpha: 1)
        shoreDateGlyph.text = shorelineTideDetail.shoreDayText
        shoreTimeGlyph.text = "\(shorelineTideDetail.sunMeridiemText)\n\(shorelineTideDetail.shoreClockText)"
        shoreTitleGlyph.text = shorelineTideDetail.tideTitleLine
      
        shoreAvatarRail.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for asset in shorelineTideDetail.shorelineAvatarTokens.prefix(3) {
            let shoreAvatarView = UIImageView(image: UIImage(named: asset))
            shoreAvatarView.translatesAutoresizingMaskIntoConstraints = false
            shoreAvatarView.contentMode = .scaleAspectFill
            shoreAvatarView.clipsToBounds = true
            shoreAvatarView.layer.cornerRadius = 10
            shoreAvatarView.layer.borderColor = UIColor.white.cgColor
            shoreAvatarView.layer.borderWidth = 1
            shoreAvatarRail.addArrangedSubview(shoreAvatarView)
            shoreAvatarView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            shoreAvatarView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
    }

    @objc private func open() {
        onShoreTap?(shorelineTideDetail.tideMark)
    }
}

private final class SuliJoyTideTalkSpaceViewController: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private let shorelineTideDetail: SuliJoyTideActivity
    private var talkSpace: SuliJoyTideTalkSpace?
    private var harborSeatControls: [SuliJoyLagoonSeatShellControl] = []

    private let harborBackdropImage = UIImageView()
    private let harborShadeView = UIView()
    private let harborHeaderRail = UIView()
    private let shoreTitleGlyph = UILabel()
    private let harborHostGlyph = UILabel()
    private let harborParticipantRail = UIStackView()
    private let harborMoreControl = UIButton(type: .system)
    private let harborCloseControl = UIButton(type: .custom)
    private let harborSeatGrid = UIStackView()
    private let harborSafetyGlyph = UILabel()
    private let shoreBubbleTable = UITableView(frame: .zero, style: .plain)
    private let shoreInputDock = UIView()
    private let shoreNoteField = UITextField()
    private let shoreSendControl = UIButton(type: .custom)
    private let shoreSpinner = UIActivityIndicatorView(style: .large)
    private var shoreDockBottomConstraint: NSLayoutConstraint?

    init(shorelineTideDetail: SuliJoyTideActivity) {
        self.shorelineTideDetail = shorelineTideDetail
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("iPnDimty(FcCoOdReHrD:Z)M WhvaFsP knRoBtX dbMeLeHnq oiumNpClYeumVeknrtdecdi".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        raiseShorelineDetailScene()
        registerHarborKeyboard()
        loadHarborSpace()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func raiseShorelineDetailScene() {
        harborBackdropImage.translatesAutoresizingMaskIntoConstraints = false
        harborBackdropImage.image = UIImage(named: "sulijoy_tide_room_sunset_bg") ?? UIImage.suliJoyAssetOrLocal(named: shorelineTideDetail.reefGallery.first?.reefAssetToken ?? "")
        harborBackdropImage.contentMode = .scaleAspectFill
        harborBackdropImage.clipsToBounds = true

        harborShadeView.translatesAutoresizingMaskIntoConstraints = false
        harborShadeView.backgroundColor = UIColor.black.withAlphaComponent(0.28)

        harborHeaderRail.translatesAutoresizingMaskIntoConstraints = false
        shoreTitleGlyph.translatesAutoresizingMaskIntoConstraints = false
        shoreTitleGlyph.text = shorelineTideDetail.tideTitleLine
        shoreTitleGlyph.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        shoreTitleGlyph.textColor = .white
        shoreTitleGlyph.numberOfLines = 1
        shoreTitleGlyph.lineBreakMode = .byTruncatingTail

        harborHostGlyph.translatesAutoresizingMaskIntoConstraints = false
        harborHostGlyph.text = "LnutcLijeR gRcaGyw".suliJoyPalmUnfurled
        harborHostGlyph.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        harborHostGlyph.textColor = UIColor.white.withAlphaComponent(0.82)

        harborParticipantRail.translatesAutoresizingMaskIntoConstraints = false
        harborParticipantRail.axis = .horizontal
        harborParticipantRail.spacing = -8

        harborMoreControl.translatesAutoresizingMaskIntoConstraints = false
        harborMoreControl.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        harborMoreControl.tintColor = .white
        harborMoreControl.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        harborMoreControl.layer.cornerRadius = 15
        harborMoreControl.addTarget(self, action: #selector(openHarborMore), for: .touchUpInside)

        harborCloseControl.translatesAutoresizingMaskIntoConstraints = false
        harborCloseControl.setImage(UIImage(named: "sulijoy_tide_room_close_mark"), for: .normal)
        harborCloseControl.imageView?.contentMode = .scaleAspectFit
        harborCloseControl.addTarget(self, action: #selector(confirmHarborLeave), for: .touchUpInside)

        harborSeatGrid.translatesAutoresizingMaskIntoConstraints = false
        harborSeatGrid.axis = .vertical
        harborSeatGrid.spacing = 14
        harborSeatGrid.distribution = .fillEqually

        harborSafetyGlyph.translatesAutoresizingMaskIntoConstraints = false
        harborSafetyGlyph.text = "BAel XrAeOsMpkeGcEtjfxuJlR,g bpvrVoPtpewcFtz byHoQuYrO OptrNijvOatccyd,H WaDnTdp PaIvhoBiqdK dsFeOnydliFnNgO aocfjfpeyntsiitvUed aoKra VpxeirpsSoDndaklk tcjoCnQtEeonFtj.N".suliJoyPalmUnfurled
        harborSafetyGlyph.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        harborSafetyGlyph.textColor = UIColor(red: 1, green: 0.82, blue: 0.54, alpha: 1)
        harborSafetyGlyph.numberOfLines = 2
        harborSafetyGlyph.backgroundColor = UIColor.black.withAlphaComponent(0.30)
        harborSafetyGlyph.layer.cornerRadius = 10
        harborSafetyGlyph.clipsToBounds = true

        shoreBubbleTable.translatesAutoresizingMaskIntoConstraints = false
        shoreBubbleTable.backgroundColor = .clear
        shoreBubbleTable.separatorStyle = .none
        shoreBubbleTable.dataSource = self
        shoreBubbleTable.delegate = self
        shoreBubbleTable.keyboardDismissMode = .interactive
        shoreBubbleTable.register(SuliJoyShoreNoteBubbleCell.self, forCellReuseIdentifier: SuliJoyShoreNoteBubbleCell.shoreReuseKey)
        shoreBubbleTable.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)

        shoreInputDock.translatesAutoresizingMaskIntoConstraints = false
        shoreInputDock.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        shoreInputDock.layer.cornerRadius = 24
        shoreInputDock.clipsToBounds = true

        let emojiButton = UIButton(type: .system)
        emojiButton.translatesAutoresizingMaskIntoConstraints = false
        emojiButton.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        emojiButton.tintColor = UIColor.white.withAlphaComponent(0.86)

        shoreNoteField.translatesAutoresizingMaskIntoConstraints = false
        shoreNoteField.placeholder = "ShaGyu bhriX~y".suliJoyPalmUnfurled
        shoreNoteField.textColor = .white
        shoreNoteField.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        shoreNoteField.delegate = self
        shoreNoteField.returnKeyType = .send
        shoreNoteField.attributedPlaceholder = NSAttributedString(
            string: "Say hi~",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.56)]
        )

        shoreSendControl.translatesAutoresizingMaskIntoConstraints = false
        shoreSendControl.setImage(UIImage(named: "sulijoy_feed_send_mark"), for: .normal)
        shoreSendControl.backgroundColor = UIColor(red: 1, green: 0.91, blue: 0.23, alpha: 1)
        shoreSendControl.layer.cornerRadius = 17.5
        shoreSendControl.imageView?.contentMode = .scaleAspectFit
        shoreSendControl.addTarget(self, action: #selector(sendShoreNote), for: .touchUpInside)

        shoreSpinner.translatesAutoresizingMaskIntoConstraints = false
        shoreSpinner.color = .white
        shoreSpinner.hidesWhenStopped = true

        view.addSubview(harborBackdropImage)
        view.addSubview(harborShadeView)
        view.addSubview(harborHeaderRail)
        view.addSubview(harborSeatGrid)
        view.addSubview(harborSafetyGlyph)
        view.addSubview(shoreBubbleTable)
        view.addSubview(shoreInputDock)
        view.addSubview(shoreSpinner)
        [shoreTitleGlyph, harborHostGlyph, harborParticipantRail, harborMoreControl, harborCloseControl].forEach { harborHeaderRail.addSubview($0) }
        [emojiButton, shoreNoteField, shoreSendControl].forEach { shoreInputDock.addSubview($0) }

        shoreDockBottomConstraint = shoreInputDock.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)

        NSLayoutConstraint.activate([
            harborBackdropImage.topAnchor.constraint(equalTo: view.topAnchor),
            harborBackdropImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            harborBackdropImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            harborBackdropImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            harborShadeView.topAnchor.constraint(equalTo: view.topAnchor),
            harborShadeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            harborShadeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            harborShadeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            harborHeaderRail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            harborHeaderRail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            harborHeaderRail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            harborHeaderRail.heightAnchor.constraint(equalToConstant: 48),
            shoreTitleGlyph.topAnchor.constraint(equalTo: harborHeaderRail.topAnchor, constant: 3),
            shoreTitleGlyph.leadingAnchor.constraint(equalTo: harborHeaderRail.leadingAnchor),
            shoreTitleGlyph.trailingAnchor.constraint(lessThanOrEqualTo: harborParticipantRail.leadingAnchor, constant: -12),
            harborHostGlyph.topAnchor.constraint(equalTo: shoreTitleGlyph.bottomAnchor, constant: 4),
            harborHostGlyph.leadingAnchor.constraint(equalTo: shoreTitleGlyph.leadingAnchor),
            harborHostGlyph.trailingAnchor.constraint(equalTo: shoreTitleGlyph.trailingAnchor),
            harborCloseControl.trailingAnchor.constraint(equalTo: harborHeaderRail.trailingAnchor),
            harborCloseControl.centerYAnchor.constraint(equalTo: harborHeaderRail.centerYAnchor),
            harborCloseControl.widthAnchor.constraint(equalToConstant: 30),
            harborCloseControl.heightAnchor.constraint(equalToConstant: 30),
            harborMoreControl.trailingAnchor.constraint(equalTo: harborCloseControl.leadingAnchor, constant: -8),
            harborMoreControl.centerYAnchor.constraint(equalTo: harborCloseControl.centerYAnchor),
            harborMoreControl.widthAnchor.constraint(equalToConstant: 30),
            harborMoreControl.heightAnchor.constraint(equalToConstant: 30),
            harborParticipantRail.trailingAnchor.constraint(equalTo: harborMoreControl.leadingAnchor, constant: -10),
            harborParticipantRail.centerYAnchor.constraint(equalTo: harborMoreControl.centerYAnchor),
            harborParticipantRail.heightAnchor.constraint(equalToConstant: 26),

            harborSeatGrid.topAnchor.constraint(equalTo: harborHeaderRail.bottomAnchor, constant: 26),
            harborSeatGrid.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            harborSeatGrid.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            harborSeatGrid.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.35),

            harborSafetyGlyph.topAnchor.constraint(equalTo: harborSeatGrid.bottomAnchor, constant: 16),
            harborSafetyGlyph.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            harborSafetyGlyph.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            harborSafetyGlyph.heightAnchor.constraint(greaterThanOrEqualToConstant: 38),

            shoreBubbleTable.topAnchor.constraint(equalTo: harborSafetyGlyph.bottomAnchor, constant: 8),
            shoreBubbleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shoreBubbleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shoreBubbleTable.bottomAnchor.constraint(equalTo: shoreInputDock.topAnchor, constant: -8),

            shoreInputDock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            shoreInputDock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            shoreInputDock.heightAnchor.constraint(equalToConstant: 48),
            shoreDockBottomConstraint!,
            emojiButton.leadingAnchor.constraint(equalTo: shoreInputDock.leadingAnchor, constant: 14),
            emojiButton.centerYAnchor.constraint(equalTo: shoreInputDock.centerYAnchor),
            emojiButton.widthAnchor.constraint(equalToConstant: 28),
            emojiButton.heightAnchor.constraint(equalToConstant: 28),
            shoreSendControl.trailingAnchor.constraint(equalTo: shoreInputDock.trailingAnchor, constant: -6),
            shoreSendControl.centerYAnchor.constraint(equalTo: shoreInputDock.centerYAnchor),
            shoreSendControl.widthAnchor.constraint(equalToConstant: 35),
            shoreSendControl.heightAnchor.constraint(equalToConstant: 35),
            shoreNoteField.leadingAnchor.constraint(equalTo: emojiButton.trailingAnchor, constant: 8),
            shoreNoteField.trailingAnchor.constraint(equalTo: shoreSendControl.leadingAnchor, constant: -8),
            shoreNoteField.topAnchor.constraint(equalTo: shoreInputDock.topAnchor),
            shoreNoteField.bottomAnchor.constraint(equalTo: shoreInputDock.bottomAnchor),

            shoreSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shoreSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(foldHarborKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func registerHarborKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(harborKeyboardWillRise(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(harborKeyboardWillSettle(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func loadHarborSpace() {
        shoreSpinner.startAnimating()
        SuliJoyCoveMockService.shared.fetchTideTalkSpace(tideMark: shorelineTideDetail.tideMark) { [weak self] harborEnvelope in
            guard let self else { return }
            self.shoreSpinner.stopAnimating()
            guard harborEnvelope.beachwearCapsule == 200, let harborSpace = harborEnvelope.sandbarLayering else {
                self.showLagoonToast(harborEnvelope.coastalWardrobe)
                return
            }
            self.talkSpace = harborSpace
            self.render(harborSpace)
        }
    }

    private func render(_ harborSpace: SuliJoyTideTalkSpace) {
        shoreTitleGlyph.text = harborSpace.tideTitleLine
        harborHostGlyph.text = harborSpace.shoreHostAlias
        renderHarborParticipants(harborSpace.participantPortraitTokens)
        renderHarborSeats(harborSpace.lagoonSeats)
        shoreBubbleTable.reloadData()
        scrollShoreBubblesToBottom(animated: false)
    }

    private func renderHarborParticipants(_ participantAssets: [String]) {
        harborParticipantRail.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for participantAsset in participantAssets.prefix(3) {
            let shoreAvatarView = UIImageView(image: UIImage(named: participantAsset))
            shoreAvatarView.translatesAutoresizingMaskIntoConstraints = false
            shoreAvatarView.contentMode = .scaleAspectFill
            shoreAvatarView.clipsToBounds = true
            shoreAvatarView.layer.cornerRadius = 13
            shoreAvatarView.layer.borderColor = UIColor.white.cgColor
            shoreAvatarView.layer.borderWidth = 1
            harborParticipantRail.addArrangedSubview(shoreAvatarView)
            shoreAvatarView.widthAnchor.constraint(equalToConstant: 26).isActive = true
            shoreAvatarView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        }
    }

    private func renderHarborSeats(_ voiceSeatShelf: [SuliJoyLagoonVoiceSeat]) {
        harborSeatControls.removeAll()
        harborSeatGrid.arrangedSubviews.forEach { seatRail in
            harborSeatGrid.removeArrangedSubview(seatRail)
            seatRail.removeFromSuperview()
        }
        var seatCursor = 0
        while seatCursor < voiceSeatShelf.count {
            let seatRail = UIStackView()
            seatRail.axis = .horizontal
            seatRail.spacing = 10
            seatRail.distribution = .fillEqually
            seatRail.translatesAutoresizingMaskIntoConstraints = false
            for voiceSeat in voiceSeatShelf[seatCursor..<min(seatCursor + 3, voiceSeatShelf.count)] {
                let seatControl = SuliJoyLagoonSeatShellControl()
                seatControl.render(voiceSeat)
                seatControl.addTarget(self, action: #selector(handleHarborSeatTap(_:)), for: .touchUpInside)
                seatRail.addArrangedSubview(seatControl)
                harborSeatControls.append(seatControl)
            }
            harborSeatGrid.addArrangedSubview(seatRail)
            seatCursor += 3
        }
    }

    @objc private func handleHarborSeatTap(_ sender: SuliJoyLagoonSeatShellControl) {
        guard let seat = sender.seat else { return }
        if seat.isSeatOpen {
            sender.isEnabled = false
            SuliJoyCoveMockService.shared.joinLagoonVoiceSeat(tideMark: shorelineTideDetail.tideMark, lagoonSeatMark: seat.lagoonSeatMark) { [weak self, weak sender] seatEnvelope in
                sender?.isEnabled = true
                guard let self else { return }
                guard seatEnvelope.beachwearCapsule == 200, let harborSpace = seatEnvelope.sandbarLayering else {
                    self.showLagoonToast(seatEnvelope.coastalWardrobe)
                    return
                }
                self.talkSpace = harborSpace
                self.render(harborSpace)
                self.showLagoonToast("SHeuaete ajiocimnhecdU.h".suliJoyPalmUnfurled)
            }
        } else {
            showLagoonToast("\(seat.seatAliasLine) is on the seat.")
        }
    }

    @objc private func sendShoreNote() {
        let shoreDraftText = shoreNoteField.text ?? ""
        guard !shoreDraftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showLagoonToast("PllAeOalsqeg ReLnhtSeerm Qar q".suliJoyPalmUnfurled + "mteesJsn".suliJoyPalmUnfurled + "aFgceM.b".suliJoyPalmUnfurled)
            return
        }
        shoreSendControl.isEnabled = false
        SuliJoyCoveMockService.shared.sendShoreBreeze(tideMark: shorelineTideDetail.tideMark, text: shoreDraftText) { [weak self] breezeEnvelope in
            guard let self else { return }
            self.shoreSendControl.isEnabled = true
            guard breezeEnvelope.beachwearCapsule == 200, let harborSpace = breezeEnvelope.sandbarLayering else {
                self.showLagoonToast(breezeEnvelope.coastalWardrobe)
                return
            }
            self.shoreNoteField.text = nil
            self.talkSpace = harborSpace
            self.shoreBubbleTable.reloadData()
            self.scrollShoreBubblesToBottom(animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendShoreNote()
        return true
    }

    @objc private func openHarborMore() {
        presentSuliJoyHarborGuardMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .breezyFit(crinkleLinen: self.shorelineTideDetail.tideMark))
        } block: { [weak self] in
            guard let self else { return }
            let visitorID = SuliJoyLagoonVisitor.lagoonGuestToken(for: self.shorelineTideDetail.shoreHostAlias)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(seersuckerStripe: visitorID) { result in
                self.showLagoonToast(result.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc private func confirmHarborLeave() {
        showHarborLeaveDialog()
    }

    private func showHarborWarningDialog() {
        presentHarborNoticeDialog(
            badgeName: "sulijoy_tide_room_warning_badge",
            reefHeadline: "Warning",
            shoreNotice: "Be careful. No explicit content or revealing outfits allowed.",
            primaryTitle: "OK",
            secondaryTitle: nil,
            runShorePrimaryAction: nil
        )
    }

    private func showHarborLeaveDialog() {
        presentHarborNoticeDialog(
            badgeName: "sulijoy_tide_room_exit_badge",
            reefHeadline: nil,
            shoreNotice: "Do you want to close the room?",
            primaryTitle: "Cancel",
            secondaryTitle: "Close",
            runShorePrimaryAction: nil,
            secondaryAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
    }

    private func presentHarborNoticeDialog(
        badgeName: String,
        reefHeadline: String?,
        shoreNotice: String,
        primaryTitle: String,
        secondaryTitle: String?,
        runShorePrimaryAction: (() -> Void)?,
        secondaryAction: (() -> Void)? = nil
    ) {
        let harborVeil = UIControl()
        harborVeil.translatesAutoresizingMaskIntoConstraints = false
        harborVeil.backgroundColor = UIColor.black.withAlphaComponent(0.62)
        harborVeil.alpha = 0

        let harborNoticeCard = UIView()
        harborNoticeCard.translatesAutoresizingMaskIntoConstraints = false
        harborNoticeCard.backgroundColor = .white
        harborNoticeCard.layer.cornerRadius = 18
        harborNoticeCard.clipsToBounds = true

        let harborBadgeView = UIImageView(image: UIImage(named: badgeName))
        harborBadgeView.translatesAutoresizingMaskIntoConstraints = false
        harborBadgeView.contentMode = .scaleAspectFit

        let shoreTitleGlyph = UILabel()
        shoreTitleGlyph.translatesAutoresizingMaskIntoConstraints = false
        shoreTitleGlyph.text = reefHeadline
        shoreTitleGlyph.font = UIFont.systemFont(ofSize: 18, weight: .black)
        shoreTitleGlyph.textColor = .suliInk
        shoreTitleGlyph.textAlignment = .center
        shoreTitleGlyph.isHidden = reefHeadline == nil

        let shoreNoticeGlyph = UILabel()
        shoreNoticeGlyph.translatesAutoresizingMaskIntoConstraints = false
        shoreNoticeGlyph.text = shoreNotice
        shoreNoticeGlyph.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        shoreNoticeGlyph.textColor = .suliInk
        shoreNoticeGlyph.textAlignment = .center
        shoreNoticeGlyph.numberOfLines = 0

        let harborPrimaryControl = SuliJoyGradientButton(reefHeadline: primaryTitle)
        harborPrimaryControl.translatesAutoresizingMaskIntoConstraints = false
        harborPrimaryControl.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .black)
        harborPrimaryControl.addAction(UIAction { [weak harborVeil] _ in
            harborVeil?.removeFromSuperview()
            runShorePrimaryAction?()
        }, for: .touchUpInside)

        let harborActionRail = UIStackView()
        harborActionRail.translatesAutoresizingMaskIntoConstraints = false
        harborActionRail.axis = .horizontal
        harborActionRail.spacing = 14
        harborActionRail.distribution = .fillEqually

        if let secondaryTitle {
            let harborSecondaryControl = UIButton(type: .system)
            harborSecondaryControl.translatesAutoresizingMaskIntoConstraints = false
            harborSecondaryControl.setTitle(secondaryTitle, for: .normal)
            harborSecondaryControl.setTitleColor(UIColor(white: 0.62, alpha: 1), for: .normal)
            harborSecondaryControl.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .black)
            harborSecondaryControl.backgroundColor = UIColor(white: 0.95, alpha: 1)
            harborSecondaryControl.layer.cornerRadius = 25
            harborSecondaryControl.addAction(UIAction { [weak harborVeil] _ in
                harborVeil?.removeFromSuperview()
                secondaryAction?()
            }, for: .touchUpInside)
            harborActionRail.addArrangedSubview(harborPrimaryControl)
            harborActionRail.addArrangedSubview(harborSecondaryControl)
        } else {
            harborActionRail.addArrangedSubview(harborPrimaryControl)
        }

        view.addSubview(harborVeil)
        harborVeil.addSubview(harborNoticeCard)
        [harborBadgeView, shoreTitleGlyph, shoreNoticeGlyph, harborActionRail].forEach { harborNoticeCard.addSubview($0) }

        NSLayoutConstraint.activate([
            harborVeil.topAnchor.constraint(equalTo: view.topAnchor),
            harborVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            harborVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            harborVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            harborNoticeCard.centerXAnchor.constraint(equalTo: harborVeil.centerXAnchor),
            harborNoticeCard.centerYAnchor.constraint(equalTo: harborVeil.centerYAnchor),
            harborNoticeCard.leadingAnchor.constraint(greaterThanOrEqualTo: harborVeil.leadingAnchor, constant: 42),
            harborNoticeCard.trailingAnchor.constraint(lessThanOrEqualTo: harborVeil.trailingAnchor, constant: -42),
            harborNoticeCard.widthAnchor.constraint(lessThanOrEqualToConstant: 310),
            harborBadgeView.topAnchor.constraint(equalTo: harborNoticeCard.topAnchor, constant: 18),
            harborBadgeView.centerXAnchor.constraint(equalTo: harborNoticeCard.centerXAnchor),
            harborBadgeView.widthAnchor.constraint(equalToConstant: 82),
            harborBadgeView.heightAnchor.constraint(equalToConstant: 82),
            shoreTitleGlyph.topAnchor.constraint(equalTo: harborBadgeView.bottomAnchor, constant: reefHeadline == nil ? 0 : 4),
            shoreTitleGlyph.leadingAnchor.constraint(equalTo: harborNoticeCard.leadingAnchor, constant: 18),
            shoreTitleGlyph.trailingAnchor.constraint(equalTo: harborNoticeCard.trailingAnchor, constant: -18),
            shoreNoticeGlyph.topAnchor.constraint(equalTo: reefHeadline == nil ? harborBadgeView.bottomAnchor : shoreTitleGlyph.bottomAnchor, constant: 12),
            shoreNoticeGlyph.leadingAnchor.constraint(equalTo: harborNoticeCard.leadingAnchor, constant: 22),
            shoreNoticeGlyph.trailingAnchor.constraint(equalTo: harborNoticeCard.trailingAnchor, constant: -22),
            harborActionRail.topAnchor.constraint(equalTo: shoreNoticeGlyph.bottomAnchor, constant: 22),
            harborActionRail.leadingAnchor.constraint(equalTo: harborNoticeCard.leadingAnchor, constant: 28),
            harborActionRail.trailingAnchor.constraint(equalTo: harborNoticeCard.trailingAnchor, constant: -28),
            harborActionRail.heightAnchor.constraint(equalToConstant: 50),
            harborActionRail.bottomAnchor.constraint(equalTo: harborNoticeCard.bottomAnchor, constant: -22)
        ])

        UIView.animate(withDuration: 0.18) {
            harborVeil.alpha = 1
        }
    }

    @objc private func foldHarborKeyboard() {
        view.endEditing(true)
    }

    @objc private func harborKeyboardWillRise(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let converted = view.convert(frame, from: nil)
        let overlap = max(0, view.bounds.maxY - converted.minY)
        shoreDockBottomConstraint?.constant = -overlap + view.safeAreaInsets.bottom - 10
        shoreBubbleTable.contentInset.bottom = overlap + 72
        shoreBubbleTable.scrollIndicatorInsets.bottom = overlap + 72
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        scrollShoreBubblesToBottom(animated: true)
    }

    @objc private func harborKeyboardWillSettle(_ note: Notification) {
        shoreDockBottomConstraint?.constant = -10
        shoreBubbleTable.contentInset.bottom = 16
        shoreBubbleTable.scrollIndicatorInsets.bottom = 16
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    private func scrollShoreBubblesToBottom(animated: Bool) {
        let count = talkSpace?.shoreBreezeBubbles.count ?? 0
        guard count > 0 else { return }
        shoreBubbleTable.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .bottom, animated: animated)
    }

    func tableView(_ shoreBubbleTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        talkSpace?.shoreBreezeBubbles.count ?? 0
    }

    func tableView(_ shoreBubbleTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = shoreBubbleTable.dequeueReusableCell(withIdentifier: SuliJoyShoreNoteBubbleCell.shoreReuseKey, for: indexPath) as? SuliJoyShoreNoteBubbleCell,
            let bubble = talkSpace?.shoreBreezeBubbles[indexPath.row]
        else {
            return UITableViewCell()
        }
        cell.render(bubble)
        return cell
    }
}

private final class SuliJoyLagoonSeatShellControl: UIControl {
    private let seatAvatarView = UIImageView()
    private let seatMarkView = UIImageView()
    private let ownerBadgeGlyph = UILabel()
    private let seatNameGlyph = UILabel()
    private(set) var seat: SuliJoyLagoonVoiceSeat?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        raiseShorelineDetailScene()
    }

    required init?(coder: NSCoder) {
        fatalError("iLnSiKtu(McroIdQecri:j)X WhJaIsv WncoLtB AbyeyeRnp QimmLpjlpewmVeknTtseOdG".suliJoyPalmUnfurled)
    }

    private func raiseShorelineDetailScene() {
        seatAvatarView.translatesAutoresizingMaskIntoConstraints = false
        seatAvatarView.contentMode = .scaleAspectFill
        seatAvatarView.clipsToBounds = true
        seatAvatarView.layer.cornerRadius = 28
        seatAvatarView.layer.borderWidth = 1.5
        seatAvatarView.layer.borderColor = UIColor.white.withAlphaComponent(0.68).cgColor
        seatAvatarView.backgroundColor = UIColor.white.withAlphaComponent(0.16)

        seatMarkView.translatesAutoresizingMaskIntoConstraints = false
        seatMarkView.image = UIImage(systemName: "mic")
        seatMarkView.tintColor = .white
        seatMarkView.contentMode = .scaleAspectFit

        ownerBadgeGlyph.translatesAutoresizingMaskIntoConstraints = false
        ownerBadgeGlyph.text = "OHwsnoelrT".suliJoyPalmUnfurled
        ownerBadgeGlyph.font = UIFont.systemFont(ofSize: 9, weight: .black)
        ownerBadgeGlyph.textColor = .white
        ownerBadgeGlyph.textAlignment = .center
        ownerBadgeGlyph.backgroundColor = UIColor(red: 1, green: 0.45, blue: 0.25, alpha: 1)
        ownerBadgeGlyph.layer.cornerRadius = 8
        ownerBadgeGlyph.clipsToBounds = true

        seatNameGlyph.translatesAutoresizingMaskIntoConstraints = false
        seatNameGlyph.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        seatNameGlyph.textColor = .white
        seatNameGlyph.textAlignment = .center
        seatNameGlyph.numberOfLines = 1
        seatNameGlyph.adjustsFontSizeToFitWidth = true
        seatNameGlyph.minimumScaleFactor = 0.72

        [seatAvatarView, seatMarkView, ownerBadgeGlyph, seatNameGlyph].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            seatAvatarView.topAnchor.constraint(equalTo: topAnchor),
            seatAvatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            seatAvatarView.widthAnchor.constraint(equalToConstant: 56),
            seatAvatarView.heightAnchor.constraint(equalToConstant: 56),
            seatMarkView.centerXAnchor.constraint(equalTo: seatAvatarView.centerXAnchor),
            seatMarkView.centerYAnchor.constraint(equalTo: seatAvatarView.centerYAnchor),
            seatMarkView.widthAnchor.constraint(equalToConstant: 24),
            seatMarkView.heightAnchor.constraint(equalToConstant: 24),
            ownerBadgeGlyph.leadingAnchor.constraint(equalTo: seatAvatarView.leadingAnchor, constant: -2),
            ownerBadgeGlyph.trailingAnchor.constraint(equalTo: seatAvatarView.trailingAnchor, constant: 2),
            ownerBadgeGlyph.bottomAnchor.constraint(equalTo: seatAvatarView.bottomAnchor, constant: 7),
            ownerBadgeGlyph.heightAnchor.constraint(equalToConstant: 16),
            seatNameGlyph.topAnchor.constraint(equalTo: seatAvatarView.bottomAnchor, constant: 8),
            seatNameGlyph.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            seatNameGlyph.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            seatNameGlyph.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func render(_ seat: SuliJoyLagoonVoiceSeat) {
        self.seat = seat
        seatNameGlyph.text = seat.seatAliasLine
        ownerBadgeGlyph.isHidden = !seat.isTideHost
        if seat.isSeatOpen {
            seatAvatarView.image = nil
            seatMarkView.isHidden = false
            seatAvatarView.backgroundColor = UIColor.black.withAlphaComponent(0.22)
            seatNameGlyph.textColor = UIColor.white.withAlphaComponent(0.86)
        } else {
            seatAvatarView.image = UIImage(named: seat.seatAvatarToken ?? "")
            seatMarkView.isHidden = true
            seatAvatarView.backgroundColor = UIColor.white.withAlphaComponent(0.16)
            seatNameGlyph.textColor = .white
        }
    }
}

private final class SuliJoyShoreNoteBubbleCell: UITableViewCell {
    static let shoreReuseKey = "SuliJoyShoreNoteBubbleCell"
    private let shoreAvatarView = UIImageView()
    private let seatNameGlyph = UILabel()
    private let bubbleTextGlyph = UILabel()
    private let bubbleShellView = UIView()
    private var leadingShoreConstraint: NSLayoutConstraint?
    private var trailingShoreConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        raiseShorelineDetailScene()
    }

    required init?(coder: NSCoder) {
        fatalError("ifngiGtT(McHoMdweDrE:O)f jhnaKsu NnQontQ ebYeUeZnq kikmXpLlreMmOejnetRexdp".suliJoyPalmUnfurled)
    }

    private func raiseShorelineDetailScene() {
        shoreAvatarView.translatesAutoresizingMaskIntoConstraints = false
        shoreAvatarView.contentMode = .scaleAspectFill
        shoreAvatarView.clipsToBounds = true
        shoreAvatarView.layer.cornerRadius = 14

        seatNameGlyph.translatesAutoresizingMaskIntoConstraints = false
        seatNameGlyph.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        seatNameGlyph.textColor = UIColor.white.withAlphaComponent(0.76)

        bubbleShellView.translatesAutoresizingMaskIntoConstraints = false
        bubbleShellView.backgroundColor = .white
        bubbleShellView.layer.cornerRadius = 8
        bubbleShellView.clipsToBounds = true

        bubbleTextGlyph.translatesAutoresizingMaskIntoConstraints = false
        bubbleTextGlyph.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        bubbleTextGlyph.textColor = .suliInk
        bubbleTextGlyph.numberOfLines = 0

        contentView.addSubview(shoreAvatarView)
        contentView.addSubview(seatNameGlyph)
        contentView.addSubview(bubbleShellView)
        bubbleShellView.addSubview(bubbleTextGlyph)
        leadingShoreConstraint = bubbleShellView.leadingAnchor.constraint(equalTo: shoreAvatarView.trailingAnchor, constant: 10)
        trailingShoreConstraint = bubbleShellView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -54)

        NSLayoutConstraint.activate([
            shoreAvatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            shoreAvatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shoreAvatarView.widthAnchor.constraint(equalToConstant: 28),
            shoreAvatarView.heightAnchor.constraint(equalToConstant: 28),
            seatNameGlyph.leadingAnchor.constraint(equalTo: shoreAvatarView.trailingAnchor, constant: 10),
            seatNameGlyph.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            seatNameGlyph.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -54),
            bubbleShellView.topAnchor.constraint(equalTo: seatNameGlyph.bottomAnchor, constant: 3),
            leadingShoreConstraint!,
            trailingShoreConstraint!,
            bubbleShellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleTextGlyph.topAnchor.constraint(equalTo: bubbleShellView.topAnchor, constant: 8),
            bubbleTextGlyph.leadingAnchor.constraint(equalTo: bubbleShellView.leadingAnchor, constant: 12),
            bubbleTextGlyph.trailingAnchor.constraint(equalTo: bubbleShellView.trailingAnchor, constant: -12),
            bubbleTextGlyph.bottomAnchor.constraint(equalTo: bubbleShellView.bottomAnchor, constant: -8)
        ])
    }

    func render(_ bubble: SuliJoyShoreBubble) {
        shoreAvatarView.image = UIImage(named: bubble.avatarAssetName ?? "")
        seatNameGlyph.text = bubble.senderName
        bubbleTextGlyph.text = bubble.text
        bubbleShellView.backgroundColor = bubble.isMine ? UIColor(red: 0.84, green: 1, blue: 0.76, alpha: 1) : .white
    }
}
