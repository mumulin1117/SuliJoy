import UIKit

final class suliJoySunsetBoardController: UIViewController {
    private enum ReadyIslandTideMeasure {
        static let titleSize: CGFloat = 34
        static let subtitleSize: CGFloat = 17
        static let exitSize: CGFloat = 16
        static let titleLift: CGFloat = -34
        static let subtitleDrop: CGFloat = 10
        static let subtitleSide: CGFloat = 40
        static let exitDrop: CGFloat = 28
    }

    private struct ReadyIslandReefScene {
        let islandBackdrop: SuliJoyIslandBackgroundView
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

    private func makeReadyIslandBackdrop() -> SuliJoyIslandBackgroundView {
        let backdrop = SuliJoyIslandBackgroundView()
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        return backdrop
    }

    private func makeReadyIslandTitle() -> UILabel {
        let titleMark = UILabel()
        titleMark.translatesAutoresizingMaskIntoConstraints = false
        titleMark.text = "SuliJoy"
        titleMark.textColor = .suliInk
        titleMark.font = UIFont.systemFont(ofSize: ReadyIslandTideMeasure.titleSize, weight: .black)
        titleMark.textAlignment = .center
        return titleMark
    }

    private func makeReadyIslandSubtitle() -> UILabel {
        let subtitleMark = UILabel()
        subtitleMark.translatesAutoresizingMaskIntoConstraints = false
        subtitleMark.text = "Your island style space is ready."
        subtitleMark.textColor = .suliMutedInk
        subtitleMark.font = UIFont.systemFont(ofSize: ReadyIslandTideMeasure.subtitleSize, weight: .medium)
        subtitleMark.textAlignment = .center
        subtitleMark.numberOfLines = 0
        return subtitleMark
    }

    private func makeReadyIslandExitControl() -> UIButton {
        let exitControl = UIButton(type: .system)
        exitControl.translatesAutoresizingMaskIntoConstraints = false
        exitControl.setTitle("Log out", for: .normal)
        exitControl.titleLabel?.font = UIFont.systemFont(ofSize: ReadyIslandTideMeasure.exitSize, weight: .bold)
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
            readyScene.titleGlyph.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: ReadyIslandTideMeasure.titleLift),
            readyScene.subtitleGlyph.topAnchor.constraint(equalTo: readyScene.titleGlyph.bottomAnchor, constant: ReadyIslandTideMeasure.subtitleDrop),
            readyScene.subtitleGlyph.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReadyIslandTideMeasure.subtitleSide),
            readyScene.subtitleGlyph.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReadyIslandTideMeasure.subtitleSide),
            readyScene.exitControl.topAnchor.constraint(equalTo: readyScene.subtitleGlyph.bottomAnchor, constant: ReadyIslandTideMeasure.exitDrop),
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
