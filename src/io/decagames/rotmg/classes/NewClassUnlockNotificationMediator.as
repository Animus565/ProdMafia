package io.decagames.rotmg.classes {
import robotlegs.bender.bundles.mvcs.Mediator;

public class NewClassUnlockNotificationMediator extends Mediator {

    public function NewClassUnlockNotificationMediator() {
        super();
    }

    [Inject]
    public var view:NewClassUnlockNotification;
    [Inject]
    public var newClassUnlockSignal:NewClassUnlockSignal;

    override public function initialize():void {
        this.newClassUnlockSignal.add(this.onNewClassUnlocked);
    }

    override public function destroy():void {
        super.destroy();
        this.newClassUnlockSignal.remove(this.onNewClassUnlocked);
    }

    private function onNewClassUnlocked(param1:Array):void {
        this.view.playNotification(param1);
    }
}
}
