package kabam.rotmg.tooltips.view {
import flash.display.DisplayObject;
import flash.display.Sprite;

public class TooltipsView extends Sprite {

    public function TooltipsView() {
        super();
    }

    private var toolTip:DisplayObject;

    public function show(param1:DisplayObject):void {
        this.hide();
        this.toolTip = param1;
        if (param1) {
            addChild(param1);
        }
    }

    public function hide():void {
        if (this.toolTip && this.toolTip.parent) {
            this.toolTip.parent.removeChild(this.toolTip);
        }
        this.toolTip = null;
    }
}
}
