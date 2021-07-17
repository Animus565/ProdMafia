package kabam.rotmg.chat.view
{
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.FameUtil;
import com.company.assembleegameclient.util.StageProxy;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;
import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.chat.model.ChatModel;
import kabam.rotmg.text.model.FontModel;
import kabam.rotmg.text.view.BitmapTextFactory;
import kabam.rotmg.ui.model.HUDModel;

public class ChatListItemFactory
{

    private static const IDENTITY_MATRIX:Matrix = new Matrix();

    private static const SERVER:String = "";

    private static const CLIENT:String = "*Client*";

    private static const HELP:String = "*Help*";

    private static const ERROR:String = "*Error*";

    private static const GUILD:String = "*Guild*";

    private static const SYNC:String = "*Sync*";

    private static const ALERT:String = "*Alert*";

    private static const testField:TextField = makeTestTextField();


    [Inject]
    public var model:ChatModel;

    [Inject]
    public var fontModel:FontModel;

    [Inject]
    public var stageProxy:StageProxy;

    [Inject]
    public var hudModel:HUDModel;

    private var message:ChatMessage;

    private var buffer:Vector.<DisplayObject>;

    private var delete_:Vector.<DisplayObject>;

    public function ChatListItemFactory()
    {
        delete_ = new Vector.<DisplayObject>();
        super();
    }

    public static function isTradeMessage(param1:int, param2:int, param3:String) : Boolean
    {
        return (param1 == -1 || param2 == -1) && param3.search("/trade") != -1;
    }

    public static function isGuildMessage(param1:String) : Boolean
    {
        return param1 == "*Guild*";
    }

    private static function makeTestTextField() : TextField
    {
        var _loc1_:TextField = new TextField();
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.size = 15;
        _loc2_.bold = true;
        _loc1_.defaultTextFormat = _loc2_;
        return _loc1_;
    }

    public function make(param1:ChatMessage, param2:Boolean = false) : ChatListItem
    {
        var _loc9_:int = 0;
        var _loc7_:* = undefined;
        var _loc10_:int = 0;
        var _loc6_:* = null;
        var _loc8_:* = 0;
        var _loc5_:Boolean = false;
        this.message = param1;
        if(this.buffer != null)
        {
            _loc9_ = 0;
            _loc7_ = buffer;
            var _loc13_:int = 0;
            var _loc12_:* = buffer;
            for each(var _loc11_ in buffer)
            {
                delete_.push(_loc11_);
            }
        }
        this.buffer = new Vector.<DisplayObject>();
        this.setTFonTestField();
        this.makeStarsIcon();
        this.makeWhisperText();
        this.makeNameText();
        this.makeMessageText();
        var _loc4_:Boolean = param1.numStars == -1 || param1.objectId == -1;
        var _loc3_:* = param1.name;
        if(_loc4_ && param1.text.search("/trade ") != -1)
        {
            _loc10_ = _loc10_ + 7;
            _loc6_ = "";
            _loc8_ = _loc10_;
            _loc10_ = _loc10_ + 10;
            while(_loc8_ < _loc10_)
            {
                if(param1.text.charAt(_loc8_) != "\"")
                {
                    _loc6_ = _loc6_ + param1.text.charAt(_loc8_);
                    _loc8_++;
                    continue;
                }
                break;
            }
            _loc3_ = _loc6_;
            _loc5_ = true;
        }
        return new ChatListItem(this.buffer,this.model.bounds.width,this.model.lineHeight,param2,param1.objectId,_loc3_,param1.recipient == "*Guild*",_loc5_);
    }

    public function dispose() : void
    {
        var _loc1_:int = 0;
        var _loc2_:* = null;
        var _loc3_:uint = this.delete_.length;
        _loc1_ = 0;
        while(_loc1_ < _loc3_)
        {
            _loc2_ = delete_[_loc1_] as Bitmap;
            if(_loc2_)
            {
                _loc2_.bitmapData.dispose();
                _loc2_.bitmapData = null;
                _loc2_ = null;
                delete_[_loc1_] = null;
            }
            _loc1_++;
        }
        this.delete_.length = 0;
    }

    private function makeStarsIcon() : void
    {
        var _loc1_:int = this.message.numStars;
        if(Parameters.data.dataScrambler && this.message.numStars != -1 && this.message.name == Parameters.data.customName)
        {
            _loc1_ = Math.random() * 85;
        }
        if(_loc1_ >= 0)
        {
            this.buffer.push(FameUtil.numStarsToIcon(_loc1_));
        }
    }

    private function makeWhisperText() : void
    {
        var _loc1_:* = null;
        var _loc2_:* = null;
        if(this.message.isWhisper && !this.message.isToMe)
        {
            _loc1_ = "To: ";
            _loc2_ = this.getBitmapData(_loc1_,61695);
            this.buffer.push(new Bitmap(_loc2_));
        }
    }

    private function makeNameText() : void
    {
        if(!this.isSpecialMessageType())
        {
            this.bufferNameText();
        }
    }

    private function isSpecialMessageType() : Boolean
    {
        var _loc1_:String = this.message.name;
        return _loc1_ == "" || _loc1_ == "*Client*" || _loc1_ == "*Help*" || _loc1_ == "*Error*" || _loc1_ == "*Guild*";
    }

    private function bufferNameText() : void
    {
        var _loc1_:BitmapData = this.getBitmapData(this.processName(),this.getNameColor());
        this.buffer.push(new Bitmap(_loc1_));
    }

    private function processName() : String
    {
        var _loc1_:String = this.message.isWhisper && !this.message.isToMe?this.message.recipient:this.message.name;
        if(_loc1_.charAt(0) == "#" || _loc1_.charAt(0) == "@")
        {
            _loc1_ = _loc1_.substr(1);
        }
        return "<" + _loc1_ + ">";
    }

    private function makeMessageText() : void
    {
        var _loc1_:int = 0;
        var _loc2_:Array = this.message.text.split("\n");
        var _loc3_:uint = _loc2_.length;
        if(_loc3_ > 0)
        {
            this.makeNewLineFreeMessageText(_loc2_[0],true);
            _loc1_ = 1;
            while(_loc1_ < _loc3_)
            {
                this.makeNewLineFreeMessageText(_loc2_[_loc1_],false);
                _loc1_++;
            }
        }
    }

    private function makeNewLineFreeMessageText(param1:String, param2:Boolean) : void
    {
        var _loc15_:int = 0;
        var _loc14_:* = undefined;
        var _loc13_:int = 0;
        var _loc10_:* = undefined;
        var _loc4_:* = null;
        var _loc5_:int = 0;
        var _loc9_:* = 0;
        var _loc6_:* = 0;
        var _loc3_:int = 0;
        var _loc11_:int = 0;
        var _loc12_:int = 0;
        var _loc8_:* = param1;
        if(param2)
        {
            _loc13_ = 0;
            _loc10_ = this.buffer;
            _loc15_ = 0;
            _loc14_ = this.buffer;
            var _loc17_:int = 0;
            var _loc16_:* = this.buffer;
            for each(_loc4_ in this.buffer)
            {
                _loc11_ = _loc11_ + _loc4_.width;
            }
            _loc12_ = _loc8_.length;
            testField.text = _loc8_;
            while(testField.textWidth >= this.model.bounds.width - _loc11_)
            {
                _loc12_ = _loc12_ - 10;
                testField.text = _loc8_.substr(0,_loc12_);
            }
            if(_loc12_ < _loc8_.length)
            {
                _loc5_ = _loc8_.substr(0,_loc12_).lastIndexOf(" ");
                _loc12_ = _loc5_ == 0 || _loc5_ == -1?_loc12_:_loc5_ + 1;
            }
            this.makeMessageLine(_loc8_.substr(0,_loc12_));
        }
        var _loc7_:int = _loc8_.length;
        if(_loc7_ > _loc12_)
        {
            _loc9_ = uint(_loc8_.length);
            _loc6_ = _loc12_;
            while(_loc6_ < _loc7_)
            {
                testField.text = _loc8_.substr(_loc6_,_loc9_);
                while(testField.textWidth >= this.model.bounds.width)
                {
                    _loc9_ = uint(_loc9_ - 2);
                    testField.text = _loc8_.substr(_loc6_,_loc9_);
                }
                _loc3_ = _loc9_;
                if(_loc8_.length > _loc6_ + _loc9_)
                {
                    _loc3_ = _loc8_.substr(_loc6_,_loc9_).lastIndexOf(" ");
                    _loc3_ = _loc3_ == 0 || _loc3_ == -1?_loc9_:_loc3_ + 1;
                }
                this.makeMessageLine(_loc8_.substr(_loc6_,_loc3_));
                _loc6_ = int(_loc6_ + _loc3_);
            }
        }
    }

    private function makeMessageLine(param1:String) : void
    {
        var _loc2_:BitmapData = this.getBitmapData(param1,this.getTextColor());
        this.buffer.push(new Bitmap(_loc2_));
    }

    private function getNameColor() : uint
    {
        if(this.message.name.charAt(0) == "#")
        {
            return 16754688;
        }
        if(this.message.name.charAt(0) == "@")
        {
            return 16776960;
        }
        if(this.message.recipient == "*Guild*")
        {
            return 10944349;
        }
        if(this.message.recipient != "")
        {
            return 61695;
        }
        if(this.message.isFromSupporter)
        {
            return 13395711;
        }
        return 65280;
    }

    private function getTextColor() : uint
    {
        var _loc1_:String = this.message.name;
        if(_loc1_ == "")
        {
            return 16776960;
        }
        if(_loc1_ == "*Client*")
        {
            return 255;
        }
        if(_loc1_ == "*Help*")
        {
            return 16734981;
        }
        if(_loc1_ == "*Error*")
        {
            return 16711680;
        }
        if(_loc1_ == "*Sync*")
        {
            return 1168896;
        }
        if(_loc1_.charAt(0) == "@")
        {
            return 16776960;
        }
        if(this.message.recipient == "*Guild*")
        {
            return 10944349;
        }
        if(this.message.recipient != "")
        {
            return 61695;
        }
        return 16777215;
    }

    private function getBitmapData(param1:String, param2:uint) : BitmapData
    {
        var _loc3_:String = this.stageProxy.getQuality();
        var _loc4_:Boolean = Parameters.data.forceChatQuality;
        _loc4_ && this.stageProxy.setQuality("high");
        var _loc5_:BitmapData = BitmapTextFactory.make(param1,14,param2,true,IDENTITY_MATRIX,true);
        _loc4_ && this.stageProxy.setQuality(_loc3_);
        return _loc5_;
    }

    private function setTFonTestField() : void
    {
        var _loc1_:TextFormat = testField.getTextFormat();
        _loc1_.font = this.fontModel.getFont().getName();
        testField.defaultTextFormat = _loc1_;
    }
}
}
