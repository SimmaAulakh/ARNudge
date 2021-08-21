/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct NotificationBase : Mappable {
	var lng : String?
	var updated_at : String?
	var product_id : String?
	var discount : String?
	var created_at : String?
	var locations : Locations?
	var _id : String?
	var radius : String?
	var client_id : String?
	var offer_type : String?
	var lat : String?
	var products : Products?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		lng <- map["lng"]
		updated_at <- map["updated_at"]
		product_id <- map["product_id"]
		discount <- map["discount"]
		created_at <- map["created_at"]
		locations <- map["locations"]
		_id <- map["_id"]
		radius <- map["radius"]
		client_id <- map["client_id"]
		offer_type <- map["offer_type"]
		lat <- map["lat"]
		products <- map["products"]
	}

}
