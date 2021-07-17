package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

public class SetCondition extends OutgoingMessage {

    public function SetCondition(param1:uint, param2:Function) {
        super(param1, param2);
    }

    public var conditionEffect_:uint;
    public var conditionDuration_:Number;

    override public function writeToOutput(param1:IDataOutput):void {
        param1.writeByte(this.conditionEffect_);
        param1.writeFloat(this.conditionDuration_);
    }

    override public function toString():String {
        return formatToString("SETCONDITION", "conditionEffect_", "conditionDuration_");
    }
}
}
