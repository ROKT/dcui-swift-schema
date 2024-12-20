//  Copyright 2020 Rokt Pte Ltd
//
//  Licensed under the Rokt Software Development Kit (SDK) Terms of Use
//  Version 2.0 (the "License");
//
//  You may not use this file except in compliance with the License.
//
//  You may obtain a copy of the License at https://rokt.com/sdk-license-2-0/

import Foundation

public struct RootSchemaModel<Layout: Codable, Display: Codable, Settings: Codable>: Codable {
	public let breakpoints: [String: Float]
	public let layout: Layout
	public let settings: Settings?
	public let display: Display?

	public init(breakpoints: [String: Float], layout: Layout, settings: Settings?, display: Display?) {
		self.breakpoints = breakpoints
		self.layout = layout
		self.settings = settings
		self.display = display
	}
}

public struct FadeInOutTransitionSettings: Codable, Hashable {
	public let duration: Int32

	public init(duration: Int32) {
		self.duration = duration
	}
}

public struct FadeInTransitionSettings: Codable, Hashable {
	public let duration: Int32

	public init(duration: Int32) {
		self.duration = duration
	}
}

public struct FadeOutTransitionSettings: Codable, Hashable {
	public let duration: Int32

	public init(duration: Int32) {
		self.duration = duration
	}
}

public enum OrderableWhenCondition: String, Codable, Hashable {
	case `is`
	case isNot = "is-not"
	case isBelow = "is-below"
	case isAbove = "is-above"
}

public struct BreakpointPredicate: Codable, Hashable {
	public let condition: OrderableWhenCondition
	public let value: String

	public init(condition: OrderableWhenCondition, value: String) {
		self.condition = condition
		self.value = value
	}
}

public struct PositionPredicate: Codable, Hashable {
	public let condition: OrderableWhenCondition
	public let value: String

	public init(condition: OrderableWhenCondition, value: String) {
		self.condition = condition
		self.value = value
	}
}

public struct ProgressionPredicate: Codable, Hashable {
	public let condition: OrderableWhenCondition
	public let value: String

	public init(condition: OrderableWhenCondition, value: String) {
		self.condition = condition
		self.value = value
	}
}

public enum EqualityWhenCondition: String, Codable, Hashable {
	case `is`
	case isNot = "is-not"
}

public struct DarkModePredicate: Codable, Hashable {
	public let condition: EqualityWhenCondition
	public let value: Bool

	public init(condition: EqualityWhenCondition, value: Bool) {
		self.condition = condition
		self.value = value
	}
}

public enum ExistenceWhenCondition: String, Codable, Hashable {
	case exists
	case notExists = "not-exists"
}

public struct CreativeCopyPredicate: Codable, Hashable {
	public let condition: ExistenceWhenCondition
	public let value: String

	public init(condition: ExistenceWhenCondition, value: String) {
		self.condition = condition
		self.value = value
	}
}

public enum BooleanWhenCondition: String, Codable, Hashable {
	case isTrue = "is-true"
	case isFalse = "is-false"
}

public struct StaticBooleanPredicate: Codable, Hashable {
	public let condition: BooleanWhenCondition
	public let value: Bool

	public init(condition: BooleanWhenCondition, value: Bool) {
		self.condition = condition
		self.value = value
	}
}

public struct CustomStatePredicate: Codable, Hashable {
	public let key: String
	public let condition: OrderableWhenCondition
	public let value: Int32

	public init(key: String, condition: OrderableWhenCondition, value: Int32) {
		self.key = key
		self.condition = condition
		self.value = value
	}
}

public enum DomainStateKey: String, Codable, Hashable {
	case offerComplete
}

public struct DomainStatePredicate<DomainStateKey: Codable>: Codable {
	public let key: DomainStateKey
	public let condition: OrderableWhenCondition
	public let value: Int32

	public init(key: DomainStateKey, condition: OrderableWhenCondition, value: Int32) {
		self.key = key
		self.condition = condition
		self.value = value
	}
}

public struct LayoutSchemaDomainStatePredicate: Codable, Hashable {
	public let key: DomainStateKey
	public let condition: OrderableWhenCondition
	public let value: Int32

	public init(key: DomainStateKey, condition: OrderableWhenCondition, value: Int32) {
		self.key = key
		self.condition = condition
		self.value = value
	}
}

public struct StaticStringPredicate: Codable, Hashable {
	public let input: String
	public let condition: EqualityWhenCondition
	public let value: String

	public init(input: String, condition: EqualityWhenCondition, value: String) {
		self.input = input
		self.condition = condition
		self.value = value
	}
}

public struct LayoutSettings: Codable, Hashable {
	public let closeOnComplete: Bool?

	public init(closeOnComplete: Bool?) {
		self.closeOnComplete = closeOnComplete
	}
}

public struct AccessibilityGroupedModel<T: Codable>: Codable {
	public let child: T

	public init(child: T) {
		self.child = child
	}
}

public enum DimensionWidthValue: Codable, Hashable {
	case fixed(Float)
	case percentage(Float)
	case fit(DimensionWidthFitValue)

	enum CodingKeys: String, CodingKey, Codable {
		case fixed,
			percentage,
			fit
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .fixed:
				if let content = try? container.decode(Float.self, forKey: .value) {
					self = .fixed(content)
					return
				}
			case .percentage:
				if let content = try? container.decode(Float.self, forKey: .value) {
					self = .percentage(content)
					return
				}
			case .fit:
				if let content = try? container.decode(DimensionWidthFitValue.self, forKey: .value) {
					self = .fit(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(DimensionWidthValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DimensionWidthValue"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .fixed(let content):
			try container.encode(CodingKeys.fixed, forKey: .type)
			try container.encode(content, forKey: .value)
		case .percentage(let content):
			try container.encode(CodingKeys.percentage, forKey: .type)
			try container.encode(content, forKey: .value)
		case .fit(let content):
			try container.encode(CodingKeys.fit, forKey: .type)
			try container.encode(content, forKey: .value)
		}
	}
}

public enum DimensionHeightValue: Codable, Hashable {
	case fixed(Float)
	case percentage(Float)
	case fit(DimensionHeightFitValue)

	enum CodingKeys: String, CodingKey, Codable {
		case fixed,
			percentage,
			fit
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .fixed:
				if let content = try? container.decode(Float.self, forKey: .value) {
					self = .fixed(content)
					return
				}
			case .percentage:
				if let content = try? container.decode(Float.self, forKey: .value) {
					self = .percentage(content)
					return
				}
			case .fit:
				if let content = try? container.decode(DimensionHeightFitValue.self, forKey: .value) {
					self = .fit(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(DimensionHeightValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DimensionHeightValue"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .fixed(let content):
			try container.encode(CodingKeys.fixed, forKey: .type)
			try container.encode(content, forKey: .value)
		case .percentage(let content):
			try container.encode(CodingKeys.percentage, forKey: .type)
			try container.encode(content, forKey: .value)
		case .fit(let content):
			try container.encode(CodingKeys.fit, forKey: .type)
			try container.encode(content, forKey: .value)
		}
	}
}

public struct DimensionStylingProperties: Codable, Hashable {
	public let minWidth: Float?
	public let maxWidth: Float?
	public let width: DimensionWidthValue?
	public let minHeight: Float?
	public let maxHeight: Float?
	public let height: DimensionHeightValue?
	public let rotateZ: Float?

	public init(minWidth: Float?, maxWidth: Float?, width: DimensionWidthValue?, minHeight: Float?, maxHeight: Float?, height: DimensionHeightValue?, rotateZ: Float?) {
		self.minWidth = minWidth
		self.maxWidth = maxWidth
		self.width = width
		self.minHeight = minHeight
		self.maxHeight = maxHeight
		self.height = height
		self.rotateZ = rotateZ
	}
}

public enum FlexAlignment: String, Codable, Hashable {
	case center
	case flexStart = "flex-start"
	case flexEnd = "flex-end"
	case stretch
}

public struct FlexChildStylingProperties: Codable, Hashable {
	public let weight: Float?
	public let order: Int32?
	public let alignSelf: FlexAlignment?

	public init(weight: Float?, order: Int32?, alignSelf: FlexAlignment?) {
		self.weight = weight
		self.order = order
		self.alignSelf = alignSelf
	}
}

public struct SpacingStylingProperties: Codable, Hashable {
	public let padding: String?
	public let margin: String?
	public let offset: String?

	public init(padding: String?, margin: String?, offset: String?) {
		self.padding = padding
		self.margin = margin
		self.offset = offset
	}
}

public struct ThemeColor: Codable, Hashable {
	public let light: String
	public let dark: String?

	public init(light: String, dark: String?) {
		self.light = light
		self.dark = dark
	}
}

public struct ThemeUrl: Codable, Hashable {
	public let light: String
	public let dark: String?

	public init(light: String, dark: String?) {
		self.light = light
		self.dark = dark
	}
}

public enum BackgroundImagePosition: String, Codable {
	case top
	case right
	case bottom
	case left
	case center
	case topRight = "top-right"
	case topLeft = "top-left"
	case bottomLeft = "bottom-left"
	case bottomRight = "bottom-right"
}

public enum BackgroundImageScale: String, Codable {
	case crop
	case fit
	case fill
}

public struct BackgroundImage: Codable, Hashable {
	public let url: ThemeUrl
	public let position: BackgroundImagePosition?
	public let scale: BackgroundImageScale?

	public init(url: ThemeUrl, position: BackgroundImagePosition?, scale: BackgroundImageScale?) {
		self.url = url
		self.position = position
		self.scale = scale
	}
}

public struct BackgroundStylingProperties: Codable, Hashable {
	public let backgroundColor: ThemeColor?
	public let backgroundImage: BackgroundImage?

	public init(backgroundColor: ThemeColor?, backgroundImage: BackgroundImage?) {
		self.backgroundColor = backgroundColor
		self.backgroundImage = backgroundImage
	}
}

public enum FontWeight: String, Codable {
	case w100 = "100"
	case w200 = "200"
	case w300 = "300"
	case w400 = "400"
	case w500 = "500"
	case w600 = "600"
	case w700 = "700"
	case w800 = "800"
	case w900 = "900"
}

public enum FontJustification: String, Codable {
	case left
	case right
	case center
	case start
	case end
	case justify
}

public enum FontBaselineAlignment: String, Codable {
	case `super`
	case sub
	case baseline
}

public enum FontStyle: String, Codable {
	case normal
	case italic
}

public enum TextTransform: String, Codable {
	case capitalize
	case uppercase
	case lowercase
	case none
}

public enum TextDecoration: String, Codable {
	case underline
	case strikeThrough = "strike-through"
	case none
}

public struct TextStylingProperties: Codable, Hashable {
	public let textColor: ThemeColor?
	public let fontSize: Float?
	public let fontFamily: String?
	public let fontWeight: FontWeight?
	public let lineHeight: Float?
	public let horizontalTextAlign: FontJustification?
	public let baselineTextAlign: FontBaselineAlignment?
	public let fontStyle: FontStyle?
	public let textTransform: TextTransform?
	public let letterSpacing: Float?
	public let textDecoration: TextDecoration?
	public let lineLimit: Int32?

	public init(textColor: ThemeColor?, fontSize: Float?, fontFamily: String?, fontWeight: FontWeight?, lineHeight: Float?, horizontalTextAlign: FontJustification?, baselineTextAlign: FontBaselineAlignment?, fontStyle: FontStyle?, textTransform: TextTransform?, letterSpacing: Float?, textDecoration: TextDecoration?, lineLimit: Int32?) {
		self.textColor = textColor
		self.fontSize = fontSize
		self.fontFamily = fontFamily
		self.fontWeight = fontWeight
		self.lineHeight = lineHeight
		self.horizontalTextAlign = horizontalTextAlign
		self.baselineTextAlign = baselineTextAlign
		self.fontStyle = fontStyle
		self.textTransform = textTransform
		self.letterSpacing = letterSpacing
		self.textDecoration = textDecoration
		self.lineLimit = lineLimit
	}
}

public struct BasicTextStyle: Codable, Hashable {
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?
	public let background: BackgroundStylingProperties?
	public let text: TextStylingProperties?

	public init(dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?, background: BackgroundStylingProperties?, text: TextStylingProperties?) {
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
		self.background = background
		self.text = text
	}
}

public struct BasicStateStylingBlock<T: Codable>: Codable {
	public let `default`: T
	public let pressed: T?
	public let hovered: T?
	public let disabled: T?

