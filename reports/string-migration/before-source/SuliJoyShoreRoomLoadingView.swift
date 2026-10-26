import UIKit

final class toggleAuthorFollow: UIView {
    private let crownSide = UIView()
    private let reefSource = SuliJoyGuestActionButton()
    private let asset = SuliJoyGuestActionButton()
    private let detachedPortraitPath = UIView()
    private let reefSecretPhrase = UILabel()
    private let fetchProfileTideActivities = UILabel()
    private var coconutCream: [UIView] = []
    private var stitchPearlTileScene = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        backgroundColor = UIColor(red: 21 / 255, green: 5 / 255, blue: 46 / 255, alpha: 1)
        accessibilityViewIsModal = true
        moorReadyIslandReefScene()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func shoreNotice(kind: coverSlot) {
        switch kind {
        case .moorShoreProfileReefScene:
            reefSecretPhrase.text = "Joining the live"
            accessibilityLabel = "Joining the live"
        case .raiseReefCommentFlag:
            reefSecretPhrase.text = "Joining the voice room"
            accessibilityLabel = "Joining the voice room"
        }
        fetchProfileTideActivities.text = "Setting the shore lights"
        alpha = 1
        tapHarborFlag()
    }

    func shoresunDressSettle() {
        keyboardAnimation()
    }

    private func moorReadyIslandReefScene() {
        crownSide.translatesAutoresizingMaskIntoConstraints = false
        crownSide.backgroundColor = UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 0.18)
        crownSide.layer.cornerRadius = 78

