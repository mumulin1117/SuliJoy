import UIKit

final class SuliJoymetallicThreadController: SuliJoyTropicCanvasController {
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        rewriteIslandAccounts()
    }

    override func viewWillAppear(_ reefConsentJoinNote: Bool) {
        super.viewWillAppear(reefConsentJoinNote)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ reefConsentJoinNote: Bool) {
        super.viewWillDisappear(reefConsentJoinNote)
        if isMovingFromParent {
            tabBarController?.tabBar.isHidden = false
        }
    }

    private func rewriteIslandAccounts() {
        let refreshConsentRibbonBinding = UIButton(type: .custom)
        refreshConsentRibbonBinding.translatesAutoresizingMaskIntoConstraints = false
        refreshConsentRibbonBinding.setImage(UIImage(named: "sxuxlxixjxoxyx_xsxhxaxrxex_xcxlxoxsxex".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysOriginal), for: .normal)
        refreshConsentRibbonBinding.imageView?.contentMode = .scaleAspectFit
        refreshConsentRibbonBinding.accessibilityLabel = "Cxlxoxsxex".suliJoyPalmUnfurled
        refreshConsentRibbonBinding.addTarget(self, action: #selector(blockLagoonVisitor), for: .touchUpInside)

        let islandAwaitingReturn = UIImageView(image: UIImage(named: "sxuxlxixjxoxyx_xsxhxaxrxex_xtxixtxlxex".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysOriginal))
        islandAwaitingReturn.translatesAutoresizingMaskIntoConstraints = false
        islandAwaitingReturn.contentMode = .scaleAspectFit
        islandAwaitingReturn.accessibilityLabel = "Sxhxaxrxex xNxoxwx".suliJoyPalmUnfurled

        let renderShoreFilterTabs = UIImageView(image: UIImage(named: "sxuxlxixjxoxyx_xsxhxaxrxex_xbxaxnxnxexrx".suliJoyPalmUnfurled)?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), resizingMode: .stretch))
        renderShoreFilterTabs.translatesAutoresizingMaskIntoConstraints = false
        renderShoreFilterTabs.contentMode = .scaleToFill
        renderShoreFilterTabs.setContentHuggingPriority(.defaultLow, for: .horizontal)
        renderShoreFilterTabs.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let reefCommentsTitle = UILabel()
        reefCommentsTitle.translatesAutoresizingMaskIntoConstraints = false
        reefCommentsTitle.text = "Wxaxnxtx xtxox xCxrxexaxtxex xExvxexnxtxsx,x xpxoxsxtx,x xoxrx xfxixlxmx?x".suliJoyPalmUnfurled
        reefCommentsTitle.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        reefCommentsTitle.textColor = .suliInk
        reefCommentsTitle.adjustsFontSizeToFitWidth = true
        reefCommentsTitle.minimumScaleFactor = 0.75
        reefCommentsTitle.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        renderShoreFilterTabs.addSubview(reefCommentsTitle)

        let reefKeyboardHeight = waveOnlyCaptionGlyph(trimmedLagoonText: "sxuxlxixjxoxyx_xsxhxaxrxex_xgxox_xlxixvxex".suliJoyPalmUnfurled, shorelineAuthorName: "Gxox xLxixvxex".suliJoyPalmUnfurled, wrapCoastalEnvelope: #selector(sheetBottomConstraint))
        let makeShorelineChoiceWrap = waveOnlyCaptionGlyph(trimmedLagoonText: "sxuxlxixjxoxyx_xsxhxaxrxex_xsxtxaxrxtx_xrxoxoxmx".suliJoyPalmUnfurled, shorelineAuthorName: "Sxtxaxrxtx xax xRxoxoxmx".suliJoyPalmUnfurled, wrapCoastalEnvelope: #selector(replyFlagControl))
        let shoreBreezeBubbles = waveOnlyCaptionGlyph(trimmedLagoonText: "sxuxlxixjxoxyx_xsxhxaxrxex_xpxoxsxtx_xmxoxmxexnxtx".suliJoyPalmUnfurled, shorelineAuthorName: "Pxoxsxtx xMxoxmxexnxtx".suliJoyPalmUnfurled, wrapCoastalEnvelope: #selector(tideIndicatorLead))
        let dismissReefReplyVeil = waveOnlyCaptionGlyph(trimmedLagoonText: "sxuxlxixjxoxyx_xsxhxaxrxex_xsxhxoxrxtxsx".suliJoyPalmUnfurled, shorelineAuthorName: "Sxhxoxrxtxsx xVxixdxexox".suliJoyPalmUnfurled, wrapCoastalEnvelope: #selector(assembleReefLaunchCard))

        let moorLagoonScrollTextScene = UIStackView(arrangedSubviews: [reefKeyboardHeight, makeShorelineChoiceWrap])
        let reefKeysWillSettle = UIStackView(arrangedSubviews: [shoreBreezeBubbles, dismissReefReplyVeil])
        [moorLagoonScrollTextScene, reefKeysWillSettle].forEach {
            $0.axis = .horizontal
            $0.spacing = 14
            $0.distribution = .fillEqually
        }
        let fetchHomeActivities = UIStackView(arrangedSubviews: [moorLagoonScrollTextScene, reefKeysWillSettle])
        fetchHomeActivities.translatesAutoresizingMaskIntoConstraints = false
        fetchHomeActivities.axis = .vertical
        fetchHomeActivities.spacing = 14

        [refreshConsentRibbonBinding, islandAwaitingReturn, renderShoreFilterTabs, fetchHomeActivities].forEach { view.addSubview($0) }
        let flaggedLagoonVisitors = fetchHomeActivities.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 52)
        flaggedLagoonVisitors.priority = .defaultHigh
        NSLayoutConstraint.activate([
            refreshConsentRibbonBinding.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            refreshConsentRibbonBinding.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            refreshConsentRibbonBinding.widthAnchor.constraint(equalToConstant: 32),
            refreshConsentRibbonBinding.heightAnchor.constraint(equalToConstant: 32),

            islandAwaitingReturn.topAnchor.constraint(equalTo: refreshConsentRibbonBinding.bottomAnchor, constant: 18),
            islandAwaitingReturn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            islandAwaitingReturn.heightAnchor.constraint(equalToConstant: 28),
            islandAwaitingReturn.widthAnchor.constraint(equalTo: islandAwaitingReturn.heightAnchor, multiplier: 410.0 / 52.0),
            islandAwaitingReturn.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -22),

            renderShoreFilterTabs.topAnchor.constraint(equalTo: islandAwaitingReturn.bottomAnchor, constant: 14),
            renderShoreFilterTabs.leadingAnchor.constraint(equalTo: islandAwaitingReturn.leadingAnchor),
            renderShoreFilterTabs.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -22),
            renderShoreFilterTabs.heightAnchor.constraint(equalToConstant: 32),
            reefCommentsTitle.leadingAnchor.constraint(equalTo: renderShoreFilterTabs.leadingAnchor, constant: 12),
            reefCommentsTitle.trailingAnchor.constraint(equalTo: renderShoreFilterTabs.trailingAnchor, constant: -12),
            reefCommentsTitle.centerYAnchor.constraint(equalTo: renderShoreFilterTabs.centerYAnchor),

            fetchHomeActivities.topAnchor.constraint(greaterThanOrEqualTo: renderShoreFilterTabs.bottomAnchor, constant: 28),
            fetchHomeActivities.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            fetchHomeActivities.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            fetchHomeActivities.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            flaggedLagoonVisitors,
            reefKeyboardHeight.heightAnchor.constraint(equalTo: reefKeyboardHeight.widthAnchor, multiplier: 224.0 / 328.0)
        ])
    }

    private func waveOnlyCaptionGlyph(trimmedLagoonText lagoonMarkControl: String, shorelineAuthorName: String, wrapCoastalEnvelope: Selector) -> UIButton {
        let shelfMinimumWidth = UIButton(type: .custom)
        shelfMinimumWidth.translatesAutoresizingMaskIntoConstraints = false
        shelfMinimumWidth.setImage(UIImage(named: lagoonMarkControl)?.withRenderingMode(.alwaysOriginal), for: .normal)
        shelfMinimumWidth.imageView?.contentMode = .scaleAspectFit
        shelfMinimumWidth.contentHorizontalAlignment = .fill
        shelfMinimumWidth.contentVerticalAlignment = .fill
        shelfMinimumWidth.accessibilityLabel = shorelineAuthorName
        shelfMinimumWidth.addTarget(self, action: wrapCoastalEnvelope, for: .touchUpInside)
        return shelfMinimumWidth
    }

    @objc private func blockLagoonVisitor() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func sheetBottomConstraint() {
        let lagoonFollowBadge = coralMood()
        lagoonFollowBadge.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(lagoonFollowBadge, animated: true)
    }

    @objc private func replyFlagControl() {
        let lagoonFollowBadge = typeWrap()
        lagoonFollowBadge.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(lagoonFollowBadge, animated: true)
    }

    @objc private func tideIndicatorLead() {
        let lagoonFollowBadge = SuliJoysequinedGlimmerController()
        lagoonFollowBadge.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(lagoonFollowBadge, animated: true)
    }

    @objc private func assembleReefLaunchCard() {
        let lagoonFollowBadge = SuliJoyReefMotionTideController()
        lagoonFollowBadge.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(lagoonFollowBadge, animated: true)
    }
}
