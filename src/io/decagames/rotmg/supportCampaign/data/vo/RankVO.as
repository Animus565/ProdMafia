package io.decagames.rotmg.supportCampaign.data.vo {
public class RankVO {

    public function RankVO(param1:int, param2:String) {
        super();
        this._points = param1;
        this._name = param2;
    }

    private var _points:int;

    public function get points():int {
        return this._points;
    }

    private var _name:String;

    public function get name():String {
        return this._name;
    }
}
}
