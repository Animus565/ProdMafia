package kabam.rotmg.ui.model {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;

import kabam.rotmg.ui.view.KeysView;

public class HUDModel {

    public function HUDModel() {
        super();
    }

    public var gameSprite:GameSprite;
    public var vaultContents:Vector.<int>;

    public var giftContents:Vector.<int>;

    public var potContents:Vector.<int>;

    private var _keysView:KeysView;

    public function get keysView():KeysView {
        return this._keysView;
    }

    public function set keysView(param1:KeysView):void {
        this._keysView = param1;
    }

    public function getPlayerName():String {
        return this.gameSprite.model.getName() ? this.gameSprite.model.getName() : this.gameSprite.map.player_ ? this.gameSprite.map.player_.name_ : "";
    }

    public function getButtonType():String {
        return this.gameSprite.gsc_.gameId_ == Parameters.NEXUS_GAMEID ? "OPTIONS_BUTTON" : "NEXUS_BUTTON";
    }
}
}
