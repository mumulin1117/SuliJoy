import UIKit

final class SuliJoyShoreRoomLoadingView: UIView {
    private let glow = UIView()
    private let outerRing = ShoreTideRing()
    private let innerRing = ShoreTideRing()
    private let barsHost = UIView()
    private let captionLabel = UILabel()
    private let detailLabel = UILabel()
    private var bars: [UIView] = []
    private var didStartMotion = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        backgroundColor = UIColor(red: 21 / 255, green: 5 / 255, blue: 46 / 255, alpha: 1)
        accessibilityViewIsModal = true
        buildShoreCluster()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showShore(kind: SuliJoyRoomShellKind) {
        switch kind {
        case .live:
            captionLabel.text = "Joining the live"
            accessibilityLabel = "Joining the live"
        case .voice:
            captionLabel.text = "Joining the voice room"
            accessibilityLabel = "Joining the voice room"
        }
        detailLabel.text = "Setting the shore lights"
        alpha = 1
        startShoreMotion()
    }

    func hideShore() {
        stopShoreMotion()
    }

    private func buildShoreCluster() {
        glow.translatesAutoresizingMaskIntoConstraints = false
        glow.backgroundColor = UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 0.18)
        glow.layer.cornerRadius = 78

        outerRing.translatesAutoresizingMaskIntoConstraints = false
        outerRing.paint(color: UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 1), lineWidth: 3, dash: [16, 10])
        innerRing.translatesAutoresizingMaskIntoConstraints = false
        innerRing.paint(color: UIColor(red: 0.55, green: 0.95, blue: 0.4, alpha: 1), lineWidth: 2.5, dash: [8, 8])

        barsHost.translatesAutoresizingMaskIntoConstraints = false
        barsHost.backgroundColor = .clear

        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        captionLabel.textColor = .white
        captionLabel.textAlignment = .center
        captionLabel.adjustsFontSizeToFitWidth = true
        captionLabel.minimumScaleFactor = 0.8

        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        detailLabel.textColor = UIColor.white.withAlphaComponent(0.68)
        detailLabel.textAlignment = .center

        addSubview(glow)
        addSubview(outerRing)
        addSubview(innerRing)
        addSubview(barsHost)
        addSubview(captionLabel)
        addSubview(detailLabel)

        NSLayoutConstraint.activate([
            glow.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            glow.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -28),
            glow.widthAnchor.constraint(equalToConstant: 156),
            glow.heightAnchor.constraint(equalToConstant: 156),

            outerRing.centerXAnchor.constraint(equalTo: glow.centerXAnchor),
            outerRing.centerYAnchor.constraint(equalTo: glow.centerYAnchor),
            outerRing.widthAnchor.constraint(equalToConstant: 112),
            outerRing.heightAnchor.constraint(equalToConstant: 112),

            innerRing.centerXAnchor.constraint(equalTo: glow.centerXAnchor),
            innerRing.centerYAnchor.constraint(equalTo: glow.centerYAnchor),
            innerRing.widthAnchor.constraint(equalToConstant: 78),
            innerRing.heightAnchor.constraint(equalToConstant: 78),

            barsHost.centerXAnchor.constraint(equalTo: glow.centerXAnchor),
            barsHost.centerYAnchor.constraint(equalTo: glow.centerYAnchor),
            barsHost.widthAnchor.constraint(equalToConstant: 36),
            barsHost.heightAnchor.constraint(equalToConstant: 28),

            captionLabel.topAnchor.constraint(equalTo: outerRing.bottomAnchor, constant: 22),
            captionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            captionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24),

            detailLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 6),
            detailLabel.leadingAnchor.constraint(equalTo: captionLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: captionLabel.trailingAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard bars.isEmpty, barsHost.bounds.width > 0 else { return }
        let count = 5
        let gap: CGFloat = 3
        let barWidth = (barsHost.bounds.width - gap * CGFloat(count - 1)) / CGFloat(count)
        let resting = barsHost.bounds.height * 0.38
        let coral = UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 1)
        let lime = UIColor(red: 0.55, green: 0.95, blue: 0.4, alpha: 1)
        for index in 0..<count {
            let bar = UIView()
            bar.backgroundColor = index.isMultiple(of: 2) ? coral : lime
            bar.layer.cornerRadius = barWidth / 2
            bar.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            let originX = CGFloat(index) * (barWidth + gap)
            bar.frame = CGRect(x: originX, y: barsHost.bounds.height - resting, width: barWidth, height: resting)
            barsHost.addSubview(bar)
            bars.append(bar)
        }
        if didStartMotion {
            pulseBars()
        }
    }

    private func startShoreMotion() {
        didStartMotion = true
        spin(outerRing, duration: 2.4, clockwise: true)
        spin(innerRing, duration: 1.8, clockwise: false)
        breatheGlow()
        pulseBars()
    }

    private func stopShoreMotion() {
        didStartMotion = false
        [glow, outerRing, innerRing].forEach { $0.layer.removeAllAnimations() }
        bars.forEach { $0.layer.removeAllAnimations() }
    }

    private func spin(_ view: UIView, duration: CFTimeInterval, clockwise: Bool) {
        guard view.layer.animation(forKey: "shoreSpin") == nil else { return }
        let turn = CABasicAnimation(keyPath: "transform.rotation.z")
        turn.fromValue = 0
        turn.toValue = clockwise ? CGFloat.pi * 2 : -CGFloat.pi * 2
        turn.duration = duration
        turn.repeatCount = .infinity
        turn.isRemovedOnCompletion = false
        view.layer.add(turn, forKey: "shoreSpin")
    }

    private func breatheGlow() {
        guard glow.layer.animation(forKey: "shoreGlow") == nil else { return }
        let glowPulse = CABasicAnimation(keyPath: "opacity")
        glowPulse.fromValue = 1
        glowPulse.toValue = 0.45
        glowPulse.duration = 1.15
        glowPulse.autoreverses = true
        glowPulse.repeatCount = .infinity
        glowPulse.isRemovedOnCompletion = false
        glow.layer.add(glowPulse, forKey: "shoreGlow")
    }

    private func pulseBars() {
        let patterns: [[CGFloat]] = [
            [0.35, 1, 0.5, 0.82],
            [0.9, 0.4, 1, 0.55],
            [0.45, 0.85, 0.32, 1],
            [1, 0.48, 0.78, 0.36],
            [0.55, 1, 0.42, 0.9]
        ]
        for (index, bar) in bars.enumerated() {
            guard bar.layer.animation(forKey: "shoreBar") == nil else { continue }
            let pulse = CAKeyframeAnimation(keyPath: "transform.scale.y")
            pulse.values = patterns[index]
            pulse.keyTimes = [0, 0.33, 0.66, 1]
            pulse.duration = 0.78 + Double(index) * 0.08
            pulse.autoreverses = true
            pulse.repeatCount = .infinity
            pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            pulse.isRemovedOnCompletion = false
            bar.layer.add(pulse, forKey: "shoreBar")
        }
    }
}

private final class ShoreTideRing: UIView {
    private let shape = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = .clear
        layer.addSublayer(shape)
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func paint(color: UIColor, lineWidth: CGFloat, dash: [NSNumber]) {
        shape.strokeColor = color.cgColor
        shape.lineWidth = lineWidth
        shape.lineDashPattern = dash
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shape.frame = bounds
        let inset = shape.lineWidth / 2
        shape.path = UIBezierPath(ovalIn: bounds.insetBy(dx: inset, dy: inset)).cgPath
    }
}
