//
//  CircularSlider.swift
//
//  Created by Christopher Olsen on 03/03/16.
//  Copyright © 2016 Christopher Olsen. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

enum CircularSliderHandleType {
  case semiTransparentWhiteSmallCircle,
  semiTransparentWhiteCircle,
  semiTransparentBlackCircle,
  bigCircle,
  custom
}

class CircularSlider: UIControl {

    var lastAngle : CGFloat = 0
    var circleToggle = 0
    var leftToggle = 0
    var count = 0
    var setcount = 0
    
  // MARK: Values
  // Value at North/midnight (start)
  var minimumValue: Float = 0.0 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  // Value at North/midnight (end)
  var maximumValue: Float = 100.0 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  // value for end of arc. This allows for incomplete circles to be created
  var maximumAngle: CGFloat = 360.0 {
    didSet {
      if maximumAngle > 360.0 {
        print("Warning: Maximum angle should be 360 or less.")
        maximumAngle = 360.0
      }
      setNeedsDisplay()
    }
  }
  
  // Current value between North/midnight (start) and North/midnight (end) - clockwise direction
  var currentValue: Float {
    set {
      assert(newValue <= maximumValue && newValue >= minimumValue, "current value \(newValue) must be between minimumValue \(minimumValue) and maximumValue \(maximumValue)")
      // Update the angleFromNorth to match this newly set value
        
      angleFromNorth = Int((newValue * Float(maximumAngle)) / (maximumValue - minimumValue))
      moveHandle(CGFloat(angleFromNorth))
      
    } get {
        return (Float(angleFromNorth) * (maximumValue - minimumValue)) / Float(maximumAngle)
    }
  }

  // MARK: Handle
  let circularSliderHandle = CircularSliderHandle()
 
  /**
   *  Note: If this property is not set, filledColor will be used.
   *        If handleType is semiTransparent*, specified color will override this property.
   *
   *  Color of the handle
   */
  var handleColor: UIColor? {
    didSet {
      setNeedsDisplay()
    }
  }
  

  // Type of the handle to display to represent draggable current value
  var handleType: CircularSliderHandleType = .semiTransparentWhiteSmallCircle {
    didSet {
      setNeedsUpdateConstraints()
      setNeedsDisplay()
    }
  }
  
  // MARK: Labels
  // BOOL indicating whether values snap to nearest label
  var snapToLabels: Bool = false
  
  /**
  *  Note: The LAST label will appear at North/midnight
  *        The FIRST label will appear at the first interval after North/midnight
  *
  *  NSArray of strings used to render labels at regular intervals within the circle
  */
  var innerMarkingLabels: [String]? {
    didSet {
      setNeedsUpdateConstraints()
      setNeedsDisplay()
    }
  }
  
  
  // MARK: Visual Customisation
  // property Width of the line to draw for slider
  var lineWidth: Int = 12 {
    didSet {
      setNeedsUpdateConstraints() // This could affect intrinsic content size
      invalidateIntrinsicContentSize() // Need to update intrinsice content size
      setNeedsDisplay() // Need to redraw with new line width
    }
  }
  
  // Color of filled portion of line (from North/midnight start to currentValue)
  var filledColor: UIColor = .cyan {
    didSet {
      setNeedsDisplay()
    }
  }
  
 // Color of unfilled portion of line (from currentValue to North/midnight end)
  var unfilledColor: UIColor = .white {
    didSet {
      setNeedsDisplay()
    }
  }

  // Font of the inner marking labels within the circle
  var labelFont: UIFont = .systemFont(ofSize: 10.0) {
    didSet {
      setNeedsDisplay()
    }
  }
  
  // Color of the inner marking labels within the circle
  var labelColor: UIColor = .red {
    didSet {
      setNeedsDisplay()
    }
  }
  
  /**
  *  Note: A negative value will move the label closer to the center. A positive value will move the label closer to the circumference
  *  Value with which to displace all labels along radial line from center to slider circumference.
  */
  var labelDisplacement: CGFloat = 0
  
  // type of LineCap to use for the unfilled arc
  // NOTE: user CGLineCap.Butt for full circles
  var unfilledArcLineCap: CGLineCap = .butt
  
  // type of CGLineCap to use for the arc that is filled in as the handle moves
  var filledArcLineCap: CGLineCap = .butt
  
  // MARK: Computed Public Properties
  var computedRadius: CGFloat {
    if (radius == -1.0) {
      // Slider is being used in frames - calculate the max radius based on the frame
      //  (constrained by smallest dimension so it fits within view)
      let minimumDimension = min(bounds.size.height - 18 , bounds.size.width - 18)
      let halfLineWidth = ceilf(Float(lineWidth) / 2.0)
      let halfHandleWidth = ceilf(Float(handleWidth) / 2.0)
      return minimumDimension * 0.5 - CGFloat(max(halfHandleWidth, halfLineWidth))
    }
    return radius
  }
  