	public init(default: T, pressed: T?, hovered: T?, disabled: T?) {
		self.default = `default`
		self.pressed = pressed
		self.hovered = hovered
		self.disabled = disabled
	}
}

public struct BasicTextElements: Codable {
	public let own: [BasicStateStylingBlock<BasicTextStyle>]

	public init(own: [BasicStateStylingBlock<BasicTextStyle>]) {
		self.own = own
	}
}

public struct BasicTextTransitions: Codable, Hashable {
	public let own: BasicTextStyle?

	public init(own: BasicTextStyle?) {
		self.own = own
	}
}

public struct LayoutStyle<ElementsStyles: Codable, ConditionalTransitionsStyles: Codable>: Codable {
	public let elements: ElementsStyles?
	public let conditionalTransitions: ConditionalTransitionsStyles?

	public init(elements: ElementsStyles?, conditionalTransitions: ConditionalTransitionsStyles?) {
		self.elements = elements
		self.conditionalTransitions = conditionalTransitions
	}
}

public struct ConditionalStyleTransition<Styles: Codable, Predicates: Codable>: Codable {
	public let predicates: [Predicates]
	public let duration: Int32
	public let value: Styles

	public init(predicates: [Predicates], duration: Int32, value: Styles) {
		self.predicates = predicates
		self.duration = duration
		self.value = value
	}
}

public struct BasicTextModel<Predicates: Codable>: Codable {
	public let styles: LayoutStyle<BasicTextElements, ConditionalStyleTransition<BasicTextTransitions, Predicates>>?
	public let value: String

	public init(styles: LayoutStyle<BasicTextElements, ConditionalStyleTransition<BasicTextTransitions, Predicates>>?, value: String) {
		self.styles = styles
		self.value = value
	}
}

public enum FlexJustification: String, Codable, Hashable {
	case center
	case flexStart = "flex-start"
	case flexEnd = "flex-end"
}

public struct Shadow: Codable, Hashable {
	public let offsetX: Float?
	public let offsetY: Float?
	public let blurRadius: Float?
	public let spreadRadius: Float?
	public let color: ThemeColor

	public init(offsetX: Float?, offsetY: Float?, blurRadius: Float?, spreadRadius: Float?, color: ThemeColor) {
		self.offsetX = offsetX
		self.offsetY = offsetY
		self.blurRadius = blurRadius
		self.spreadRadius = spreadRadius
		self.color = color
	}
}

public enum Overflow: String, Codable, Hashable {
	case hidden
	case visible
}

public struct ContainerStylingProperties: Codable, Hashable {
	public let justifyContent: FlexJustification?
	public let alignItems: FlexAlignment?
	public let shadow: Shadow?
	public let overflow: Overflow?
	public let gap: Float?
	public let blur: Float?

	public init(justifyContent: FlexJustification?, alignItems: FlexAlignment?, shadow: Shadow?, overflow: Overflow?, gap: Float?, blur: Float?) {
		self.justifyContent = justifyContent
		self.alignItems = alignItems
		self.shadow = shadow
		self.overflow = overflow
		self.gap = gap
		self.blur = blur
	}
}

public enum BorderStyle: String, Codable {
	case solid
	case dashed
}

public struct BorderStylingProperties: Codable, Hashable {
	public let borderRadius: Float?
	public let borderColor: ThemeColor?
	public let borderWidth: String?
	public let borderStyle: BorderStyle?

	public init(borderRadius: Float?, borderColor: ThemeColor?, borderWidth: String?, borderStyle: BorderStyle?) {
		self.borderRadius = borderRadius
		self.borderColor = borderColor
		self.borderWidth = borderWidth
		self.borderStyle = borderStyle
	}
}

public struct BottomSheetStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct BottomSheetWrapperStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?) {
		self.container = container
		self.background = background
	}
}

public struct BottomSheetElements: Codable {
	public let own: [BasicStateStylingBlock<BottomSheetStyles>]
	public let wrapper: [BasicStateStylingBlock<BottomSheetWrapperStyles>]

	public init(own: [BasicStateStylingBlock<BottomSheetStyles>], wrapper: [BasicStateStylingBlock<BottomSheetWrapperStyles>]) {
		self.own = own
		self.wrapper = wrapper
	}
}

public struct BottomSheetTransitions: Codable, Hashable {
	public let own: BottomSheetStyles?
	public let wrapper: BottomSheetWrapperStyles?

	public init(own: BottomSheetStyles?, wrapper: BottomSheetWrapperStyles?) {
		self.own = own
		self.wrapper = wrapper
	}
}

public struct BottomSheetModel<Children: Codable, Predicates: Codable>: Codable {
	public let allowBackdropToClose: Bool
	public let styles: LayoutStyle<BottomSheetElements, ConditionalStyleTransition<BottomSheetTransitions, Predicates>>?
	public let children: [Children]

	public init(allowBackdropToClose: Bool, styles: LayoutStyle<BottomSheetElements, ConditionalStyleTransition<BottomSheetTransitions, Predicates>>?, children: [Children]) {
		self.allowBackdropToClose = allowBackdropToClose
		self.styles = styles
		self.children = children
	}
}

public struct CarouselDistributionStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct StatelessStylingBlock<T: Codable>: Codable {
	public let `default`: T

	public init(default: T) {
		self.default = `default`
	}
}

public struct CarouselDistributionElements: Codable {
	public let own: [StatelessStylingBlock<CarouselDistributionStyles>]

	public init(own: [StatelessStylingBlock<CarouselDistributionStyles>]) {
		self.own = own
	}
}

public struct CarouselDistributionTransitions: Codable, Hashable {
	public let own: CarouselDistributionStyles?

	public init(own: CarouselDistributionStyles?) {
		self.own = own
	}
}

public enum PeekThroughSize: Codable, Hashable {
	case fixed(Float)
	case percentage(Float)

	enum CodingKeys: String, CodingKey, Codable {
		case fixed = "Fixed",
			percentage = "Percentage"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, value
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .fixed:
				if let content = try? container.decode(Float.self, forKey: .value) {
					self = .fixed(content)
					return
				}
			case .percentage:
				if let content = try? container.decode(Float.self, forKey: .value) {
					self = .percentage(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(PeekThroughSize.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PeekThroughSize"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .fixed(let content):
			try container.encode(CodingKeys.fixed, forKey: .type)
			try container.encode(content, forKey: .value)
		case .percentage(let content):
			try container.encode(CodingKeys.percentage, forKey: .type)
			try container.encode(content, forKey: .value)
		}
	}
}

public struct CarouselDistributionModel<Predicates: Codable>: Codable {
	public let viewableItems: [UInt8]
	public let peekThroughSize: [PeekThroughSize]
	public let styles: LayoutStyle<CarouselDistributionElements, ConditionalStyleTransition<CarouselDistributionTransitions, Predicates>>?

	public init(viewableItems: [UInt8], peekThroughSize: [PeekThroughSize], styles: LayoutStyle<CarouselDistributionElements, ConditionalStyleTransition<CarouselDistributionTransitions, Predicates>>?) {
		self.viewableItems = viewableItems
		self.peekThroughSize = peekThroughSize
		self.styles = styles
	}
}

public struct CloseButtonStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct CloseButtonElements: Codable {
	public let own: [BasicStateStylingBlock<CloseButtonStyles>]

	public init(own: [BasicStateStylingBlock<CloseButtonStyles>]) {
		self.own = own
	}
}

public struct CloseButtonTransitions: Codable, Hashable {
	public let own: CloseButtonStyles?

	public init(own: CloseButtonStyles?) {
		self.own = own
	}
}

public struct CloseButtonModel<Children: Codable, Predicates: Codable>: Codable {
	public let styles: LayoutStyle<CloseButtonElements, ConditionalStyleTransition<CloseButtonTransitions, Predicates>>?
	public let children: [Children]
	public let dismissalMethod: String?

	public init(styles: LayoutStyle<CloseButtonElements, ConditionalStyleTransition<CloseButtonTransitions, Predicates>>?, children: [Children], dismissalMethod: String?) {
		self.styles = styles
		self.children = children
		self.dismissalMethod = dismissalMethod
	}
}

public struct ColumnStyle: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct ColumnElements: Codable {
	public let own: [BasicStateStylingBlock<ColumnStyle>]

	public init(own: [BasicStateStylingBlock<ColumnStyle>]) {
		self.own = own
	}
}

public struct ColumnTransitions: Codable, Hashable {
	public let own: ColumnStyle?

	public init(own: ColumnStyle?) {
		self.own = own
	}
}

public struct ColumnModel<Children: Codable, Predicates: Codable>: Codable {
	public let styles: LayoutStyle<ColumnElements, ConditionalStyleTransition<ColumnTransitions, Predicates>>?
	public let children: [Children]

	public init(styles: LayoutStyle<ColumnElements, ConditionalStyleTransition<ColumnTransitions, Predicates>>?, children: [Children]) {
		self.styles = styles
		self.children = children
	}
}

public struct CreativeResponseStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct CreativeResponseElements: Codable {
	public let own: [BasicStateStylingBlock<CreativeResponseStyles>]

	public init(own: [BasicStateStylingBlock<CreativeResponseStyles>]) {
		self.own = own
	}
}

public struct CreativeResponseTransitions: Codable, Hashable {
	public let own: CreativeResponseStyles?

	public init(own: CreativeResponseStyles?) {
		self.own = own
	}
}

public enum LinkOpenTarget: String, Codable {
	case internally
	case externally
	case passthrough
}

public struct CreativeResponseModel<Children: Codable, Predicates: Codable>: Codable {
	public let responseKey: String
	public let styles: LayoutStyle<CreativeResponseElements, ConditionalStyleTransition<CreativeResponseTransitions, Predicates>>?
	public let openLinks: LinkOpenTarget?
	public let children: [Children]

	public init(responseKey: String, styles: LayoutStyle<CreativeResponseElements, ConditionalStyleTransition<CreativeResponseTransitions, Predicates>>?, openLinks: LinkOpenTarget?, children: [Children]) {
		self.responseKey = responseKey
		self.styles = styles
		self.openLinks = openLinks
		self.children = children
	}
}

public struct DataImageStyles: Codable, Hashable {
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct DataImageElements: Codable {
	public let own: [BasicStateStylingBlock<DataImageStyles>]

	public init(own: [BasicStateStylingBlock<DataImageStyles>]) {
		self.own = own
	}
}

public struct DataImageTransitions: Codable, Hashable {
	public let own: DataImageStyles?

	public init(own: DataImageStyles?) {
		self.own = own
	}
}

public struct DataImageModel<Predicates: Codable>: Codable {
	public let styles: LayoutStyle<DataImageElements, ConditionalStyleTransition<DataImageTransitions, Predicates>>?
	public let imageKey: String

	public init(styles: LayoutStyle<DataImageElements, ConditionalStyleTransition<DataImageTransitions, Predicates>>?, imageKey: String) {
		self.styles = styles
		self.imageKey = imageKey
	}
}

public struct GroupedDistributionStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct GroupedDistributionElements: Codable {
	public let own: [StatelessStylingBlock<GroupedDistributionStyles>]

	public init(own: [StatelessStylingBlock<GroupedDistributionStyles>]) {
		self.own = own
	}
}

public struct GroupedDistributionTransitions: Codable, Hashable {
	public let own: GroupedDistributionStyles?

	public init(own: GroupedDistributionStyles?) {
		self.own = own
	}
}

public enum Transition: Codable, Hashable {
	case fadeInOut(FadeInOutTransitionSettings)

	enum CodingKeys: String, CodingKey, Codable {
		case fadeInOut = "FadeInOut"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, settings
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .fadeInOut:
				if let content = try? container.decode(FadeInOutTransitionSettings.self, forKey: .settings) {
					self = .fadeInOut(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(Transition.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Transition"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .fadeInOut(let content):
			try container.encode(CodingKeys.fadeInOut, forKey: .type)
			try container.encode(content, forKey: .settings)
		}
	}
}

public struct GroupedDistributionModel<Predicates: Codable>: Codable {
	public let viewableItems: [UInt8]
	public let transition: Transition
	public let styles: LayoutStyle<GroupedDistributionElements, ConditionalStyleTransition<GroupedDistributionTransitions, Predicates>>?

