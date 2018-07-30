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

    private var _topGuide: Number;
    public function get topGuide(): Number {
        return _topGuide;
    }
    public function set topGuide(value: Number): void {
        _topGuide = value;
        VerticalLayout(layout).paddingTop = value;
    }

    private var _bottomGuide: Number;
    public function get bottomGuide(): Number {
        return _bottomGuide;
    }
    public function set bottomGuide(value: Number): void {
        _bottomGuide = value;
        VerticalLayout(layout).paddingBottom = value;
    }
}
}
