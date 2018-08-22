/**
 * Created by max.rozdobudko@gmail.com on 7/23/17.
 */
package feathersx.mvvc.examples.helloWorld.view {
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.layout.HorizontalAlign;
import feathers.layout.VerticalAlign;
import feathers.layout.VerticalLayout;

public class AView extends LayoutGroup {
    public function AView() {
        super();

        var layout: VerticalLayout = new VerticalLayout();
        layout.horizontalAlign = HorizontalAlign.CENTER;
        layout.verticalAlign = VerticalAlign.MIDDLE;

        this.layout = layout;

        pushScreenB1Button = new Button();
        pushScreenB1Button.label = "Push Screen B1";
        addChild(pushScreenB1Button);

        pushScreenSButton = new Button();
        pushScreenSButton.label = "Push Screen S";
        addChild(pushScreenSButton);

        presentScreenDButton = new Button();
        presentScreenDButton.label = "Present Screen D (Modal)";
        addChild(presentScreenDButton);

        showAlertButton = new Button();
        showAlertButton.label = "Show Alert";
        addChild(showAlertButton);
    }

    public var pushScreenB1Button:Button;
    public var pushScreenSButton:Button;
    public var presentScreenDButton:Button;
    public var showAlertButton: Button;

    override protected function initialize(): void {
        super.initialize();
        pushScreenB1Button.validate();
        pushScreenSButton.validate();
        presentScreenDButton.validate();
    }
}
}
