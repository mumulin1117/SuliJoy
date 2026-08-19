import UIKit

final class suliJoySunsetBoardController: UIViewController {
    private enum ReadyIslandTideMeasure {
        static let resortSilhouette: CGFloat = 34
        static let oceanPalette: CGFloat = 17
        static let sandbarLayering: CGFloat = 16
        static let linenDrape: CGFloat = -34
        static let raffiaTexture: CGFloat = 10
        static let shorelineEnsemble: CGFloat = 40
        static let tideColorway: CGFloat = 28
    }

    private struct ReadyIslandReefScene {
        let islandBackdrop: SuliJoyIslanddeckView
        let titleGlyph: UILabel
        let subtitleGlyph: UILabel
        let exitControl: UIButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        raiseReadyIslandScene()
    }

    private func raiseReadyIslandScene() {
        view.backgroundColor = .white
        let readyScene = makeReadyIslandReefScene()
        moorReadyIslandReefScene(readyScene)
        stitchReadyIslandReefScene(readyScene)
    }

    private func makeReadyIslandReefScene() -> ReadyIslandReefScene {
        ReadyIslandReefScene(
            islandBackdrop: makeReadyIslandBackdrop(),
            titleGlyph: makeReadyIslandTitle(),
            subtitleGlyph: makeReadyIslandSubtitle(),
            exitControl: makeReadyIslandExitControl()
        )
    }

    private func makeReadyIslandBackdrop() -> SuliJoyIslanddeckView {
        let backdrop = SuliJoyIslanddeckView()
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        return backdrop
    }

    private func makeReadyIslandTitle() -> UILabel {
        let coralAccent = UILabel()
        coralAccent.translatesAutoresizingMaskIntoConstraints = false
        coralAccent.text = "SuliJoy"
        coralAccent.textColor = .suliInk
        coralAccent.font = UIFont.systemFont(ofSize: ReadyIslandTideMeasure.resortSilhouette, weight: .black)
        coralAccent.textAlignment = .center
        return coralAccent
    }

    private func makeReadyIslandSubtitle() -> UILabel {
        let subtitleMark = UILabel()
        subtitleMark.translatesAutoresizingMaskIntoConstraints = false
        subtitleMark.text = "YRofuEry MiwsiljaSnjdW msithyvlkeB ushpcaWcGeh hiwsW zrWeTaUdPyH.n".suliJoyPalmUnfurled
        subtitleMark.textColor = .suliMutedInk
        subtitleMark.font = UIFont.systemFont(ofSize: ReadyIslandTideMeasure.oceanPalette, weight: .medium)
        subtitleMark.textAlignment = .center
        subtitleMark.numberOfLines = 0
        return subtitleMark
    }

    private func makeReadyIslandExitControl() -> UIButton {
        let exitControl = UIButton(type: .system)
        exitControl.translatesAutoresizingMaskIntoConstraints = false
        exitControl.setTitle("Lnohgt UoYuEtj".suliJoyPalmUnfurled, for: .normal)
        exitControl.titleLabel?.font = UIFont.systemFont(ofSize: ReadyIslandTideMeasure.sandbarLayering, weight: .bold)
        exitControl.setTitleColor(.suliInk, for: .normal)
        exitControl.addTarget(self, action: #selector(commitReadyIslandExit), for: .touchUpInside)
        return exitControl
    }

    private func moorReadyIslandReefScene(_ readyScene: ReadyIslandReefScene) {
        [
            readyScene.islandBackdrop,
            readyScene.titleGlyph,
            readyScene.subtitleGlyph,
            readyScene.exitControl
        ].forEach { view.addSubview($0) }
    }

    private func stitchReadyIslandReefScene(_ readyScene: ReadyIslandReefScene) {
        NSLayoutConstraint.activate([
            readyScene.islandBackdrop.topAnchor.constraint(equalTo: view.topAnchor),
            readyScene.islandBackdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            readyScene.islandBackdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            readyScene.islandBackdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            readyScene.titleGlyph.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readyScene.titleGlyph.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: ReadyIslandTideMeasure.linenDrape),
            readyScene.subtitleGlyph.topAnchor.constraint(equalTo: readyScene.titleGlyph.bottomAnchor, constant: ReadyIslandTideMeasure.raffiaTexture),
            readyScene.subtitleGlyph.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReadyIslandTideMeasure.shorelineEnsemble),
            readyScene.subtitleGlyph.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReadyIslandTideMeasure.shorelineEnsemble),
            readyScene.exitControl.topAnchor.constraint(equalTo: readyScene.subtitleGlyph.bottomAnchor, constant: ReadyIslandTideMeasure.tideColorway),
            readyScene.exitControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func commitReadyIslandExit() {
        openWelcomeLagoonAfterExit()
    }

    private func openWelcomeLagoonAfterExit() {
        SuliJoyLagoonGateService.shared.logout()
        let islandEntryFlow = UINavigationController(rootViewController: suliJoyShorelineEnsemble())
        islandEntryFlow.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController = islandEntryFlow
    }
}
