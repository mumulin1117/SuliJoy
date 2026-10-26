import UIKit

final class lagoonLetterCanvas: UIView {
    private let comment = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.93, alpha: 1)
        comment.colors = [
            UIColor(white: 1, alpha: 0).cgColor,
            UIColor(white: 1, alpha: 0.78).cgColor,
            UIColor(white: 1, alpha: 0).cgColor
        ]
        comment.startPoint = CGPoint(x: 0, y: 0.5)
        comment.endPoint = CGPoint(x: 1, y: 0.5)
        comment.locations = [-1, -0.5, 0]
        layer.addSublayer(comment)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        comment.frame = bounds
        comment.cornerRadius = layer.cornerRadius
    }

    func reefReplies() {
        guard comment.animation(forKey: "shoreSheen") == nil else { return }
        let presentShoreCalendarWheel = CABasicAnimation(keyPath: "locations")
        presentShoreCalendarWheel.fromValue = [-1.0, -0.5, 0.0]
        presentShoreCalendarWheel.toValue = [1.0, 1.5, 2.0]
        presentShoreCalendarWheel.duration = 1.15
        presentShoreCalendarWheel.repeatCount = .infinity
        presentShoreCalendarWheel.isRemovedOnCompletion = false
        comment.add(presentShoreCalendarWheel, forKey: "shoreSheen")
    }

    func dismissReefKeyboard() {
        comment.removeAnimation(forKey: "shoreSheen")
    }
}

