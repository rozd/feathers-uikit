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
        this.layout = new VerticalLayout();
    }

    public var popToScreenAButton:Button;
    public var pushScreenCButton:Button;
    public var replaceWithScreenB2Button:Button;


    override protected function initialize(): void {
        super.initialize();

        this.popToScreenAButton = new Button();
        this.popToScreenAButton.label = "Pop to Sreen A";
        this.addChild(this.popToScreenAButton);
        this.popToScreenAButton.validate();

        this.pushScreenCButton = new Button();
        this.pushScreenCButton.label = "Push Screen C";
        this.addChild(this.pushScreenCButton);
        this.pushScreenCButton.validate();

        this.replaceWithScreenB2Button = new Button();
        this.replaceWithScreenB2Button.label = "Repalce with Screen B2";
        this.addChild(this.replaceWithScreenB2Button);
        this.replaceWithScreenB2Button.validate();
    }
}
}