  var centerPoint: CGPoint {
    return CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
  }
  
  var angleFromNorth: Int = 0 {
    didSet {
      assert(angleFromNorth >= 0, "angleFromNorth \(angleFromNorth) must be greater than 0")
    }
  }
  
  var handleWidth: CGFloat {
    switch handleType {
    case .semiTransparentWhiteSmallCircle:
      return CGFloat(lineWidth / 2)
    case .semiTransparentWhiteCircle, .semiTransparentBlackCircle:
      return CGFloat(lineWidth)
    case .bigCircle:
      return CGFloat(lineWidth + 5) // 5 points bigger than standard handles
    case .custom:
        return CGFloat(lineWidth + 40)
    }
  }

  // MARK: Private Variables
  fileprivate var radius: CGFloat = -1.0 {
    didSet {
      setNeedsUpdateConstraints()
      setNeedsDisplay()
    }
  }
  
  fileprivate var computedHandleColor: UIColor? {
    var newHandleColor = handleColor
    
    switch (handleType) {
    case .semiTransparentWhiteSmallCircle, .semiTransparentWhiteCircle:
      newHandleColor = UIColor(white: 1.0, alpha: 0.7)
    case .semiTransparentBlackCircle:
      newHandleColor = UIColor(white: 0.0, alpha: 0.7)
    case .bigCircle:
      newHandleColor = filledColor
    case .custom:
      
        newHandleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    return newHandleColor
  }
  
  fileprivate var innerLabelRadialDistanceFromCircumference: CGFloat {
    // Labels should be moved far enough to clear the line itself plus a fixed offset (relative to radius).
    var distanceToMoveInwards = 0.1 * -(radius) - 0.5 * CGFloat(lineWidth)
    distanceToMoveInwards -= 0.5 * labelFont.pointSize // Also account for variable font size.
    return distanceToMoveInwards
  }
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = .clear
  }
  
  // TODO: initializer for autolayout
  /**
   *  Initialise the class with a desired radius
   *  This initialiser should be used for autolayout - use initWithFrame otherwise
   *  Note: Intrinsic content size will be based on this parameter, lineWidth and handleType
   *
   *  radiusToSet Desired radius of circular slider
   */
//  convenience init(radiusToSet: CGFloat) {
//
//  }
  
  // MARK: - Function Overrides
  override var intrinsicContentSize : CGSize {
    // Total width is: diameter + (2 * MAX(halfLineWidth, halfHandleWidth))
    let diameter = radius * 2
    let halfLineWidth = ceilf(Float(lineWidth) / 2.0)
    let halfHandleWidth = ceilf(Float(handleWidth) / 2.0)
    
    let widthWithHandle = diameter + CGFloat(2 *  max(halfHandleWidth, halfLineWidth))
    
    return CGSize(width: widthWithHandle, height: widthWithHandle)
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let ctx = UIGraphicsGetCurrentContext()
    
    // Draw the circular lines that slider handle moves along
    drawLine(ctx!)
    
    // Draw the draggable 'handle'
    let handleCenter = pointOnCircleAtAngleFromNorth(angleFromNorth)
    circularSliderHandle.frame = drawHandle(ctx!, atPoint: handleCenter)
    
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    guard event != nil else { return false }
    
    if pointInsideHandle(point, withEvent: event!) {
      return true
    } else {
      return pointInsideCircle(point, withEvent: event!)
    }
  }
  
  fileprivate func pointInsideCircle(_ point: CGPoint, withEvent event: UIEvent) -> Bool {
    let p1 = centerPoint
    let p2 = point
    let xDist = p2.x - p1.x
    let yDist = p2.y - p1.y
    let distance = sqrt((xDist * xDist) + (yDist * yDist))
    return distance < computedRadius + CGFloat(lineWidth) * 0.5
  }

  fileprivate func pointInsideHandle(_ point: CGPoint, withEvent event: UIEvent) -> Bool {
    let handleCenter = pointOnCircleAtAngleFromNorth(angleFromNorth)
    // Adhere to apple's design guidelines - avoid making touch targets smaller than 44 points
    let handleRadius = max(handleWidth, 44.0) * 0.5

    // Treat handle as a box around it's center
    let pointInsideHorzontalHandleBounds = (point.x >= handleCenter.x - handleRadius && point.x <= handleCenter.x + handleRadius)
    let pointInsideVerticalHandleBounds  = (point.y >= handleCenter.y - handleRadius && point.y <= handleCenter.y + handleRadius)
    return pointInsideHorzontalHandleBounds && pointInsideVerticalHandleBounds
  }
  
