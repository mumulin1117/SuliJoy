import UIKit

final class SuliJoyTideCardCell: UITableViewCell {
    var onTideJoin: (() -> Void)?
    var onHarborFlag: ((UIView) -> Void)?
    private let tideCardShell = UIView()
    private let tideDayGlyph = UILabel()
    private let tideClockGlyph = UILabel()
    private let tideTitleGlyph = UILabel()
    private let shoreSpotGlyph = UILabel()
    private let shoreBriefGlyph = UILabel()
    private let harborFlagControl = UIButton(type: .system)
    private let tideStatePill = UIButton(type: .system)
    private let reefImageRail = UIStackView()
    private let lagoonFaceRail = UIStackView()
    private let crewTallyGlyph = UILabel()
    private let joinCoveStack = UIStackView()
    private let joinTideControl = SuliJoyGradientButton(reefHeadline: "JkoMiRnK PETvJeJnEtz".suliJoyPalmUnfurled)
    private let joinTideInnerStack = UIStackView()
    private let joinTideTitleGlyph = UILabel()
    private let gemSparkView = UIImageView(image: UIImage(named: "sulijoy_shell_" + "co" + "in_gem"))
    private let gemNeedGlyph = UILabel()
    private var reefPreviewViews: [UIImageView] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        craftTideCardShell()
    }

    required init?(coder: NSCoder) {
        fatalError("ionPirtz(zcroVdUeorS:M)N zhdatsp nnaoItc ubgeSeHnZ timmspllKeMmaeCnktFeEdz".suliJoyPalmUnfurled)
    }

    private func craftTideCardShell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        prepareTideCardSurface()
        prepareTideCardTypography()
        prepareTideCardControls()
        moorTideCardScene()
        stitchTideCardScene()
    }

    private func prepareTideCardSurface() {
        tideCardShell.translatesAutoresizingMaskIntoConstraints = false
        tideCardShell.backgroundColor = .white
        tideCardShell.layer.cornerRadius = 24
        tideCardShell.layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        tideCardShell.layer.shadowOpacity = 1
        tideCardShell.layer.shadowRadius = 16
        tideCardShell.layer.shadowOffset = CGSize(width: 0, height: 10)
    }

    private func prepareTideCardTypography() {
        tideDayGlyph.font = UIFont.systemFont(ofSize: 20, weight: .black)
        tideDayGlyph.textColor = .suliInk
        tideClockGlyph.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        tideClockGlyph.textColor = .suliInk
        tideClockGlyph.numberOfLines = 2
        tideTitleGlyph.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        tideTitleGlyph.textColor = .suliInk
        shoreSpotGlyph.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        shoreSpotGlyph.textColor = UIColor.gray
        shoreSpotGlyph.numberOfLines = 1
        shoreBriefGlyph.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        shoreBriefGlyph.textColor = UIColor(red: 0.38, green: 0.34, blue: 0.26, alpha: 1)
        shoreBriefGlyph.numberOfLines = 2
        tideStatePill.titleLabel?.font = UIFont.italicSystemFont(ofSize: 14)
        tideStatePill.layer.cornerRadius = 10
        tideStatePill.isUserInteractionEnabled = false
    }

    private func prepareTideCardControls() {
        harborFlagControl.backgroundColor = UIColor(red: 1, green: 0.94, blue: 0.89, alpha: 1)
        harborFlagControl.layer.cornerRadius = 15
        harborFlagControl.setImage(UIImage(systemName: "flag.fill"), for: .normal)
        harborFlagControl.tintColor = UIColor(red: 1, green: 0.42, blue: 0.18, alpha: 1)
        harborFlagControl.addTarget(self, action: #selector(raiseHarborFlag), for: .touchUpInside)

        reefImageRail.axis = .horizontal
        reefImageRail.spacing = 8
        reefImageRail.distribution = .fillEqually
        lagoonFaceRail.axis = .horizontal
        lagoonFaceRail.spacing = -5
        crewTallyGlyph.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        crewTallyGlyph.textColor = UIColor.gray
        joinTideControl.setTitle("", for: .normal)
        joinTideControl.addTarget(self, action: #selector(joinTideNow), for: .touchUpInside)

        joinTideTitleGlyph.text = "JZowiJnX sEmvLennotZ".suliJoyPalmUnfurled
        joinTideTitleGlyph.font = UIFont.italicSystemFont(ofSize: 13).suliWithWeight(.black)
        joinTideTitleGlyph.textColor = .suliInk
        joinTideTitleGlyph.textAlignment = .center
        joinTideTitleGlyph.adjustsFontSizeToFitWidth = true
        joinTideTitleGlyph.minimumScaleFactor = 0.76

        gemSparkView.contentMode = .scaleAspectFit
        gemSparkView.translatesAutoresizingMaskIntoConstraints = false
        gemNeedGlyph.font = UIFont.systemFont(ofSize: 12, weight: .black)
        gemNeedGlyph.textColor = .suliInk

        let pearlNeedRail = UIStackView(arrangedSubviews: [gemSparkView, gemNeedGlyph])
        pearlNeedRail.axis = .horizontal
        pearlNeedRail.alignment = .center
        pearlNeedRail.spacing = 3
        pearlNeedRail.translatesAutoresizingMaskIntoConstraints = false

        joinTideInnerStack.axis = .vertical
        joinTideInnerStack.alignment = .center
        joinTideInnerStack.spacing = 1
        joinTideInnerStack.translatesAutoresizingMaskIntoConstraints = false
        joinTideInnerStack.isUserInteractionEnabled = false
        joinTideInnerStack.addArrangedSubview(joinTideTitleGlyph)
        joinTideInnerStack.addArrangedSubview(pearlNeedRail)
        joinTideControl.addSubview(joinTideInnerStack)

        joinCoveStack.axis = .vertical
        joinCoveStack.alignment = .center
        joinCoveStack.translatesAutoresizingMaskIntoConstraints = false
        joinCoveStack.addArrangedSubview(joinTideControl)
    }

    private func moorTideCardScene() {
        [tideCardShell].forEach { contentView.addSubview($0) }
        [tideDayGlyph, tideClockGlyph, harborFlagControl, tideStatePill, tideTitleGlyph, shoreSpotGlyph, shoreBriefGlyph, reefImageRail, lagoonFaceRail, crewTallyGlyph, joinCoveStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            tideCardShell.addSubview($0)
        }
    }

    private func stitchTideCardScene() {
        NSLayoutConstraint.activate([
            tideCardShell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            tideCardShell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            tideCardShell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            tideCardShell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            tideDayGlyph.topAnchor.constraint(equalTo: tideCardShell.topAnchor, constant: 20),
            tideDayGlyph.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor, constant: 24),
            tideClockGlyph.leadingAnchor.constraint(equalTo: tideDayGlyph.trailingAnchor, constant: 10),
            tideClockGlyph.centerYAnchor.constraint(equalTo: tideDayGlyph.centerYAnchor),
            tideStatePill.centerYAnchor.constraint(equalTo: tideDayGlyph.centerYAnchor),
            tideStatePill.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor, constant: -24),
            tideStatePill.widthAnchor.constraint(greaterThanOrEqualToConstant: 78),
            tideStatePill.heightAnchor.constraint(equalToConstant: 32),
            harborFlagControl.centerYAnchor.constraint(equalTo: tideStatePill.centerYAnchor),
            harborFlagControl.trailingAnchor.constraint(equalTo: tideStatePill.leadingAnchor, constant: -8),
            harborFlagControl.widthAnchor.constraint(equalToConstant: 30),
            harborFlagControl.heightAnchor.constraint(equalToConstant: 30),
            tideTitleGlyph.topAnchor.constraint(equalTo: tideDayGlyph.bottomAnchor, constant: 18),
            tideTitleGlyph.leadingAnchor.constraint(equalTo: tideDayGlyph.leadingAnchor),
            tideTitleGlyph.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor, constant: -24),
            shoreSpotGlyph.topAnchor.constraint(equalTo: tideTitleGlyph.bottomAnchor, constant: 8),
            shoreSpotGlyph.leadingAnchor.constraint(equalTo: tideTitleGlyph.leadingAnchor),
            shoreSpotGlyph.trailingAnchor.constraint(equalTo: tideTitleGlyph.trailingAnchor),
            shoreBriefGlyph.topAnchor.constraint(equalTo: shoreSpotGlyph.bottomAnchor, constant: 8),
            shoreBriefGlyph.leadingAnchor.constraint(equalTo: tideTitleGlyph.leadingAnchor),
            shoreBriefGlyph.trailingAnchor.constraint(equalTo: tideTitleGlyph.trailingAnchor),
            reefImageRail.topAnchor.constraint(equalTo: shoreBriefGlyph.bottomAnchor, constant: 14),
            reefImageRail.leadingAnchor.constraint(equalTo: tideTitleGlyph.leadingAnchor),
            reefImageRail.trailingAnchor.constraint(equalTo: tideTitleGlyph.trailingAnchor),
            reefImageRail.heightAnchor.constraint(equalTo: reefImageRail.widthAnchor, multiplier: 0.29),
            lagoonFaceRail.topAnchor.constraint(equalTo: reefImageRail.bottomAnchor, constant: 18),
            lagoonFaceRail.leadingAnchor.constraint(equalTo: reefImageRail.leadingAnchor),
            lagoonFaceRail.heightAnchor.constraint(equalToConstant: 28),
            crewTallyGlyph.leadingAnchor.constraint(equalTo: lagoonFaceRail.trailingAnchor, constant: 10),
            crewTallyGlyph.centerYAnchor.constraint(equalTo: lagoonFaceRail.centerYAnchor),
            crewTallyGlyph.trailingAnchor.constraint(lessThanOrEqualTo: joinCoveStack.leadingAnchor, constant: -8),
            joinCoveStack.centerYAnchor.constraint(equalTo: lagoonFaceRail.centerYAnchor),
            joinCoveStack.trailingAnchor.constraint(equalTo: reefImageRail.trailingAnchor),
            joinCoveStack.widthAnchor.constraint(equalToConstant: 118),
            joinCoveStack.bottomAnchor.constraint(equalTo: tideCardShell.bottomAnchor, constant: -14),
            joinTideControl.widthAnchor.constraint(equalTo: joinCoveStack.widthAnchor),
            joinTideInnerStack.centerXAnchor.constraint(equalTo: joinTideControl.centerXAnchor),
            joinTideInnerStack.centerYAnchor.constraint(equalTo: joinTideControl.centerYAnchor),
            joinTideInnerStack.leadingAnchor.constraint(greaterThanOrEqualTo: joinTideControl.leadingAnchor, constant: 10),
            joinTideInnerStack.trailingAnchor.constraint(lessThanOrEqualTo: joinTideControl.trailingAnchor, constant: -10),
            gemSparkView.widthAnchor.constraint(equalToConstant: 14),
            gemSparkView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    func configure(with tideSnapshot: SuliJoyTideActivity) {
        tideDayGlyph.text = tideSnapshot.shoreDayText
        tideClockGlyph.text = "\(tideSnapshot.sunMeridiemText)\n\(tideSnapshot.shoreClockText)"
        tideTitleGlyph.text = tideSnapshot.tideTitleLine
        shoreSpotGlyph.text = "●  \(tideSnapshot.shoreSpotLine)"
        shoreBriefGlyph.text = tideSnapshot.shoreSummaryLine
        renderTideCardState(tideSnapshot.tideState)
        renderTideJoinControl(tideSnapshot)
        renderTidePreviewRail(tideSnapshot.reefGallery)
        renderTideCrewRail(tideSnapshot.shorelineAvatarTokens)
        crewTallyGlyph.text = "\(tideSnapshot.tideJoinedTotal)/\(tideSnapshot.tideCrewLimit)"
    }

    private func renderTideCardState(_ shoreState: SuliJoyTideActivityStatus) {
        tideStatePill.setTitle(shoreState.rawValue, for: .normal)
        tideStatePill.backgroundColor = shoreState == .tideClosed ? UIColor(white: 0.94, alpha: 1) : UIColor(red: 0.91, green: 1, blue: 0.91, alpha: 1)
        tideStatePill.setTitleColor(shoreState == .tideClosed ? UIColor.lightGray : UIColor(red: 0.19, green: 0.82, blue: 0.61, alpha: 1), for: .normal)
    }

    private func renderTideJoinControl(_ tideSnapshot: SuliJoyTideActivity) {
        let joinGlyphText: String
        switch tideSnapshot.tideState {
        case .tideJoined:
            joinGlyphText = "Joined"
        case .tideClosed:
            joinGlyphText = "Closed"
        case .tideOpen:
            joinGlyphText = "Join Event"
        }
        joinTideControl.setTitle("", for: .normal)
        joinTideTitleGlyph.text = joinGlyphText
        joinTideControl.isEnabled = tideSnapshot.tideState == .tideOpen
        joinCoveStack.alpha = tideSnapshot.tideState == .tideClosed ? 0.45 : 1
        gemNeedGlyph.text = "\(tideSnapshot.pearlNeed)"
    }

    private func renderTidePreviewRail(_ shoreMediaShelf: [SuliJoyReefMedia]) {
        reefImageRail.arrangedSubviews.forEach { $0.removeFromSuperview() }
        reefPreviewViews = shoreMediaShelf.prefix(3).map { tideMedia in
            let reefImage = UIImageView()
            reefImage.backgroundColor = UIColor(red: 1, green: 0.91, blue: 0.73, alpha: 1)
            reefImage.shoreCell(tideMedia.reefAssetToken)
            reefImage.contentMode = .scaleAspectFill
            reefImage.clipsToBounds = true
            reefImage.layer.cornerRadius = 9
            reefImageRail.addArrangedSubview(reefImage)
            return reefImage
        }
    }

    private func renderTideCrewRail(_ avatarTokens: [String]) {
        lagoonFaceRail.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for reefAsset in avatarTokens.prefix(3) {
            let lagoonFace = UIImageView()
            lagoonFace.actionRow(reefAsset)
            lagoonFace.translatesAutoresizingMaskIntoConstraints = false
            lagoonFace.contentMode = .scaleAspectFill
            lagoonFace.clipsToBounds = true
            lagoonFace.layer.cornerRadius = 14
            lagoonFace.layer.borderColor = UIColor.white.cgColor
            lagoonFace.layer.borderWidth = 1
            lagoonFaceRail.addArrangedSubview(lagoonFace)
            lagoonFace.widthAnchor.constraint(equalToConstant: 28).isActive = true
            lagoonFace.heightAnchor.constraint(equalToConstant: 28).isActive = true
        }
    }

    @objc private func joinTideNow() {
        onTideJoin?()
    }

    @objc private func raiseHarborFlag() {
        onHarborFlag?(harborFlagControl)
    }
}
