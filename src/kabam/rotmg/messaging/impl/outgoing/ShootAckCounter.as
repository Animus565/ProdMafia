package kabam.rotmg.messaging.impl.outgoing {

import flash.utils.IDataOutput;

public class ShootAckCounter extends OutgoingMessage {
    public function ShootAckCounter(id:uint, callback:Function) {
        super(id, callback);
    }

    public var time:int;
    public var amount:int;

    override public function writeToOutput(data:IDataOutput):void {
        data.writeInt(this.time);
        data.writeShort(this.amount);
    }

    override public function toString():String {
        return formatToString("SHOOTACK_COUNTER", "time", "amount");
    }
}
}