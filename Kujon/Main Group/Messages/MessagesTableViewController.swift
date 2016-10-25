//
//  MessagesTableViewController.swift
//  Kujon
//
//  Created by Adam on 25.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController, NavigationDelegate, MessageProviderDelegate {

    // MARK: Properties

    private weak var delegate: NavigationMenuProtocol?
    private let messageProvider: MessageProvider = MessageProvider()
    private var messages: [Message] = []
    private let messageCellId: String = "messageCellId"
    private var backgroundLabel: UILabel = UILabel()
    private var spinner = SpinnerView()


    // MARK: Initial section

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundLabel(message: StringHolder.noMessages)
        addSpinner()
        messageProvider.delegate = self
        messageProvider.loadMessage()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(UserTableViewController.openDrawer), andTitle: StringHolder.messages)
        configureTableView()
        addRefreshControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        messages = []
    }

    private func configureTableView() {
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: messageCellId)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = UIColor.lightGray
    }

    internal func refresh() {
        messageProvider.loadMessage()
        spinner.isHidden = true
        backgroundLabel.isHidden = true
    }

    private func addBackgroundLabel(message:String) {
        backgroundLabel = UILabel(frame: view.bounds)
        backgroundLabel.textAlignment = .center
        backgroundLabel.attributedText = message.toAttributedStringWithFont(UIFont.kjnFontLatoRegular(size: 17)!, color: UIColor.white)
        backgroundLabel.text = message
        view.addSubview(backgroundLabel)
        backgroundLabel.isHidden = true

    }

    private func addSpinner() {
        let width: CGFloat = 30
        let height: CGFloat = 30
        spinner = SpinnerView(frame: CGRect(origin: CGPoint(x: view.bounds.midX-width/2, y: view.bounds.midY-height/2), size: CGSize(width:width, height:height)))
        view.addSubview(spinner)
    }

    private func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refreshControlUniversalMessage)
        refreshControl?.addTarget(self, action: #selector(MessagesTableViewController.refresh), for: .valueChanged)
    }



    // MARK: Hamburger button

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    // MARK: NavigationDelegate

    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    // MARK: MessageProviderDelegate

    func onMessageLoaded(_ message: Array<Message>) {
        spinner.isHidden = true
        messages = message
        backgroundLabel.isHidden = !message.isEmpty
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    func onErrorOccurs(_ text: String) {
        spinner.isHidden = true
        refreshControl?.endRefreshing()
        presentAlertWithMessage(StringHolder.errorRetrievingMessages, title: StringHolder.errorAlertTitle)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellId, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        return cell
    }


}
