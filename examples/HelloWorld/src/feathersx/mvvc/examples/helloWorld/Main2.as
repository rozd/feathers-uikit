/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc.examples.helloWorld {
import feathers.themes.MetalWorksMobileTheme;

import feathersx.mvvc.WindowDecorator;

import starling.display.Sprite;
import starling.events.Event;

public class Main2 extends Sprite {

    public function Main2() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    protected function addedToStageHandler(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        new MetalWorksMobileTheme();

        new WindowDecorator(this).rootViewController = new MainController();
    }
}
}