  // MARK: - Drawing methods
  func drawLine(_ ctx: CGContext) {
    unfilledColor.set()
    // Draw an unfilled circle (this shows what can be filled)
    CircularTrig.drawUnfilledCircleInContext(ctx, center: centerPoint, radius: computedRadius, lineWidth: CGFloat(lineWidth), maximumAngle: maximumAngle, lineCap: unfilledArcLineCap)
    
    filledColor.set()
    // Draw an unfilled arc up to the currently filled point
    CircularTrig.drawUnfilledArcInContext(ctx, center: centerPoint, radius: computedRadius, lineWidth: CGFloat(lineWidth), fromAngleFromNorth: 0, toAngleFromNorth: CGFloat(angleFromNorth), lineCap: filledArcLineCap)
  }
  
  func drawHandle(_ ctx: CGContext, atPoint handleCenter: CGPoint) -> CGRect {
    ctx.saveGState()
    var frame: CGRect!
    
    // Ensure that handle is drawn in the correct color
    handleColor = computedHandleColor
    handleColor!.set()
   
    
   
    
    frame = CircularTrig.drawFilledCircleInContext(ctx, center: handleCenter, radius: 0.6 * handleWidth)

 
    
    ctx.saveGState()
    return frame
  }
  
    func drawPrint(_ ctx: CGContext, atPoint handleCenter: CGPoint) -> CGRect {
        ctx.saveGState()
        var frame: CGRect!
        
        // Ensure that handle is drawn in the correct color
        handleColor = computedHandleColor
        handleColor!.set()
        
        
        
        
        frame = CircularTrig.drawFilledCircleInContext(ctx, center: handleCenter, radius: 1.4 * handleWidth)
        
        
        
        ctx.saveGState()
        return frame
    }
   
   
   
  // MARK: - UIControl Functions
  
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
         let lastPoint = touch.location(in: self.superview)
        if( count <= 1 && lastAngle > 345)
        {
            returnHandle()
            self.count = 0
            return false
            
        }
        if( count <  5 && lastAngle > 270){
            self.count = 0
            return false
        }
        if(count > 5 && lastAngle > 330)
        {circleToggle = 1
        
        completed()
        return false
        }
   
    self.lastAngle = floor(CircularTrig.angleRelativeToNorthFromPoint(centerPoint, toPoint: lastPoint))
    moveHandle(self.lastAngle)
    sendActions(for: UIControlEvents.valueChanged)
    count += 1
    return true
  
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(circleToggle != 1){
            returnHandle()
            self.count = 0
        }
    }
    func completed(){
    
        self.filledColor = UIColor.green
        moveHandle(359.5)
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.returnHandle()
            self.filledColor = UIColor.cyan
          
           self.circleToggle = 0
           self.sendActions(for: UIControlEvents.primaryActionTriggered)
        }
        
    }
   func moveHandle(_ newAngleFromNorth: CGFloat) {
 
    // prevent slider from moving past maximumAngle
      angleFromNorth = Int(newAngleFromNorth)
    
    setNeedsDisplay()

    }
       func pushHandle() {
        
        if(self.lastAngle > 5){
        let pushAngle = self.lastAngle - 5
        self.lastAngle -= 5
        moveHandle(pushAngle)
        }
    }
    
    func returnHandle() {
        var check = self.lastAngle
       
       
            repeat{
               
                  self.pushHandle()
             check -= 5
            }  while(check > 5);
        moveHandle(0)
        self.count = 0
            
            
        }
    

  // MARK: - Helper Functions
  func pointOnCircleAtAngleFromNorth(_ angleFromNorth: Int) -> CGPoint {
    let offset = CircularTrig.pointOnRadius(computedRadius, atAngleFromNorth: CGFloat(angleFromNorth))
    return CGPoint(x: centerPoint.x + offset.x, y: centerPoint.y + offset.y)
  }
  
  func sizeOfString(_ string: String, withFont font: UIFont) -> CGSize {
    let attributes = [NSFontAttributeName: font]
    return NSAttributedString(string: string, attributes: attributes).size()
  }
  
  func getRotationalTransform() -> CGAffineTransform {
    if maximumAngle == 360 {
      // do not perform a rotation if using a full circle slider
      let transform = CGAffineTransform.identity.rotated(by: CGFloat(0))
      return transform
    } else {
      // rotate slider view so "north" is at the start
      let radians = Double(-(maximumAngle / 2)) / 180.0 * M_PI
      let transform = CGAffineTransform.identity.rotated(by: CGFloat(radians))
      return transform
    }
  }
}
