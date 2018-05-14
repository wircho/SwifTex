//
//  TikzOperators.swift
//  SwifTeX
//
//  Created by Adolfo Rodriguez on 2018-05-15.
//  Copyright © 2018 Wircho. All rights reserved.
//

public func <-(lhs: inout Tikz, rhs: TikzPath) { lhs.elements.append(rhs) }
public func <-(lhs: inout Tikz, rhs: AnyTikzItem) { lhs.elements.append(rhs) }

// MARK: - TikzPathExtendable

infix operator --: MultiplicationPrecedence

// MARK: Item -- Item

public func --(lhs: AnyTikzItem, rhs: AnyTikzItem) -> TikzPath { return TikzPath(lhs, rhs) }
public func --(lhs: TikzPath, rhs: AnyTikzItem) -> TikzPath {
    var path = lhs
    path.items.append(rhs)
    return path
}

// MARK: Item -- Point

public func --(lhs: TikzPoint.Raw, rhs: TikzPoint.Raw) -> TikzPath { return TikzPath(AnyTikzItem(lhs), AnyTikzItem(rhs)) }
public func --(lhs: AnyTikzItem, rhs: TikzPoint.Raw) -> TikzPath { return TikzPath(lhs, AnyTikzItem(rhs)) }
public func --(lhs: TikzPoint.Raw, rhs: AnyTikzItem) -> TikzPath { return TikzPath(AnyTikzItem(lhs), rhs) }
public func --(lhs: TikzPath, rhs: TikzPoint.Raw) -> TikzPath {
    var path = lhs
    path.items.append(AnyTikzItem(rhs))
    return path
}

// MARK: - Style | Path

public func |(lhs: TikzStyle, rhs: TikzPath) -> TikzPath { return TikzPath(style: lhs, rhs.items) }
public func |(lhs: TikzStyle, rhs: AnyTikzItem) -> TikzPath { return TikzPath(style: lhs, rhs) }

// MARK: - Length | Raw

public func |(lhs: LengthProtocol, rhs: TikzPath) -> TikzPath { return TikzStyle(lhs) | rhs }
public func |(lhs: LengthProtocol, rhs: AnyTikzItem) -> TikzPath { return TikzStyle(lhs) | rhs }
