//
//  MessagesTableViewController.swift
//  Kujon
//
//  Created by Adam on 25.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class MessagesTableViewController: RefreshingTableViewController, NavigationDelegate, MessageProviderDelegate {

    // MARK: Properties

    private weak var delegate: NavigationMenuProtocol?
    private let messageProvider: MessageProvider = MessageProvider()
    private var messages: [Message] = []
    private let messageCellId: String = "messageCellId"
    private var backgroundImage: UIImageView?
    private var backgroundLabel: UILabel?
    private let cellHeight: CGFloat = 50

    // MARK: Initial section

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDataHolder.sharedInstance.isNotificationPending {
            UserDataHolder.sharedInstance.isNotificationPending = false
        }
        addBackgroundLabel(message: StringHolder.noMessages)
        backgroundLabel?.isHidden = true
        addBackgroundImage(imageName: "mailbox")
        backgroundImage?.isHidden = true
        messageProvider.delegate = self
        addToProvidersList(provider: messageProvider)
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(UserTableViewController.openDrawer), andTitle: StringHolder.messages)
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        messages = []
    }

    private func configureTableView() {
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: messageCellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.greyBackgroundColor()
    }

    override func loadData() {
        messageProvider.loadMessage()
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
            backgroundImage.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
            view.addSubview(backgroundImage)
        }
    }

    private func addBackgroundLabel(message:String) {
        var frame = view.bounds
        frame.origin.y -= 70
        backgroundLabel = UILabel(frame: frame)
        backgroundLabel?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        backgroundLabel!.textAlignment = .center
        backgroundLabel!.attributedText = message.toAttributedStringWithFont(UIFont.kjnFontLatoRegular(size: 17)!, color: UIColor.kujonDarkTextColor())
        view.addSubview(backgroundLabel!)
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
        messages = message
        backgroundLabel?.isHidden = !message.isEmpty
        backgroundImage?.isHidden = !message.isEmpty
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }


    func onErrorOccurs(_ text: String) {
        refreshControl?.endRefreshing()
        presentAlertWithMessage(StringHolder.errorRetrievingMessages, title: StringHolder.errorAlertTitle)

    }

    func onUsosDown() {
        self.refreshControl?.endRefreshing()
        EmptyStateView.showUsosDownAlert(inParent: view)
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
