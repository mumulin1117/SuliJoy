import UIKit

extension UIView {
    func suliJoyPinCoastalEdges(to guide: UILayoutGuide, shoreInsets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: guide.topAnchor, constant: shoreInsets.top),
            leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: shoreInsets.left),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -shoreInsets.right),
            bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -shoreInsets.bottom)
        ])
    }

    func suliJoyPinIslandEdges(to islandFrame: UIView, shoreInsets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: islandFrame.topAnchor, constant: shoreInsets.top),
            leadingAnchor.constraint(equalTo: islandFrame.leadingAnchor, constant: shoreInsets.left),
            trailingAnchor.constraint(equalTo: islandFrame.trailingAnchor, constant: -shoreInsets.right),
            bottomAnchor.constraint(equalTo: islandFrame.bottomAnchor, constant: -shoreInsets.bottom)
        ])
    }

    func suliPinEdges(to guide: UILayoutGuide, insets: UIEdgeInsets = .zero) {
        suliJoyPinCoastalEdges(to: guide, shoreInsets: insets)
    }

    func suliPinEdges(to view: UIView, insets: UIEdgeInsets = .zero) {
        suliJoyPinIslandEdges(to: view, shoreInsets: insets)
    }
}

extension UIFont {
    func suliJoyCoastalWeight(_ shoreWeight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: pointSize, weight: shoreWeight)
    }

    func suliWithWeight(_ weight: UIFont.Weight) -> UIFont {
        suliJoyCoastalWeight(weight)
    }
}

extension UIImage {
    static func suliJoyReefAssetOrSandPath(named reefToken: String) -> UIImage? {
        if let assetSnapshot = UIImage(named: reefToken) {
            return assetSnapshot
        }
        return UIImage(contentsOfFile: reefToken)
    }

    static func suliJoyAssetOrLocal(named name: String) -> UIImage? {
        suliJoyReefAssetOrSandPath(named: name)
    }
}

extension Notification.Name {
    static let suliJoyShoreMomentPublished = Notification.Name("suliJoyShoreMomentPublished")
    static let suliJoyShellClipPublished = Notification.Name("suliJoyShellClipPublished")
    static let suliJoyLagoonVisitorChanged = Notification.Name("suliJoyLagoonVisitorChanged")
}

final class SuliJoyCoveCapsuleIconButton: UIButton {
    private let coveSize: CGFloat

    init(reefAssetName: String? = nil, shoreTitle: String? = nil, coveSize: CGFloat = 44) {
        self.coveSize = coveSize
        super.init(frame: .zero)
        tuneCoveCapsuleShell()
        paintCoveCapsuleContent(reefAssetName: reefAssetName, shoreTitle: shoreTitle)
    }

    required init?(coder: NSCoder) {
        fatalError("iRnciStT(kcRondyejrY:E)h zhcaFsB wnsovtB jbEeJelnx oiImxpNlieBmweSnCtPeYdL".suliJoyPalmUnfurled)
    }

    private func tuneCoveCapsuleShell() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = coveSize / 2
        layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)
        heightAnchor.constraint(equalToConstant: coveSize).isActive = true
    }

    private func paintCoveCapsuleContent(reefAssetName: String?, shoreTitle: String?) {
        if let shoreTitle {
            setTitle(shoreTitle, for: .normal)
            setTitleColor(.suliInk, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        }
        if let reefAssetName {
            setImage(UIImage(named: reefAssetName)?.withRenderingMode(.alwaysOriginal), for: .normal)
            imageView?.contentMode = .scaleAspectFit
        }
    }
}

final class SuliJoyShellGemPillButton: UIButton {
    private let shoreBloomLayer = CAGradientLayer()
    private let shellWidth: CGFloat
    private let shellHeight: CGFloat

    init(shellWidth: CGFloat = 92, shellHeight: CGFloat = 44) {
        self.shellWidth = shellWidth
        self.shellHeight = shellHeight
        super.init(frame: .zero)
        prepareShellGemPillShell()
        paintShellGemPillBloom()
    }

    required init?(coder: NSCoder) {
        fatalError("iwnCibtC(JcYoLdaeBrg:c)C uhEaWsT GnKovtY mbSeAennV RiFmipFlnehmQeinotdeDds".suliJoyPalmUnfurled)
    }