        reefSource.translatesAutoresizingMaskIntoConstraints = false
        reefSource.commentsStack(SuliJoyCoastalVaultMark: UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 1), shoreReplyHintLabel: 3, welcome: [16, 10])
        asset.translatesAutoresizingMaskIntoConstraints = false
        asset.commentsStack(SuliJoyCoastalVaultMark: UIColor(red: 0.55, green: 0.95, blue: 0.4, alpha: 1), shoreReplyHintLabel: 2.5, welcome: [8, 8])

        detachedPortraitPath.translatesAutoresizingMaskIntoConstraints = false
        detachedPortraitPath.backgroundColor = .clear

        reefSecretPhrase.translatesAutoresizingMaskIntoConstraints = false
        reefSecretPhrase.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        reefSecretPhrase.textColor = .white
        reefSecretPhrase.textAlignment = .center
        reefSecretPhrase.adjustsFontSizeToFitWidth = true
        reefSecretPhrase.minimumScaleFactor = 0.8

        fetchProfileTideActivities.translatesAutoresizingMaskIntoConstraints = false
        fetchProfileTideActivities.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        fetchProfileTideActivities.textColor = UIColor.white.withAlphaComponent(0.68)
        fetchProfileTideActivities.textAlignment = .center

        addSubview(crownSide)
        addSubview(reefSource)
        addSubview(asset)
        addSubview(detachedPortraitPath)
        addSubview(reefSecretPhrase)
        addSubview(fetchProfileTideActivities)

        NSLayoutConstraint.activate([
            crownSide.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            crownSide.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -28),
            crownSide.widthAnchor.constraint(equalToConstant: 156),
            crownSide.heightAnchor.constraint(equalToConstant: 156),

            reefSource.centerXAnchor.constraint(equalTo: crownSide.centerXAnchor),
            reefSource.centerYAnchor.constraint(equalTo: crownSide.centerYAnchor),
            reefSource.widthAnchor.constraint(equalToConstant: 112),
            reefSource.heightAnchor.constraint(equalToConstant: 112),

            asset.centerXAnchor.constraint(equalTo: crownSide.centerXAnchor),
            asset.centerYAnchor.constraint(equalTo: crownSide.centerYAnchor),
            asset.widthAnchor.constraint(equalToConstant: 78),
            asset.heightAnchor.constraint(equalToConstant: 78),

            detachedPortraitPath.centerXAnchor.constraint(equalTo: crownSide.centerXAnchor),
            detachedPortraitPath.centerYAnchor.constraint(equalTo: crownSide.centerYAnchor),
            detachedPortraitPath.widthAnchor.constraint(equalToConstant: 36),
            detachedPortraitPath.heightAnchor.constraint(equalToConstant: 28),

            reefSecretPhrase.topAnchor.constraint(equalTo: reefSource.bottomAnchor, constant: 22),
            reefSecretPhrase.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            reefSecretPhrase.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24),

            fetchProfileTideActivities.topAnchor.constraint(equalTo: reefSecretPhrase.bottomAnchor, constant: 6),
            fetchProfileTideActivities.leadingAnchor.constraint(equalTo: reefSecretPhrase.leadingAnchor),
            fetchProfileTideActivities.trailingAnchor.constraint(equalTo: reefSecretPhrase.trailingAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard coconutCream.isEmpty, detachedPortraitPath.bounds.width > 0 else { return }
        let count = 5
        let reefDraft: CGFloat = 3
        let clause = (detachedPortraitPath.bounds.width - reefDraft * CGFloat(count - 1)) / CGFloat(count)
        let currentShoreVoice = detachedPortraitPath.bounds.height * 0.38
        let suliJoyCoastalChecklist = UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 1)
        let reefAddGlyph = UIColor(red: 0.55, green: 0.95, blue: 0.4, alpha: 1)
        for index in 0..<count {
            let fetchIslandProfileSummary = UIView()
            fetchIslandProfileSummary.backgroundColor = index.isMultiple(of: 2) ? suliJoyCoastalChecklist : reefAddGlyph
            fetchIslandProfileSummary.layer.cornerRadius = clause / 2
            fetchIslandProfileSummary.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            let makeLagoonEntryReefScene = CGFloat(index) * (clause + reefDraft)
            fetchIslandProfileSummary.frame = CGRect(x: makeLagoonEntryReefScene, y: detachedPortraitPath.bounds.height - currentShoreVoice, width: clause, height: currentShoreVoice)
            detachedPortraitPath.addSubview(fetchIslandProfileSummary)
            coconutCream.append(fetchIslandProfileSummary)
        }
        if stitchPearlTileScene {
            visibleClipReef()
        }
    }

    private func tapHarborFlag() {
        stitchPearlTileScene = true
        activeCoverSlotIndex(reefSource, duration: 2.4, stitchArrivalScene: true)
        activeCoverSlotIndex(asset, duration: 1.8, stitchArrivalScene: false)
        gemMark()
        visibleClipReef()
    }

    private func keyboardAnimation() {
        stitchPearlTileScene = false
        [crownSide, reefSource, asset].forEach { $0.layer.removeAllAnimations() }
        coconutCream.forEach { $0.layer.removeAllAnimations() }
    }

    private func activeCoverSlotIndex(_ view: UIView, duration: CFTimeInterval, stitchArrivalScene: Bool) {
        guard view.layer.animation(forKey: "shoreSpin") == nil else { return }
        let returnToPreviousReef = CABasicAnimation(keyPath: "transform.rotation.z")
        returnToPreviousReef.fromValue = 0
        returnToPreviousReef.toValue = stitchArrivalScene ? CGFloat.pi * 2 : -CGFloat.pi * 2
        returnToPreviousReef.duration = duration
        returnToPreviousReef.repeatCount = .infinity
        returnToPreviousReef.isRemovedOnCompletion = false
        view.layer.add(returnToPreviousReef, forKey: "shoreSpin")
    }

    private func gemMark() {
        guard crownSide.layer.animation(forKey: "shoreGlow") == nil else { return }
        let makeIslandToastPearlIcon = CABasicAnimation(keyPath: "opacity")
        makeIslandToastPearlIcon.fromValue = 1
        makeIslandToastPearlIcon.toValue = 0.45
        makeIslandToastPearlIcon.duration = 1.15
        makeIslandToastPearlIcon.autoreverses = true
        makeIslandToastPearlIcon.repeatCount = .infinity
        makeIslandToastPearlIcon.isRemovedOnCompletion = false
        crownSide.layer.add(makeIslandToastPearlIcon, forKey: "shoreGlow")
    }

    private func visibleClipReef() {
        let palmThread: [[CGFloat]] = [
            [0.35, 1, 0.5, 0.82],
            [0.9, 0.4, 1, 0.55],
            [0.45, 0.85, 0.32, 1],
            [1, 0.48, 0.78, 0.36],
            [0.55, 1, 0.42, 0.9]
        ]
        for (index, fetchIslandProfileSummary) in coconutCream.enumerated() {
            guard fetchIslandProfileSummary.layer.animation(forKey: "shoreBar") == nil else { continue }
            let tuneMomentImageWavePill = CAKeyframeAnimation(keyPath: "transform.scale.y")
            tuneMomentImageWavePill.values = palmThread[index]
            tuneMomentImageWavePill.keyTimes = [0, 0.33, 0.66, 1]
            tuneMomentImageWavePill.duration = 0.78 + Double(index) * 0.08
            tuneMomentImageWavePill.autoreverses = true
            tuneMomentImageWavePill.repeatCount = .infinity
            tuneMomentImageWavePill.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            tuneMomentImageWavePill.isRemovedOnCompletion = false
            fetchIslandProfileSummary.layer.add(tuneMomentImageWavePill, forKey: "shoreBar")
        }
    }
}

private final class SuliJoyGuestActionButton: UIView {
    private let setEULATideConsent = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = .clear
        layer.addSublayer(setEULATideConsent)
        setEULATideConsent.fillColor = UIColor.clear.cgColor
        setEULATideConsent.lineCap = .round
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commentsStack(SuliJoyCoastalVaultMark: UIColor, shoreReplyHintLabel: CGFloat, welcome: [NSNumber]) {
        setEULATideConsent.strokeColor = SuliJoyCoastalVaultMark.cgColor
        setEULATideConsent.lineWidth = shoreReplyHintLabel
        setEULATideConsent.lineDashPattern = welcome
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setEULATideConsent.frame = bounds
        let inset = setEULATideConsent.lineWidth / 2
        setEULATideConsent.path = UIBezierPath(ovalIn: bounds.insetBy(dx: inset, dy: inset)).cgPath
    }
}
