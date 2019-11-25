/**
 * Created by max.rozdobudko@gmail.com on 25.11.2019.
 */
package screens.issue3 {
import feathers.controls.LayoutGroup;

import feathersx.mvvc.WindowDecorator;

public class Issue3Tab extends LayoutGroup {
    public function Issue3Tab() {
        super();

        new WindowDecorator(this).rootViewController = new MainController(new Issue3ViewController(new Issue3ViewModel()));
    }
}
}
