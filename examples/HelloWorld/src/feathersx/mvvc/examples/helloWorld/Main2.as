/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc.examples.helloWorld {
import com.demonsters.debugger.MonsterDebugger;

import feathers.themes.MetalWorksMobileTheme;

import feathersx.mvvc.ViewController;

import starling.display.Sprite;
import starling.events.Event;

public class Main2 extends Sprite {
    public function Main2() {
        super();
        // Start the MonsterDebugger with a Starling display object
        MonsterDebugger.initialize(this);
        MonsterDebugger.trace(this, "Hello World!");
        this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }
    private var rootViewController: ViewController;
    protected function addedToStageHandler(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        new MetalWorksMobileTheme();

        this.rootViewController = new MainController();
//        this.rootViewController = new AViewController();
        this.rootViewController.setAsRootViewController(this);
    }
}
}
