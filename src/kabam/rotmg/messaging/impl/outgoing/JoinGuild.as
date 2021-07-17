package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

public class JoinGuild extends OutgoingMessage {

    public function JoinGuild(param1:uint, param2:Function) {
        super(param1, param2);
    }

    public var guildName_:String;

    override public function writeToOutput(param1:IDataOutput):void {
        param1.writeUTF(this.guildName_);
    }

    override public function toString():String {
        return formatToString("JOINGUILD", "guildName_");
    }
}
}
