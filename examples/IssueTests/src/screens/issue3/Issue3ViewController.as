/**
 * Created by max.rozdobudko@gmail.com on 25.11.2019.
 */
package screens.issue3 {
import feathers.controls.Button;

import feathersx.mvvc.ViewController;

import starling.display.DisplayObject;
import starling.events.Event;

public class Issue3ViewController extends ViewController {

    // MARK: Constructor

    public function Issue3ViewController(viewModel: Issue3ViewModel) {
        super();
        this.viewModel = viewModel;
    }

    // MARK: View model

    public var viewModel: Issue3ViewModel;

    // MARK: Outlets

    public function get testButton(): Button {
        return Issue3View(view).testButton;
    }

    // MARK: View lifecycle

    override protected function loadView(): DisplayObject {
        return new Issue3View();
    }

    override protected function viewDidLoad(): void {
        super.viewDidLoad();

        // view

        testButton.addEventListener(Event.TRIGGERED, testButton_triggeredHandler);
    }
    
    // MARK: Tests

    public function testDoubleDismissWithAnimation(): void {
        var popover: PopoverViewController = presentPopoverFrom(this);
        
        popover.dismiss(true);
        popover.dismiss(true);
    }

    public function testDoubleDismissWithoutAnimation(): void {
        var popover: PopoverViewController = presentPopoverFrom(this);

        popover.dismiss(false);
        popover.dismiss(false);
    }

    // MARK: Navigation

    public function presentPopoverFrom(vc: ViewController): PopoverViewController {
        var popover: PopoverViewController = new PopoverViewController();
        vc.present(popover, true);
        return popover;
    }

    // MARK: Handlers

    private function testButton_triggeredHandler(event: Event): void {
        testDoubleDismissWithAnimation();
    }
}
}
