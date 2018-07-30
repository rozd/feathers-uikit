/**
 * Created by max.rozdobudko@gmail.com on 7/26/17.
 */
package feathersx.mvvc.examples.helloWorld.view {
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.layout.VerticalLayout;

public class B1View extends LayoutGroup {
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
}
}
