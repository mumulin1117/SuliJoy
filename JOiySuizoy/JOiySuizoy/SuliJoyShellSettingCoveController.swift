import UIKit

final class SuliJoyShellSettingCoveController: SuliJoyTropicCanvasController {
    private enum ShellWardrobeMeasure {
        static let sunriseInset: CGFloat = 18
        static let palmEdgeInset: CGFloat = 24
        static let shellBackTapSize: CGFloat = 44
        static let reefRowsTopGap: CGFloat = 22
        static let harborActionBottomLift: CGFloat = -24
        static let harborActionSideInset: CGFloat = 30
        static let reefStackFloor: CGFloat = 280
        static let coralDialogSideInset: CGFloat = 42
        static let tideSheetSideInset: CGFloat = 30
    }

    private struct ShellWardrobeEntry {
        let shoreCaption: String
        let reefMarkName: String
        let tideSelector: Selector
    }

    private struct ShellWardrobeCrown {
        let shoreBackTap: UIButton
        let coveTitleGlyph: UILabel
    }

    private let wardrobeCoveService = SuliJoyCoveMockService.shared
    private let lagoonAccessStore = SuliJoyLagoonGateService.shared
    private let shoreDriftScroll = UIScrollView()
    private let reefRowStack = UIStackView()
    private let harborExitButton = SuliJoyGradientButton(reefHeadline: "LkoDgf goduHtW".suliJoyPalmUnfurled)
    private var mistVeil: UIView?

