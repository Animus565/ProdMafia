package kabam.rotmg.external.command {
import kabam.lib.tasks.DispatchSignalTask;
import kabam.lib.tasks.TaskMonitor;
import kabam.lib.tasks.TaskSequence;
import kabam.rotmg.external.service.RequestPlayerCreditsTask;

import org.swiftsuspenders.Injector;

import robotlegs.bender.bundles.mvcs.Command;

public class RequestPlayerCreditsCommand extends Command {

    public function RequestPlayerCreditsCommand() {
        super();
    }

    [Inject]
    public var taskMonitor:TaskMonitor;
    [Inject]
    public var injector:Injector;
    [Inject]
    public var requestPlayerCreditsComplete:RequestPlayerCreditsCompleteSignal;

    override public function execute():void {
        var _loc1_:TaskSequence = new TaskSequence();
        _loc1_.add(this.injector.getInstance(RequestPlayerCreditsTask));
        _loc1_.add(new DispatchSignalTask(this.requestPlayerCreditsComplete));
        this.taskMonitor.add(_loc1_);
        _loc1_.start();
    }
}
}
