import UIKit

final class SuliJoyShoreBone: UIView {
    private let sheen = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.93, alpha: 1)
        sheen.colors = [
            UIColor(white: 1, alpha: 0).cgColor,
            UIColor(white: 1, alpha: 0.78).cgColor,
            UIColor(white: 1, alpha: 0).cgColor
        ]
        sheen.startPoint = CGPoint(x: 0, y: 0.5)
        sheen.endPoint = CGPoint(x: 1, y: 0.5)
        sheen.locations = [-1, -0.5, 0]
        layer.addSublayer(sheen)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sheen.frame = bounds
        sheen.cornerRadius = layer.cornerRadius
    }

    func startSheen() {
        guard sheen.animation(forKey: "shoreSheen") == nil else { return }
        let slide = CABasicAnimation(keyPath: "locations")
        slide.fromValue = [-1.0, -0.5, 0.0]
        slide.toValue = [1.0, 1.5, 2.0]
        slide.duration = 1.15
        slide.repeatCount = .infinity
        slide.isRemovedOnCompletion = false
        sheen.add(slide, forKey: "shoreSheen")
    }

    func stopSheen() {
        sheen.removeAnimation(forKey: "shoreSheen")
    }
}

final class SuliJoyVoiceBoardSkeleton: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        isHidden = true
        accessibilityLabel = "Loading voice rooms"
        let grid = UIStackView()
        grid.translatesAutoresizingMaskIntoConstraints = false
        grid.axis = .vertical
        grid.spacing = 12
        addSubview(grid)
        NSLayoutConstraint.activate([
            grid.topAnchor.constraint(equalTo: topAnchor),
            grid.leadingAnchor.constraint(equalTo: leadingAnchor),
            grid.trailingAnchor.constraint(equalTo: trailingAnchor),
            grid.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        for _ in 0..<2 {
            let line = UIStackView()
            line.axis = .horizontal
            line.spacing = 12
            line.distribution = .fillEqually
            let leadingCard = SuliJoyVoiceBoneCard()
            let trailingCard = SuliJoyVoiceBoneCard()
            line.addArrangedSubview(leadingCard)
            line.addArrangedSubview(trailingCard)
            grid.addArrangedSubview(line)
            leadingCard.heightAnchor.constraint(equalTo: leadingCard.widthAnchor, multiplier: 1.28).isActive = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setShoreBonesVisible(_ visible: Bool) {
        isHidden = !visible
        walkBones { visible ? $0.startSheen() : $0.stopSheen() }
    }

    private func walkBones(_ apply: (SuliJoyShoreBone) -> Void) {
        func visit(_ view: UIView) {
            if let bone = view as? SuliJoyShoreBone {
                apply(bone)
            }
            view.subviews.forEach(visit)
        }
        visit(self)
    }
}

private final class SuliJoyVoiceBoneCard: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 18
        let cover = SuliJoyShoreBone()
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.layer.cornerRadius = 18
        let host = SuliJoyShoreBone()
        host.translatesAutoresizingMaskIntoConstraints = false
        host.layer.cornerRadius = 13
        host.backgroundColor = UIColor.white.withAlphaComponent(0.55)
        let heat = SuliJoyShoreBone()
        heat.translatesAutoresizingMaskIntoConstraints = false
        heat.layer.cornerRadius = 13
        heat.backgroundColor = UIColor.white.withAlphaComponent(0.55)
        let summary = SuliJoyShoreBone()
        summary.translatesAutoresizingMaskIntoConstraints = false
        summary.layer.cornerRadius = 6
        summary.backgroundColor = UIColor.white.withAlphaComponent(0.55)
        let people = SuliJoyShoreBone()
        people.translatesAutoresizingMaskIntoConstraints = false
        people.layer.cornerRadius = 14
        people.backgroundColor = UIColor.white.withAlphaComponent(0.55)
        [cover, host, heat, people, summary].forEach(addSubview)
        NSLayoutConstraint.activate([
            cover.topAnchor.constraint(equalTo: topAnchor),
            cover.leadingAnchor.constraint(equalTo: leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: trailingAnchor),
            cover.bottomAnchor.constraint(equalTo: bottomAnchor),
            host.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            host.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            host.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.42),
            host.heightAnchor.constraint(equalToConstant: 26),
            heat.topAnchor.constraint(equalTo: host.topAnchor),
            heat.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            heat.widthAnchor.constraint(equalToConstant: 52),
            heat.heightAnchor.constraint(equalToConstant: 26),
            summary.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            summary.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            summary.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            summary.heightAnchor.constraint(equalToConstant: 12),
            people.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            people.bottomAnchor.constraint(equalTo: summary.topAnchor, constant: -8),
            people.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.46),
            people.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SuliJoyLiveBoardSkeleton: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        isHidden = true
        accessibilityLabel = "Loading live rooms"
        let column = UIStackView()
        column.translatesAutoresizingMaskIntoConstraints = false
        column.axis = .vertical
        column.spacing = 12
        addSubview(column)
        NSLayoutConstraint.activate([
            column.topAnchor.constraint(equalTo: topAnchor),
            column.leadingAnchor.constraint(equalTo: leadingAnchor),
            column.trailingAnchor.constraint(equalTo: trailingAnchor),
            column.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        for _ in 0..<4 {
            let row = SuliJoyLiveBoneRow()
            column.addArrangedSubview(row)
            row.heightAnchor.constraint(equalToConstant: 106).isActive = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setShoreBonesVisible(_ visible: Bool) {
        isHidden = !visible
        func visit(_ view: UIView) {
            if let bone = view as? SuliJoyShoreBone {
                visible ? bone.startSheen() : bone.stopSheen()
            }
            view.subviews.forEach(visit)
        }
        visit(self)
    }
}

private final class SuliJoyLiveBoneRow: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 24
        clipsToBounds = true
        let portrait = SuliJoyShoreBone()
        portrait.translatesAutoresizingMaskIntoConstraints = false
        portrait.layer.cornerRadius = 28
        let title = SuliJoyShoreBone()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.layer.cornerRadius = 6
        let subtitle = SuliJoyShoreBone()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.layer.cornerRadius = 5
        let tagA = SuliJoyShoreBone()
        tagA.translatesAutoresizingMaskIntoConstraints = false
        tagA.layer.cornerRadius = 10
        let tagB = SuliJoyShoreBone()
        tagB.translatesAutoresizingMaskIntoConstraints = false
        tagB.layer.cornerRadius = 10
        [portrait, title, subtitle, tagA, tagB].forEach(addSubview)
        NSLayoutConstraint.activate([
            portrait.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            portrait.centerYAnchor.constraint(equalTo: centerYAnchor),
            portrait.widthAnchor.constraint(equalToConstant: 56),
            portrait.heightAnchor.constraint(equalToConstant: 56),
            title.leadingAnchor.constraint(equalTo: portrait.trailingAnchor, constant: 12),
            title.topAnchor.constraint(equalTo: portrait.topAnchor, constant: 4),
            title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.42),
            title.heightAnchor.constraint(equalToConstant: 14),
            subtitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            subtitle.widthAnchor.constraint(equalTo: title.widthAnchor, multiplier: 0.72),
            subtitle.heightAnchor.constraint(equalToConstant: 12),
            tagA.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            tagA.bottomAnchor.constraint(equalTo: portrait.bottomAnchor, constant: -2),
            tagA.widthAnchor.constraint(equalToConstant: 64),
            tagA.heightAnchor.constraint(equalToConstant: 20),
            tagB.leadingAnchor.constraint(equalTo: tagA.trailingAnchor, constant: 6),
            tagB.centerYAnchor.constraint(equalTo: tagA.centerYAnchor),
            tagB.widthAnchor.constraint(equalToConstant: 48),
            tagB.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
