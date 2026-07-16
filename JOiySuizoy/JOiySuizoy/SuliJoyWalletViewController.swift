import UIKit

final class SuliJoyWalletViewController: SuliJoyBaseIslandViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let balanceLabel = UILabel()
    private let statusLabel = UILabel()
    private let collectionView: UICollectionView
    private var packs: [SuliJoyPearlCoinPack] = SuliJoyPearlCoinPack.localPacks
    private var productsReady = false
    private var purchasingProductID: String?

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 14
        layout.sectionInset = UIEdgeInsets(top: 16, left: 18, bottom: 30, right: 18)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        refreshBalance()
        loadProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBalance()
    }

    private func buildUI() {
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .black
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "My wallet"
        title.font = UIFont.systemFont(ofSize: 30, weight: .black)
        title.textColor = .black
        title.textAlignment = .center

        let hero = UIView()
        hero.translatesAutoresizingMaskIntoConstraints = false
        hero.layer.cornerRadius = 26
        hero.clipsToBounds = true
        let heroGradient = SuliJoyGradientCapsuleView(colors: [
            UIColor(red: 1, green: 0.36, blue: 0.51, alpha: 1),
            UIColor(red: 1, green: 0.67, blue: 0.35, alpha: 1)
        ])
        let gem = UIImageView(image: UIImage(named: "sulijoy_wallet_gem_large"))
        gem.translatesAutoresizingMaskIntoConstraints = false
        gem.contentMode = .scaleAspectFit
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.font = UIFont.systemFont(ofSize: 32, weight: .black)
        balanceLabel.textColor = .white
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.minimumScaleFactor = 0.55
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
//        subtitle.text = "My gold coins"
        subtitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        subtitle.textColor = .white
        hero.addSubview(heroGradient)
        hero.addSubview(gem)
        hero.addSubview(balanceLabel)
        hero.addSubview(subtitle)
        heroGradient.suliPinEdges(to: hero)

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        statusLabel.textColor = .suliMutedInk
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(SuliJoyPearlPackCell.self, forCellWithReuseIdentifier: "SuliJoyPearlPackCell")

        [back, title, hero, statusLabel, collectionView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            title.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 12),

            hero.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 24),
            hero.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            hero.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            hero.heightAnchor.constraint(equalToConstant: 136),
            gem.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 26),
            gem.centerYAnchor.constraint(equalTo: hero.centerYAnchor, constant: -8),
            gem.widthAnchor.constraint(equalTo: hero.heightAnchor, multiplier: 0.72),
            gem.heightAnchor.constraint(equalTo: gem.widthAnchor),
            balanceLabel.leadingAnchor.constraint(equalTo: gem.trailingAnchor, constant: 18),
            balanceLabel.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -22),
            balanceLabel.topAnchor.constraint(equalTo: hero.topAnchor, constant: 50),
            subtitle.leadingAnchor.constraint(equalTo: balanceLabel.leadingAnchor),
            subtitle.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 8),
            subtitle.trailingAnchor.constraint(equalTo: balanceLabel.trailingAnchor),

            statusLabel.topAnchor.constraint(equalTo: hero.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),

            collectionView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func refreshBalance() {
        balanceLabel.text = "\(SuliJoyShellWalletStore.shared.currentBalance())"
    }

    private func loadProducts() {
        statusLabel.text = "Loading StoreKit products..."
        Task { [weak self] in
            let result = await SuliJoyLagoonPurchaseService.shared.fetchPearlCoinPacks()
            guard let self else { return }
            if result.code == 200, let packs = result.data {
                self.productsReady = true
                self.packs = packs
                self.statusLabel.text = ""
            } else {
                self.productsReady = false
                self.packs = SuliJoyPearlCoinPack.localPacks
                self.statusLabel.text = result.message
                self.showToast(result.message)
            }
            self.collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        packs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuliJoyPearlPackCell", for: indexPath) as! SuliJoyPearlPackCell
        let pack = packs[indexPath.item]
        cell.configure(
            pack: pack,
            isEnabled: productsReady && purchasingProductID == nil,
            isLoading: purchasingProductID == pack.storeProductID
        )
        cell.onRecharge = { [weak self] in
            self?.purchase(pack)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let usable = width - 36 - 24
        let itemWidth = floor(usable / 3)
        return CGSize(width: max(92, itemWidth), height: 170)
    }

    private func purchase(_ pack: SuliJoyPearlCoinPack) {
        guard productsReady, purchasingProductID == nil else { return }
        purchasingProductID = pack.storeProductID
        collectionView.reloadData()
        Task { [weak self] in
            let result = await SuliJoyLagoonPurchaseService.shared.purchase(pack: pack)
            guard let self else { return }
            self.purchasingProductID = nil
            switch result.data {
            case .completed:
                self.refreshBalance()
                self.showToast("Recharge completed.")
            case .cancelled:
                self.showToast("Purchase cancelled.")
            case .pending:
                self.showToast("Purchase pending.")
            case .none:
                self.showToast(result.message)
            }
            self.collectionView.reloadData()
        }
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

private final class SuliJoyPearlPackCell: UICollectionViewCell {
    var onRecharge: (() -> Void)?
    private let gemView = UIImageView(image: UIImage(named: "sulijoy_wallet_gem_small"))
    private let amountLabel = UILabel()
    private let priceLabel = UILabel()
    private let rechargeButton = SuliJoyGradientButton(title: "Recharge")

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor(red: 1, green: 0.66, blue: 0.41, alpha: 1).cgColor
        contentView.clipsToBounds = true

        gemView.translatesAutoresizingMaskIntoConstraints = false
        gemView.contentMode = .scaleAspectFit
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        amountLabel.textColor = UIColor(red: 0.21, green: 0.27, blue: 0.02, alpha: 1)
        amountLabel.textAlignment = .center
        amountLabel.adjustsFontSizeToFitWidth = true
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
        priceLabel.textColor = amountLabel.textColor
        priceLabel.textAlignment = .center

        let dash = UIView()
        dash.translatesAutoresizingMaskIntoConstraints = false
        dash.backgroundColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)

        rechargeButton.translatesAutoresizingMaskIntoConstraints = false
        rechargeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        rechargeButton.addTarget(self, action: #selector(recharge), for: .touchUpInside)

        [gemView, amountLabel, dash, priceLabel, rechargeButton].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            gemView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            gemView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            gemView.widthAnchor.constraint(equalToConstant: 24),
            gemView.heightAnchor.constraint(equalToConstant: 24),
            amountLabel.topAnchor.constraint(equalTo: gemView.bottomAnchor, constant: 14),
            amountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dash.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 8),
            dash.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            dash.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            dash.heightAnchor.constraint(equalToConstant: 1),
            priceLabel.topAnchor.constraint(equalTo: dash.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: amountLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: amountLabel.trailingAnchor),
            rechargeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            rechargeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            rechargeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            rechargeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(pack: SuliJoyPearlCoinPack, isEnabled: Bool, isLoading: Bool) {
        amountLabel.text = "\(pack.coinAmount)"
        priceLabel.text = pack.displayPrice
        rechargeButton.isLoading = isLoading
        rechargeButton.isEnabled = isEnabled && !isLoading
        rechargeButton.alpha = isEnabled || isLoading ? 1 : 0.45
    }

    @objc private func recharge() {
        onRecharge?()
    }
}