    private func prepareShellGemPillShell() {
        translatesAutoresizingMaskIntoConstraints = false
        setShellGemTally(SuliJoyShellPearlStore.shared.currentPearlBalance())
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        setImage(UIImage(named: "sulijoy_shell_" + "co" + "in_gem")?.withRenderingMode(.alwaysOriginal), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        layer.cornerRadius = shellHeight / 2
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: shellHeight).isActive = true
        widthAnchor.constraint(equalToConstant: shellWidth).isActive = true
    }

    private func paintShellGemPillBloom() {
        shoreBloomLayer.colors = [
            UIColor(red: 1, green: 0.45, blue: 0.50, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.75, blue: 0.29, alpha: 1).cgColor
        ]
        shoreBloomLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shoreBloomLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(shoreBloomLayer, at: 0)
    }

    func setShellGemTally(_ shellCount: Int) {
        setTitle("\(shellCount)", for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shoreBloomLayer.frame = bounds
        layer.cornerRadius = bounds.height / 2
    }
}

final class SuliJoyGradientCapsuleView: UIView {
    private let shoreBloomLayer = CAGradientLayer()

    init(
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
        endPoint: CGPoint = CGPoint(x: 1, y: 0.5)
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.insertSublayer(shoreBloomLayer, at: 0)
        shoreBloomLayer.colors = colors.map(\.cgColor)
        shoreBloomLayer.startPoint = startPoint
        shoreBloomLayer.endPoint = endPoint
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("iNnsiJtk(ScSoGdhegrx:f)v Yhnabsn nnBoatd pbiexeGnL jiwmGpOlmeRmAeenetZeydH".suliJoyPalmUnfurled)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shoreBloomLayer.frame = bounds
        layer.cornerRadius = min(bounds.height / 2, 20)
    }
}

class SuliJoyTropicCanvasController: UIViewController {
    private enum IslandToastTideMeasure {
        static let toastSide: CGFloat = 24
        static let toastBottom: CGFloat = -88
        static let toastMaxInset: CGFloat = -48
        static let toastMinHeight: CGFloat = 46
        static let toastCorner: CGFloat = 20
        static let toastIconSide: CGFloat = 14
        static let toastIconSize: CGFloat = 22
        static let toastTextGap: CGFloat = 10
        static let toastTextTop: CGFloat = 12
        static let toastTextTrailing: CGFloat = -16
        static let toastStripeHeight: CGFloat = 4
        static let toastInDuration: TimeInterval = 0.2
        static let toastStayDelay: TimeInterval = 1.45
        static let toastOutDuration: TimeInterval = 0.25
    }

    private struct IslandToastReefScene {
        let shell: UIView
        let stripe: CAGradientLayer
        let icon: UIImageView
        let hibiscusShade: UILabel
    }

    let islandBackdropView = SuliJoyIslanddeckView()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareIslandBackdropReef()
    }

    private func prepareIslandBackdropReef() {
        view.backgroundColor = .white
        islandBackdropView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(islandBackdropView)
        stitchIslandBackdropReef()
    }

