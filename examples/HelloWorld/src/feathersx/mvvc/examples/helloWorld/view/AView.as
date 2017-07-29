/**
 * Created by max.rozdobudko@gmail.com on 7/23/17.
 */
package feathersx.mvvc.examples.helloWorld.view {
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.controls.TextCallout;

import starling.events.Event;

public class AView extends LayoutGroup {
    public function AView() {
        super();
    }

    public var button:Button;

    override protected function initialize(): void {
        super.initialize();

        //create a button and give it some text to display.
        this.button = new Button();
        this.button.label = "Push Screen B1";

        //an event that tells us when the user has tapped the button.
//        this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
        //add the button to the display list, just like you would with any
        //other Starling display object. this is where the theme give some
        //skins to the button.
        this.addChild(this.button);

        //the button won't have a width and height until it "validates". it
        //will validate on its own before the next frame is rendered by
        //Starling, but we want to access the dimension immediately, so tell
        //it to validate right now.
        this.button.validate();

        //center the button
        this.button.x = Math.round((this.stage.stageWidth - this.button.width) / 2);
        this.button.y = Math.round((this.stage.stageHeight - this.button.height) / 2);
    }

    /**
     * Listener for the Button's Event.TRIGGERED event.
     */
    protected function button_triggeredHandler(event:Event):void
    {
        TextCallout.show("Hi, I'm Feathers!\nHave a nice day.", this.button);
    }
}
}
