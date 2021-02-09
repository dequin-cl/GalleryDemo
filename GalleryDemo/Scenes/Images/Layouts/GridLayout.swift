//
//  GridLayout.swift
//  A Grid layout for UICollectionView
//
//  Based on Pinterest layout created by Astemir Eleev
//

import UIKit

protocol GridLayoutDelegate: class {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class GridLayout: UICollectionViewLayout {

  // MARK: - Propertiess

  weak var delegate: GridLayoutDelegate!

  // Layout configuration properties
  fileprivate var numberOfColumns: Int {
    return (UIApplication.shared.statusBarOrientation == .landscapeLeft ||
              UIApplication.shared.statusBarOrientation == .landscapeRight) ? 4: 3
  }

  fileprivate var cellPadding: CGFloat = 3

  // An array to cache the calculated attributes. When you call prepare(), you’ll calculate the attributes for all items and add them to the cache. When the collection view later requests the layout attributes, you can be efficient and query the cache instead of recalculating them every time
  fileprivate var cache = [UICollectionViewLayoutAttributes]()
  fileprivate var contentHeight: CGFloat = 0

  fileprivate var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }

  // MARK: - Overrides

  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func prepare() {
    super.prepare()
    // Only calculate the layout attributes if cache is empty and the collection view exists
    guard cache.isEmpty == true, let collectionView = collectionView else {
      return
    }
    let currentNumberOfColumns = numberOfColumns
    let columnWidth = contentWidth / CGFloat(currentNumberOfColumns)
    var xOffset = [CGFloat]()

    for column in 0 ..< currentNumberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset = [CGFloat](repeating: 0, count: currentNumberOfColumns)

    for item in 0 ..< collectionView.numberOfItems(inSection: 0) {

      let indexPath = IndexPath(item: item, section: 0)

      // Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
      let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

      // Creates an UICollectionViewLayoutItem with the frame and add it to the cache
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)

      // Updates the collection view content height
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height

      column = column < (currentNumberOfColumns - 1) ? (column + 1) : 0
    }
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  override func invalidateLayout() {
    super.invalidateLayout()
    cache.removeAll()
  }

}