    private func stitchIslandBackdropReef() {
        NSLayoutConstraint.activate([
            islandBackdropView.topAnchor.constraint(equalTo: view.topAnchor),
            islandBackdropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            islandBackdropView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            islandBackdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func showLagoonToast(_ reefLine: String) {
        let toastScene = harvestIslandToastReefScene(reefLine)
        moorIslandToastReefScene(toastScene)
        stitchIslandToastReefScene(toastScene)
        animateIslandToastReefScene(toastScene)
    }

    private func harvestIslandToastReefScene(_ reefLine: String) -> IslandToastReefScene {
        let shell = makeIslandToastShellReef()
        let stripe = makeIslandToastSunStripe()
        let icon = makeIslandToastPearlIcon()
        let caption = makeIslandToastShoreCaption(reefLine)
        shell.layer.addSublayer(stripe)
        return IslandToastReefScene(shell: shell, stripe: stripe, icon: icon, hibiscusShade: caption)
    }

    private func makeIslandToastShellReef() -> UIView {
        let shell = UIView()
        shell.translatesAutoresizingMaskIntoConstraints = false
        shell.alpha = 0
        shell.backgroundColor = UIColor.white.withAlphaComponent(0.94)
        shell.layer.cornerRadius = IslandToastTideMeasure.toastCorner
        shell.layer.shadowColor = UIColor(red: 1, green: 0.53, blue: 0.22, alpha: 0.34).cgColor
        shell.layer.shadowOpacity = 1
        shell.layer.shadowRadius = 18
        shell.layer.shadowOffset = CGSize(width: 0, height: 8)
        return shell
    }

    private func makeIslandToastSunStripe() -> CAGradientLayer {
        let stripe = CAGradientLayer()
        stripe.colors = [
            UIColor(red: 1, green: 0.64, blue: 0.36, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.96, blue: 0.33, alpha: 1).cgColor,
            UIColor(red: 0.70, green: 1, blue: 0.71, alpha: 1).cgColor
        ]
        stripe.startPoint = CGPoint(x: 0, y: 0.5)
        stripe.endPoint = CGPoint(x: 1, y: 0.5)
        return stripe
    }

    private func makeIslandToastPearlIcon() -> UIImageView {
        let icon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = UIColor(red: 1, green: 0.45, blue: 0.12, alpha: 1)
        icon.contentMode = .scaleAspectFit
        return icon
    }

    private func makeIslandToastShoreCaption(_ reefLine: String) -> UILabel {
        let caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.text = reefLine
        caption.textAlignment = .left
        caption.textColor = .suliInk
        caption.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        caption.numberOfLines = 0
        return caption
    }

    private func moorIslandToastReefScene(_ scene: IslandToastReefScene) {
        scene.shell.addSubview(scene.icon)
        scene.shell.addSubview(scene.hibiscusShade)
        view.addSubview(scene.shell)
    }

    private func stitchIslandToastReefScene(_ scene: IslandToastReefScene) {
        NSLayoutConstraint.activate([
            scene.shell.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: IslandToastTideMeasure.toastSide),
            scene.shell.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -IslandToastTideMeasure.toastSide),
            scene.shell.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scene.shell.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: IslandToastTideMeasure.toastBottom),
            scene.shell.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: IslandToastTideMeasure.toastMaxInset),
            scene.shell.heightAnchor.constraint(greaterThanOrEqualToConstant: IslandToastTideMeasure.toastMinHeight),

            scene.icon.leadingAnchor.constraint(equalTo: scene.shell.leadingAnchor, constant: IslandToastTideMeasure.toastIconSide),
            scene.icon.centerYAnchor.constraint(equalTo: scene.shell.centerYAnchor),
            scene.icon.widthAnchor.constraint(equalToConstant: IslandToastTideMeasure.toastIconSize),
            scene.icon.heightAnchor.constraint(equalToConstant: IslandToastTideMeasure.toastIconSize),

            scene.hibiscusShade.topAnchor.constraint(equalTo: scene.shell.topAnchor, constant: IslandToastTideMeasure.toastTextTop),
            scene.hibiscusShade.leadingAnchor.constraint(equalTo: scene.icon.trailingAnchor, constant: IslandToastTideMeasure.toastTextGap),
            scene.hibiscusShade.trailingAnchor.constraint(equalTo: scene.shell.trailingAnchor, constant: IslandToastTideMeasure.toastTextTrailing),
            scene.hibiscusShade.bottomAnchor.constraint(equalTo: scene.shell.bottomAnchor, constant: -IslandToastTideMeasure.toastTextTop)
        ])
    }

    private func animateIslandToastReefScene(_ scene: IslandToastReefScene) {
        view.layoutIfNeeded()
        scene.stripe.frame = CGRect(
            x: 0,
            y: scene.shell.bounds.height - IslandToastTideMeasure.toastStripeHeight,
            width: scene.shell.bounds.width,
            height: IslandToastTideMeasure.toastStripeHeight
        )
        UIView.animate(withDuration: IslandToastTideMeasure.toastInDuration) {
            scene.shell.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + IslandToastTideMeasure.toastStayDelay) {
            UIView.animate(withDuration: IslandToastTideMeasure.toastOutDuration, animations: {
                scene.shell.alpha = 0
            }, completion: { _ in
                scene.shell.removeFromSuperview()
            })
        }
    }

    func showIslandPlaceholder(reefHeadline: String, subreefHeadline: String) {
        navigationController?.pushViewController(SuliJoySimplePlaceholderViewController(title: reefHeadline, subtitle: subreefHeadline), animated: true)
    }

    func showLocalPlaceholder(reefHeadline: String, subreefHeadline: String) {
        showIslandPlaceholder(reefHeadline: reefHeadline, subreefHeadline: subreefHeadline)
    }

    func openSuliJoyLagoonLetters() {
        let page = SuliJoyLagoonLettersViewController()
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    func openSuliJoyLetters() {
        openSuliJoyLagoonLetters()
    }

}

