package kabam.rotmg.account.core.services {
import com.company.assembleegameclient.parameters.Parameters;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.signals.CharListDataSignal;
import kabam.rotmg.account.securityQuestions.data.SecurityQuestionsModel;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.signals.CharListLoadedSignal;

import robotlegs.bender.framework.api.ILogger;

public class GetConCharListTask extends BaseTask {
    public function GetConCharListTask() {
        super();
    }

    [Inject]
    public var account:Account;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var charListData:CharListDataSignal;
    [Inject]
    public var charListLoadedSignal:CharListLoadedSignal;
    [Inject]
    public var logger:ILogger;
    [Inject]
    public var securityQuestionsModel:SecurityQuestionsModel;
    private var requestData:Object;

    override protected function startTask():void {
        this.requestData = this.makeRequestData();
        this.sendRequest();
    }

    public function makeRequestData():Object {
        var _loc1_:Object = {};
        _loc1_.accessToken = this.account.getAccessToken();
        _loc1_.game_net_user_id = this.account.gameNetworkUserId();
        _loc1_.game_net = this.account.gameNetwork();
        _loc1_.play_platform = this.account.playPlatform();
        return _loc1_;
    }

    private function sendRequest():void {
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("/char/list", this.requestData);
    }

    private function onComplete(param1:Boolean, param2:*):void {
        completeTask(true);
        if (param1) {
            this.onListComplete(param2);
        } else {
            this.onTextError(param2);
        }
    }

    private function onListComplete(param1:String):void {
        var _loc3_:* = null;
        var _loc2_:XML = new XML(param1);
        if ("Account" in _loc2_) {
            this.account.creationDate = new Date(_loc2_.Account[0].CreationTimestamp * 1000);
            if ("SecurityQuestions" in _loc2_.Account[0]) {
                this.securityQuestionsModel.showSecurityQuestionsOnStartup = !Parameters.data.skipPopups && !Parameters.ignoringSecurityQuestions && _loc2_.Account[0].SecurityQuestions[0].ShowSecurityQuestionsDialog[0] == "1";
                this.securityQuestionsModel.clearQuestionsList();
                for each(_loc3_ in _loc2_.Account[0].SecurityQuestions[0].SecurityQuestionsKeys[0].SecurityQuestionsKey) {
                    this.securityQuestionsModel.addSecurityQuestion(_loc3_.toString());
                }
            }
        }
        this.charListData.dispatch(_loc2_);
        this.charListLoadedSignal.dispatch();
    }

    private function onTextError(param1:String):void {
        if (param1 == "Account credentials not valid") {
            this.clearAccountAndReloadCharacters();
        } else if (param1 == "Account is under maintenance") {
            this.account.clear();
        }
    }

    private function clearAccountAndReloadCharacters():void {
        this.logger.info("GetUserDataTask invalid credentials");
        this.account.clear();
        this.client.complete.addOnce(this.onComplete);
        this.requestData = this.makeRequestData();
        this.client.sendRequest("/char/list", this.requestData);
    }
}
}