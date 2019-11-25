/**
 * Created by max.rozdobudko@gmail.com on 25.11.2019.
 */
package screens.issue3 {
import feathersx.mvvc.NavigationController;
import feathersx.mvvc.ViewController;

import starling.animation.Transitions;

import utils.Tweens;

public class MainController extends NavigationController {

    {
        ViewController.dismissTransition = function dismissTransition(presenting: ViewController, presented: ViewController, complete: Function): void {
            Tweens.shared.tweenWithEase(presented.view, 0.4, {alpha: 0.0}, Transitions.EASE_IN, complete);
        };
    }

    public function MainController(rootViewController: ViewController) {
        super(rootViewController);
    }
}
}