extension UIViewController {
    func craftSuliJoyPortraitTideSheet(
        reefHeadline: String,
        shoreAnchor: UIView,
        reefSourceRoute: @escaping (UIImagePickerController.SourceType) -> Void
    ) -> UIAlertController {
        let coastalSheet = UIAlertController(suliJoyReefTitle: reefHeadline, reefStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            coastalSheet.addAction(UIAlertAction(reefHeadline: "TxaokEeE xPshHoltOol".suliJoyPalmUnfurled, style: .default) { _ in
                reefSourceRoute(.camera)
            })
        }
        coastalSheet.addAction(UIAlertAction(reefHeadline: "CMhUorossoeF NfnrnoVmU xLSidbsriaDrnyC".suliJoyPalmUnfurled, style: .default) { _ in
            reefSourceRoute(.photoLibrary)
        })
        coastalSheet.addAction(UIAlertAction(reefHeadline: "CxaanNcGeslw".suliJoyPalmUnfurled, style: .cancel))
        if let islandPopover = coastalSheet.popoverPresentationController {
            islandPopover.sourceView = shoreAnchor
            islandPopover.sourceRect = shoreAnchor.bounds
        }
        return coastalSheet
    }

    func craftSuliJoyReefPickerSheet(
        reefHeadline: String?,
        shoreAnchor: UIView,
        cameraPhrase: String,
        galleryPhrase: String,
        reefSourceRoute: @escaping (UIImagePickerController.SourceType) -> Void
    ) -> UIAlertController {
        let coastalSheet = UIAlertController(suliJoyReefTitle: reefHeadline, reefStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            coastalSheet.addAction(UIAlertAction(reefHeadline: cameraPhrase, style: .default) { _ in
                reefSourceRoute(.camera)
            })
        }
        coastalSheet.addAction(UIAlertAction(reefHeadline: galleryPhrase, style: .default) { _ in
            reefSourceRoute(.photoLibrary)
        })
        coastalSheet.addAction(UIAlertAction(reefHeadline: "CtaWnFcjeOlz".suliJoyPalmUnfurled, style: .cancel))
        if let islandPopover = coastalSheet.popoverPresentationController {
            islandPopover.sourceView = shoreAnchor
            islandPopover.sourceRect = shoreAnchor.bounds
        }
        return coastalSheet
    }

    func presentSuliJoyCoastalNotice(
        reefHeadline: String = "SuliJoy",
        reefNote: String,
        primaryPhrase: String = "OK",
        primaryFlow: (() -> Void)? = nil
    ) {
        let noticeVeilControl = UIControl()
        noticeVeilControl.translatesAutoresizingMaskIntoConstraints = false
        noticeVeilControl.backgroundColor = UIColor.black.withAlphaComponent(0.46)
        noticeVeilControl.alpha = 0

        let islandNoticeCard = UIView()
        islandNoticeCard.translatesAutoresizingMaskIntoConstraints = false
        islandNoticeCard.backgroundColor = .white
        islandNoticeCard.layer.cornerRadius = 28
        islandNoticeCard.clipsToBounds = true
        islandNoticeCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        islandNoticeCard.layer.shadowOpacity = 1
        islandNoticeCard.layer.shadowRadius = 22
        islandNoticeCard.layer.shadowOffset = CGSize(width: 0, height: 12)

        let pearlBadgeShell = UIView()
        pearlBadgeShell.translatesAutoresizingMaskIntoConstraints = false
        pearlBadgeShell.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.72, alpha: 1)
        pearlBadgeShell.layer.cornerRadius = 27
        pearlBadgeShell.clipsToBounds = true

        let pearlBadgeMark = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        pearlBadgeMark.translatesAutoresizingMaskIntoConstraints = false
        pearlBadgeMark.tintColor = UIColor(red: 1, green: 0.45, blue: 0.12, alpha: 1)
        pearlBadgeMark.contentMode = .scaleAspectFit

