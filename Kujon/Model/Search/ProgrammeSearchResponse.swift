//
// Created by Wojciech Maciejewski on 06/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct ProgrammeSearchResponse{
    let data: ProgrammeSearchData

}

extension ProgrammeSearchResponse: Decodable, GetListOfSearchElements {
    static func decode(_ j: Any) throws -> ProgrammeSearchResponse {
        return try ProgrammeSearchResponse(
                data: j => "data"
                )
    }

    func getList() -> Array<SearchElementProtocol> {
        let data = self.data;
        var array:Array<SearchElementProtocol>  = Array()
        for userSearch in data.items{
            array.append(userSearch)
        }
        return array;


    }

    func isThereNext() -> Bool {
        return self.data.nextPage
    }

}


struct ProgrammeSearchData: Decodable {

    let items: Array<ProgrammeSearch>
    let nextPage: Bool
    static func decode(_ j: Any) throws -> ProgrammeSearchData {
        return try ProgrammeSearchData(
                items: j => "items",
                nextPage: j => "next_page"
                )
    }
}


struct ProgrammeSearch: Decodable, SearchElementProtocol{
    let match : String
    let programme: Programme

    static func decode(_ json: Any) throws -> ProgrammeSearch {
        return try ProgrammeSearch(match: json => "match", programme: json => "programme")
    }

    func getTitle() -> String {
        return self.match
    }

    func reactOnClick(_ mainController: UINavigationController) {
        let popController = KierunkiViewController(nibName: "KierunkiViewController", bundle: Bundle.main)
        popController.modalPresentationStyle = .overCurrentContext
        mainController.present(popController, animated: false, completion: { popController.showAnimate(); })
        popController.showInView(withProgramme: self.programme)
    }
}