	public init(viewableItems: [UInt8], transition: Transition, styles: LayoutStyle<GroupedDistributionElements, ConditionalStyleTransition<GroupedDistributionTransitions, Predicates>>?) {
		self.viewableItems = viewableItems
		self.transition = transition
		self.styles = styles
	}
}

public struct OneByOneDistributionStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct OneByOneDistributionElements: Codable {
	public let own: [StatelessStylingBlock<OneByOneDistributionStyles>]

	public init(own: [StatelessStylingBlock<OneByOneDistributionStyles>]) {
		self.own = own
	}
}

public struct OneByOneDistributionTransitions: Codable, Hashable {
	public let own: OneByOneDistributionStyles?

	public init(own: OneByOneDistributionStyles?) {
		self.own = own
	}
}

public struct OneByOneDistributionModel<Predicates: Codable>: Codable {
	public let styles: LayoutStyle<OneByOneDistributionElements, ConditionalStyleTransition<OneByOneDistributionTransitions, Predicates>>?
	public let transition: Transition

	public init(styles: LayoutStyle<OneByOneDistributionElements, ConditionalStyleTransition<OneByOneDistributionTransitions, Predicates>>?, transition: Transition) {
		self.styles = styles
		self.transition = transition
	}
}

public struct OverlayStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct OverlayWrapperStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?) {
		self.container = container
		self.background = background
	}
}

public struct OverlayElements: Codable {
	public let own: [BasicStateStylingBlock<OverlayStyles>]
	public let wrapper: [BasicStateStylingBlock<OverlayWrapperStyles>]

	public init(own: [BasicStateStylingBlock<OverlayStyles>], wrapper: [BasicStateStylingBlock<OverlayWrapperStyles>]) {
		self.own = own
		self.wrapper = wrapper
	}
}

public struct OverlayTransitions: Codable, Hashable {
	public let own: OverlayStyles?
	public let wrapper: OverlayWrapperStyles?

	public init(own: OverlayStyles?, wrapper: OverlayWrapperStyles?) {
		self.own = own
		self.wrapper = wrapper
	}
}

public struct OverlayModel<Children: Codable, Predicates: Codable>: Codable {
	public let allowBackdropToClose: Bool
	public let styles: LayoutStyle<OverlayElements, ConditionalStyleTransition<OverlayTransitions, Predicates>>?
	public let children: [Children]

	public init(allowBackdropToClose: Bool, styles: LayoutStyle<OverlayElements, ConditionalStyleTransition<OverlayTransitions, Predicates>>?, children: [Children]) {
		self.allowBackdropToClose = allowBackdropToClose
		self.styles = styles
		self.children = children
	}
}

public struct ProgressControlStyle: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct ProgressControlElements: Codable {
	public let own: [BasicStateStylingBlock<ProgressControlStyle>]

	public init(own: [BasicStateStylingBlock<ProgressControlStyle>]) {
		self.own = own
	}
}

public struct ProgressControlTransitions: Codable, Hashable {
	public let own: ProgressControlStyle?

	public init(own: ProgressControlStyle?) {
		self.own = own
	}
}

public enum ProgressionDirection: String, Codable, Hashable {
	case forward = "Forward"
	case backward = "Backward"
}

public struct ProgressControlModel<Children: Codable, Predicates: Codable>: Codable {
	public let styles: LayoutStyle<ProgressControlElements, ConditionalStyleTransition<ProgressControlTransitions, Predicates>>?
	public let direction: ProgressionDirection
	public let children: [Children]

	public init(styles: LayoutStyle<ProgressControlElements, ConditionalStyleTransition<ProgressControlTransitions, Predicates>>?, direction: ProgressionDirection, children: [Children]) {
		self.styles = styles
		self.direction = direction
		self.children = children
	}
}

public struct IndicatorStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?
	public let text: TextStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?, text: TextStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
		self.text = text
	}
}

public struct ProgressIndicatorStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct ProgressIndicatorElements: Codable {
	public let own: [BasicStateStylingBlock<ProgressIndicatorStyles>]
	public let indicator: [BasicStateStylingBlock<IndicatorStyles>]
	public let activeIndicator: [BasicStateStylingBlock<IndicatorStyles>]?
	public let seenIndicator: [BasicStateStylingBlock<IndicatorStyles>]?

	public init(own: [BasicStateStylingBlock<ProgressIndicatorStyles>], indicator: [BasicStateStylingBlock<IndicatorStyles>], activeIndicator: [BasicStateStylingBlock<IndicatorStyles>]?, seenIndicator: [BasicStateStylingBlock<IndicatorStyles>]?) {
		self.own = own
		self.indicator = indicator
		self.activeIndicator = activeIndicator
		self.seenIndicator = seenIndicator
	}
}

public struct ProgressIndicatorTransitions: Codable, Hashable {
	public let own: ProgressIndicatorStyles?
	public let indicator: IndicatorStyles?
	public let activeIndicator: IndicatorStyles?
	public let seenIndicator: IndicatorStyles?

	public init(own: ProgressIndicatorStyles?, indicator: IndicatorStyles?, activeIndicator: IndicatorStyles?, seenIndicator: IndicatorStyles?) {
		self.own = own
		self.indicator = indicator
		self.activeIndicator = activeIndicator
		self.seenIndicator = seenIndicator
	}
}

public struct ProgressIndicatorModel<Predicates: Codable>: Codable {
	public let styles: LayoutStyle<ProgressIndicatorElements, ConditionalStyleTransition<ProgressIndicatorTransitions, Predicates>>?
	public let indicator: String
	public let startPosition: Int32?
	public let accessibilityHidden: Bool?

	public init(styles: LayoutStyle<ProgressIndicatorElements, ConditionalStyleTransition<ProgressIndicatorTransitions, Predicates>>?, indicator: String, startPosition: Int32?, accessibilityHidden: Bool?) {
		self.styles = styles
		self.indicator = indicator
		self.startPosition = startPosition
		self.accessibilityHidden = accessibilityHidden
	}
}

public struct RichTextStyle: Codable, Hashable {
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?
	public let background: BackgroundStylingProperties?
	public let text: TextStylingProperties?

	public init(dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?, background: BackgroundStylingProperties?, text: TextStylingProperties?) {
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
		self.background = background
		self.text = text
	}
}

public struct InlineTextStylingProperties: Codable, Hashable {
	public let textColor: ThemeColor?
	public let fontSize: Float?
	public let fontFamily: String?
	public let fontWeight: FontWeight?
	public let baselineTextAlign: FontBaselineAlignment?
	public let fontStyle: FontStyle?
	public let textTransform: TextTransform?
	public let letterSpacing: Float?
	public let textDecoration: TextDecoration?

	public init(textColor: ThemeColor?, fontSize: Float?, fontFamily: String?, fontWeight: FontWeight?, baselineTextAlign: FontBaselineAlignment?, fontStyle: FontStyle?, textTransform: TextTransform?, letterSpacing: Float?, textDecoration: TextDecoration?) {
		self.textColor = textColor
		self.fontSize = fontSize
		self.fontFamily = fontFamily
		self.fontWeight = fontWeight
		self.baselineTextAlign = baselineTextAlign
		self.fontStyle = fontStyle
		self.textTransform = textTransform
		self.letterSpacing = letterSpacing
		self.textDecoration = textDecoration
	}
}

public struct InLineTextStyle: Codable, Hashable {
	public let text: InlineTextStylingProperties

	public init(text: InlineTextStylingProperties) {
		self.text = text
	}
}

public struct RichTextElements: Codable {
	public let own: [BasicStateStylingBlock<RichTextStyle>]
	public let link: [BasicStateStylingBlock<InLineTextStyle>]?

	public init(own: [BasicStateStylingBlock<RichTextStyle>], link: [BasicStateStylingBlock<InLineTextStyle>]?) {
		self.own = own
		self.link = link
	}
}

public struct RichTextTransitions: Codable, Hashable {
	public let own: RichTextStyle?
	public let link: InLineTextStyle?

	public init(own: RichTextStyle?, link: InLineTextStyle?) {
		self.own = own
		self.link = link
	}
}

public struct RichTextModel<Predicates: Codable>: Codable {
	public let styles: LayoutStyle<RichTextElements, ConditionalStyleTransition<RichTextTransitions, Predicates>>?
	public let openLinks: LinkOpenTarget?
	public let value: String

	public init(styles: LayoutStyle<RichTextElements, ConditionalStyleTransition<RichTextTransitions, Predicates>>?, openLinks: LinkOpenTarget?, value: String) {
		self.styles = styles
		self.openLinks = openLinks
		self.value = value
	}
}

public struct RowStyle: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct RowElements: Codable {
	public let own: [BasicStateStylingBlock<RowStyle>]

	public init(own: [BasicStateStylingBlock<RowStyle>]) {
		self.own = own
	}
}

public struct RowTransitions: Codable, Hashable {
	public let own: RowStyle?

	public init(own: RowStyle?) {
		self.own = own
	}
}

public struct RowModel<Children: Codable, Predicates: Codable>: Codable {
	public let styles: LayoutStyle<RowElements, ConditionalStyleTransition<RowTransitions, Predicates>>?
	public let children: [Children]

	public init(styles: LayoutStyle<RowElements, ConditionalStyleTransition<RowTransitions, Predicates>>?, children: [Children]) {
		self.styles = styles
		self.children = children
	}
}

public struct ScrollableColumnStyle: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct ScrollableColumnElements: Codable {
	public let own: [BasicStateStylingBlock<ScrollableColumnStyle>]

	public init(own: [BasicStateStylingBlock<ScrollableColumnStyle>]) {
		self.own = own
	}
}

public struct ScrollableColumnTransitions: Codable, Hashable {
	public let own: ScrollableColumnStyle?

	public init(own: ScrollableColumnStyle?) {
		self.own = own
	}
}

public struct ScrollableColumnModel<Children: Codable, Predicates: Codable>: Codable {
	public let styles: LayoutStyle<ScrollableColumnElements, ConditionalStyleTransition<ScrollableColumnTransitions, Predicates>>?
	public let children: [Children]

	public init(styles: LayoutStyle<ScrollableColumnElements, ConditionalStyleTransition<ScrollableColumnTransitions, Predicates>>?, children: [Children]) {
		self.styles = styles
		self.children = children
	}
}

public struct ScrollableRowStyle: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct ScrollableRowElements: Codable {
	public let own: [BasicStateStylingBlock<ScrollableRowStyle>]

	public init(own: [BasicStateStylingBlock<ScrollableRowStyle>]) {
		self.own = own
	}
}

public struct ScrollableRowTransitions: Codable, Hashable {
	public let own: ScrollableRowStyle?

	public init(own: ScrollableRowStyle?) {
		self.own = own
	}
}

public struct ScrollableRowModel<Children: Codable, Predicates: Codable>: Codable {
	public let styles: LayoutStyle<ScrollableRowElements, ConditionalStyleTransition<ScrollableRowTransitions, Predicates>>?
	public let children: [Children]

	public init(styles: LayoutStyle<ScrollableRowElements, ConditionalStyleTransition<ScrollableRowTransitions, Predicates>>?, children: [Children]) {
		self.styles = styles
		self.children = children
	}
}

public struct StaticImageStyles: Codable, Hashable {
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct StaticImageElements: Codable {
	public let own: [BasicStateStylingBlock<StaticImageStyles>]

	public init(own: [BasicStateStylingBlock<StaticImageStyles>]) {
		self.own = own
	}
}

public struct StaticImageTransitions: Codable, Hashable {
	public let own: StaticImageStyles?

	public init(own: StaticImageStyles?) {
		self.own = own
	}
}

public struct StaticImageUrl: Codable, Hashable {
	public let light: String
	public let dark: String?

	public init(light: String, dark: String?) {
		self.light = light
		self.dark = dark
	}
}

public struct StaticImageModel<Predicates: Codable>: Codable {
	public let styles: LayoutStyle<StaticImageElements, ConditionalStyleTransition<StaticImageTransitions, Predicates>>?
	public let alt: String?
	public let title: String?
	public let url: StaticImageUrl