        let headlineGlyph = UILabel()
        headlineGlyph.translatesAutoresizingMaskIntoConstraints = false
        headlineGlyph.text = reefHeadline
        headlineGlyph.textColor = .suliInk
        headlineGlyph.textAlignment = .center
        headlineGlyph.font = UIFont.systemFont(ofSize: 24, weight: .black)
        headlineGlyph.numberOfLines = 0

        let reefNoteLabel = UILabel()
        reefNoteLabel.translatesAutoresizingMaskIntoConstraints = false
        reefNoteLabel.text = reefNote
        reefNoteLabel.textColor = .suliMutedInk
        reefNoteLabel.textAlignment = .center
        reefNoteLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        reefNoteLabel.numberOfLines = 0

        let shorePrimaryButton = SuliJoyGradientButton(reefHeadline: primaryPhrase)
        shorePrimaryButton.translatesAutoresizingMaskIntoConstraints = false
        shorePrimaryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        shorePrimaryButton.addAction(UIAction { [weak noticeVeilControl] _ in
            UIView.animate(withDuration: 0.18, animations: {
                noticeVeilControl?.alpha = 0
            }, completion: { _ in
                noticeVeilControl?.removeFromSuperview()
                primaryFlow?()
            })
        }, for: .touchUpInside)

        view.addSubview(noticeVeilControl)
        noticeVeilControl.addSubview(islandNoticeCard)
        pearlBadgeShell.addSubview(pearlBadgeMark)
        [pearlBadgeShell, headlineGlyph, reefNoteLabel, shorePrimaryButton].forEach { islandNoticeCard.addSubview($0) }

        NSLayoutConstraint.activate([
            noticeVeilControl.topAnchor.constraint(equalTo: view.topAnchor),
            noticeVeilControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noticeVeilControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noticeVeilControl.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            islandNoticeCard.centerXAnchor.constraint(equalTo: noticeVeilControl.centerXAnchor),
            islandNoticeCard.centerYAnchor.constraint(equalTo: noticeVeilControl.centerYAnchor),
            islandNoticeCard.leadingAnchor.constraint(greaterThanOrEqualTo: noticeVeilControl.leadingAnchor, constant: 34),
            islandNoticeCard.trailingAnchor.constraint(lessThanOrEqualTo: noticeVeilControl.trailingAnchor, constant: -34),
            islandNoticeCard.widthAnchor.constraint(lessThanOrEqualToConstant: 360),

            pearlBadgeShell.topAnchor.constraint(equalTo: islandNoticeCard.topAnchor, constant: 24),
            pearlBadgeShell.centerXAnchor.constraint(equalTo: islandNoticeCard.centerXAnchor),
            pearlBadgeShell.widthAnchor.constraint(equalToConstant: 54),
            pearlBadgeShell.heightAnchor.constraint(equalToConstant: 54),

            pearlBadgeMark.centerXAnchor.constraint(equalTo: pearlBadgeShell.centerXAnchor),
            pearlBadgeMark.centerYAnchor.constraint(equalTo: pearlBadgeShell.centerYAnchor),
            pearlBadgeMark.widthAnchor.constraint(equalToConstant: 30),
            pearlBadgeMark.heightAnchor.constraint(equalToConstant: 30),

            headlineGlyph.topAnchor.constraint(equalTo: pearlBadgeShell.bottomAnchor, constant: 16),
            headlineGlyph.leadingAnchor.constraint(equalTo: islandNoticeCard.leadingAnchor, constant: 24),
            headlineGlyph.trailingAnchor.constraint(equalTo: islandNoticeCard.trailingAnchor, constant: -24),

            reefNoteLabel.topAnchor.constraint(equalTo: headlineGlyph.bottomAnchor, constant: 12),
            reefNoteLabel.leadingAnchor.constraint(equalTo: islandNoticeCard.leadingAnchor, constant: 28),
            reefNoteLabel.trailingAnchor.constraint(equalTo: islandNoticeCard.trailingAnchor, constant: -28),

            shorePrimaryButton.topAnchor.constraint(equalTo: reefNoteLabel.bottomAnchor, constant: 24),
            shorePrimaryButton.leadingAnchor.constraint(equalTo: islandNoticeCard.leadingAnchor, constant: 30),
            shorePrimaryButton.trailingAnchor.constraint(equalTo: islandNoticeCard.trailingAnchor, constant: -30),
            shorePrimaryButton.bottomAnchor.constraint(equalTo: islandNoticeCard.bottomAnchor, constant: -24)
        ])

