package kabam.rotmg.messaging.impl.incoming {
import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.data.CompressedInt;

public class ForgeUnlockedBlueprints extends IncomingMessage {
    public function ForgeUnlockedBlueprints(id:uint, callback:Function) {
        this.unlockedItems = new Vector.<int>();
        super(id, callback);
    }

    public var unlockedItems:Vector.<int>;

    override public function parseFromInput(data:IDataInput):void {
        var count:int = data.readByte();
        for (var i:int = 0; i < count; i++)
            this.unlockedItems.push(CompressedInt.read(data));
    }

    override public function toString():String {
        return formatToString("FORGE_UNLOCKED_BLUEPRINTS", "unlockedItems");
    }
}
}