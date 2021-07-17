package kabam.rotmg.messaging.impl.incoming {
import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.data.CompressedInt;

public class QuestObjId extends IncomingMessage {
    public function QuestObjId(id:uint, callback:Function) {
        this.extraQuestObjIds = new Vector.<int>();
        super(id, callback);
    }

    public var objectId_:int;
    public var extraQuestObjIds:Vector.<int>;

    override public function parseFromInput(data:IDataInput):void {
        this.objectId_ = data.readInt();
        var len:int = CompressedInt.read(data);
        for (var i:int = 0; i < len; i++)
            this.extraQuestObjIds.push(CompressedInt.read(data));
    }

    override public function toString():String {
        return formatToString("QUESTOBJID", "objectId_", "extraQuestObjIds");
    }
}
}