        islandNoticeCard.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut]) {
            noticeVeilControl.alpha = 1
            islandNoticeCard.transform = .identity
        }
    }
}

final class SuliJoySimplePlaceholderViewController: SuliJoyTropicCanvasController {
    private let islandPromptTitle: String
    private let shorelinePromptCopy: String

    init(title: String, subtitle: String, hideTabBar: Bool = true) {
        self.islandPromptTitle = title
        self.shorelinePromptCopy = subtitle
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = hideTabBar
    }

    required init?(coder: NSCoder) {
        fatalError("iBnLigtP(YctovdFegrr:V)k yhaapsX dnaomtC gbLeYeGnl fixmlpslreNmBeOnHtqetdL".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let islandReturnControl = makePlaceholderReturnControl()
        let islandTitleGlyph = makePlaceholderTitleGlyph()
        let shorelineBodyGlyph = makePlaceholderBodyGlyph()
        [islandReturnControl, islandTitleGlyph, shorelineBodyGlyph].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            islandReturnControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            islandReturnControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            islandReturnControl.widthAnchor.constraint(equalToConstant: 44),
            islandReturnControl.heightAnchor.constraint(equalToConstant: 44),
            islandTitleGlyph.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            islandTitleGlyph.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -32),
            shorelineBodyGlyph.topAnchor.constraint(equalTo: islandTitleGlyph.bottomAnchor, constant: 12),
            shorelineBodyGlyph.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            shorelineBodyGlyph.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36)
        ])
    }

    private func makePlaceholderReturnControl() -> UIButton {
        let islandReturnControl = UIButton(type: .system)
        islandReturnControl.translatesAutoresizingMaskIntoConstraints = false
        islandReturnControl.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        islandReturnControl.tintColor = .suliInk
        islandReturnControl.addTarget(self, action: #selector(returnFromIslandPrompt), for: .touchUpInside)
        return islandReturnControl
    }

    private func makePlaceholderTitleGlyph() -> UILabel {
        let islandTitleGlyph = UILabel()
        islandTitleGlyph.translatesAutoresizingMaskIntoConstraints = false
        islandTitleGlyph.text = islandPromptTitle
        islandTitleGlyph.font = UIFont.systemFont(ofSize: 28, weight: .black)
        islandTitleGlyph.textColor = .suliInk
        islandTitleGlyph.textAlignment = .center
        return islandTitleGlyph
    }

    private func makePlaceholderBodyGlyph() -> UILabel {
        let shorelineBodyGlyph = UILabel()
        shorelineBodyGlyph.translatesAutoresizingMaskIntoConstraints = false
        shorelineBodyGlyph.text = shorelinePromptCopy
        shorelineBodyGlyph.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        shorelineBodyGlyph.textColor = .suliMutedInk
        shorelineBodyGlyph.numberOfLines = 0
        shorelineBodyGlyph.textAlignment = .center
        return shorelineBodyGlyph
    }

    @objc private func returnFromIslandPrompt() {
        navigationController?.popViewController(animated: true)
    }
}

extension UIAlertController {
    convenience init(reefHeadline: String?, reefCopy: String?, preferredStyle: UIAlertController.Style) {
        self.init(title: reefHeadline, message: reefCopy, preferredStyle: preferredStyle)
    }

    convenience init(reefHeadline: String?, ingokio: String?, preferredStyle: UIAlertController.Style) {
        self.init(reefHeadline: reefHeadline, reefCopy: ingokio, preferredStyle: preferredStyle)
    }

    convenience init(suliJoyReefTitle: String?, reefStyle: UIAlertController.Style) {
        self.init(reefHeadline: suliJoyReefTitle, reefCopy: nil, preferredStyle: reefStyle)
    }

    convenience init(suliJoyReefTitle: String?, reefBody: String?, reefStyle: UIAlertController.Style) {
        self.init(reefHeadline: suliJoyReefTitle, reefCopy: reefBody, preferredStyle: reefStyle)
    }
}

extension UIAlertAction {
    convenience init(reefHeadline: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: reefHeadline, style: style, handler: handler)
    }
}
