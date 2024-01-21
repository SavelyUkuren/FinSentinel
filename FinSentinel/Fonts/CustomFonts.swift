//
//  CustomFonts.swift
//  MoneyM
//
//  Created by Air on 06.12.2023.
//

import Foundation
import UIKit

class CustomFonts {

	let roundedFont: (_ size: CGFloat, UIFont.Weight) -> UIFont? = { (size, weight)  in
		var font: UIFont?
		switch weight {
		case .black:
			font = UIFont(name: "SFProRounded-Black", size: size)
		case .bold:
			font = UIFont(name: "SFProRounded-Bold", size: size)
		case .heavy:
			font = UIFont(name: "SFProRounded-Heavy", size: size)
		case .light:
			font = UIFont(name: "SFProRounded-Light", size: size)
		case .medium:
			font = UIFont(name: "SFProRounded-Medium", size: size)
		case .regular:
			font = UIFont(name: "SFProRounded-Regular", size: size)
		case .semibold:
			font = UIFont(name: "SFProRounded-Semibold", size: size)
		case .thin:
			font = UIFont(name: "SFProRounded-Thin", size: size)
		case .ultraLight:
			font = UIFont(name: "SFProRounded-Ultralight", size: size)
		default:
			font = UIFont(name: "SFProRounded-Regular", size: size)
		}
		return font
	}

}
