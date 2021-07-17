package kabam.rotmg.messaging.impl.incoming {
import flash.utils.IDataInput;

public class MapInfo extends IncomingMessage {
    public function MapInfo(id:uint, callback:Function) {
        super(id, callback);
    }

    public var width_:int;
    public var height_:int;
    public var name_:String;
    public var displayName_:String;
    public var realmName_:String;
    public var difficulty_:int;
    public var fp_:uint;
    public var background_:int;
    public var allowPlayerTeleport_:Boolean;
    public var showDisplays_:Boolean;
    public var maxPlayers_:int;
    public var gameOpenedTime_:int;
    public var version:String;
    public var unknown:int;

    override public function parseFromInput(input:IDataInput):void {
        this.width_ = input.readInt();
        this.height_ = input.readInt();
        this.name_ = input.readUTF();
        this.displayName_ = input.readUTF();
        this.realmName_ = input.readUTF();
        this.fp_ = input.readUnsignedInt();
        this.background_ = input.readInt();
        this.difficulty_ = input.readInt();
        this.allowPlayerTeleport_ = input.readBoolean();
        this.showDisplays_ = input.readBoolean();
        this.maxPlayers_ = input.readShort();
        this.gameOpenedTime_ = input.readUnsignedInt();
        this.version = input.readUTF();
        this.unknown = input.readInt();
    }

    override public function toString():String {
        return formatToString("MAPINFO", "width_", "height_", "name_", "displayName_",
                "realmName_", "fp_", "background_", "difficulty_", "allowPlayerTeleport_", "showDisplays_",
                "maxPlayers_", "gameOpenedTime_", "version", "unknown");
    }
}
}
