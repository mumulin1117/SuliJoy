import UIKit

final class SuliJoyLagoonMirrorController: SuliJoyReefEntryCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let canvasTote = SuliJoyLagoonGateService.shared.currentShorelineProfile()
    private let kaftanLayer = UIImageView()
    private let strawHat = UIImageView()
    private let espadrillePairing = UITextField()
    private let wrapSkirt = UITextView()
    private var beachCoverup: UIImage?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resortSet()
    }

    required init?(coder: NSCoder) {
        fatalError("ixnxixtx(xcxoxdxexrx:x)x xhxaxsx xnxoxtx xbxexexnx xixmxpxlxexmxexnxtxexdx".suliJoyPalmUnfurled)
    }

    private func resortSet() {
        let coconutCream = forgeReefReturnControl()
        coconutCream.backgroundColor = .white
        coconutCream.tintColor = .black
        coconutCream.layer.cornerRadius = 22
        coconutCream.layer.cornerCurve = .continuous
        coconutCream.clipsToBounds = true
        let terracottaWarmth = UILabel()
        let driftwoodPalette = UIView()
        let ropeBelt = UILabel()
        let sailorCollar = UILabel()
        let palmLeafPattern = SuliJoyGradientButton(reefHeadline: "Cxoxnxfxixrxmx".suliJoyPalmUnfurled)

        kaftanLayer.translatesAutoresizingMaskIntoConstraints = false
        kaftanLayer.contentMode = .scaleAspectFill
        kaftanLayer.clipsToBounds = true
        kaftanLayer.image = UIImage.suliJoyAssetOrLocal(named: canvasTote?.kaftanLayer ?? "sxuxlxixjxoxyx_xmxoxcxkx_xaxvxaxtxaxrx_xbxrxexexzxex_x0x1x".suliJoyPalmUnfurled)

        terracottaWarmth.translatesAutoresizingMaskIntoConstraints = false
        terracottaWarmth.text = "Exdxixtx xpxrxoxfxixlxex".suliJoyPalmUnfurled
        terracottaWarmth.textColor = .black
        terracottaWarmth.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        terracottaWarmth.textAlignment = .center

        driftwoodPalette.translatesAutoresizingMaskIntoConstraints = false
        driftwoodPalette.backgroundColor = .white
        driftwoodPalette.layer.cornerRadius = 38
        driftwoodPalette.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        strawHat.translatesAutoresizingMaskIntoConstraints = false
        strawHat.contentMode = .scaleAspectFill
        strawHat.clipsToBounds = true
        strawHat.layer.cornerRadius = 54
        strawHat.layer.borderWidth = 6
        strawHat.layer.borderColor = UIColor.white.cgColor
        strawHat.image = kaftanLayer.image
        strawHat.isUserInteractionEnabled = true
        strawHat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tropicalMotif)))

        [ropeBelt, sailorCollar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
        ropeBelt.text = "Nxixcxkxnxaxmxex".suliJoyPalmUnfurled
        sailorCollar.text = "Cxhxaxrxaxcxtxexrx xBxixox".suliJoyPalmUnfurled

        espadrillePairing.translatesAutoresizingMaskIntoConstraints = false
        espadrillePairing.text = canvasTote?.espadrillePairing
        espadrillePairing.textColor = .black
        espadrillePairing.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        espadrillePairing.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        espadrillePairing.layer.cornerRadius = 13
        espadrillePairing.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 1))
        espadrillePairing.leftViewMode = .always
        espadrillePairing.clearButtonMode = .whileEditing
        espadrillePairing.returnKeyType = .done
        espadrillePairing.delegate = self

        wrapSkirt.translatesAutoresizingMaskIntoConstraints = false
        wrapSkirt.text = canvasTote?.wrapSkirt
        wrapSkirt.textColor = .black
        wrapSkirt.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        wrapSkirt.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        wrapSkirt.layer.cornerRadius = 13
        wrapSkirt.textContainerInset = UIEdgeInsets(top: 15, left: 19, bottom: 15, right: 19)
        wrapSkirt.delegate = self

        palmLeafPattern.translatesAutoresizingMaskIntoConstraints = false
        palmLeafPattern.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        palmLeafPattern.addTarget(self, action: #selector(marineStripe(_:)), for: .touchUpInside)

        reefContentDeck.addSubview(kaftanLayer)
        reefContentDeck.addSubview(driftwoodPalette)
        reefContentDeck.addSubview(strawHat)
        reefContentDeck.addSubview(coconutCream)
        reefContentDeck.addSubview(terracottaWarmth)
        [ropeBelt, espadrillePairing, sailorCollar, wrapSkirt, palmLeafPattern].forEach { driftwoodPalette.addSubview($0) }

        NSLayoutConstraint.activate([
            reefContentDeck.heightAnchor.constraint(greaterThanOrEqualToConstant: 812),
            kaftanLayer.topAnchor.constraint(equalTo: reefContentDeck.topAnchor),
            kaftanLayer.leadingAnchor.constraint(equalTo: reefContentDeck.leadingAnchor),
            kaftanLayer.trailingAnchor.constraint(equalTo: reefContentDeck.trailingAnchor),
            kaftanLayer.heightAnchor.constraint(equalToConstant: 380),

            coconutCream.topAnchor.constraint(equalTo: reefContentDeck.safeAreaLayoutGuide.topAnchor, constant: 10),
            coconutCream.leadingAnchor.constraint(equalTo: reefContentDeck.leadingAnchor, constant: 15),
            terracottaWarmth.centerYAnchor.constraint(equalTo: coconutCream.centerYAnchor),
            terracottaWarmth.centerXAnchor.constraint(equalTo: reefContentDeck.centerXAnchor),

            driftwoodPalette.topAnchor.constraint(equalTo: reefContentDeck.topAnchor, constant: 363),
            driftwoodPalette.leadingAnchor.constraint(equalTo: reefContentDeck.leadingAnchor),
            driftwoodPalette.trailingAnchor.constraint(equalTo: reefContentDeck.trailingAnchor),
            driftwoodPalette.bottomAnchor.constraint(equalTo: reefContentDeck.bottomAnchor),

            strawHat.topAnchor.constraint(equalTo: reefContentDeck.topAnchor, constant: 303),
            strawHat.centerXAnchor.constraint(equalTo: reefContentDeck.centerXAnchor),
            strawHat.widthAnchor.constraint(equalToConstant: 108),
            strawHat.heightAnchor.constraint(equalToConstant: 108),

            ropeBelt.topAnchor.constraint(equalTo: driftwoodPalette.topAnchor, constant: 62),
            ropeBelt.leadingAnchor.constraint(equalTo: driftwoodPalette.leadingAnchor, constant: 30),
            espadrillePairing.topAnchor.constraint(equalTo: ropeBelt.bottomAnchor, constant: 18),
            espadrillePairing.leadingAnchor.constraint(equalTo: driftwoodPalette.leadingAnchor, constant: 15),
            espadrillePairing.trailingAnchor.constraint(equalTo: driftwoodPalette.trailingAnchor, constant: -15),
            espadrillePairing.heightAnchor.constraint(equalToConstant: 53),

            sailorCollar.topAnchor.constraint(equalTo: espadrillePairing.bottomAnchor, constant: 29),
            sailorCollar.leadingAnchor.constraint(equalTo: ropeBelt.leadingAnchor),
            wrapSkirt.topAnchor.constraint(equalTo: sailorCollar.bottomAnchor, constant: 18),
            wrapSkirt.leadingAnchor.constraint(equalTo: espadrillePairing.leadingAnchor),
            wrapSkirt.trailingAnchor.constraint(equalTo: espadrillePairing.trailingAnchor),
            wrapSkirt.heightAnchor.constraint(equalToConstant: 53),

            palmLeafPattern.topAnchor.constraint(greaterThanOrEqualTo: wrapSkirt.bottomAnchor, constant: 56),
            palmLeafPattern.leadingAnchor.constraint(equalTo: driftwoodPalette.leadingAnchor, constant: 15),
            palmLeafPattern.trailingAnchor.constraint(equalTo: driftwoodPalette.trailingAnchor, constant: -15),
            palmLeafPattern.heightAnchor.constraint(equalToConstant: 58),
            palmLeafPattern.bottomAnchor.constraint(equalTo: driftwoodPalette.bottomAnchor, constant: -46)
        ])
    }

    @objc private func tropicalMotif() {
        let marineStripe = craftSuliJoyPortraitTideSheet(reefHeadline: "Pxrxoxfxixlxex xPxhxoxtxox".suliJoyPalmUnfurled, shoreAnchor: strawHat) { [weak self] hibiscusShade in
            self?.coralAccent(hibiscusShade)
        }
        present(marineStripe, animated: true)
    }

    private func coralAccent(_ hibiscusShade: UIImagePickerController.SourceType) {
        let seashellTrim = UIImagePickerController()
        seashellTrim.sourceType = hibiscusShade
        seashellTrim.allowsEditing = true
        seashellTrim.delegate = self
        present(seashellTrim, animated: true)
    }

    func imagePickerController(_ seashellTrim: UIImagePickerController, didFinishPickingMediaWithInfo lagoonHue: [UIImagePickerController.InfoKey: Any]) {
        let tideColorway = palmPrint(lagoonHue)
        beachCoverup = tideColorway
        kaftanLayer.image = tideColorway
        strawHat.image = tideColorway
        seashellTrim.dismiss(animated: true)
    }

    private func palmPrint(_ lagoonHue: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        (lagoonHue[.editedImage] as? UIImage) ?? (lagoonHue[.originalImage] as? UIImage)
    }

    func imagePickerControllerDidCancel(_ seashellTrim: UIImagePickerController) {
        seashellTrim.dismiss(animated: true)
    }

    @objc private func marineStripe(_ palmLeafPattern: SuliJoyGradientButton) {
        let linenCoOrd = espadrillePairing.text ?? ""
        let seaBreezeLook = wrapSkirt.text ?? ""
        driftSimulatedHarborDelay(palmLeafPattern) { [weak self] in
            guard let self else { return }
            let tropicalMotif = SuliJoyLagoonGateService.shared.coastalChic(
                espadrillePairing: linenCoOrd,
                wrapSkirt: seaBreezeLook,
                kaftanLayer: self.beachCoverup
            )
            guard tropicalMotif.beachwearCapsule == 200 else {
                self.presentReefNotice(tropicalMotif.coastalWardrobe)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