final class makeCurationChoiceRail: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        isHidden = true
        accessibilityLabel = "Loading voice rooms"
        let reefNumber = UIStackView()
        reefNumber.translatesAutoresizingMaskIntoConstraints = false
        reefNumber.axis = .vertical
        reefNumber.spacing = 12
        addSubview(reefNumber)
        NSLayoutConstraint.activate([
            reefNumber.topAnchor.constraint(equalTo: topAnchor),
            reefNumber.leadingAnchor.constraint(equalTo: leadingAnchor),
            reefNumber.trailingAnchor.constraint(equalTo: trailingAnchor),
            reefNumber.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        for _ in 0..<2 {
            let islandCode = UIStackView()
            islandCode.axis = .horizontal
            islandCode.spacing = 12
            islandCode.distribution = .fillEqually
            let renderMomentMedia = coverPreviewImages()
            let reefBloomLayer = coverPreviewImages()
            islandCode.addArrangedSubview(renderMomentMedia)
            islandCode.addArrangedSubview(reefBloomLayer)
            reefNumber.addArrangedSubview(islandCode)
            renderMomentMedia.heightAnchor.constraint(equalTo: renderMomentMedia.widthAnchor, multiplier: 1.28).isActive = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func weaveShellCovePage(_ loadHarborSpace: Bool) {
        isHidden = !loadHarborSpace
        shortageCardWidth { loadHarborSpace ? $0.reefReplies() : $0.dismissReefKeyboard() }
    }

    private func shortageCardWidth(_ islandStyleTagline: (lagoonLetterCanvas) -> Void) {
        func suliJoyIslandEnsemble(_ view: UIView) {
            if let duskVeilView = view as? lagoonLetterCanvas {
                islandStyleTagline(duskVeilView)
            }
            view.subviews.forEach(suliJoyIslandEnsemble)
        }
        suliJoyIslandEnsemble(self)
    }
}

private final class coverPreviewImages: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 18
        let shoreResonanceStripeAsset = lagoonLetterCanvas()
        shoreResonanceStripeAsset.translatesAutoresizingMaskIntoConstraints = false
        shoreResonanceStripeAsset.layer.cornerRadius = 18
        let motionPulseButton = lagoonLetterCanvas()
        motionPulseButton.translatesAutoresizingMaskIntoConstraints = false
        motionPulseButton.layer.cornerRadius = 13
        motionPulseButton.backgroundColor = UIColor.white.withAlphaComponent(0.55)
        let suliJoyShoreMomentPublished = lagoonLetterCanvas()
        suliJoyShoreMomentPublished.translatesAutoresizingMaskIntoConstraints = false
        suliJoyShoreMomentPublished.layer.cornerRadius = 13
        suliJoyShoreMomentPublished.backgroundColor = UIColor.white.withAlphaComponent(0.55)
        let summary = lagoonLetterCanvas()
        summary.translatesAutoresizingMaskIntoConstraints = false
        summary.layer.cornerRadius = 6
        summary.backgroundColor = UIColor.white.withAlphaComponent(0.55)
        let bindShoreKeyboardTides = lagoonLetterCanvas()
        bindShoreKeyboardTides.translatesAutoresizingMaskIntoConstraints = false
        bindShoreKeyboardTides.layer.cornerRadius = 14
        bindShoreKeyboardTides.backgroundColor = UIColor.white.withAlphaComponent(0.55)
        [shoreResonanceStripeAsset, motionPulseButton, suliJoyShoreMomentPublished, bindShoreKeyboardTides, summary].forEach(addSubview)
        NSLayoutConstraint.activate([
            shoreResonanceStripeAsset.topAnchor.constraint(equalTo: topAnchor),
            shoreResonanceStripeAsset.leadingAnchor.constraint(equalTo: leadingAnchor),
            shoreResonanceStripeAsset.trailingAnchor.constraint(equalTo: trailingAnchor),
            shoreResonanceStripeAsset.bottomAnchor.constraint(equalTo: bottomAnchor),
            motionPulseButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            motionPulseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            motionPulseButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.42),
            motionPulseButton.heightAnchor.constraint(equalToConstant: 26),
            suliJoyShoreMomentPublished.topAnchor.constraint(equalTo: motionPulseButton.topAnchor),
            suliJoyShoreMomentPublished.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            suliJoyShoreMomentPublished.widthAnchor.constraint(equalToConstant: 52),
            suliJoyShoreMomentPublished.heightAnchor.constraint(equalToConstant: 26),
            summary.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            summary.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            summary.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            summary.heightAnchor.constraint(equalToConstant: 12),
            bindShoreKeyboardTides.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            bindShoreKeyboardTides.bottomAnchor.constraint(equalTo: summary.topAnchor, constant: -8),
            bindShoreKeyboardTides.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.46),
            bindShoreKeyboardTides.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class LagoonLetterMeasure: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        isHidden = true
        accessibilityLabel = "Loading live rooms"
        let clipPortraitToken = UIStackView()
        clipPortraitToken.translatesAutoresizingMaskIntoConstraints = false
        clipPortraitToken.axis = .vertical
        clipPortraitToken.spacing = 12
        addSubview(clipPortraitToken)
        NSLayoutConstraint.activate([
            clipPortraitToken.topAnchor.constraint(equalTo: topAnchor),
            clipPortraitToken.leadingAnchor.constraint(equalTo: leadingAnchor),
            clipPortraitToken.trailingAnchor.constraint(equalTo: trailingAnchor),
            clipPortraitToken.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        for _ in 0..<4 {
            let row = reefLettersButton()
            clipPortraitToken.addArrangedSubview(row)
            row.heightAnchor.constraint(equalToConstant: 106).isActive = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func weaveShellCovePage(_ loadHarborSpace: Bool) {
        isHidden = !loadHarborSpace
        func suliJoyIslandEnsemble(_ view: UIView) {
            if let duskVeilView = view as? lagoonLetterCanvas {
                loadHarborSpace ? duskVeilView.reefReplies() : duskVeilView.dismissReefKeyboard()
            }
            view.subviews.forEach(suliJoyIslandEnsemble)
        }
        suliJoyIslandEnsemble(self)
    }
}

private final class reefLettersButton: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 24
        clipsToBounds = true
        let hideTabBar = lagoonLetterCanvas()
        hideTabBar.translatesAutoresizingMaskIntoConstraints = false
        hideTabBar.layer.cornerRadius = 28
        let lagoonSeatMarkbighb = lagoonLetterCanvas()
        lagoonSeatMarkbighb.translatesAutoresizingMaskIntoConstraints = false
        lagoonSeatMarkbighb.layer.cornerRadius = 6
        let subtitle = lagoonLetterCanvas()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.layer.cornerRadius = 5
        let ShoreSignupReefScene = lagoonLetterCanvas()
        ShoreSignupReefScene.translatesAutoresizingMaskIntoConstraints = false
        ShoreSignupReefScene.layer.cornerRadius = 10
        let joinTideControl = lagoonLetterCanvas()
        joinTideControl.translatesAutoresizingMaskIntoConstraints = false
        joinTideControl.layer.cornerRadius = 10
        [hideTabBar, lagoonSeatMarkbighb, subtitle, ShoreSignupReefScene, joinTideControl].forEach(addSubview)
        NSLayoutConstraint.activate([
            hideTabBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            hideTabBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            hideTabBar.widthAnchor.constraint(equalToConstant: 56),
            hideTabBar.heightAnchor.constraint(equalToConstant: 56),
            lagoonSeatMarkbighb.leadingAnchor.constraint(equalTo: hideTabBar.trailingAnchor, constant: 12),
            lagoonSeatMarkbighb.topAnchor.constraint(equalTo: hideTabBar.topAnchor, constant: 4),
            lagoonSeatMarkbighb.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.42),
            lagoonSeatMarkbighb.heightAnchor.constraint(equalToConstant: 14),
            subtitle.leadingAnchor.constraint(equalTo: lagoonSeatMarkbighb.leadingAnchor),
            subtitle.topAnchor.constraint(equalTo: lagoonSeatMarkbighb.bottomAnchor, constant: 8),
            subtitle.widthAnchor.constraint(equalTo: lagoonSeatMarkbighb.widthAnchor, multiplier: 0.72),
            subtitle.heightAnchor.constraint(equalToConstant: 12),
            ShoreSignupReefScene.leadingAnchor.constraint(equalTo: lagoonSeatMarkbighb.leadingAnchor),
            ShoreSignupReefScene.bottomAnchor.constraint(equalTo: hideTabBar.bottomAnchor, constant: -2),
            ShoreSignupReefScene.widthAnchor.constraint(equalToConstant: 64),
            ShoreSignupReefScene.heightAnchor.constraint(equalToConstant: 20),
            joinTideControl.leadingAnchor.constraint(equalTo: ShoreSignupReefScene.trailingAnchor, constant: 6),
            joinTideControl.centerYAnchor.constraint(equalTo: ShoreSignupReefScene.centerYAnchor),
            joinTideControl.widthAnchor.constraint(equalToConstant: 48),
            joinTideControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
