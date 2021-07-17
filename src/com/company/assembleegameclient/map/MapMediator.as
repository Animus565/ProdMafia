package com.company.assembleegameclient.map {
import kabam.rotmg.game.view.components.QueuedStatusText;

import robotlegs.bender.bundles.mvcs.Mediator;

public class MapMediator extends Mediator {

    public function MapMediator() {
        super();
    }

    [Inject]
    public var view:Map;
    [Inject]
    public var queueStatusText:QueueStatusTextSignal;

    override public function initialize():void {
        this.queueStatusText.add(this.onQueuedStatusText);
    }

    override public function destroy():void {
        this.queueStatusText.remove(this.onQueuedStatusText);
    }

    private function onQueuedStatusText(param1:String, param2:uint):void {
    }

    private function queueText(param1:String, param2:uint):void {
        var _loc3_:QueuedStatusText = new QueuedStatusText(this.view.player_, param1, param2, 2000, 0);
        this.view.mapOverlay_.addQueuedText(_loc3_);
    }
}
}
