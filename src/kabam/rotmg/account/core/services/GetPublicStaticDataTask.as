package kabam.rotmg.account.core.services {
import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;

public class GetPublicStaticDataTask extends BaseTask {

    public function GetPublicStaticDataTask() {
        super();
    }

    [Inject]
    public var account:Account;
    [Inject]
    public var client:AppEngineClient;
    private var requestData:Object;

    override protected function startTask():void {
        this.requestData = this.makeRequestData();
        this.sendRequest();
    }

    public function makeRequestData():Object {
        var _loc1_:* = {};
        _loc1_.dataType = "powerUpSettings";
        _loc1_.version = 0;
        _loc1_.accessToken = this.account.getAccessToken();
        _loc1_.game_net_user_id = this.account.gameNetworkUserId();
        _loc1_.game_net = this.account.gameNetwork();
        _loc1_.play_platform = this.account.playPlatform();
        return _loc1_;
    }

    private function sendRequest():void {
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("/app/publicStaticData", this.requestData);
    }

    private function onComplete(param1:Boolean, param2:*):void {
        completeTask(true);
    }
}
}
