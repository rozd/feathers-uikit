/**
 * Created by max.rozdobudko@gmail.com on 7/27/18.
 */
package feathersx.mvvc.debug {
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.layout.HorizontalAlign;
import feathers.layout.VerticalLayout;

import feathersx.mvvc.View;

public class DummyView extends LayoutGroup implements View {

    // MARK: Constructor

    public function DummyView() {
        super();
    }

    // MARK: Outlets

    public var popButton: Button;

    //  MARK: topGuide

    private var _topGuide:Number = 0;
    public function get topGuide():Number {
        return _topGuide;
    }
    public function set topGuide(value:Number):void {
        if (_topGuide == value) return;
        _topGuide = value;
    }

    //  MARK: bottomGuide

    private var _bottomGuide: Number = 0;
    public function get bottomGuide():Number {
        return _bottomGuide;
    }
    public function set bottomGuide(value:Number):void {
        if (_bottomGuide == value) return;
        _bottomGuide = value;
    }

    //  MARK: leftGuide

    private var _leftGuide:Number = 0;
    [Bindable(event="leftGuideChanged")]
    public function get leftGuide():Number {
        return _leftGuide;
    }
    public function set leftGuide(value:Number):void {
        if (_leftGuide == value) return;
        _leftGuide = value;
        dispatchEventWith("leftGuideChanged");
    }

    //  MARK: leftGuide

    private var _rightGuide:Number = 0;
    [Bindable(event="rightGuideChanged")]
    public function get rightGuide():Number {
        return _rightGuide;
    }
    public function set rightGuide(value:Number):void {
        if (_rightGuide == value) return;
        _rightGuide = value;
        dispatchEventWith("rightGuideChanged");
    }

    // MARK: Overridden methods

    override protected function initialize(): void {
        super.initialize();

        var layout: VerticalLayout = new VerticalLayout();
        layout.horizontalAlign = HorizontalAlign.CENTER;
        layout.paddingTop = topGuide;
        layout.paddingBottom = bottomGuide;
        this.layout = layout;

        popButton = new Button();
        popButton.label = "Pop";
        addChild(popButton);
    }
}
}
