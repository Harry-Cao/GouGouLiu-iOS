//
//  GGLPersonalViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit
import Combine

final class GGLPersonalViewController: GGLBaseViewController {
    override var prefersNavigationBarHidden: Bool { true }

    private let viewModel = GGLPersonalViewModel()
    private var cancellables = Set<AnyCancellable>()
    private lazy var personalTableView: UITableView = {
        let emptyView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: .zero, height: GGLPersonalHeaderView.normalHeight)))
        let tableView = UITableView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = emptyView
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GGLPersonalRowCell.self)
        return tableView
    }()
    private lazy var headerView: GGLPersonalHeaderView = {
        let view = GGLPersonalHeaderView()
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setupUI()
    }

    private func bindData() {
        viewModel.$current
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self else { return }
                headerView.setup(user: user)
            }.store(in: &cancellables)
        viewModel.$settingRows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                personalTableView.reloadData()
            }.store(in: &cancellables)
    }

    private func setupUI() {
        view.addSubview(personalTableView)
        personalTableView.addSubview(headerView)
        personalTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view)
            make.height.equalTo(GGLPersonalHeaderView.normalHeight)
        }
    }
}

// MARK: - UITableViewDataSource
extension GGLPersonalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingRows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = viewModel.settingRows[indexPath.row]
        let cell: GGLPersonalRowCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setup(row: row)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GGLPersonalViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView(scrollView: scrollView)
    }

    private func updateHeaderView(scrollView: UIScrollView) {
        let contentOffsetY = min(0, -scrollView.contentOffset.y)
        let headerHeight = max(GGLPersonalHeaderView.normalHeight, GGLPersonalHeaderView.normalHeight - scrollView.contentOffset.y)
        headerView.snp.updateConstraints { make in
            make.top.equalTo(view).offset(contentOffsetY)
            make.height.equalTo(headerHeight)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = viewModel.settingRows[indexPath.row]
        row.action()
    }
}

// MARK: - GGLPersonalHeaderViewDelegate
extension GGLPersonalViewController: GGLPersonalHeaderViewDelegate {
    func didTapAvatar() {
        viewModel.pickAvatar()
    }
}
