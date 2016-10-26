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
    private var backgroundImage: UIImageView?
    private var backgroundLabel: UILabel = UILabel()
    private var spinner = SpinnerView()
    private let cellHeight: CGFloat = 50

    // MARK: Initial section

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundLabel(message: StringHolder.noMessages)
        backgroundLabel.isHidden = true
        addBackgroundImage(imageName: "mailbox")
        backgroundImage?.isHidden = true
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
        tableView.backgroundColor = UIColor.lightGray()
    }

    internal func refresh() {
        messageProvider.loadMessage()
        spinner.isHidden = true
        backgroundLabel.isHidden = true
        backgroundImage?.isHidden = true
    }

    private func addBackgroundImage(imageName:String) {
        let image = UIImage(named: imageName)
        backgroundImage = UIImageView(image: image)
        if let backgroundImage = backgroundImage {
            var frame = backgroundImage.frame
            let originX = view.bounds.midX - backgroundImage.frame.width/2
            let originY = view.bounds.midY - backgroundImage.frame.height/2 - 150
            frame.origin = CGPoint(x: originX, y: originY)
            backgroundImage.frame = frame
            view.addSubview(backgroundImage)
        }
    }

    private func addBackgroundLabel(message:String) {
        var frame = view.bounds
        frame.origin.y -= 70
        backgroundLabel = UILabel(frame: frame)
        backgroundLabel.textAlignment = .center
        backgroundLabel.attributedText = message.toAttributedStringWithFont(UIFont.kjnFontLatoRegular(size: 17)!, color: UIColor.kujonDarkTextColor())
        view.addSubview(backgroundLabel)
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
        backgroundImage?.isHidden = backgroundLabel.isHidden
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    //TODO: delete (only for UI testing purposes)
/*
    func onMessageLoaded(_ message: Array<Message>) {
        spinner.isHidden = true
        messages = message
        messages.append(Message(createdTime: "2016-10-18 23:01:11", from: "John Johnson", message: "This is some message. This is some message. This is some message. This is some message. This is some message. This is some message. This is some message. This is some message. This is some message. This is some message. This is some message. This is some message. This is some message. This is some message.", type: "email"))
        messages.append(Message(createdTime: "2015-12-03 23:01:11", from: "Jane Johnson", message: "This is some message. This is some message. This is some message. This is some message. This is some message. This is some message.", type: "email"))
        backgroundLabel.isHidden = !messages.isEmpty
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
 */

    func onErrorOccurs(_ text: String) {
        spinner.isHidden = true
        refreshControl?.endRefreshing()
        presentAlertWithMessage(StringHolder.errorRetrievingMessages, title: StringHolder.errorAlertTitle)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellId, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageDetailController = MessageDetailViewController(nibName: "MessageDetailViewController", bundle: nil)
        messageDetailController.message = messages[indexPath.row]
        navigationController?.pushViewController(messageDetailController, animated: true)

    }


}
