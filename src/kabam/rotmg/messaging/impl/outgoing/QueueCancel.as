package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

public class QueueCancel extends OutgoingMessage {
    public function QueueCancel(id:uint, callback:Function) {
        super(id, callback);
    }

    public var objectId:int;

    override public function writeToOutput(data:IDataOutput):void {
        data.writeInt(this.objectId);
    }

    override public function toString():String {
        return formatToString("QUEUE_CANCEL", "objectId");
    }
}
}