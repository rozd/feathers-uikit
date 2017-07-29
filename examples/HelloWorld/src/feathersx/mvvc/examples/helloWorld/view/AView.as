/**
 * Created by max.rozdobudko@gmail.com on 7/23/17.
 */
package feathersx.mvvc.examples.helloWorld.view {
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.controls.TextCallout;
import feathers.layout.VerticalLayout;

import starling.events.Event;

public class AView extends LayoutGroup {
    public function AView() {
        super();
        layout = new VerticalLayout();
    }

    public var pushScreenB1Button:Button;

    public var presentScreenDButton:Button;

    override protected function initialize(): void {
        super.initialize();

        pushScreenB1Button = new Button();
        pushScreenB1Button.label = "Push Screen B1";
        addChild(pushScreenB1Button);
        pushScreenB1Button.validate();

        presentScreenDButton = new Button();
        presentScreenDButton.label = "Present Screen D (Modally)";
        addChild(presentScreenDButton);
        presentScreenDButton.validate();
    }

    /**
     * Listener for the Button's Event.TRIGGERED event.
     */
    protected function button_triggeredHandler(event:Event):void
    {
        TextCallout.show("Hi, I'm Feathers!\nHave a nice day.", pushScreenB1Button);
    }
}
}
