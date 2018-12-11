/**
 * Created by max.rozdobudko@gmail.com on 7/26/17.
 */
package feathersx.mvvc.examples.helloWorld.view {
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.layout.VerticalLayout;

import feathersx.mvvc.View;

public class B1View extends LayoutGroup implements View {
    public function B1View() {
        super();
        layout = new VerticalLayout();
    }

    public var popToScreenAButton:Button;
    public var pushScreenCButton:Button;
    public var replaceWithScreenB2Button:Button;
    public var showAlertButton: Button;

    override protected function initialize(): void {
        super.initialize();

        popToScreenAButton = new Button();
        popToScreenAButton.label = "Pop to Sreen A";
        addChild(popToScreenAButton);

        pushScreenCButton = new Button();
        pushScreenCButton.label = "Push Screen C";
        addChild(pushScreenCButton);

        replaceWithScreenB2Button = new Button();
        replaceWithScreenB2Button.label = "Replace with Screen B2";
        addChild(replaceWithScreenB2Button);

        showAlertButton = new Button();
        showAlertButton.label = "Show Alert";
        addChild(showAlertButton);
    }

    override public function dispose(): void {
        super.dispose();
    }


    //------------------------------------
    //  topGuide
    //------------------------------------

    private var _topGuide:Number = 0;
    [Bindable(event="topGuideChanged")]
    public function get topGuide():Number {
        return _topGuide;
    }
    public function set topGuide(value:Number):void {
        if (_topGuide == value) return;
        _topGuide = value;
        dispatchEventWith("topGuideChanged");
    }

    //------------------------------------
    //  leftGuide
    //------------------------------------

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

    //------------------------------------
    //  bottomGuide
    //------------------------------------

    private var _bottomGuide: Number = 0;
    [Bindable(event="bottomGuideChanged")]
    public function get bottomGuide():Number {
        return _bottomGuide;
    }
    public function set bottomGuide(value:Number):void {
        if (_bottomGuide == value) return;
        _bottomGuide = value;
        dispatchEventWith("bottomGuideChanged");
    }

    //------------------------------------
    //  rightGuide
    //------------------------------------

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

}
}
