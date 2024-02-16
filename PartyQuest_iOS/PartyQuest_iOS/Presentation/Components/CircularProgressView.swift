import Foundation
import UIKit

final class CircularProgressView: UIView {
    private var progressLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = PQColor.buttonMain
        label.font = PQFont.cellTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(percentLabel)
        configureProgressViewToBeCircular()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureProgressViewToBeCircular()
    }
    
    var setProgressColor: UIColor = UIColor.red {
        didSet {
            progressLayer.strokeColor = setProgressColor.cgColor
        }
    }
    
    var setTrackColor: UIColor = UIColor.white {
        didSet {
            trackLayer.strokeColor = setTrackColor.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        prepareToReuse()
        configureProgressViewToBeCircular()
        setConstraints()
    }
    
    func prepareToReuse() {
        progressLayer.removeFromSuperlayer()
        trackLayer.removeFromSuperlayer()

        configureProgressViewToBeCircular()
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.percentLabel.text = "\(Int(value * 100)) %"

            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = 0
            animation.toValue = value
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

            self.progressLayer.strokeEnd = CGFloat(value)
            self.progressLayer.add(animation, forKey: "animateCircle")
        }
    }
    
    private func configureProgressViewToBeCircular() {
        trackLayer = createShapeLayer(strokeColor: setTrackColor.cgColor, lineWidth: 8.0, strokeEnd: 1.0)
        progressLayer = createShapeLayer(strokeColor: setProgressColor.cgColor, lineWidth: 8.0, strokeEnd: 0.0)
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }
    
    private func createShapeLayer(strokeColor: CGColor, lineWidth: CGFloat, strokeEnd: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
            radius: frame.size.width / 4.0,
            startAngle: CGFloat(-0.5 * Double.pi),
            endAngle: CGFloat(1.5 * Double.pi),
            clockwise: true
        ).cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.strokeColor = strokeColor
        layer.lineWidth = lineWidth
        layer.strokeEnd = strokeEnd
        
        return layer
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
