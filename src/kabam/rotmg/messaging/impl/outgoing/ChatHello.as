package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

public class ChatHello extends OutgoingMessage {

    public function ChatHello(param1:uint, param2:Function) {
        super(param1, param2);
    }

    public var accountId:String;
    public var token:String;

    override public function writeToOutput(param1:IDataOutput):void {
        param1.writeUTF(this.accountId);
        param1.writeUTF(this.token);
    }

    override public function toString():String {
        return formatToString("CHATHELLO", "accountId", "token");
    }
}
}