	public init(styles: LayoutStyle<StaticImageElements, ConditionalStyleTransition<StaticImageTransitions, Predicates>>?, alt: String?, title: String?, url: StaticImageUrl) {
		self.styles = styles
		self.alt = alt
		self.title = title
		self.url = url
	}
}

public struct StaticLinkStyles: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct StaticLinkElements: Codable {
	public let own: [BasicStateStylingBlock<StaticLinkStyles>]

	public init(own: [BasicStateStylingBlock<StaticLinkStyles>]) {
		self.own = own
	}
}

public struct StaticLinkTransitions: Codable, Hashable {
	public let own: StaticLinkStyles?

	public init(own: StaticLinkStyles?) {
		self.own = own
	}
}

public struct StaticLinkModel<Children: Codable, Predicates: Codable>: Codable {
	public let src: String
	public let open: LinkOpenTarget
	public let styles: LayoutStyle<StaticLinkElements, ConditionalStyleTransition<StaticLinkTransitions, Predicates>>?
	public let children: [Children]

	public init(src: String, open: LinkOpenTarget, styles: LayoutStyle<StaticLinkElements, ConditionalStyleTransition<StaticLinkTransitions, Predicates>>?, children: [Children]) {
		self.src = src
		self.open = open
		self.styles = styles
		self.children = children
	}
}

public struct ToggleButtonStateTriggerStyle: Codable, Hashable {
	public let container: ContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct ToggleButtonStateTriggerElements: Codable {
	public let own: [BasicStateStylingBlock<ToggleButtonStateTriggerStyle>]

	public init(own: [BasicStateStylingBlock<ToggleButtonStateTriggerStyle>]) {
		self.own = own
	}
}

public struct ToggleButtonStateTriggerTransitions: Codable, Hashable {
	public let own: ToggleButtonStateTriggerStyle?

	public init(own: ToggleButtonStateTriggerStyle?) {
		self.own = own
	}
}

public struct ToggleButtonStateTriggerModel<Children: Codable, Predicates: Codable>: Codable {
	public let styles: LayoutStyle<ToggleButtonStateTriggerElements, ConditionalStyleTransition<ToggleButtonStateTriggerTransitions, Predicates>>?
	public let children: [Children]
	public let customStateKey: String

	public init(styles: LayoutStyle<ToggleButtonStateTriggerElements, ConditionalStyleTransition<ToggleButtonStateTriggerTransitions, Predicates>>?, children: [Children], customStateKey: String) {
		self.styles = styles
		self.children = children
		self.customStateKey = customStateKey
	}
}

public enum InTransition: Codable, Hashable {
	case fadeIn(FadeInTransitionSettings)

	enum CodingKeys: String, CodingKey, Codable {
		case fadeIn = "FadeIn"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, settings
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .fadeIn:
				if let content = try? container.decode(FadeInTransitionSettings.self, forKey: .settings) {
					self = .fadeIn(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(InTransition.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for InTransition"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .fadeIn(let content):
			try container.encode(CodingKeys.fadeIn, forKey: .type)
			try container.encode(content, forKey: .settings)
		}
	}
}

public enum OutTransition: Codable, Hashable {
	case fadeOut(FadeOutTransitionSettings)

	enum CodingKeys: String, CodingKey, Codable {
		case fadeOut = "FadeOut"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, settings
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .fadeOut:
				if let content = try? container.decode(FadeOutTransitionSettings.self, forKey: .settings) {
					self = .fadeOut(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(OutTransition.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for OutTransition"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .fadeOut(let content):
			try container.encode(CodingKeys.fadeOut, forKey: .type)
			try container.encode(content, forKey: .settings)
		}
	}
}

public struct WhenTransition: Codable, Hashable {
	public let inTransition: [InTransition]?
	public let outTransition: [OutTransition]?

	public init(inTransition: [InTransition]?, outTransition: [OutTransition]?) {
		self.inTransition = inTransition
		self.outTransition = outTransition
	}
}

public enum WhenHidden: String, Codable {
	case visually
	case functionally
}

public struct WhenModel<Children: Codable, Predicates: Codable>: Codable {
	public let predicates: [Predicates]
	public let children: [Children]
	public let transition: WhenTransition?
	public let hide: WhenHidden?

	public init(predicates: [Predicates], children: [Children], transition: WhenTransition?, hide: WhenHidden?) {
		self.predicates = predicates
		self.children = children
		self.transition = transition
		self.hide = hide
	}
}

public struct ZStackContainerStylingProperties: Codable, Hashable {
	public let justifyContent: FlexJustification?
	public let alignItems: FlexAlignment?
	public let shadow: Shadow?
	public let overflow: Overflow?
	public let blur: Float?

	public init(justifyContent: FlexJustification?, alignItems: FlexAlignment?, shadow: Shadow?, overflow: Overflow?, blur: Float?) {
		self.justifyContent = justifyContent
		self.alignItems = alignItems
		self.shadow = shadow
		self.overflow = overflow
		self.blur = blur
	}
}

public struct ZStackStyle: Codable, Hashable {
	public let container: ZStackContainerStylingProperties?
	public let background: BackgroundStylingProperties?
	public let border: BorderStylingProperties?
	public let dimension: DimensionStylingProperties?
	public let flexChild: FlexChildStylingProperties?
	public let spacing: SpacingStylingProperties?

	public init(container: ZStackContainerStylingProperties?, background: BackgroundStylingProperties?, border: BorderStylingProperties?, dimension: DimensionStylingProperties?, flexChild: FlexChildStylingProperties?, spacing: SpacingStylingProperties?) {
		self.container = container
		self.background = background
		self.border = border
		self.dimension = dimension
		self.flexChild = flexChild
		self.spacing = spacing
	}
}

public struct ZStackElements: Codable {
	public let own: [BasicStateStylingBlock<ZStackStyle>]

	public init(own: [BasicStateStylingBlock<ZStackStyle>]) {
		self.own = own
	}
}

public struct ZStackTransitions: Codable, Hashable {
	public let own: ZStackStyle?

	public init(own: ZStackStyle?) {
		self.own = own
	}
}

public struct ZStackModel<Children: Codable, Predicates: Codable>: Codable {
	public let styles: LayoutStyle<ZStackElements, ConditionalStyleTransition<ZStackTransitions, Predicates>>?
	public let children: [Children]

	public init(styles: LayoutStyle<ZStackElements, ConditionalStyleTransition<ZStackTransitions, Predicates>>?, children: [Children]) {
		self.styles = styles
		self.children = children
	}
}

public enum LayoutVariantDomainStateKey: String, Codable, Hashable {
	case offerComplete
}

public enum WhenPredicate: Codable, Hashable {
	case breakpoint(BreakpointPredicate)
	case position(PositionPredicate)
	case progression(ProgressionPredicate)
	case darkMode(DarkModePredicate)
	case creativeCopy(CreativeCopyPredicate)
	case staticBoolean(StaticBooleanPredicate)
	case customState(CustomStatePredicate)
	case domainState(LayoutSchemaDomainStatePredicate)
	case staticString(StaticStringPredicate)

