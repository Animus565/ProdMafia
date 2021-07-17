package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

public class RedeemExaltationReward extends OutgoingMessage {
    public function RedeemExaltationReward(id:uint, callback:Function) {
        super(id, callback);
    }

    public var item:int;

    override public function writeToOutput(data:IDataOutput):void {
        data.writeInt(this.item);
    }

    override public function toString():String {
        return formatToString("REDEEM_EXALTATION_REWARD", "item");
    }
}
}