    private var shellWardrobeEntries: [ShellWardrobeEntry] {
        [
            ShellWardrobeEntry(shoreCaption: "User Agreement", reefMarkName: "doc.text.fill", tideSelector: #selector(openShoreTerms)),
            ShellWardrobeEntry(shoreCaption: "Privacy", reefMarkName: "lock.doc.fill", tideSelector: #selector(openReefPrivacy)),
            ShellWardrobeEntry(shoreCaption: "Clear the cache", reefMarkName: "sparkles", tideSelector: #selector(polishShellCache)),
            ShellWardrobeEntry(shoreCaption: "Blocked List", reefMarkName: "person.crop.circle.badge.xmark", tideSelector: #selector(openMutedReef)),
            ShellWardrobeEntry(shoreCaption: "Delete Account", reefMarkName: "person.crop.circle.badge.minus", tideSelector: #selector(askIslandAccountRemoval))
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        weaveShellCovePage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func weaveShellCovePage() {
        let crownBundle = gatherShellWardrobeCrown()
        tuneShellCoveScroll()
        tuneShellCoveStack()
        growShellCoveRows()
        tuneHarborExitControl()
        moorShellCoveCrown(crownBundle)
        stitchShellCoveCrown(crownBundle)
    }

    private func gatherShellWardrobeCrown() -> ShellWardrobeCrown {
        let shoreBackTap = UIButton(type: .system)
        shoreBackTap.translatesAutoresizingMaskIntoConstraints = false
        shoreBackTap.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        shoreBackTap.tintColor = .suliInk
        shoreBackTap.addTarget(self, action: #selector(sailBack), for: .touchUpInside)

        let coveTitleGlyph = UILabel()
        coveTitleGlyph.translatesAutoresizingMaskIntoConstraints = false
        coveTitleGlyph.text = "SYeEtVttiWnugp".suliJoyPalmUnfurled
        coveTitleGlyph.textAlignment = .center
        coveTitleGlyph.textColor = .suliInk
        coveTitleGlyph.font = UIFont.systemFont(ofSize: 18, weight: .black)
        return ShellWardrobeCrown(shoreBackTap: shoreBackTap, coveTitleGlyph: coveTitleGlyph)
    }

    private func tuneShellCoveScroll() {
        shoreDriftScroll.translatesAutoresizingMaskIntoConstraints = false
        shoreDriftScroll.alwaysBounceVertical = true
        shoreDriftScroll.showsVerticalScrollIndicator = false
    }

    private func tuneShellCoveStack() {
        reefRowStack.translatesAutoresizingMaskIntoConstraints = false
        reefRowStack.axis = .vertical
        reefRowStack.spacing = 0
        reefRowStack.layer.cornerRadius = 16
        reefRowStack.clipsToBounds = true
        reefRowStack.backgroundColor = UIColor.white.withAlphaComponent(0.36)
    }

    private func growShellCoveRows() {
        shellWardrobeEntries.enumerated().forEach { reefIndex, shoreEntry in
            let shoreRow = SuliJoyShellCoveActionRow(shoreTitle: shoreEntry.shoreCaption, reefSymbol: shoreEntry.reefMarkName)
            shoreRow.addTarget(self, action: shoreEntry.tideSelector, for: .touchUpInside)
            reefRowStack.addArrangedSubview(shoreRow)
            if reefIndex < shellWardrobeEntries.count - 1 {
                reefRowStack.addArrangedSubview(SuliJoyShellCoveHairline())
            }
        }
    }

    private func tuneHarborExitControl() {
        harborExitButton.translatesAutoresizingMaskIntoConstraints = false
        harborExitButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        harborExitButton.tintColor = .suliInk
        harborExitButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        harborExitButton.addTarget(self, action: #selector(askLagoonExit), for: .touchUpInside)
    }

    private func moorShellCoveCrown(_ crownBundle: ShellWardrobeCrown) {
        view.addSubview(crownBundle.shoreBackTap)
        view.addSubview(crownBundle.coveTitleGlyph)
        view.addSubview(shoreDriftScroll)
        shoreDriftScroll.addSubview(reefRowStack)
        view.addSubview(harborExitButton)
    }

    private func stitchShellCoveCrown(_ crownBundle: ShellWardrobeCrown) {
        NSLayoutConstraint.activate([
            crownBundle.shoreBackTap.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ShellWardrobeMeasure.palmEdgeInset),
            crownBundle.shoreBackTap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ShellWardrobeMeasure.sunriseInset),
            crownBundle.shoreBackTap.widthAnchor.constraint(equalToConstant: ShellWardrobeMeasure.shellBackTapSize),
            crownBundle.shoreBackTap.heightAnchor.constraint(equalToConstant: ShellWardrobeMeasure.shellBackTapSize),

            crownBundle.coveTitleGlyph.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crownBundle.coveTitleGlyph.centerYAnchor.constraint(equalTo: crownBundle.shoreBackTap.centerYAnchor),
            crownBundle.coveTitleGlyph.leadingAnchor.constraint(greaterThanOrEqualTo: crownBundle.shoreBackTap.trailingAnchor, constant: 12),

            harborExitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ShellWardrobeMeasure.harborActionSideInset),
            harborExitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ShellWardrobeMeasure.harborActionSideInset),
            harborExitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: ShellWardrobeMeasure.harborActionBottomLift),

            shoreDriftScroll.topAnchor.constraint(equalTo: crownBundle.shoreBackTap.bottomAnchor, constant: ShellWardrobeMeasure.reefRowsTopGap),
            shoreDriftScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreDriftScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreDriftScroll.bottomAnchor.constraint(equalTo: harborExitButton.topAnchor, constant: -24),

            reefRowStack.topAnchor.constraint(equalTo: shoreDriftScroll.contentLayoutGuide.topAnchor),
            reefRowStack.leadingAnchor.constraint(equalTo: shoreDriftScroll.frameLayoutGuide.leadingAnchor, constant: 24),
            reefRowStack.trailingAnchor.constraint(equalTo: shoreDriftScroll.frameLayoutGuide.trailingAnchor, constant: -24),
            reefRowStack.bottomAnchor.constraint(equalTo: shoreDriftScroll.contentLayoutGuide.bottomAnchor),
            reefRowStack.heightAnchor.constraint(greaterThanOrEqualToConstant: ShellWardrobeMeasure.reefStackFloor)
        ])
    }

    @objc private func sailBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func openShoreTerms() {
        navigationController?.pushViewController(SuliJoyLagoonScrollTextController(shoreTitle: "Terms of Service", reefClauses: SuliJoyPolicyCopy.terms), animated: true)
    }

    @objc private func openReefPrivacy() {
        navigationController?.pushViewController(SuliJoyLagoonScrollTextController(shoreTitle: "Privacy Policy", reefClauses: SuliJoyPolicyCopy.privacy), animated: true)
    }

    @objc private func polishShellCache() {
        wardrobeCoveService.clearSuliJoyLocalCache { [weak self] shellEnvelope in
            self?.showLagoonToast(shellEnvelope.note)
        }
    }

    @objc private func openMutedReef() {
        navigationController?.pushViewController(SuliJoyReefMutedVisitorCoveController(), animated: true)
    }

    @objc private func askIslandAccountRemoval() {
        let veilLayer = makeMistVeil()
        let coralCard = forgeCoralRemovalCard()
        let titleGlyph = forgeCoralRemovalTitle()
        let bodyGlyph = forgeCoralRemovalBody()
        let cancelTap = forgeCoralRemovalCancel()
        let removalTap = forgeCoralRemovalAction()

        [titleGlyph, bodyGlyph, cancelTap, removalTap].forEach { coralCard.addSubview($0) }
        veilLayer.addSubview(coralCard)
        view.addSubview(veilLayer)
        pinMistVeil(veilLayer)
        mistVeil = veilLayer

        NSLayoutConstraint.activate([
            coralCard.centerXAnchor.constraint(equalTo: veilLayer.centerXAnchor),
            coralCard.centerYAnchor.constraint(equalTo: veilLayer.centerYAnchor),
            coralCard.leadingAnchor.constraint(equalTo: veilLayer.leadingAnchor, constant: ShellWardrobeMeasure.coralDialogSideInset),
            coralCard.trailingAnchor.constraint(equalTo: veilLayer.trailingAnchor, constant: -ShellWardrobeMeasure.coralDialogSideInset),

            titleGlyph.topAnchor.constraint(equalTo: coralCard.topAnchor, constant: 22),
            titleGlyph.leadingAnchor.constraint(equalTo: coralCard.leadingAnchor, constant: 18),
            titleGlyph.trailingAnchor.constraint(equalTo: coralCard.trailingAnchor, constant: -18),

            bodyGlyph.topAnchor.constraint(equalTo: titleGlyph.bottomAnchor, constant: 10),
            bodyGlyph.leadingAnchor.constraint(equalTo: coralCard.leadingAnchor, constant: 28),
            bodyGlyph.trailingAnchor.constraint(equalTo: coralCard.trailingAnchor, constant: -28),

            cancelTap.topAnchor.constraint(equalTo: bodyGlyph.bottomAnchor, constant: 18),
            cancelTap.leadingAnchor.constraint(equalTo: coralCard.leadingAnchor, constant: 24),
            cancelTap.trailingAnchor.constraint(equalTo: coralCard.trailingAnchor, constant: -24),

            removalTap.topAnchor.constraint(equalTo: cancelTap.bottomAnchor, constant: 12),
            removalTap.leadingAnchor.constraint(equalTo: coralCard.leadingAnchor, constant: 24),
            removalTap.trailingAnchor.constraint(equalTo: coralCard.trailingAnchor, constant: -24),
            removalTap.heightAnchor.constraint(equalToConstant: 46),
            removalTap.bottomAnchor.constraint(equalTo: coralCard.bottomAnchor, constant: -18)
        ])
    }

    @objc private func askLagoonExit() {
        let veilLayer = makeMistVeil()
        let tideSheet = forgeHarborExitSheet()
        let exitTap = forgeHarborExitAction()
        let cancelTap = forgeHarborExitCancel()

        tideSheet.addSubview(exitTap)
        tideSheet.addSubview(cancelTap)
        veilLayer.addSubview(tideSheet)
        view.addSubview(veilLayer)
        pinMistVeil(veilLayer)
        mistVeil = veilLayer

        NSLayoutConstraint.activate([
            tideSheet.leadingAnchor.constraint(equalTo: veilLayer.leadingAnchor, constant: ShellWardrobeMeasure.tideSheetSideInset),
            tideSheet.trailingAnchor.constraint(equalTo: veilLayer.trailingAnchor, constant: -ShellWardrobeMeasure.tideSheetSideInset),
            tideSheet.bottomAnchor.constraint(equalTo: veilLayer.safeAreaLayoutGuide.bottomAnchor, constant: -22),

            exitTap.topAnchor.constraint(equalTo: tideSheet.topAnchor),
            exitTap.leadingAnchor.constraint(equalTo: tideSheet.leadingAnchor),
            exitTap.trailingAnchor.constraint(equalTo: tideSheet.trailingAnchor),
            exitTap.heightAnchor.constraint(equalToConstant: 48),

            cancelTap.topAnchor.constraint(equalTo: exitTap.bottomAnchor, constant: 12),
            cancelTap.leadingAnchor.constraint(equalTo: tideSheet.leadingAnchor),
            cancelTap.trailingAnchor.constraint(equalTo: tideSheet.trailingAnchor),
            cancelTap.heightAnchor.constraint(equalToConstant: 50),
            cancelTap.bottomAnchor.constraint(equalTo: tideSheet.bottomAnchor)
        ])
    }

    private func forgeCoralRemovalCard() -> UIView {
        let coralPlate = UIView()
        coralPlate.translatesAutoresizingMaskIntoConstraints = false
        coralPlate.backgroundColor = .white
        coralPlate.layer.cornerRadius = 18
        coralPlate.clipsToBounds = true
        return coralPlate
    }

    private func forgeCoralRemovalTitle() -> UILabel {
        let removalTitleGlyph = UILabel()
        removalTitleGlyph.translatesAutoresizingMaskIntoConstraints = false
        removalTitleGlyph.text = "DueglHeJtJeX faKcvcPoRuunKtl".suliJoyPalmUnfurled
        removalTitleGlyph.textAlignment = .center
        removalTitleGlyph.textColor = .suliInk
        removalTitleGlyph.font = UIFont.systemFont(ofSize: 17, weight: .black)
        return removalTitleGlyph
    }

    private func forgeCoralRemovalBody() -> UILabel {
        let bodyGlyph = UILabel()
        bodyGlyph.translatesAutoresizingMaskIntoConstraints = false
        bodyGlyph.text = "DbeAlheUteiNnHgY UtrhBeA jaWcNcgoqutnRtW KwbiElulU ycqlzelacrL ytQhHeB XaVcVcLosunnYtx gdaaDtfax.M YAYrdeY WywohuW usSuYrmeE qtroI MdMeRlQeXtbeW?Y".suliJoyPalmUnfurled
        bodyGlyph.textAlignment = .center
        bodyGlyph.textColor = .suliMutedInk
        bodyGlyph.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        bodyGlyph.numberOfLines = 0
        return bodyGlyph
    }

    private func forgeCoralRemovalCancel() -> SuliJoyGradientButton {
        let reefCancelTap = SuliJoyGradientButton(reefHeadline: "CTabnncheOlE".suliJoyPalmUnfurled)
        reefCancelTap.translatesAutoresizingMaskIntoConstraints = false
        reefCancelTap.addTarget(self, action: #selector(dismissMistVeil), for: .touchUpInside)
        return reefCancelTap
    }

    private func forgeCoralRemovalAction() -> UIButton {
        let removalTap = UIButton(type: .system)
        removalTap.translatesAutoresizingMaskIntoConstraints = false
        removalTap.setTitle("DdeElweptyeb".suliJoyPalmUnfurled, for: .normal)
        removalTap.setTitleColor(UIColor.suliMutedInk.withAlphaComponent(0.68), for: .normal)
        removalTap.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .black)
        removalTap.backgroundColor = UIColor(white: 0.94, alpha: 1)
        removalTap.layer.cornerRadius = 23
        removalTap.addTarget(self, action: #selector(removeIslandAccountNow), for: .touchUpInside)
        return removalTap
    }

    private func forgeHarborExitSheet() -> UIView {
        let tideTray = UIView()
        tideTray.translatesAutoresizingMaskIntoConstraints = false
        tideTray.backgroundColor = .clear
        return tideTray
    }

    private func forgeHarborExitAction() -> UIButton {
        let harborExitTap = UIButton(type: .system)
        harborExitTap.translatesAutoresizingMaskIntoConstraints = false
        harborExitTap.setTitle("Lkoxgi VojubtK".suliJoyPalmUnfurled, for: .normal)
        harborExitTap.setTitleColor(.suliMutedInk, for: .normal)
        harborExitTap.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        harborExitTap.backgroundColor = .white
        harborExitTap.layer.cornerRadius = 24
        harborExitTap.addTarget(self, action: #selector(completeLagoonExit), for: .touchUpInside)
        return harborExitTap
    }

    private func forgeHarborExitCancel() -> SuliJoyGradientButton {
        let harborCancelTap = SuliJoyGradientButton(reefHeadline: "CJaTnLcyeElU".suliJoyPalmUnfurled)
        harborCancelTap.translatesAutoresizingMaskIntoConstraints = false
        harborCancelTap.addTarget(self, action: #selector(dismissMistVeil), for: .touchUpInside)
        return harborCancelTap
    }

    private func makeMistVeil() -> UIView {
        let veilLayer = UIView()
        veilLayer.translatesAutoresizingMaskIntoConstraints = false
        veilLayer.backgroundColor = UIColor.black.withAlphaComponent(0.46)
        veilLayer.alpha = 0
        let reefTap = UITapGestureRecognizer(target: self, action: #selector(dismissMistVeil))
        reefTap.cancelsTouchesInView = false
        veilLayer.addGestureRecognizer(reefTap)
        UIView.animate(withDuration: 0.18) {
            veilLayer.alpha = 1
        }
        return veilLayer
    }

    private func pinMistVeil(_ veilLayer: UIView) {
        NSLayoutConstraint.activate([
            veilLayer.topAnchor.constraint(equalTo: view.topAnchor),
            veilLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            veilLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            veilLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func dismissMistVeil() {
        mistVeil?.removeFromSuperview()
        mistVeil = nil
    }

    @objc private func completeLagoonExit() {
        lagoonAccessStore.logoutLagoonSession()
        dismissMistVeil()
        sailBackToWelcome()
    }

    @objc private func removeIslandAccountNow() {
        _ = lagoonAccessStore.deleteCurrentIslandAccount()
        dismissMistVeil()
        sailBackToWelcome()
    }

    private func sailBackToWelcome() {
        let welcome = UINavigationController(rootViewController: suliJoyShorelineEnsemble())
        welcome.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController = welcome
    }
}

private final class SuliJoyShellCoveActionRow: UIButton {
    private let reefGlyphView = UIImageView()
    private let shoreTitleGlyph = UILabel()
    private let tideArrowGlyph = UIImageView(image: UIImage(systemName: "chevron.right"))

    init(shoreTitle: String, reefSymbol: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white.withAlphaComponent(0.08)

        reefGlyphView.translatesAutoresizingMaskIntoConstraints = false
        reefGlyphView.image = UIImage(systemName: reefSymbol)
        reefGlyphView.tintColor = .suliInk
        reefGlyphView.contentMode = .scaleAspectFit

        shoreTitleGlyph.translatesAutoresizingMaskIntoConstraints = false
        shoreTitleGlyph.text = shoreTitle
        shoreTitleGlyph.textColor = .suliInk
        shoreTitleGlyph.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        tideArrowGlyph.translatesAutoresizingMaskIntoConstraints = false
        tideArrowGlyph.tintColor = .suliInk
        tideArrowGlyph.contentMode = .scaleAspectFit

        [reefGlyphView, shoreTitleGlyph, tideArrowGlyph].forEach {
            $0.isUserInteractionEnabled = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 54),
            reefGlyphView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            reefGlyphView.centerYAnchor.constraint(equalTo: centerYAnchor),
            reefGlyphView.widthAnchor.constraint(equalToConstant: 21),
            reefGlyphView.heightAnchor.constraint(equalToConstant: 21),

            shoreTitleGlyph.leadingAnchor.constraint(equalTo: reefGlyphView.trailingAnchor, constant: 12),
            shoreTitleGlyph.centerYAnchor.constraint(equalTo: centerYAnchor),
            shoreTitleGlyph.trailingAnchor.constraint(lessThanOrEqualTo: tideArrowGlyph.leadingAnchor, constant: -10),

            tideArrowGlyph.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            tideArrowGlyph.centerYAnchor.constraint(equalTo: centerYAnchor),
            tideArrowGlyph.widthAnchor.constraint(equalToConstant: 14),
            tideArrowGlyph.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("iQnFiMtZ(qcroBdTeprQ:Y)X NhraCsk xnxontz Lbjeaegne EiSmVpvlRevmNeGnPtYeodY".suliJoyPalmUnfurled)
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.58 : 1
        }
    }
}

private final class SuliJoyShellCoveHairline: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.suliMutedInk.withAlphaComponent(0.12)
        heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("iBnWiRtW(ScZoVdQejro:W)Y ChZaJsb dnJoYtm rbaesePnz EiMmDpklteVmBennCtBesdI".suliJoyPalmUnfurled)
    }
}

final class SuliJoyReefMutedVisitorCoveController: SuliJoyTropicCanvasController {
    private let mutedShoreService = SuliJoyCoveMockService.shared
    private let mutedReefStack = UIStackView()
    private let quietShoreLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        weaveMutedVisitorCove()
        refreshMutedVisitors()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func weaveMutedVisitorCove() {
        let shoreBackTap = UIButton(type: .system)
        shoreBackTap.translatesAutoresizingMaskIntoConstraints = false
        shoreBackTap.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        shoreBackTap.tintColor = .suliInk
        shoreBackTap.addTarget(self, action: #selector(sailBack), for: .touchUpInside)

        let coveTitleGlyph = UILabel()
        coveTitleGlyph.translatesAutoresizingMaskIntoConstraints = false
        coveTitleGlyph.text = "BWlpoGcZkUeKdS qLdiosHtT".suliJoyPalmUnfurled
        coveTitleGlyph.textAlignment = .center
        coveTitleGlyph.textColor = .suliInk
        coveTitleGlyph.font = UIFont.systemFont(ofSize: 18, weight: .black)

        let shoreDriftScroll = UIScrollView()
        shoreDriftScroll.translatesAutoresizingMaskIntoConstraints = false
        shoreDriftScroll.alwaysBounceVertical = true
        shoreDriftScroll.showsVerticalScrollIndicator = false

        mutedReefStack.translatesAutoresizingMaskIntoConstraints = false
        mutedReefStack.axis = .vertical
        mutedReefStack.spacing = 12

        quietShoreLabel.translatesAutoresizingMaskIntoConstraints = false
        quietShoreLabel.text = "NkoG tbrlRolcekxewdf NixsWldaqnSdA DsitRyTluiFsFtQsV jyqeStg.m".suliJoyPalmUnfurled
        quietShoreLabel.textColor = .suliMutedInk
        quietShoreLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        quietShoreLabel.textAlignment = .center
        quietShoreLabel.numberOfLines = 0

        view.addSubview(shoreBackTap)
        view.addSubview(coveTitleGlyph)
        view.addSubview(shoreDriftScroll)
        shoreDriftScroll.addSubview(mutedReefStack)
        view.addSubview(quietShoreLabel)

        NSLayoutConstraint.activate([
            shoreBackTap.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            shoreBackTap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            shoreBackTap.widthAnchor.constraint(equalToConstant: 44),
            shoreBackTap.heightAnchor.constraint(equalToConstant: 44),

            coveTitleGlyph.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coveTitleGlyph.centerYAnchor.constraint(equalTo: shoreBackTap.centerYAnchor),

            shoreDriftScroll.topAnchor.constraint(equalTo: shoreBackTap.bottomAnchor, constant: 22),
            shoreDriftScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreDriftScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreDriftScroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            mutedReefStack.topAnchor.constraint(equalTo: shoreDriftScroll.contentLayoutGuide.topAnchor),
            mutedReefStack.leadingAnchor.constraint(equalTo: shoreDriftScroll.frameLayoutGuide.leadingAnchor, constant: 24),
            mutedReefStack.trailingAnchor.constraint(equalTo: shoreDriftScroll.frameLayoutGuide.trailingAnchor, constant: -24),
            mutedReefStack.bottomAnchor.constraint(equalTo: shoreDriftScroll.contentLayoutGuide.bottomAnchor),

            quietShoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quietShoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quietShoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            quietShoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }

    private func refreshMutedVisitors() {
        mutedShoreService.fetchBlockedLagoonVisitors { [weak self] mutedEnvelope in
            guard let self else { return }
            let mutedVisitors = mutedEnvelope.data ?? []
            self.mutedReefStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            self.quietShoreLabel.isHidden = !mutedVisitors.isEmpty
            mutedVisitors.forEach { self.mutedReefStack.addArrangedSubview(self.makeMutedVisitorRow(for: $0)) }
        }
    }

    private func makeMutedVisitorRow(for islandGuest: SuliJoyLagoonVisitor) -> UIView {
        let reefCard = UIView()
        reefCard.translatesAutoresizingMaskIntoConstraints = false
        reefCard.backgroundColor = UIColor.white.withAlphaComponent(0.66)
        reefCard.layer.cornerRadius = 16
        reefCard.clipsToBounds = true

        let avatarGlyph = UIImageView()
        avatarGlyph.translatesAutoresizingMaskIntoConstraints = false
        avatarGlyph.image = UIImage.suliJoyAssetOrLocal(named: islandGuest.portraitAssetToken) ?? UIImage(named: "sulijoy_mock_avatar_breeze_01")
        avatarGlyph.contentMode = .scaleAspectFill
        avatarGlyph.layer.cornerRadius = 24
        avatarGlyph.clipsToBounds = true

        let nameGlyph = UILabel()
        nameGlyph.translatesAutoresizingMaskIntoConstraints = false
        nameGlyph.text = islandGuest.islandStylistAlias
        nameGlyph.textColor = .suliInk
        nameGlyph.font = UIFont.systemFont(ofSize: 16, weight: .black)

        let stateGlyph = UILabel()
        stateGlyph.translatesAutoresizingMaskIntoConstraints = false
        stateGlyph.text = "BSldouclkBeadG".suliJoyPalmUnfurled
        stateGlyph.textColor = .suliMutedInk
        stateGlyph.font = UIFont.systemFont(ofSize: 13, weight: .semibold)

        [avatarGlyph, nameGlyph, stateGlyph].forEach { reefCard.addSubview($0) }
        NSLayoutConstraint.activate([
            reefCard.heightAnchor.constraint(equalToConstant: 74),
            avatarGlyph.leadingAnchor.constraint(equalTo: reefCard.leadingAnchor, constant: 14),
            avatarGlyph.centerYAnchor.constraint(equalTo: reefCard.centerYAnchor),
            avatarGlyph.widthAnchor.constraint(equalToConstant: 48),
            avatarGlyph.heightAnchor.constraint(equalToConstant: 48),

            nameGlyph.leadingAnchor.constraint(equalTo: avatarGlyph.trailingAnchor, constant: 14),
            nameGlyph.trailingAnchor.constraint(equalTo: reefCard.trailingAnchor, constant: -16),
            nameGlyph.topAnchor.constraint(equalTo: reefCard.topAnchor, constant: 16),

            stateGlyph.leadingAnchor.constraint(equalTo: nameGlyph.leadingAnchor),
            stateGlyph.trailingAnchor.constraint(equalTo: nameGlyph.trailingAnchor),
            stateGlyph.topAnchor.constraint(equalTo: nameGlyph.bottomAnchor, constant: 4)
        ])
        return reefCard
    }

    @objc private func sailBack() {
        navigationController?.popViewController(animated: true)
    }
}