	enum CodingKeys: String, CodingKey, Codable {
		case breakpoint = "Breakpoint",
			position = "Position",
			progression = "Progression",
			darkMode = "DarkMode",
			creativeCopy = "CreativeCopy",
			staticBoolean = "StaticBoolean",
			customState = "CustomState",
			domainState = "DomainState",
			staticString = "StaticString"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, predicate
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .breakpoint:
				if let content = try? container.decode(BreakpointPredicate.self, forKey: .predicate) {
					self = .breakpoint(content)
					return
				}
			case .position:
				if let content = try? container.decode(PositionPredicate.self, forKey: .predicate) {
					self = .position(content)
					return
				}
			case .progression:
				if let content = try? container.decode(ProgressionPredicate.self, forKey: .predicate) {
					self = .progression(content)
					return
				}
			case .darkMode:
				if let content = try? container.decode(DarkModePredicate.self, forKey: .predicate) {
					self = .darkMode(content)
					return
				}
			case .creativeCopy:
				if let content = try? container.decode(CreativeCopyPredicate.self, forKey: .predicate) {
					self = .creativeCopy(content)
					return
				}
			case .staticBoolean:
				if let content = try? container.decode(StaticBooleanPredicate.self, forKey: .predicate) {
					self = .staticBoolean(content)
					return
				}
			case .customState:
				if let content = try? container.decode(CustomStatePredicate.self, forKey: .predicate) {
					self = .customState(content)
					return
				}
			case .domainState:
				if let content = try? container.decode(LayoutSchemaDomainStatePredicate.self, forKey: .predicate) {
					self = .domainState(content)
					return
				}
			case .staticString:
				if let content = try? container.decode(StaticStringPredicate.self, forKey: .predicate) {
					self = .staticString(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(WhenPredicate.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for WhenPredicate"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .breakpoint(let content):
			try container.encode(CodingKeys.breakpoint, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .position(let content):
			try container.encode(CodingKeys.position, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .progression(let content):
			try container.encode(CodingKeys.progression, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .darkMode(let content):
			try container.encode(CodingKeys.darkMode, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .creativeCopy(let content):
			try container.encode(CodingKeys.creativeCopy, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .staticBoolean(let content):
			try container.encode(CodingKeys.staticBoolean, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .customState(let content):
			try container.encode(CodingKeys.customState, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .domainState(let content):
			try container.encode(CodingKeys.domainState, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .staticString(let content):
			try container.encode(CodingKeys.staticString, forKey: .type)
			try container.encode(content, forKey: .predicate)
		}
	}
}

public enum LayoutVariantWhenPredicate: Codable {
	case breakpoint(BreakpointPredicate)
	case position(PositionPredicate)
	case progression(ProgressionPredicate)
	case darkMode(DarkModePredicate)
	case creativeCopy(CreativeCopyPredicate)
	case staticBoolean(StaticBooleanPredicate)
	case customState(CustomStatePredicate)
	case domainState(DomainStatePredicate<LayoutVariantDomainStateKey>)
	case staticString(StaticStringPredicate)

	enum CodingKeys: String, CodingKey, Codable {
		case breakpoint = "Breakpoint",
			position = "Position",
			progression = "Progression",
			darkMode = "DarkMode",
			creativeCopy = "CreativeCopy",
			staticBoolean = "StaticBoolean",
			customState = "CustomState",
			domainState = "DomainState",
			staticString = "StaticString"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, predicate
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .breakpoint:
				if let content = try? container.decode(BreakpointPredicate.self, forKey: .predicate) {
					self = .breakpoint(content)
					return
				}
			case .position:
				if let content = try? container.decode(PositionPredicate.self, forKey: .predicate) {
					self = .position(content)
					return
				}
			case .progression:
				if let content = try? container.decode(ProgressionPredicate.self, forKey: .predicate) {
					self = .progression(content)
					return
				}
			case .darkMode:
				if let content = try? container.decode(DarkModePredicate.self, forKey: .predicate) {
					self = .darkMode(content)
					return
				}
			case .creativeCopy:
				if let content = try? container.decode(CreativeCopyPredicate.self, forKey: .predicate) {
					self = .creativeCopy(content)
					return
				}
			case .staticBoolean:
				if let content = try? container.decode(StaticBooleanPredicate.self, forKey: .predicate) {
					self = .staticBoolean(content)
					return
				}
			case .customState:
				if let content = try? container.decode(CustomStatePredicate.self, forKey: .predicate) {
					self = .customState(content)
					return
				}
			case .domainState:
				if let content = try? container.decode(DomainStatePredicate<LayoutVariantDomainStateKey>.self, forKey: .predicate) {
					self = .domainState(content)
					return
				}
			case .staticString:
				if let content = try? container.decode(StaticStringPredicate.self, forKey: .predicate) {
					self = .staticString(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(LayoutVariantWhenPredicate.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for LayoutVariantWhenPredicate"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .breakpoint(let content):
			try container.encode(CodingKeys.breakpoint, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .position(let content):
			try container.encode(CodingKeys.position, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .progression(let content):
			try container.encode(CodingKeys.progression, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .darkMode(let content):
			try container.encode(CodingKeys.darkMode, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .creativeCopy(let content):
			try container.encode(CodingKeys.creativeCopy, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .staticBoolean(let content):
			try container.encode(CodingKeys.staticBoolean, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .customState(let content):
			try container.encode(CodingKeys.customState, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .domainState(let content):
			try container.encode(CodingKeys.domainState, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .staticString(let content):
			try container.encode(CodingKeys.staticString, forKey: .type)
			try container.encode(content, forKey: .predicate)
		}
	}
}

public enum OuterLayoutWhenPredicate: Codable {
	case breakpoint(BreakpointPredicate)
	case progression(ProgressionPredicate)
	case darkMode(DarkModePredicate)
	case staticBoolean(StaticBooleanPredicate)
	case customState(CustomStatePredicate)
	case staticString(StaticStringPredicate)

	enum CodingKeys: String, CodingKey, Codable {
		case breakpoint = "Breakpoint",
			progression = "Progression",
			darkMode = "DarkMode",
			staticBoolean = "StaticBoolean",
			customState = "CustomState",
			staticString = "StaticString"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, predicate
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .breakpoint:
				if let content = try? container.decode(BreakpointPredicate.self, forKey: .predicate) {
					self = .breakpoint(content)
					return
				}
			case .progression:
				if let content = try? container.decode(ProgressionPredicate.self, forKey: .predicate) {
					self = .progression(content)
					return
				}
			case .darkMode:
				if let content = try? container.decode(DarkModePredicate.self, forKey: .predicate) {
					self = .darkMode(content)
					return
				}
			case .staticBoolean:
				if let content = try? container.decode(StaticBooleanPredicate.self, forKey: .predicate) {
					self = .staticBoolean(content)
					return
				}
			case .customState:
				if let content = try? container.decode(CustomStatePredicate.self, forKey: .predicate) {
					self = .customState(content)
					return
				}
			case .staticString:
				if let content = try? container.decode(StaticStringPredicate.self, forKey: .predicate) {
					self = .staticString(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(OuterLayoutWhenPredicate.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for OuterLayoutWhenPredicate"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .breakpoint(let content):
			try container.encode(CodingKeys.breakpoint, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .progression(let content):
			try container.encode(CodingKeys.progression, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .darkMode(let content):
			try container.encode(CodingKeys.darkMode, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .staticBoolean(let content):
			try container.encode(CodingKeys.staticBoolean, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .customState(let content):
			try container.encode(CodingKeys.customState, forKey: .type)
			try container.encode(content, forKey: .predicate)
		case .staticString(let content):
			try container.encode(CodingKeys.staticString, forKey: .type)
			try container.encode(content, forKey: .predicate)
		}
	}
}

public indirect enum LayoutSchemaModel: Codable {
	case row(RowModel<LayoutSchemaModel, WhenPredicate>)
	case column(ColumnModel<LayoutSchemaModel, WhenPredicate>)
	case scrollableColumn(ScrollableColumnModel<LayoutSchemaModel, WhenPredicate>)
	case scrollableRow(ScrollableRowModel<LayoutSchemaModel, WhenPredicate>)
	case zStack(ZStackModel<LayoutSchemaModel, WhenPredicate>)
	case accessibilityGrouped(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>)
	case staticImage(StaticImageModel<WhenPredicate>)
	case dataImage(DataImageModel<WhenPredicate>)
	case richText(RichTextModel<WhenPredicate>)
	case basicText(BasicTextModel<WhenPredicate>)
	case progressIndicator(ProgressIndicatorModel<WhenPredicate>)
	case creativeResponse(CreativeResponseModel<LayoutSchemaModel, WhenPredicate>)
	case oneByOneDistribution(OneByOneDistributionModel<WhenPredicate>)
	case overlay(OverlayModel<LayoutSchemaModel, WhenPredicate>)
	case bottomSheet(BottomSheetModel<LayoutSchemaModel, WhenPredicate>)
	case when(WhenModel<LayoutSchemaModel, WhenPredicate>)
	case staticLink(StaticLinkModel<LayoutSchemaModel, WhenPredicate>)
	case closeButton(CloseButtonModel<LayoutSchemaModel, WhenPredicate>)
	case carouselDistribution(CarouselDistributionModel<WhenPredicate>)
	case progressControl(ProgressControlModel<LayoutSchemaModel, WhenPredicate>)
	case groupedDistribution(GroupedDistributionModel<WhenPredicate>)
	case toggleButtonStateTrigger(ToggleButtonStateTriggerModel<LayoutSchemaModel, WhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			scrollableColumn = "ScrollableColumn",
			scrollableRow = "ScrollableRow",
			zStack = "ZStack",
			accessibilityGrouped = "AccessibilityGrouped",
			staticImage = "StaticImage",
			dataImage = "DataImage",
			richText = "RichText",
			basicText = "BasicText",
			progressIndicator = "ProgressIndicator",
			creativeResponse = "CreativeResponse",
			oneByOneDistribution = "OneByOneDistribution",
			overlay = "Overlay",
			bottomSheet = "BottomSheet",
			when = "When",
			staticLink = "StaticLink",
			closeButton = "CloseButton",
			carouselDistribution = "CarouselDistribution",
			progressControl = "ProgressControl",
			groupedDistribution = "GroupedDistribution",
			toggleButtonStateTrigger = "ToggleButtonStateTrigger"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .scrollableColumn:
				if let content = try? container.decode(ScrollableColumnModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .scrollableColumn(content)
					return
				}
			case .scrollableRow:
				if let content = try? container.decode(ScrollableRowModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .scrollableRow(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .accessibilityGrouped:
				if let content = try? container.decode(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>.self, forKey: .node) {
					self = .accessibilityGrouped(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<WhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .dataImage:
				if let content = try? container.decode(DataImageModel<WhenPredicate>.self, forKey: .node) {
					self = .dataImage(content)
					return
				}
			case .richText:
				if let content = try? container.decode(RichTextModel<WhenPredicate>.self, forKey: .node) {
					self = .richText(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<WhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .progressIndicator:
				if let content = try? container.decode(ProgressIndicatorModel<WhenPredicate>.self, forKey: .node) {
					self = .progressIndicator(content)
					return
				}
			case .creativeResponse:
				if let content = try? container.decode(CreativeResponseModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .creativeResponse(content)
					return
				}
			case .oneByOneDistribution:
				if let content = try? container.decode(OneByOneDistributionModel<WhenPredicate>.self, forKey: .node) {
					self = .oneByOneDistribution(content)
					return
				}
			case .overlay:
				if let content = try? container.decode(OverlayModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .overlay(content)
					return
				}
			case .bottomSheet:
				if let content = try? container.decode(BottomSheetModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .bottomSheet(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			case .staticLink:
				if let content = try? container.decode(StaticLinkModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .staticLink(content)
					return
				}
			case .closeButton:
				if let content = try? container.decode(CloseButtonModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .closeButton(content)
					return
				}
			case .carouselDistribution:
				if let content = try? container.decode(CarouselDistributionModel<WhenPredicate>.self, forKey: .node) {
					self = .carouselDistribution(content)
					return
				}
			case .progressControl:
				if let content = try? container.decode(ProgressControlModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .progressControl(content)
					return
				}
			case .groupedDistribution:
				if let content = try? container.decode(GroupedDistributionModel<WhenPredicate>.self, forKey: .node) {
					self = .groupedDistribution(content)
					return
				}
			case .toggleButtonStateTrigger:
				if let content = try? container.decode(ToggleButtonStateTriggerModel<LayoutSchemaModel, WhenPredicate>.self, forKey: .node) {
					self = .toggleButtonStateTrigger(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(LayoutSchemaModel.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for LayoutSchemaModel"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableColumn(let content):
			try container.encode(CodingKeys.scrollableColumn, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableRow(let content):
			try container.encode(CodingKeys.scrollableRow, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .accessibilityGrouped(let content):
			try container.encode(CodingKeys.accessibilityGrouped, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .dataImage(let content):
			try container.encode(CodingKeys.dataImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .richText(let content):
			try container.encode(CodingKeys.richText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressIndicator(let content):
			try container.encode(CodingKeys.progressIndicator, forKey: .type)
			try container.encode(content, forKey: .node)
		case .creativeResponse(let content):
			try container.encode(CodingKeys.creativeResponse, forKey: .type)
			try container.encode(content, forKey: .node)
		case .oneByOneDistribution(let content):
			try container.encode(CodingKeys.oneByOneDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .overlay(let content):
			try container.encode(CodingKeys.overlay, forKey: .type)
			try container.encode(content, forKey: .node)
		case .bottomSheet(let content):
			try container.encode(CodingKeys.bottomSheet, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticLink(let content):
			try container.encode(CodingKeys.staticLink, forKey: .type)
			try container.encode(content, forKey: .node)
		case .closeButton(let content):
			try container.encode(CodingKeys.closeButton, forKey: .type)
			try container.encode(content, forKey: .node)
		case .carouselDistribution(let content):
			try container.encode(CodingKeys.carouselDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressControl(let content):
			try container.encode(CodingKeys.progressControl, forKey: .type)
			try container.encode(content, forKey: .node)
		case .groupedDistribution(let content):
			try container.encode(CodingKeys.groupedDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .toggleButtonStateTrigger(let content):
			try container.encode(CodingKeys.toggleButtonStateTrigger, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public enum LayoutVariantSchemaModel: Codable {
	case row(RowModel<LayoutVariantChildren, LayoutVariantWhenPredicate>)
	case column(ColumnModel<LayoutVariantChildren, LayoutVariantWhenPredicate>)
	case scrollableColumn(ScrollableColumnModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>)
	case scrollableRow(ScrollableRowModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>)
	case zStack(ZStackModel<LayoutVariantChildren, LayoutVariantWhenPredicate>)
	case accessibilityGrouped(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>)
	case staticImage(StaticImageModel<LayoutVariantWhenPredicate>)
	case dataImage(DataImageModel<LayoutVariantWhenPredicate>)
	case richText(RichTextModel<LayoutVariantWhenPredicate>)
	case basicText(BasicTextModel<LayoutVariantWhenPredicate>)
	case creativeResponse(CreativeResponseModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case when(WhenModel<LayoutVariantChildren, LayoutVariantWhenPredicate>)
	case staticLink(StaticLinkModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case closeButton(CloseButtonModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case toggleButtonStateTrigger(ToggleButtonStateTriggerModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			scrollableColumn = "ScrollableColumn",
			scrollableRow = "ScrollableRow",
			zStack = "ZStack",
			accessibilityGrouped = "AccessibilityGrouped",
			staticImage = "StaticImage",
			dataImage = "DataImage",
			richText = "RichText",
			basicText = "BasicText",
			creativeResponse = "CreativeResponse",
			when = "When",
			staticLink = "StaticLink",
			closeButton = "CloseButton",
			toggleButtonStateTrigger = "ToggleButtonStateTrigger"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<LayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<LayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .scrollableColumn:
				if let content = try? container.decode(ScrollableColumnModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .scrollableColumn(content)
					return
				}
			case .scrollableRow:
				if let content = try? container.decode(ScrollableRowModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .scrollableRow(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<LayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .accessibilityGrouped:
				if let content = try? container.decode(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>.self, forKey: .node) {
					self = .accessibilityGrouped(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .dataImage:
				if let content = try? container.decode(DataImageModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .dataImage(content)
					return
				}
			case .richText:
				if let content = try? container.decode(RichTextModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .richText(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .creativeResponse:
				if let content = try? container.decode(CreativeResponseModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .creativeResponse(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<LayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			case .staticLink:
				if let content = try? container.decode(StaticLinkModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .staticLink(content)
					return
				}
			case .closeButton:
				if let content = try? container.decode(CloseButtonModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .closeButton(content)
					return
				}
			case .toggleButtonStateTrigger:
				if let content = try? container.decode(ToggleButtonStateTriggerModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .toggleButtonStateTrigger(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(LayoutVariantSchemaModel.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for LayoutVariantSchemaModel"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableColumn(let content):
			try container.encode(CodingKeys.scrollableColumn, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableRow(let content):
			try container.encode(CodingKeys.scrollableRow, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .accessibilityGrouped(let content):
			try container.encode(CodingKeys.accessibilityGrouped, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .dataImage(let content):
			try container.encode(CodingKeys.dataImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .richText(let content):
			try container.encode(CodingKeys.richText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .creativeResponse(let content):
			try container.encode(CodingKeys.creativeResponse, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticLink(let content):
			try container.encode(CodingKeys.staticLink, forKey: .type)
			try container.encode(content, forKey: .node)
		case .closeButton(let content):
			try container.encode(CodingKeys.closeButton, forKey: .type)
			try container.encode(content, forKey: .node)
		case .toggleButtonStateTrigger(let content):
			try container.encode(CodingKeys.toggleButtonStateTrigger, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public indirect enum LayoutVariantChildren: Codable {
	case row(RowModel<LayoutVariantChildren, LayoutVariantWhenPredicate>)
	case column(ColumnModel<LayoutVariantChildren, LayoutVariantWhenPredicate>)
	case scrollableColumn(ScrollableColumnModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>)
	case scrollableRow(ScrollableRowModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>)
	case zStack(ZStackModel<LayoutVariantChildren, LayoutVariantWhenPredicate>)
	case accessibilityGrouped(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>)
	case staticImage(StaticImageModel<LayoutVariantWhenPredicate>)
	case dataImage(DataImageModel<LayoutVariantWhenPredicate>)
	case richText(RichTextModel<LayoutVariantWhenPredicate>)
	case basicText(BasicTextModel<LayoutVariantWhenPredicate>)
	case creativeResponse(CreativeResponseModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case when(WhenModel<LayoutVariantChildren, LayoutVariantWhenPredicate>)
	case staticLink(StaticLinkModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case closeButton(CloseButtonModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case toggleButtonStateTrigger(ToggleButtonStateTriggerModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			scrollableColumn = "ScrollableColumn",
			scrollableRow = "ScrollableRow",
			zStack = "ZStack",
			accessibilityGrouped = "AccessibilityGrouped",
			staticImage = "StaticImage",
			dataImage = "DataImage",
			richText = "RichText",
			basicText = "BasicText",
			creativeResponse = "CreativeResponse",
			when = "When",
			staticLink = "StaticLink",
			closeButton = "CloseButton",
			toggleButtonStateTrigger = "ToggleButtonStateTrigger"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<LayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<LayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .scrollableColumn:
				if let content = try? container.decode(ScrollableColumnModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .scrollableColumn(content)
					return
				}
			case .scrollableRow:
				if let content = try? container.decode(ScrollableRowModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .scrollableRow(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<LayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .accessibilityGrouped:
				if let content = try? container.decode(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>.self, forKey: .node) {
					self = .accessibilityGrouped(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .dataImage:
				if let content = try? container.decode(DataImageModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .dataImage(content)
					return
				}
			case .richText:
				if let content = try? container.decode(RichTextModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .richText(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .creativeResponse:
				if let content = try? container.decode(CreativeResponseModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .creativeResponse(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<LayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			case .staticLink:
				if let content = try? container.decode(StaticLinkModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .staticLink(content)
					return
				}
			case .closeButton:
				if let content = try? container.decode(CloseButtonModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .closeButton(content)
					return
				}
			case .toggleButtonStateTrigger:
				if let content = try? container.decode(ToggleButtonStateTriggerModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .toggleButtonStateTrigger(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(LayoutVariantChildren.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for LayoutVariantChildren"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableColumn(let content):
			try container.encode(CodingKeys.scrollableColumn, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableRow(let content):
			try container.encode(CodingKeys.scrollableRow, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .accessibilityGrouped(let content):
			try container.encode(CodingKeys.accessibilityGrouped, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .dataImage(let content):
			try container.encode(CodingKeys.dataImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .richText(let content):
			try container.encode(CodingKeys.richText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .creativeResponse(let content):
			try container.encode(CodingKeys.creativeResponse, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticLink(let content):
			try container.encode(CodingKeys.staticLink, forKey: .type)
			try container.encode(content, forKey: .node)
		case .closeButton(let content):
			try container.encode(CodingKeys.closeButton, forKey: .type)
			try container.encode(content, forKey: .node)
		case .toggleButtonStateTrigger(let content):
			try container.encode(CodingKeys.toggleButtonStateTrigger, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public enum OuterLayoutSchemaModel: Codable {
	case row(RowModel<OuterLayoutChildren, OuterLayoutWhenPredicate>)
	case column(ColumnModel<OuterLayoutChildren, OuterLayoutWhenPredicate>)
	case scrollableColumn(ScrollableColumnModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>)
	case scrollableRow(ScrollableRowModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>)
	case zStack(ZStackModel<OuterLayoutChildren, OuterLayoutWhenPredicate>)
	case accessibilityGrouped(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>)
	case staticImage(StaticImageModel<OuterLayoutWhenPredicate>)
	case richText(RichTextModel<OuterLayoutWhenPredicate>)
	case basicText(BasicTextModel<OuterLayoutWhenPredicate>)
	case progressIndicator(ProgressIndicatorModel<OuterLayoutWhenPredicate>)
	case oneByOneDistribution(OneByOneDistributionModel<OuterLayoutWhenPredicate>)
	case overlay(OverlayModel<ModalChildren, OuterLayoutWhenPredicate>)
	case bottomSheet(BottomSheetModel<ModalChildren, OuterLayoutWhenPredicate>)
	case when(WhenModel<OuterLayoutChildren, OuterLayoutWhenPredicate>)
	case staticLink(StaticLinkModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case closeButton(CloseButtonModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case carouselDistribution(CarouselDistributionModel<OuterLayoutWhenPredicate>)
	case progressControl(ProgressControlModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case groupedDistribution(GroupedDistributionModel<OuterLayoutWhenPredicate>)
	case toggleButtonStateTrigger(ToggleButtonStateTriggerModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			scrollableColumn = "ScrollableColumn",
			scrollableRow = "ScrollableRow",
			zStack = "ZStack",
			accessibilityGrouped = "AccessibilityGrouped",
			staticImage = "StaticImage",
			richText = "RichText",
			basicText = "BasicText",
			progressIndicator = "ProgressIndicator",
			oneByOneDistribution = "OneByOneDistribution",
			overlay = "Overlay",
			bottomSheet = "BottomSheet",
			when = "When",
			staticLink = "StaticLink",
			closeButton = "CloseButton",
			carouselDistribution = "CarouselDistribution",
			progressControl = "ProgressControl",
			groupedDistribution = "GroupedDistribution",
			toggleButtonStateTrigger = "ToggleButtonStateTrigger"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<OuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<OuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .scrollableColumn:
				if let content = try? container.decode(ScrollableColumnModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .scrollableColumn(content)
					return
				}
			case .scrollableRow:
				if let content = try? container.decode(ScrollableRowModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .scrollableRow(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<OuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .accessibilityGrouped:
				if let content = try? container.decode(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>.self, forKey: .node) {
					self = .accessibilityGrouped(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .richText:
				if let content = try? container.decode(RichTextModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .richText(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .progressIndicator:
				if let content = try? container.decode(ProgressIndicatorModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .progressIndicator(content)
					return
				}
			case .oneByOneDistribution:
				if let content = try? container.decode(OneByOneDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .oneByOneDistribution(content)
					return
				}
			case .overlay:
				if let content = try? container.decode(OverlayModel<ModalChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .overlay(content)
					return
				}
			case .bottomSheet:
				if let content = try? container.decode(BottomSheetModel<ModalChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .bottomSheet(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<OuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			case .staticLink:
				if let content = try? container.decode(StaticLinkModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .staticLink(content)
					return
				}
			case .closeButton:
				if let content = try? container.decode(CloseButtonModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .closeButton(content)
					return
				}
			case .carouselDistribution:
				if let content = try? container.decode(CarouselDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .carouselDistribution(content)
					return
				}
			case .progressControl:
				if let content = try? container.decode(ProgressControlModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .progressControl(content)
					return
				}
			case .groupedDistribution:
				if let content = try? container.decode(GroupedDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .groupedDistribution(content)
					return
				}
			case .toggleButtonStateTrigger:
				if let content = try? container.decode(ToggleButtonStateTriggerModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .toggleButtonStateTrigger(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(OuterLayoutSchemaModel.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for OuterLayoutSchemaModel"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableColumn(let content):
			try container.encode(CodingKeys.scrollableColumn, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableRow(let content):
			try container.encode(CodingKeys.scrollableRow, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .accessibilityGrouped(let content):
			try container.encode(CodingKeys.accessibilityGrouped, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .richText(let content):
			try container.encode(CodingKeys.richText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressIndicator(let content):
			try container.encode(CodingKeys.progressIndicator, forKey: .type)
			try container.encode(content, forKey: .node)
		case .oneByOneDistribution(let content):
			try container.encode(CodingKeys.oneByOneDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .overlay(let content):
			try container.encode(CodingKeys.overlay, forKey: .type)
			try container.encode(content, forKey: .node)
		case .bottomSheet(let content):
			try container.encode(CodingKeys.bottomSheet, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticLink(let content):
			try container.encode(CodingKeys.staticLink, forKey: .type)
			try container.encode(content, forKey: .node)
		case .closeButton(let content):
			try container.encode(CodingKeys.closeButton, forKey: .type)
			try container.encode(content, forKey: .node)
		case .carouselDistribution(let content):
			try container.encode(CodingKeys.carouselDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressControl(let content):
			try container.encode(CodingKeys.progressControl, forKey: .type)
			try container.encode(content, forKey: .node)
		case .groupedDistribution(let content):
			try container.encode(CodingKeys.groupedDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .toggleButtonStateTrigger(let content):
			try container.encode(CodingKeys.toggleButtonStateTrigger, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public indirect enum OuterLayoutChildren: Codable {
	case row(RowModel<OuterLayoutChildren, OuterLayoutWhenPredicate>)
	case column(ColumnModel<OuterLayoutChildren, OuterLayoutWhenPredicate>)
	case scrollableColumn(ScrollableColumnModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>)
	case scrollableRow(ScrollableRowModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>)
	case zStack(ZStackModel<OuterLayoutChildren, OuterLayoutWhenPredicate>)
	case accessibilityGrouped(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>)
	case staticImage(StaticImageModel<OuterLayoutWhenPredicate>)
	case richText(RichTextModel<OuterLayoutWhenPredicate>)
	case basicText(BasicTextModel<OuterLayoutWhenPredicate>)
	case progressIndicator(ProgressIndicatorModel<OuterLayoutWhenPredicate>)
	case oneByOneDistribution(OneByOneDistributionModel<OuterLayoutWhenPredicate>)
	case when(WhenModel<OuterLayoutChildren, OuterLayoutWhenPredicate>)
	case staticLink(StaticLinkModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case closeButton(CloseButtonModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case carouselDistribution(CarouselDistributionModel<OuterLayoutWhenPredicate>)
	case progressControl(ProgressControlModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case groupedDistribution(GroupedDistributionModel<OuterLayoutWhenPredicate>)
	case toggleButtonStateTrigger(ToggleButtonStateTriggerModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			scrollableColumn = "ScrollableColumn",
			scrollableRow = "ScrollableRow",
			zStack = "ZStack",
			accessibilityGrouped = "AccessibilityGrouped",
			staticImage = "StaticImage",
			richText = "RichText",
			basicText = "BasicText",
			progressIndicator = "ProgressIndicator",
			oneByOneDistribution = "OneByOneDistribution",
			when = "When",
			staticLink = "StaticLink",
			closeButton = "CloseButton",
			carouselDistribution = "CarouselDistribution",
			progressControl = "ProgressControl",
			groupedDistribution = "GroupedDistribution",
			toggleButtonStateTrigger = "ToggleButtonStateTrigger"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<OuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<OuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .scrollableColumn:
				if let content = try? container.decode(ScrollableColumnModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .scrollableColumn(content)
					return
				}
			case .scrollableRow:
				if let content = try? container.decode(ScrollableRowModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .scrollableRow(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<OuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .accessibilityGrouped:
				if let content = try? container.decode(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>.self, forKey: .node) {
					self = .accessibilityGrouped(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .richText:
				if let content = try? container.decode(RichTextModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .richText(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .progressIndicator:
				if let content = try? container.decode(ProgressIndicatorModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .progressIndicator(content)
					return
				}
			case .oneByOneDistribution:
				if let content = try? container.decode(OneByOneDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .oneByOneDistribution(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<OuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			case .staticLink:
				if let content = try? container.decode(StaticLinkModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .staticLink(content)
					return
				}
			case .closeButton:
				if let content = try? container.decode(CloseButtonModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .closeButton(content)
					return
				}
			case .carouselDistribution:
				if let content = try? container.decode(CarouselDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .carouselDistribution(content)
					return
				}
			case .progressControl:
				if let content = try? container.decode(ProgressControlModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .progressControl(content)
					return
				}
			case .groupedDistribution:
				if let content = try? container.decode(GroupedDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .groupedDistribution(content)
					return
				}
			case .toggleButtonStateTrigger:
				if let content = try? container.decode(ToggleButtonStateTriggerModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .toggleButtonStateTrigger(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(OuterLayoutChildren.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for OuterLayoutChildren"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableColumn(let content):
			try container.encode(CodingKeys.scrollableColumn, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableRow(let content):
			try container.encode(CodingKeys.scrollableRow, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .accessibilityGrouped(let content):
			try container.encode(CodingKeys.accessibilityGrouped, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .richText(let content):
			try container.encode(CodingKeys.richText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressIndicator(let content):
			try container.encode(CodingKeys.progressIndicator, forKey: .type)
			try container.encode(content, forKey: .node)
		case .oneByOneDistribution(let content):
			try container.encode(CodingKeys.oneByOneDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticLink(let content):
			try container.encode(CodingKeys.staticLink, forKey: .type)
			try container.encode(content, forKey: .node)
		case .closeButton(let content):
			try container.encode(CodingKeys.closeButton, forKey: .type)
			try container.encode(content, forKey: .node)
		case .carouselDistribution(let content):
			try container.encode(CodingKeys.carouselDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressControl(let content):
			try container.encode(CodingKeys.progressControl, forKey: .type)
			try container.encode(content, forKey: .node)
		case .groupedDistribution(let content):
			try container.encode(CodingKeys.groupedDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .toggleButtonStateTrigger(let content):
			try container.encode(CodingKeys.toggleButtonStateTrigger, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public indirect enum ScrollableChildren: Codable {
	case row(RowModel<ScrollableChildren, WhenPredicate>)
	case column(ColumnModel<ScrollableChildren, WhenPredicate>)
	case zStack(ZStackModel<ScrollableChildren, WhenPredicate>)
	case accessibilityGrouped(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>)
	case staticImage(StaticImageModel<WhenPredicate>)
	case dataImage(DataImageModel<WhenPredicate>)
	case richText(RichTextModel<WhenPredicate>)
	case basicText(BasicTextModel<WhenPredicate>)
	case progressIndicator(ProgressIndicatorModel<WhenPredicate>)
	case creativeResponse(CreativeResponseModel<LayoutVariantNonInteractableChildren, WhenPredicate>)
	case oneByOneDistribution(OneByOneDistributionModel<WhenPredicate>)
	case when(WhenModel<ScrollableChildren, WhenPredicate>)
	case staticLink(StaticLinkModel<NonInteractableChildren, WhenPredicate>)
	case closeButton(CloseButtonModel<OuterLayoutNonInteractableChildren, WhenPredicate>)
	case carouselDistribution(CarouselDistributionModel<WhenPredicate>)
	case progressControl(ProgressControlModel<OuterLayoutNonInteractableChildren, WhenPredicate>)
	case groupedDistribution(GroupedDistributionModel<WhenPredicate>)
	case toggleButtonStateTrigger(ToggleButtonStateTriggerModel<NonInteractableChildren, WhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			zStack = "ZStack",
			accessibilityGrouped = "AccessibilityGrouped",
			staticImage = "StaticImage",
			dataImage = "DataImage",
			richText = "RichText",
			basicText = "BasicText",
			progressIndicator = "ProgressIndicator",
			creativeResponse = "CreativeResponse",
			oneByOneDistribution = "OneByOneDistribution",
			when = "When",
			staticLink = "StaticLink",
			closeButton = "CloseButton",
			carouselDistribution = "CarouselDistribution",
			progressControl = "ProgressControl",
			groupedDistribution = "GroupedDistribution",
			toggleButtonStateTrigger = "ToggleButtonStateTrigger"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<ScrollableChildren, WhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<ScrollableChildren, WhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<ScrollableChildren, WhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .accessibilityGrouped:
				if let content = try? container.decode(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>.self, forKey: .node) {
					self = .accessibilityGrouped(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<WhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .dataImage:
				if let content = try? container.decode(DataImageModel<WhenPredicate>.self, forKey: .node) {
					self = .dataImage(content)
					return
				}
			case .richText:
				if let content = try? container.decode(RichTextModel<WhenPredicate>.self, forKey: .node) {
					self = .richText(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<WhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .progressIndicator:
				if let content = try? container.decode(ProgressIndicatorModel<WhenPredicate>.self, forKey: .node) {
					self = .progressIndicator(content)
					return
				}
			case .creativeResponse:
				if let content = try? container.decode(CreativeResponseModel<LayoutVariantNonInteractableChildren, WhenPredicate>.self, forKey: .node) {
					self = .creativeResponse(content)
					return
				}
			case .oneByOneDistribution:
				if let content = try? container.decode(OneByOneDistributionModel<WhenPredicate>.self, forKey: .node) {
					self = .oneByOneDistribution(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<ScrollableChildren, WhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			case .staticLink:
				if let content = try? container.decode(StaticLinkModel<NonInteractableChildren, WhenPredicate>.self, forKey: .node) {
					self = .staticLink(content)
					return
				}
			case .closeButton:
				if let content = try? container.decode(CloseButtonModel<OuterLayoutNonInteractableChildren, WhenPredicate>.self, forKey: .node) {
					self = .closeButton(content)
					return
				}
			case .carouselDistribution:
				if let content = try? container.decode(CarouselDistributionModel<WhenPredicate>.self, forKey: .node) {
					self = .carouselDistribution(content)
					return
				}
			case .progressControl:
				if let content = try? container.decode(ProgressControlModel<OuterLayoutNonInteractableChildren, WhenPredicate>.self, forKey: .node) {
					self = .progressControl(content)
					return
				}
			case .groupedDistribution:
				if let content = try? container.decode(GroupedDistributionModel<WhenPredicate>.self, forKey: .node) {
					self = .groupedDistribution(content)
					return
				}
			case .toggleButtonStateTrigger:
				if let content = try? container.decode(ToggleButtonStateTriggerModel<NonInteractableChildren, WhenPredicate>.self, forKey: .node) {
					self = .toggleButtonStateTrigger(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(ScrollableChildren.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ScrollableChildren"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .accessibilityGrouped(let content):
			try container.encode(CodingKeys.accessibilityGrouped, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .dataImage(let content):
			try container.encode(CodingKeys.dataImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .richText(let content):
			try container.encode(CodingKeys.richText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressIndicator(let content):
			try container.encode(CodingKeys.progressIndicator, forKey: .type)
			try container.encode(content, forKey: .node)
		case .creativeResponse(let content):
			try container.encode(CodingKeys.creativeResponse, forKey: .type)
			try container.encode(content, forKey: .node)
		case .oneByOneDistribution(let content):
			try container.encode(CodingKeys.oneByOneDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticLink(let content):
			try container.encode(CodingKeys.staticLink, forKey: .type)
			try container.encode(content, forKey: .node)
		case .closeButton(let content):
			try container.encode(CodingKeys.closeButton, forKey: .type)
			try container.encode(content, forKey: .node)
		case .carouselDistribution(let content):
			try container.encode(CodingKeys.carouselDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressControl(let content):
			try container.encode(CodingKeys.progressControl, forKey: .type)
			try container.encode(content, forKey: .node)
		case .groupedDistribution(let content):
			try container.encode(CodingKeys.groupedDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .toggleButtonStateTrigger(let content):
			try container.encode(CodingKeys.toggleButtonStateTrigger, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public indirect enum ScrollableOuterLayoutChildren: Codable {
	case row(RowModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>)
	case column(ColumnModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>)
	case zStack(ZStackModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>)
	case accessibilityGrouped(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>)
	case staticImage(StaticImageModel<OuterLayoutWhenPredicate>)
	case richText(RichTextModel<OuterLayoutWhenPredicate>)
	case basicText(BasicTextModel<OuterLayoutWhenPredicate>)
	case progressIndicator(ProgressIndicatorModel<OuterLayoutWhenPredicate>)
	case oneByOneDistribution(OneByOneDistributionModel<OuterLayoutWhenPredicate>)
	case when(WhenModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>)
	case staticLink(StaticLinkModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case closeButton(CloseButtonModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case carouselDistribution(CarouselDistributionModel<OuterLayoutWhenPredicate>)
	case progressControl(ProgressControlModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case groupedDistribution(GroupedDistributionModel<OuterLayoutWhenPredicate>)
	case toggleButtonStateTrigger(ToggleButtonStateTriggerModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			zStack = "ZStack",
			accessibilityGrouped = "AccessibilityGrouped",
			staticImage = "StaticImage",
			richText = "RichText",
			basicText = "BasicText",
			progressIndicator = "ProgressIndicator",
			oneByOneDistribution = "OneByOneDistribution",
			when = "When",
			staticLink = "StaticLink",
			closeButton = "CloseButton",
			carouselDistribution = "CarouselDistribution",
			progressControl = "ProgressControl",
			groupedDistribution = "GroupedDistribution",
			toggleButtonStateTrigger = "ToggleButtonStateTrigger"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .accessibilityGrouped:
				if let content = try? container.decode(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>.self, forKey: .node) {
					self = .accessibilityGrouped(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .richText:
				if let content = try? container.decode(RichTextModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .richText(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .progressIndicator:
				if let content = try? container.decode(ProgressIndicatorModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .progressIndicator(content)
					return
				}
			case .oneByOneDistribution:
				if let content = try? container.decode(OneByOneDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .oneByOneDistribution(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			case .staticLink:
				if let content = try? container.decode(StaticLinkModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .staticLink(content)
					return
				}
			case .closeButton:
				if let content = try? container.decode(CloseButtonModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .closeButton(content)
					return
				}
			case .carouselDistribution:
				if let content = try? container.decode(CarouselDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .carouselDistribution(content)
					return
				}
			case .progressControl:
				if let content = try? container.decode(ProgressControlModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .progressControl(content)
					return
				}
			case .groupedDistribution:
				if let content = try? container.decode(GroupedDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .groupedDistribution(content)
					return
				}
			case .toggleButtonStateTrigger:
				if let content = try? container.decode(ToggleButtonStateTriggerModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .toggleButtonStateTrigger(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(ScrollableOuterLayoutChildren.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ScrollableOuterLayoutChildren"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .accessibilityGrouped(let content):
			try container.encode(CodingKeys.accessibilityGrouped, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .richText(let content):
			try container.encode(CodingKeys.richText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressIndicator(let content):
			try container.encode(CodingKeys.progressIndicator, forKey: .type)
			try container.encode(content, forKey: .node)
		case .oneByOneDistribution(let content):
			try container.encode(CodingKeys.oneByOneDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticLink(let content):
			try container.encode(CodingKeys.staticLink, forKey: .type)
			try container.encode(content, forKey: .node)
		case .closeButton(let content):
			try container.encode(CodingKeys.closeButton, forKey: .type)
			try container.encode(content, forKey: .node)
		case .carouselDistribution(let content):
			try container.encode(CodingKeys.carouselDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressControl(let content):
			try container.encode(CodingKeys.progressControl, forKey: .type)
			try container.encode(content, forKey: .node)
		case .groupedDistribution(let content):
			try container.encode(CodingKeys.groupedDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .toggleButtonStateTrigger(let content):
			try container.encode(CodingKeys.toggleButtonStateTrigger, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public indirect enum ScrollableLayoutVariantChildren: Codable {
	case row(RowModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>)
	case column(ColumnModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>)
	case accessibilityGrouped(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>)
	case zStack(ZStackModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>)
	case staticImage(StaticImageModel<LayoutVariantWhenPredicate>)
	case dataImage(DataImageModel<LayoutVariantWhenPredicate>)
	case richText(RichTextModel<LayoutVariantWhenPredicate>)
	case basicText(BasicTextModel<LayoutVariantWhenPredicate>)
	case creativeResponse(CreativeResponseModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case when(WhenModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>)
	case staticLink(StaticLinkModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case toggleButtonStateTrigger(ToggleButtonStateTriggerModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			accessibilityGrouped = "AccessibilityGrouped",
			zStack = "ZStack",
			staticImage = "StaticImage",
			dataImage = "DataImage",
			richText = "RichText",
			basicText = "BasicText",
			creativeResponse = "CreativeResponse",
			when = "When",
			staticLink = "StaticLink",
			toggleButtonStateTrigger = "ToggleButtonStateTrigger"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .accessibilityGrouped:
				if let content = try? container.decode(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>.self, forKey: .node) {
					self = .accessibilityGrouped(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .dataImage:
				if let content = try? container.decode(DataImageModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .dataImage(content)
					return
				}
			case .richText:
				if let content = try? container.decode(RichTextModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .richText(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .creativeResponse:
				if let content = try? container.decode(CreativeResponseModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .creativeResponse(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<ScrollableLayoutVariantChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			case .staticLink:
				if let content = try? container.decode(StaticLinkModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .staticLink(content)
					return
				}
			case .toggleButtonStateTrigger:
				if let content = try? container.decode(ToggleButtonStateTriggerModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .toggleButtonStateTrigger(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(ScrollableLayoutVariantChildren.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ScrollableLayoutVariantChildren"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .accessibilityGrouped(let content):
			try container.encode(CodingKeys.accessibilityGrouped, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .dataImage(let content):
			try container.encode(CodingKeys.dataImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .richText(let content):
			try container.encode(CodingKeys.richText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .creativeResponse(let content):
			try container.encode(CodingKeys.creativeResponse, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticLink(let content):
			try container.encode(CodingKeys.staticLink, forKey: .type)
			try container.encode(content, forKey: .node)
		case .toggleButtonStateTrigger(let content):
			try container.encode(CodingKeys.toggleButtonStateTrigger, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public indirect enum ModalChildren: Codable {
	case row(RowModel<ModalChildren, OuterLayoutWhenPredicate>)
	case scrollableColumn(ScrollableColumnModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>)
	case scrollableRow(ScrollableRowModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>)
	case column(ColumnModel<ModalChildren, OuterLayoutWhenPredicate>)
	case zStack(ZStackModel<ModalChildren, OuterLayoutWhenPredicate>)
	case accessibilityGrouped(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>)
	case staticImage(StaticImageModel<OuterLayoutWhenPredicate>)
	case richText(RichTextModel<OuterLayoutWhenPredicate>)
	case basicText(BasicTextModel<OuterLayoutWhenPredicate>)
	case progressIndicator(ProgressIndicatorModel<OuterLayoutWhenPredicate>)
	case oneByOneDistribution(OneByOneDistributionModel<OuterLayoutWhenPredicate>)
	case when(WhenModel<ModalChildren, OuterLayoutWhenPredicate>)
	case staticLink(StaticLinkModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case closeButton(CloseButtonModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case carouselDistribution(CarouselDistributionModel<OuterLayoutWhenPredicate>)
	case progressControl(ProgressControlModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case groupedDistribution(GroupedDistributionModel<OuterLayoutWhenPredicate>)
	case toggleButtonStateTrigger(ToggleButtonStateTriggerModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			scrollableColumn = "ScrollableColumn",
			scrollableRow = "ScrollableRow",
			column = "Column",
			zStack = "ZStack",
			accessibilityGrouped = "AccessibilityGrouped",
			staticImage = "StaticImage",
			richText = "RichText",
			basicText = "BasicText",
			progressIndicator = "ProgressIndicator",
			oneByOneDistribution = "OneByOneDistribution",
			when = "When",
			staticLink = "StaticLink",
			closeButton = "CloseButton",
			carouselDistribution = "CarouselDistribution",
			progressControl = "ProgressControl",
			groupedDistribution = "GroupedDistribution",
			toggleButtonStateTrigger = "ToggleButtonStateTrigger"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<ModalChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .scrollableColumn:
				if let content = try? container.decode(ScrollableColumnModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .scrollableColumn(content)
					return
				}
			case .scrollableRow:
				if let content = try? container.decode(ScrollableRowModel<ScrollableOuterLayoutChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .scrollableRow(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<ModalChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<ModalChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .accessibilityGrouped:
				if let content = try? container.decode(AccessibilityGroupedModel<AccessibilityGroupedLayoutChildren>.self, forKey: .node) {
					self = .accessibilityGrouped(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .richText:
				if let content = try? container.decode(RichTextModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .richText(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .progressIndicator:
				if let content = try? container.decode(ProgressIndicatorModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .progressIndicator(content)
					return
				}
			case .oneByOneDistribution:
				if let content = try? container.decode(OneByOneDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .oneByOneDistribution(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<ModalChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			case .staticLink:
				if let content = try? container.decode(StaticLinkModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .staticLink(content)
					return
				}
			case .closeButton:
				if let content = try? container.decode(CloseButtonModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .closeButton(content)
					return
				}
			case .carouselDistribution:
				if let content = try? container.decode(CarouselDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .carouselDistribution(content)
					return
				}
			case .progressControl:
				if let content = try? container.decode(ProgressControlModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .progressControl(content)
					return
				}
			case .groupedDistribution:
				if let content = try? container.decode(GroupedDistributionModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .groupedDistribution(content)
					return
				}
			case .toggleButtonStateTrigger:
				if let content = try? container.decode(ToggleButtonStateTriggerModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .toggleButtonStateTrigger(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(ModalChildren.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ModalChildren"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableColumn(let content):
			try container.encode(CodingKeys.scrollableColumn, forKey: .type)
			try container.encode(content, forKey: .node)
		case .scrollableRow(let content):
			try container.encode(CodingKeys.scrollableRow, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .accessibilityGrouped(let content):
			try container.encode(CodingKeys.accessibilityGrouped, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .richText(let content):
			try container.encode(CodingKeys.richText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressIndicator(let content):
			try container.encode(CodingKeys.progressIndicator, forKey: .type)
			try container.encode(content, forKey: .node)
		case .oneByOneDistribution(let content):
			try container.encode(CodingKeys.oneByOneDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticLink(let content):
			try container.encode(CodingKeys.staticLink, forKey: .type)
			try container.encode(content, forKey: .node)
		case .closeButton(let content):
			try container.encode(CodingKeys.closeButton, forKey: .type)
			try container.encode(content, forKey: .node)
		case .carouselDistribution(let content):
			try container.encode(CodingKeys.carouselDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .progressControl(let content):
			try container.encode(CodingKeys.progressControl, forKey: .type)
			try container.encode(content, forKey: .node)
		case .groupedDistribution(let content):
			try container.encode(CodingKeys.groupedDistribution, forKey: .type)
			try container.encode(content, forKey: .node)
		case .toggleButtonStateTrigger(let content):
			try container.encode(CodingKeys.toggleButtonStateTrigger, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public enum LayoutDisplayPreset: String, Codable {
	case fullScreen = "FULLSCREEN"
	case embedded = "EMBEDDED"
	case bottomSheet = "BOTTOMSHEET"
}

public indirect enum OuterLayoutNonInteractableChildren: Codable {
	case row(RowModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case column(ColumnModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case zStack(ZStackModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)
	case staticImage(StaticImageModel<OuterLayoutWhenPredicate>)
	case basicText(BasicTextModel<OuterLayoutWhenPredicate>)
	case when(WhenModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			zStack = "ZStack",
			staticImage = "StaticImage",
			basicText = "BasicText",
			when = "When"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<OuterLayoutNonInteractableChildren, OuterLayoutWhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(OuterLayoutNonInteractableChildren.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for OuterLayoutNonInteractableChildren"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public indirect enum LayoutVariantNonInteractableChildren: Codable {
	case row(RowModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case column(ColumnModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case zStack(ZStackModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)
	case basicText(BasicTextModel<LayoutVariantWhenPredicate>)
	case staticImage(StaticImageModel<LayoutVariantWhenPredicate>)
	case dataImage(DataImageModel<LayoutVariantWhenPredicate>)
	case when(WhenModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			zStack = "ZStack",
			basicText = "BasicText",
			staticImage = "StaticImage",
			dataImage = "DataImage",
			when = "When"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .dataImage:
				if let content = try? container.decode(DataImageModel<LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .dataImage(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<LayoutVariantNonInteractableChildren, LayoutVariantWhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(LayoutVariantNonInteractableChildren.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for LayoutVariantNonInteractableChildren"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .dataImage(let content):
			try container.encode(CodingKeys.dataImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public indirect enum NonInteractableChildren: Codable {
	case row(RowModel<NonInteractableChildren, WhenPredicate>)
	case column(ColumnModel<NonInteractableChildren, WhenPredicate>)
	case zStack(ZStackModel<NonInteractableChildren, WhenPredicate>)
	case basicText(BasicTextModel<WhenPredicate>)
	case staticImage(StaticImageModel<WhenPredicate>)
	case dataImage(DataImageModel<WhenPredicate>)
	case when(WhenModel<NonInteractableChildren, WhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			zStack = "ZStack",
			basicText = "BasicText",
			staticImage = "StaticImage",
			dataImage = "DataImage",
			when = "When"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<NonInteractableChildren, WhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<NonInteractableChildren, WhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<NonInteractableChildren, WhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			case .basicText:
				if let content = try? container.decode(BasicTextModel<WhenPredicate>.self, forKey: .node) {
					self = .basicText(content)
					return
				}
			case .staticImage:
				if let content = try? container.decode(StaticImageModel<WhenPredicate>.self, forKey: .node) {
					self = .staticImage(content)
					return
				}
			case .dataImage:
				if let content = try? container.decode(DataImageModel<WhenPredicate>.self, forKey: .node) {
					self = .dataImage(content)
					return
				}
			case .when:
				if let content = try? container.decode(WhenModel<NonInteractableChildren, WhenPredicate>.self, forKey: .node) {
					self = .when(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(NonInteractableChildren.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for NonInteractableChildren"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		case .basicText(let content):
			try container.encode(CodingKeys.basicText, forKey: .type)
			try container.encode(content, forKey: .node)
		case .staticImage(let content):
			try container.encode(CodingKeys.staticImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .dataImage(let content):
			try container.encode(CodingKeys.dataImage, forKey: .type)
			try container.encode(content, forKey: .node)
		case .when(let content):
			try container.encode(CodingKeys.when, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public indirect enum AccessibilityGroupedLayoutChildren: Codable {
	case row(RowModel<AccessibilityGroupedLayoutChildren, WhenPredicate>)
	case column(ColumnModel<AccessibilityGroupedLayoutChildren, WhenPredicate>)
	case zStack(ZStackModel<AccessibilityGroupedLayoutChildren, WhenPredicate>)

	enum CodingKeys: String, CodingKey, Codable {
		case row = "Row",
			column = "Column",
			zStack = "ZStack"
	}

	private enum ContainerCodingKeys: String, CodingKey {
		case type, node
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
		if let type = try? container.decode(CodingKeys.self, forKey: .type) {
			switch type {
			case .row:
				if let content = try? container.decode(RowModel<AccessibilityGroupedLayoutChildren, WhenPredicate>.self, forKey: .node) {
					self = .row(content)
					return
				}
			case .column:
				if let content = try? container.decode(ColumnModel<AccessibilityGroupedLayoutChildren, WhenPredicate>.self, forKey: .node) {
					self = .column(content)
					return
				}
			case .zStack:
				if let content = try? container.decode(ZStackModel<AccessibilityGroupedLayoutChildren, WhenPredicate>.self, forKey: .node) {
					self = .zStack(content)
					return
				}
			}
		}
		throw DecodingError.typeMismatch(AccessibilityGroupedLayoutChildren.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AccessibilityGroupedLayoutChildren"))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ContainerCodingKeys.self)
		switch self {
		case .row(let content):
			try container.encode(CodingKeys.row, forKey: .type)
			try container.encode(content, forKey: .node)
		case .column(let content):
			try container.encode(CodingKeys.column, forKey: .type)
			try container.encode(content, forKey: .node)
		case .zStack(let content):
			try container.encode(CodingKeys.zStack, forKey: .type)
			try container.encode(content, forKey: .node)
		}
	}
}

public enum DimensionWidthFitValue: String, Codable {
	case wrapContent = "wrap-content"
	case fitWidth = "fit-width"
}

public enum DimensionHeightFitValue: String, Codable {
	case wrapContent = "wrap-content"
	case fitHeight = "fit-height"
}
