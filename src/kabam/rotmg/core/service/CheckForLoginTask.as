package kabam.rotmg.core.service {
import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.web.signals.LoginSuccessSignal;
import kabam.rotmg.account.web.view.WebLoginDialog;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.OpenDialogSignal;

public class CheckForLoginTask extends BaseTask {
    public function CheckForLoginTask() {
        super();
    }

    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var account:Account;
    [Inject]
    public var loginSuccess:LoginSuccessSignal;
    [Inject]
    public var webLoginDialog:WebLoginDialog;
    [Inject]
    public var openDialog:OpenDialogSignal;

    override protected function startTask():void {
        var account:Account = StaticInjectorContext.getInjector().getInstance(Account);
        if (account.getAccessToken() != null &&
                account.getAccessToken() != "" &&
                account.getAccessToken() != undefined) {
            completeTask(true, "");
            return;
        }

        openDialog.dispatch(webLoginDialog);
        this.loginSuccess.add(this.onComplete);
    }

    private function onComplete():void {
        completeTask(true, "");
    }
}
}