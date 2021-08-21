/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct OffersData : Mappable {
	var _id : String?
	var store_location_id : Int?
	var product_id : Int?
	var discount : String?
	var lat : String?
	var lng : String?
	var coordinates : [String]?
	var radius : Int?
	var created_at : String?
	var updated_at : String?
	var client_details : [String]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		_id <- map["_id"]
		store_location_id <- map["store_location_id"]
		product_id <- map["product_id"]
		discount <- map["discount"]
		lat <- map["lat"]
		lng <- map["lng"]
		coordinates <- map["coordinates"]
		radius <- map["radius"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		client_details <- map["client_details"]
	}

}
